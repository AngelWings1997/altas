# SIGMA Workflow

> **统一 AI 原生研发工作流，集合 Spec驱动 + Checkpoint驱动 + 超级能力，兼顾速度与质量**

---

## 📦 安装

复制 `SKILL.md` 内容到 AI 助手的 Custom Instructions / `.cursorrules` 即可。

---

## 🎯 一句话定位

**SIGMA = Spec驱动 + Checkpoint驱动 + 超级能力的全集**

| 维度 | 解决的问题 |
|------|-----------|
| **Spec驱动** | 防止"先实现后补Spec"、上下文丢失 |
| **Checkpoint驱动** | 防止"裸改"、提供阶段性审批点 |
| **超级能力** | TDD Debug Subagent Verification |
| **测试开发** | 专为测试工程师的专用模式 |

---

## 🚀 快速开始

### 🟢 小改动 (zero/fast)

```text
>> 修复登录超时的 bug
```

### 🟡 标准任务 (standard)

```text
请使用 SIGMA 工作流：
- task: 用户认证功能重构
- goal: 迁移到 JWT 方案
- scope: src/auth/*
```

### 🔴 复杂任务 (deep)

```text
请使用 SIGMA deep 模式：
- task: 微服务架构拆分
- goal: 从单体拆分为 3 个服务
```

### 🧪 测试开发任务

```text
我要为登录功能设计测试方案
```

---

## 📁 内容结构 (36 个文件)

```
sigma-workflow/
├── SKILL.md              # 主协议入口
├── README.md             # 本文件
├── QUICKSTART.md        # 场景化快速指南
└── references/
    ├── spec-driven-development/        # Spec驱动开发 (7 文件)
    │   ├── sdd-riper-one-protocol.md  # 核心协议 (RIPER 状态机)
    │   ├── commands.md                  # 6 个原生命令详解
    │   ├── spec-template.md            # Spec 模板 (Standard)
    │   ├── multi-project.md           # 多项目协作规则
    │   ├── archive-template.md        # 归档模板 (Human/LLM)
    │   ├── workflow-quickref.md       # 工作流速查
    │   └── usage-examples.md         # 使用示例
    │
    ├── checkpoint-driven/               # Checkpoint驱动 (4 文件)
    │   ├── SKILL.md                   # 轻量协议 (9 条硬约束)
    │   ├── spec-lite-template.md     # Spec 模板 (Lite)
    │   ├── modules.md                 # Deep/Debug/Review/Multi
    │   └── conventions.md            # 目录约定
    │
    ├── superpowers/                    # 超级能力 (14 文件)
    │   ├── test-driven-development/
    │   │   ├── SKILL.md              # TDD 铁律 + RED-GREEN-REFACTOR
    │   │   └── testing-anti-patterns.md
    │   ├── systematic-debugging/
    │   │   ├── SKILL.md              # Debug 四阶段
    │   │   ├── root-cause-tracing.md
    │   │   ├── defense-in-depth.md
    │   │   ├── condition-based-waiting.md
    │   │   ├── test-pressure-*.md (3个)
    │   │   └── CREATION-LOG.md
    │   ├── subagent-driven-development/
    │   │   ├── SKILL.md              # Subagent 派遣流程
    │   │   ├── implementer-prompt.md
    │   │   ├── spec-reviewer-prompt.md
    │   │   └── code-quality-reviewer-prompt.md
    │   ├── verification-before-completion/
    │   │   └── SKILL.md              # Evidence before Claims
    │   ├── dispatching-parallel-agents/
    │   │   └── SKILL.md              # 并行执行
    │   ├── writing-plans/
    │   │   ├── SKILL.md              # 计划编写
    │   │   └── plan-document-reviewer-prompt.md
    │   └── finishing-a-development-branch/
    │       └── SKILL.md              # 分支完成
    │
    └── test-dev-workflow/              # 测试开发专用 (2 文件)
        ├── test-dev-workflow.md        # 测试开发完整规范
        └── TEST-DEV-WORKFLOW-PROJECT.md # 项目总览
```

---

## 🔑 核心命令速查

| 命令 | 用途 | 深度 |
|------|------|------|
| `>>` / `FAST` | 快速通道 | zero |
| `create_codemap` | 生成代码地图 | standard+ |
| `build_context_bundle` | 整理需求上下文 | standard+ |
| `sdd_bootstrap` | RIPER 启动 | standard+ |
| `REVIEW SPEC` | 执行前评审 | standard+ |
| `REVIEW EXECUTE` | 执行后三轴审查 | standard+ |
| `ARCHIVE` | 归档沉淀 | all |
| `TDD` | 测试驱动开发 | all |
| `DEBUG` | 系统调试 | all |
| `MULTI` | 多项目模式 | standard+ |
| `SUBAGENT` | Subagent 模式 | standard+ |

**测试触发词**: `测试` / `test` / `测试开发` / `自动化测试`

---

## 🏗️ 工作流阶段

```
PRE-RESEARCH ──→ Research ──→ [Innovate] ──→ Plan ──→ Execute ──→ Review ──→ Verification
     │              │              │            │           │           │            │
     ↓              ↓              ↓            ↓           ↓           ↓            ↓
 CodeMap        Spec 初稿       方案比较      任务清单    Checkpoint   偏差报告     验证证据
 Context       STOP-WAIT       STOP-WAIT     STOP-WAIT   阶段暂停     STOP-WAIT    完成
```

---

## ⚡ 自适应深度

| 深度 | 适用场景 | 说明 |
|------|----------|------|
| **zero** | typo、配置值 | 跳过 spec，直接执行 |
| **fast** | 简单功能/修复 | micro-spec (1-3句) |
| **standard** | 2+ 文件改动 | 完整 spec + checkpoint |
| **deep** | 架构/跨模块 | 方案比较 + 详细 plan |

---

## 🛡️ 质量铁律

| 铁律 | 来源 | 含义 |
|------|------|------|
| **No Spec, No Code** | Spec驱动 | 未形成 Spec 不写代码 |
| **No Approval, No Execute** | Checkpoint驱动 | 未获批准不执行 |
| **Evidence before Claims** | 超级能力 | 验证在前，断言在后 |
| **No Fixes Without Root Cause** | 超级能力 | 未找到根因不修复 |
| **Reverse Sync** | Spec驱动 | 发现 bug 先更新 Spec 再修复代码 |
| **No Production Code Without Failing Test First** | TDD | 先写失败测试，再写实现 |

---

## 🔧 Debug 四阶段

| 阶段 | 动作 |
|------|------|
| **Phase 1** | 读日志 + 复现 + 查变更 + 追踪数据流 |
| **Phase 2** | 找相似代码 + 比较差异 + 理解依赖 |
| **Phase 3** | 形成假设 + 最小化测试 |
| **Phase 4** | 创建失败测试 + 单点修复 + 验证 |

**铁律**: 3+ 修复失败 → 质疑架构

---

## 📝 文档路径约定

```
mydocs/
├── specs/                    # Spec 文档
├── codemap/                  # CodeMap 索引
├── context/                  # Context Bundle
├── plans/                   # Implementation Plan
└── archive/                 # 归档 (human + llm)
```

---

## 📖 文档导航

| 文档 | 用途 |
|------|------|
| `SKILL.md` | 主协议入口（引用本地文件） |
| `QUICKSTART.md` | 场景化快速指南 |
| `references/spec-driven-development/sdd-riper-one-protocol.md` | 完整 RIPER 协议 |
| `references/checkpoint-driven/SKILL.md` | 9 条硬约束 |
| `references/superpowers/test-driven-development/SKILL.md` | TDD 完整流程 |
| `references/superpowers/systematic-debugging/SKILL.md` | Debug 四阶段 |
| `references/test-dev-workflow/test-dev-workflow.md` | 测试开发专用规范 |

---

## 📊 来源整合

| 来源 | 贡献 |
|------|------|
| **SDD-RIPER** | RIPER 状态机、Spec 驱动、CodeMap、Archive |
| **SDD-RIPER-Optimized** | Checkpoint 驱动、Lite Spec、按需加载 |
| **Superpowers** | TDD、Debug、Subagent、Verification、并行、计划 |
| **Test-Dev-Workflow** | 测试开发专用模式 |

---

## 版本

- **v1.0**: 2026-04-12
