# Auto-Train-Agent

全自动机器学习模型训练 Agent

## 免责声明

本项目基于 Coding Agent 的设计理念，专为机器学习模型训练场景打造。所有代码和提示词均由 AI 生成。使用前请自行审查，任何后果概不负责。

## 项目背景

这是一个受 [Spring FES Video](https://github.com/anthropics/anthropic-automated-dev-example) 项目启发的自动化机器学习训练 Agent。它将原本用于 Web 开发的自动化开发流程，改造为适用于机器学习模型训练的流程。

**核心理念**：即使是非常复杂的机器学习项目，AI 已经能够帮我们完成绝大部分（甚至全部）代码。如果不行，不是 AI 的问题，是使用者本身的问题。AI 不是机器学习工程师的 bottleneck，工程师错误和老旧的工作方式是 AI 的 bottleneck。写代码本身将会越来越没有价值。

机器学习工程师的工作内容将会转变，从写代码，变成如何控制 AI。高效使用 AI 生成可用的模型训练项目，成为工程师新的核心竞争力。

## 功能特点

### 🤖 全自动开发流程

- **任务驱动**：通过 `task.json` 定义所有需要完成的任务
- **自动化执行**：Agent 自动选择、实现、测试、提交任务
- **进度追踪**：`progress.txt` 记录每个任务的完成情况

### 🔧 机器学习训练基础设施

- **灵活的配置系统**：支持 YAML/JSON 配置文件
- **完整的训练循环**：支持训练、验证、早停、检查点
- **分布式训练**：支持 DataParallel 和 DistributedDataParallel
- **实验跟踪**：集成 TensorBoard 和 WandB
- **超参数调优**：支持网格搜索、随机搜索、Optuna

### 📊 代码质量保证

- **类型检查**：使用 mypy 进行静态类型检查
- **代码规范**：使用 ruff 进行 linting 和 formatting
- **单元测试**：使用 pytest 进行测试
- **测试覆盖率**：自动生成测试覆盖率报告

## 项目结构

```
/
├── CLAUDE.md              # Agent 工作流程指令（核心）
├── task.json              # 任务定义列表（单一真相来源）
├── progress.txt           # 工作进度记录
├── init.sh                # 环境初始化脚本
├── run-automation.sh      # 自动化运行脚本
├── requirements.txt       # Python 依赖
├── pyproject.toml         # 项目配置
├── README.md              # 本文件
└── src/                   # 源代码
    ├── models/            # 模型架构
    ├── data/              # 数据加载和预处理
    ├── training/          # 训练循环和优化器
    ├── evaluation/        # 评估指标和脚本
    ├── utils/             # 工具函数
    └── configs/           # 配置文件
```

## Agent 工作流程

每个 Agent 会话遵循以下流程：

### 1. 初始化环境

```bash
./init.sh
```

这会：
- 创建 Python 虚拟环境
- 安装所有依赖
- 创建项目目录结构
- 验证环境配置

### 2. 选择下一个任务

读取 `task.json`，选择一个 `passes: false` 的任务

选择标准（按优先级）：
1. 选择 `passes: false` 的任务
2. 考虑依赖关系 - 基础功能应该先完成
3. 选择最高优先级的未完成任务

### 3. 实现任务

- 仔细阅读任务描述和步骤
- 实现满足所有步骤的功能
- 遵循现有的代码模式和约定
- 编写清晰的、带文档的 Python 代码

### 4. 彻底测试

**强制测试要求：**

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

### 5. 更新进度

将工作记录到 `progress.txt`：

```
## [Date] - Task: [task description]

### What was done:
- [specific changes made]

### Testing:
- [how it was tested]

### Notes:
- [any relevant notes for future agents]
```

### 6. 提交更改（包含 task.json 更新）

**重要：所有更改必须在同一个 commit 中提交，包括 task.json 的更新！**

流程：
1. 更新 `task.json`，将任务的 `passes` 从 `false` 改为 `true`
2. 更新 `progress.txt` 记录工作内容
3. 一次性提交所有更改：

```bash
git add .
git commit -m "[task description] - completed"
```

**规则：**
- 只有在所有步骤都验证通过后才标记 `passes: true`
- 永远不要删除或修改任务描述
- 永远不要从列表中移除任务
- **一个 task 的所有内容（代码、progress.txt、task.json）必须在同一个 commit 中提交**

## 使用方式

### 前提条件

- Python 3.11+
- claude-code CLI
- GPU（推荐，但非必需）

### 方式一：通过 Claude Code 运行（最稳妥）

手动启动 Claude Code，让 AI 执行下一个任务。

### 方式二：使用 dangerously skip permission 模式（次选）

使用 `--dangerously-skip-permissions` 参数运行 Claude Code，AI 可以在无需人工确认的情况下完成下一个任务。

```bash
claude -p --dangerously-skip-permissions
```

### 方式三：使用自动化脚本（不推荐）

使用 `run-automation.sh` 脚本让 AI 循环运行多次：

```bash
./run-automation.sh 10  # 运行 10 次
```

**警告**：这种方式最危险，最容易浪费资源。人不在电脑边，又想让 AI 工作时可以使用。

## 命令参考

```bash
# 环境设置
source .venv/bin/activate  # 激活虚拟环境

# 代码质量
ruff check .               # 运行 linter
ruff format .              # 格式化代码
pytest                     # 运行测试
mypy src/                  # 类型检查

# 训练
python -m src.train --config <config_path>
```

## 代码规范

- Python 3.11+ with type hints
- PyTorch 用于深度学习
- 遵循 PEP 8 风格指南
- 使用 dataclasses 定义配置
- 为所有公共函数编写 docstring
- 所有地方都添加类型提示

## 核心规则

1. **每次会话一个任务** - 专注于做好一个任务
2. **测试后标记完成** - 所有步骤必须通过
3. **核心修改需要实际测试** - 模型/训练修改必须实际运行
4. **在 progress.txt 中记录** - 帮助未来的 Agent 理解你的工作
5. **每个任务一个 commit** - 所有更改必须在同一个 commit 中提交
6. **永不删除任务** - 只能将 `passes: false` 改为 `true`
7. **阻塞时停止** - 需要人工介入时，不要提交，输出阻塞信息并停止

## 阻塞处理

如果任务无法完成测试或需要人工介入，必须遵循以下规则：

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

**禁止（DO NOT）：**
- ❌ 提交 git commit
- ❌ 将 task.json 的 passes 设为 true
- ❌ 假装任务已完成

**必须（DO）：**
- ✅ 在 progress.txt 中记录当前进度和阻塞原因
- ✅ 输出清晰的阻塞信息，说明需要人工做什么
- ✅ 停止任务，等待人工介入

## 自定义使用

要为你的机器学习项目使用这个 Agent：

1. 根据你的需求修改 `task.json`
2. 清空 `progress.txt`
3. 让 AI 根据你的项目需求开始工作

## 致谢

本项目灵感来源于 Anthropic 的 [automated-dev-example](https://github.com/anthropics/anthropic-automated-dev-example) 项目。

## 许可证

MIT License
