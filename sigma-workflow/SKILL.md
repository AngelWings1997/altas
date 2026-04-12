---
name: sigma-workflow
description: 统一 AI 原生研发工作流，集合 Spec驱动 + Checkpoint驱动 + 超级能力。
references:
  spec-driven-development:
    - references/spec-driven-development/sdd-riper-one-protocol.md  # 核心协议
    - references/spec-driven-development/commands.md              # 6个原生命令
    - references/spec-driven-development/spec-template.md         # Spec模板
    - references/spec-driven-development/multi-project.md         # 多项目协作
    - references/spec-driven-development/archive-template.md       # 归档模板
    - references/spec-driven-development/workflow-quickref.md     # 工作流速查
  checkpoint-driven:
    - references/checkpoint-driven/SKILL.md                     # 硬约束/Checkpoint
    - references/checkpoint-driven/modules.md                     # Deep Planning/Debug/Review
    - references/checkpoint-driven/conventions.md                 # 目录约定
    - references/checkpoint-driven/spec-lite-template.md         # Lite模板
  superpowers:
    - references/superpowers/test-driven-development/SKILL.md              # TDD
    - references/superpowers/test-driven-development/testing-anti-patterns.md
    - references/superpowers/systematic-debugging/SKILL.md                # Debug四阶段
    - references/superpowers/systematic-debugging/root-cause-tracing.md
    - references/superpowers/systematic-debugging/defense-in-depth.md
    - references/superpowers/systematic-debugging/condition-based-waiting.md
    - references/superpowers/subagent-driven-development/SKILL.md           # Subagent派遣
    - references/superpowers/subagent-driven-development/implementer-prompt.md
    - references/superpowers/subagent-driven-development/spec-reviewer-prompt.md
    - references/superpowers/subagent-driven-development/code-quality-reviewer-prompt.md
    - references/superpowers/verification-before-completion/SKILL.md        # 验证铁律
    - references/superpowers/dispatching-parallel-agents/SKILL.md         # 并行执行
    - references/superpowers/writing-plans/SKILL.md                      # 计划编写
    - references/superpowers/finishing-a-development-branch/SKILL.md    # 分支完成
  test-dev-workflow:
    - references/test-dev-workflow/test-dev-workflow.md            # 测试开发完整规范
    - references/test-dev-workflow/TEST-DEV-WORKFLOW-PROJECT.md   # 项目总览
---

# SIGMA Workflow: Unified AI-Native Development Protocol

> **集合 Spec驱动 + Checkpoint驱动 + 超级能力，兼顾速度与质量**

---

## 核心理念

```
Spec is Truth + Evidence before Claims + Progressive Disclosure
```

| 铁律 | 来源 | 含义 |
|------|------|------|
| **No Spec, No Code** | Spec驱动 | 未形成 Spec 不写代码 |
| **No Approval, No Execute** | Checkpoint驱动 | 未获批准不执行 |
| **Evidence before Claims** | 超级能力 | 验证在前，断言在后 |
| **No Fixes Without Root Cause** | 超级能力 | 未找到根因不修复 |
| **Reverse Sync** | Spec驱动 | 执行后发现 bug 先更新 Spec 再修复代码 |

---

## 一、快速开始

### 安装

复制 `SKILL.md` 内容到 AI 助手的 Custom Instructions 即可。

### 快速任务 (zero/fast)

```text
>> 修复登录超时的 bug
```

### 标准任务 (standard)

```text
请使用 SIGMA 工作流：
- task: 用户认证功能重构
- goal: 迁移到 JWT 方案
- scope: src/auth/*
```

### 复杂任务 (deep)

```text
请使用 SIGMA deep 模式：
- task: 微服务架构拆分
- goal: 从单体拆分为 3 个服务
```

---

## 二、工作流阶段

```
PRE-RESEARCH ──→ Research ──→ [Innovate] ──→ Plan ──→ Execute ──→ Review ──→ Verification
     │              │              │            │           │           │            │
     ↓              ↓              ↓            ↓           ↓           ↓            ↓
 CodeMap        Spec 初稿       方案比较      任务清单    Checkpoint   偏差报告     验证证据
 Context       STOP-WAIT       STOP-WAIT     STOP-WAIT   阶段暂停     STOP-WAIT    完成
```

---

## 三、核心命令速查

| 命令 | 用途 |
|------|------|
| `>>` / `FAST` | 快速通道，跳过 Plan |
| `create_codemap` | 生成代码索引地图 |
| `build_context_bundle` | 整理需求上下文 |
| `sdd_bootstrap` | RIPER 启动命令 |
| `REVIEW SPEC` | 执行前规格评审 |
| `REVIEW EXECUTE` | 执行后三轴审查 |
| `ARCHIVE` | 知识沉淀归档 |
| `TDD` | 启用测试驱动 |
| `DEBUG` | 启动系统调试 |
| `MULTI` | 多项目模式 |
| `SUBAGENT` | 启用 Subagent 模式 |

---

## 四、质量保障

### 三角验证

```
        Spec
       /    \
      /      \
   Code ─────── Log/Evidence
```

### Debug 协议

| 阶段 | 动作 |
|------|------|
| **Phase 1** | 读日志 + 复现 + 查变更 + 追踪数据流 |
| **Phase 2** | 找相似代码 + 比较差异 + 理解依赖 |
| **Phase 3** | 形成假设 + 最小化测试 |
| **Phase 4** | 创建失败测试 + 单点修复 + 验证 |

**铁律**: 3+ 修复失败 → 质疑架构

---

## 五、测试开发专用模式

**触发词**: `测试` / `test` / `测试开发` / `自动化测试`

**当用户提到测试相关需求时，自动加载**: `references/test-dev-workflow/test-dev-workflow.md`

### 测试开发核心流程

```
需求理解 ──→ Code Map ──→ Spec(测试策略) ──→ Plan(任务分解) ──→ TDD循环 ──→ Review ──→ Archive
```

### 测试开发铁律

| 铁律 | 含义 |
|------|------|
| **No Spec, No Test** | 未设计测试策略不写测试代码 |
| **No Production Code Without Failing Test First** | 先写失败测试，再写实现 |
| **Done Contract** | 明确定义"完成"的证据和边界 |

### 测试开发专用模板

详见: `references/test-dev-workflow/test-dev-workflow.md`

---

## 六、完整内容索引

### Spec驱动开发
详见: `references/spec-driven-development/`
- 核心 RIPER 协议
- 6 个原生命令
- Spec 模板 (Standard + Lite)
- 多项目协作规则
- 归档模板

### Checkpoint驱动
详见: `references/checkpoint-driven/`
- 硬约束与 Checkpoint 机制
- 阶段感知与按需加载
- 目录约定

### 超级能力
详见: `references/superpowers/`
- `test-driven-development/` - TDD 完整内容
- `systematic-debugging/` - Debug 四阶段
- `subagent-driven-development/` - Subagent 派遣
- `verification-before-completion/` - 验证铁律
- `dispatching-parallel-agents/` - 并行执行
- `writing-plans/` - 计划编写
- `finishing-a-development-branch/` - 分支完成

### 测试开发专用
详见: `references/test-dev-workflow/`
- `test-dev-workflow.md` - 测试开发完整规范
- `TEST-DEV-WORKFLOW-PROJECT.md` - 项目总览

---

## 七、文件结构

```
sigma-workflow/
├── SKILL.md              # 主协议（引用本地文件）
├── README.md             # 概览
├── QUICKSTART.md        # 快速启动
└── references/
    ├── spec-driven-development/        # Spec驱动开发
    │   ├── sdd-riper-one-protocol.md
    │   ├── commands.md
    │   ├── spec-template.md
    │   ├── multi-project.md
    │   ├── archive-template.md
    │   ├── workflow-quickref.md
    │   └── usage-examples.md
    ├── checkpoint-driven/               # Checkpoint驱动
    │   ├── SKILL.md
    │   ├── modules.md
    │   ├── conventions.md
    │   └── spec-lite-template.md
    ├── superpowers/                    # 超级能力
    │   ├── test-driven-development/
    │   ├── systematic-debugging/
    │   ├── subagent-driven-development/
    │   ├── verification-before-completion/
    │   ├── dispatching-parallel-agents/
    │   ├── writing-plans/
    │   └── finishing-a-development-branch/
    └── test-dev-workflow/              # 测试开发专用
        ├── test-dev-workflow.md
        └── TEST-DEV-WORKFLOW-PROJECT.md
```

---

## 版本

- **v1.0**: 基于 Spec驱动 + Checkpoint驱动 + 超级能力 统一工作流
- **更新**: 2026-04-12
