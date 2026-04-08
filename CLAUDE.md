# Auto-Train-Agent - Project Instructions

## Project Context

An automated machine learning model training agent that uses Python and PyTorch.

> Note: Detailed project requirements will be added to task.json as they are defined.

---

## MANDATORY: Agent Workflow

Every new agent session MUST follow this workflow:

### Step 1: Initialize Environment

```bash
./init.sh
```

This will:
- Create/activate conda environment (Auto-Train-Agent)
- Install all dependencies
- Set up project structure
- Validate environment configuration

**DO NOT skip this step.** Ensure the environment is properly set up before proceeding.

### Step 2: Select Next Task

Read `task.json` and select ONE task to work on.

Selection criteria (in order of priority):
1. Choose a task where `passes: false`
2. Consider dependencies - fundamental features should be done first
3. Pick the highest-priority incomplete task

### Step 3: Implement the Task

- Read the task description and steps carefully
- Implement the functionality to satisfy all steps
- Follow existing code patterns and conventions
- Write clean, documented Python code with type hints

### Step 4: Test Thoroughly

After implementation, verify ALL steps in the task:

**强制测试要求（Testing Requirements - MANDATORY）：**

1. **核心功能修改**（模型架构、训练循环、数据处理）：
   - **必须运行实际训练测试！**
   - 验证模型能正确初始化
   - 验证训练循环能正常运行（至少 1 个 epoch）
   - 验证损失函数下降
   - 检查梯度流动正常

2. **辅助功能修改**（日志记录、配置管理、工具函数）：
   - 可以使用单元测试验证
   - 运行 `pytest` 检查测试通过
   - 代码风格检查 `ruff check .`

3. **所有修改必须通过**：
   - `ruff check .` 无错误
   - `pytest` 测试通过
   - `python -m <module>` 能正常导入
   - 实际运行验证功能正常

**测试清单：**
- [ ] 代码没有类型错误
- [ ] ruff 检查通过
- [ ] pytest 测试通过
- [ ] 功能在实际运行中正常工作

### Step 5: Update Progress

Write your work to `progress.txt`:

```
## [Date] - Task: [task description]

### What was done:
- [specific changes made]

### Testing:
- [how it was tested]

### Notes:
- [any relevant notes for future agents]
```

### Step 6: Commit Changes (包含 task.json 更新)

**IMPORTANT: 所有更改必须在同一个 commit 中提交，包括 task.json 的更新！**

流程：
1. 更新 `task.json`，将任务的 `passes` 从 `false` 改为 `true`
2. 更新 `progress.txt` 记录工作内容
3. 一次性提交所有更改：

```bash
git add .
git commit -m "[task description] - completed"
```

**规则:**
- 只有在所有步骤都验证通过后才标记 `passes: true`
- 永远不要删除或修改任务描述
- 永远不要从列表中移除任务
- **一个 task 的所有内容（代码、progress.txt、task.json）必须在同一个 commit 中提交**

---

## ⚠️ 阻塞处理（Blocking Issues）

**如果任务无法完成测试或需要人工介入，必须遵循以下规则：**

### 需要停止任务并请求人工帮助的情况：

1. **缺少环境配置**：
   - 需要填写真实的 API 密钥（如 HuggingFace, WandB）
   - 需要特定的 GPU 环境
   - 需要大型数据集下载

2. **外部依赖不可用**：
   - HuggingFace Hub 服务不可用
   - 需要 CUDA 特定版本
   - 需要付费的云服务

3. **测试无法进行**：
   - 需要大量计算资源（长时间训练）
   - 需要特定的硬件（多GPU、TPU）
   - 需要人工评估模型质量

### 阻塞时的正确操作：

**DO NOT（禁止）：**
- ❌ 提交 git commit
- ❌ 将 task.json 的 passes 设为 true
- ❌ 假装任务已完成

**DO（必须）：**
- ✅ 在 progress.txt 中记录当前进度和阻塞原因
- ✅ 输出清晰的阻塞信息，说明需要人工做什么
- ✅ 停止任务，等待人工介入

### 阻塞信息格式：

```
🚫 任务阻塞 - 需要人工介入

**当前任务**: [任务名称]

**已完成的工作**:
- [已完成的代码/配置]

**阻塞原因**:
- [具体说明为什么无法继续]

**需要人工帮助**:
1. [具体的步骤 1]
2. [具体的步骤 2]
...

**解除阻塞后**:
- 运行 [命令] 继续任务
```

---

## Project Structure

```
/
├── CLAUDE.md              # This file - workflow instructions
├── task.json              # Task definitions (source of truth)
├── progress.txt           # Progress log from each session
├── init.sh                # Initialization script
├── requirements.txt       # Python dependencies
├── pyproject.toml         # Project configuration
└── src/                   # Source code
    ├── models/            # Model architectures
    ├── data/              # Data loaders and preprocessing
    ├── training/          # Training loops and optimizers
    ├── evaluation/        # Evaluation metrics and scripts
    ├── utils/             # Utility functions
    └── configs/           # Configuration files
```

## Commands

```bash
# Environment setup
conda activate Auto-Train-Agent  # Activate conda environment

# Code quality
ruff check .                       # Run linter
ruff format .                      # Format code
pytest                             # Run tests
mypy src/                          # Type checking

# Training
python -m src.train --config <config_path>
```

## Coding Conventions

- Python 3.11+ with type hints
- PyTorch for deep learning
- Follow PEP 8 style guide
- Use dataclasses for configurations
- Write docstrings for all public functions
- Include type hints everywhere

---

## Key Rules

1. **One task per session** - Focus on completing one task well
2. **Test before marking complete** - All steps must pass
3. **Run actual tests for core changes** - 模型/训练修改必须实际运行测试
4. **Document in progress.txt** - Help future agents understand your work
5. **One commit per task** - 所有更改（代码、progress.txt、task.json）必须在同一个 commit 中提交
6. **Never remove tasks** - Only flip `passes: false` to `true`
7. **Stop if blocked** - 需要人工介入时，不要提交，输出阻塞信息并停止

# currentDate
Today's date is 2026-04-08.
