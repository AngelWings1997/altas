# Unified AI Workflow (统一 AI 工作流程)

> 集合 Spec驱动 + Checkpoint驱动 + Subagent驱动三方优势，兼顾速度与质量

---

## 📖 简介

本工作流规范整合了三个优秀的 AI 工作流程：

1. **SDD-RIPER** (Spec-Driven Development) - 规范驱动开发
2. **Checkpoint-Driven** - 检查点驱动流程控制
3. **Superpowers** (Subagent-Driven) - 子代理驱动执行

通过融合三方的核心优势，形成一套**自适应、可伸缩、高质量**的 AI 辅助开发工作流。

---

## ✨ 核心特性

| 特性 | 说明 |
|------|------|
| **🎯 自适应模式** | 根据项目大小自动选择极速/标准/深度三种模式 |
| **⛔ Checkpoint 控制** | 关键节点强制暂停，确保用户掌控 |
| **📊 渐进式披露** | 按需加载信息，避免信息过载 |
| **🔍 质量门禁** | 三轴评审确保 Spec、代码、质量三者一致 |
| **🤖 Subagent 支持** | 复杂任务可启用子代理并行执行 |
| **🐛 系统调试** | 四阶段调试法，根因驱动修复 |

---

## 🚀 快速开始

### 安装

将 `SKILL.md` 的内容添加到 AI 助手的 Custom Instructions 中即可启用。

### 三种启动方式

#### 1. 极速模式 (2分钟任务)

```text
>> 修复登录页面的错别字
>> 将超时时间从 30 秒改为 60 秒
```

**适用**: 单文件修改、配置调整、简单 Bug 修复

#### 2. 标准模式 (30分钟任务)

```text
启动标准工作流：
- task: 用户认证功能重构
- goal: 从 Session 迁移到 JWT 方案
- scope: src/auth/*
```

**适用**: 功能开发、模块重构、接口修改

#### 3. 深度模式 (2小时+ 任务)

```text
启动深度工作流：
- task: 微服务架构拆分
- goal: 从单体拆分为 3 个独立服务
- projects: [api-service, web-console, admin-portal]
```

**适用**: 架构改造、复杂功能、多项目协作

---

## 📊 项目大小评估

| 维度 | 极速模式 | 标准模式 | 深度模式 |
|------|----------|----------|----------|
| 代码行数 | < 50 行 | 50-500 行 | > 500 行 |
| 文件数 | 1-2 个 | 3-10 个 | > 10 个 |
| 模块跨越 | 单一模块 | 2-3 个模块 | 多模块/跨项目 |
| 架构影响 | 无 | 局部 | 全局 |
| 预估时间 | < 10 分钟 | 10-60 分钟 | > 60 分钟 |

---

## 🔄 工作流程图

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        UNIFIED AI WORKFLOW                                  │
├─────────────┬─────────────┬─────────────┬─────────────┬─────────────────────┤
│ PRE-RESEARCH│   RESEARCH  │    PLAN     │   EXECUTE   │      REVIEW         │
│   (可选)     │   (LOCKED)  │   (LOCKED)  │   (ACTIVE)  │     (LOCKED)        │
├─────────────┼─────────────┼─────────────┼─────────────┼─────────────────────┤
│ CodeMap     │ 需求理解     │ 详细设计     │ 代码实现     │ 三轴评审             │
│ Context     │ 现状分析     │ 任务分解     │ 测试验证     │ 偏差分析             │
│ Bundle      │ 风险识别     │ Checkpoint  │ 进度同步     │ 知识沉淀             │
└─────────────┴─────────────┴─────────────┴─────────────┴─────────────────────┘
```

---

## 🎓 核心理念

```
Spec is Truth + Checkpoint Gates + Progressive Disclosure + Quality First
```

### 六大铁律

| 铁律 | 含义 |
|------|------|
| **No Spec, No Code** | 未形成 Spec 不写代码（FAST 模式除外） |
| **Checkpoint Gates** | 关键节点必须暂停等待确认 |
| **Evidence before Claims** | 验证在前，断言在后 |
| **No Fixes Without Root Cause** | 未找到根因不修复 |
| **Reverse Sync** | 执行后发现偏差先更新 Spec 再修复代码 |
| **Fresh Context Per Task** | 每个任务使用独立上下文 |

---

## 📋 命令速查

### 模式切换

| 命令 | 作用 |
|------|------|
| `>>` / `FAST` / `快速` | 极速模式 |
| `启动标准工作流` | 标准模式 |
| `启动深度工作流` | 深度模式 |

### 阶段控制

| 命令 | 作用 |
|------|------|
| `继续` / `下一步` | 执行下一步 |
| `全部` / `all` | 批量执行 |
| `批准` / `Plan Approved` | 批准计划进入执行 |

### 辅助功能

| 命令 | 作用 |
|------|------|
| `MAP` | 生成代码地图 |
| `REVIEW SPEC` | 计划预审 |
| `REVIEW EXECUTE` | 执行后评审 |
| `ARCHIVE` | 知识沉淀 |
| `DEBUG` | 启动调试模式 |
| `SUBAGENT` | 启用子代理模式 |

---

## 📁 文件结构

```
mydocs/
├── specs/              # Spec 文件
│   └── YYYY-MM-DD_hh-mm_<TaskName>.md
├── codemap/            # 代码地图
│   └── YYYY-MM-DD_hh-mm_<name>.md
├── context/            # 需求汇总
│   └── YYYY-MM-DD_hh-mm_<task>_context_bundle.md
├── archive/            # 知识沉淀
│   ├── YYYY-MM-DD_hh-mm_<topic>_human.md
│   └── YYYY-MM-DD_hh-mm_<topic>_llm.md
└── plans/              # 执行计划
    └── YYYY-MM-DD-<feature-name>.md
```

---

## 📚 完整文档

详细规范请查看 [SKILL.md](./SKILL.md)，包含：

- 完整的阶段详解
- 每个阶段的输入输出
- STOP-AND-WAIT 检查点说明
- 三轴评审标准
- TDD 执行规范
- DEBUG 四阶段法
- Subagent 派遣流程
- 示例对话

---

## 🔗 参考来源

本工作流整合了以下优秀规范：

1. **SDD-RIPER** - Spec-Driven Development with RIPER State Machine
2. **Checkpoint-Driven Development** - Hard constraints and phase gates
3. **Superpowers** - Subagent-driven execution and systematic debugging

---

**版本**: v1.0  
**更新**: 2026-04-12
