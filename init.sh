#!/bin/bash

# =============================================================================
# init.sh - Project Initialization Script
# =============================================================================
# Run this script at the start of every session to ensure the environment
# is properly set up.
# =============================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Project name (also conda environment name)
PROJECT_NAME="Auto-Train-Agent"

echo -e "${YELLOW}Initializing $PROJECT_NAME project...${NC}"

# Check if conda is available
if ! command -v conda &> /dev/null; then
    echo -e "${RED}Error: conda is not installed or not in PATH${NC}"
    echo "Please install Anaconda or Miniconda first"
    exit 1
fi

echo -e "${BLUE}✓ Conda detected${NC}"

# Check if conda environment exists
ENV_EXISTS=$(conda env list | grep -c "^${PROJECT_NAME} " || true)

if [ "$ENV_EXISTS" -eq 0 ]; then
    echo -e "${YELLOW}Conda environment '$PROJECT_NAME' not found${NC}"
    echo "Creating conda environment '$PROJECT_NAME' with Python 3.11..."

    # Create conda environment
    conda create -n "$PROJECT_NAME" python=3.11 -y

    echo -e "${GREEN}✓ Conda environment '$PROJECT_NAME' created${NC}"
else
    echo -e "${GREEN}✓ Conda environment '$PROJECT_NAME' exists${NC}"
fi

# Activate conda environment
echo "Activating conda environment..."
eval "$(conda shell.bash hook)"
conda activate "$PROJECT_NAME"

echo -e "${GREEN}✓ Environment '$PROJECT_NAME' activated${NC}"

# Check Python version
PYTHON_VERSION=$(python --version 2>&1 | awk '{print $2}')
echo -e "${BLUE}✓ Python $PYTHON_VERSION in use${NC}"

# Install dependencies
if [ -f "requirements.txt" ]; then
    echo "Installing dependencies from requirements.txt..."
    pip install --upgrade pip -q
    pip install -r requirements.txt
    echo -e "${GREEN}✓ Dependencies installed${NC}"
else
    echo -e "${YELLOW}Warning: requirements.txt not found${NC}"
fi

# Install package in development mode
if [ -f "pyproject.toml" ]; then
    echo "Installing package in development mode..."
    pip install -e .
    echo -e "${GREEN}✓ Package installed in development mode${NC}"
fi

# Create necessary directories
echo "Creating project directories..."
mkdir -p src/{models,data,training,evaluation,utils,configs}
mkdir -p tests/{unit,integration}
mkdir -p logs
mkdir -p checkpoints
mkdir -p configs
echo -e "${GREEN}✓ Directories created${NC}"

# Run code quality checks (if tools are installed)
if command -v ruff &> /dev/null; then
    echo "Running linter check..."
    ruff check . || echo -e "${YELLOW}Note: Some linting issues found${NC}"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Initialization complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Environment summary:"
echo "  - Conda env: $PROJECT_NAME"
echo "  - Python: $PYTHON_VERSION"
echo "  - Location: $(conda info --envs | grep $PROJECT_NAME | awk '{print $3}')"
echo ""
echo "To activate this environment in the future:"
echo "  conda activate $PROJECT_NAME"
echo ""
echo "Next steps:"
echo "  1. Read task.json to see available tasks"
echo "  2. Select a task to work on"
echo "  3. Implement and test thoroughly"
echo "  4. Update progress.txt and commit"
echo ""
