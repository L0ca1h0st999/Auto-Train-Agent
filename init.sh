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
NC='\033[0m'

echo -e "${YELLOW}Initializing Auto-Train-Agent project...${NC}"

# Check Python version
echo "Checking Python version..."
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d. -f1)
PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d. -f2)

if [ "$PYTHON_MAJOR" -lt 3 ] || ([ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 11 ]); then
    echo -e "${RED}Error: Python 3.11+ is required, but found $PYTHON_VERSION${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Python $PYTHON_VERSION detected${NC}"

# Create virtual environment if it doesn't exist
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv .venv
    echo -e "${GREEN}✓ Virtual environment created${NC}"
else
    echo -e "${GREEN}✓ Virtual environment exists${NC}"
fi

# Activate virtual environment
echo "Activating virtual environment..."
source .venv/bin/activate

# Install dependencies
if [ -f "requirements.txt" ]; then
    echo "Installing dependencies..."
    pip install --upgrade pip -q
    pip install -r requirements.txt -q
    echo -e "${GREEN}✓ Dependencies installed${NC}"
else
    echo -e "${YELLOW}Warning: requirements.txt not found${NC}"
fi

# Install package in development mode
if [ -f "pyproject.toml" ]; then
    echo "Installing package in development mode..."
    pip install -e . -q
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
echo "  - Python: $PYTHON_VERSION"
echo "  - Virtual env: .venv"
echo "  - Source: source .venv/bin/activate"
echo ""
echo "Next steps:"
echo "  1. Read task.json to see available tasks"
echo "  2. Select a task to work on"
echo "  3. Implement and test thoroughly"
echo "  4. Update progress.txt and commit"
echo ""
