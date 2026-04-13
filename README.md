# SIGMA Workflow

> **统一 AI 原生研发工作流，让 AI 助手真正帮你写好代码**

---

## 🎯 这是什么？

**SIGMA Workflow** 是一套整合了多个优秀 AI 工作流的**全集协议**，让 AI 助手能够在软件开发过程中保持高质量输出。

### 解决的问题

| 痛点 | SIGMA 解法 |
|------|-----------|
| AI 盲目写代码，不考虑需求 | **Spec 驱动** - 先明确需求再动手 |
| AI 代码不符合预期 | **Checkpoint 审批** - 每步执行前等待批准 |
| Bug 调试靠"试一下" | **系统调试** - 4 阶段根因分析 |
| 测试靠后补 | **TDD 铁律** - 先写失败测试 |
| 多任务并行效率低 | **Subagent 模式** - 派遣专业子任务 |

---

## 📦 包含什么？

```
altas/
├── sigma-workflow/           # 主协议目录
│   ├── SKILL.md            # ⭐ 一键安装的 Skill 文件
│   ├── README.md           # SIGMA 详细说明
│   ├── QUICKSTART.md       # 场景化快速指南
│   └── references/         # 完整协议内容 (36 个文件)
│       ├── spec-driven-development/   # Spec 驱动开发
│       ├── checkpoint-driven/        # Checkpoint 审批
│       └── superpowers/              # 超级能力 (TDD/Debug/Subagent)
```

---

## 🚀 如何快速使用？

### 30 秒安装

**方法 1**: 复制 `sigma-workflow/SKILL.md` 内容到 AI 助手的 Custom Instructions

**方法 2**: 在 Cursor 中运行：
```bash
cp sigma-workflow/SKILL.md .cursorrules
```

---

### 立即使用

**小改动 (10 秒)**:
```
>> 修复登录超时的 bug
```

**标准任务**:
```
请使用 SIGMA 工作流：
- task: 用户认证功能重构
- goal: 迁移到 JWT 方案
- scope: src/auth/*
```

**测试开发任务**:
```
我要为登录功能设计测试方案
```

**复杂任务**:
```
请使用 SIGMA deep 模式：
- task: 微服务架构拆分
```

---

## 📚 核心命令

| 命令 | 用途 |
|------|------|
| `>>` / `FAST` | 快速通道，跳过 Plan |
| `create_codemap` | 生成代码地图 |
| `sdd_bootstrap` | 启动 RIPER 流程 |
| `REVIEW SPEC` | 执行前评审 |
| `TDD` | 测试驱动开发 |
| `DEBUG` | 系统调试模式 |

---

## 🏗️ 工作流阶段

```
Research ──→ [Innovate] ──→ Plan ──→ Execute ──→ Review ──→ Verification
    ↓              ↓            ↓           ↓           ↓            ↓
 Spec 初稿      方案比较      任务清单    Checkpoint   偏差报告     验证证据
```

---

## ⚡ 自适应深度

| 深度 | 适用场景 | 时间 |
|------|----------|------|
| **zero** | typo、配置修改 | < 1 分钟 |
| **fast** | 简单功能/修复 | < 10 分钟 |
| **standard** | 2+ 文件改动 | 10 分钟 - 2 小时 |
| **deep** | 架构改动、跨模块 | 2 小时 + |

---

## 🛡️ 质量铁律

- **No Spec, No Code** - 未形成 Spec 不写代码
- **No Approval, No Execute** - 未获批准不执行
- **Evidence before Claims** - 验证在前，断言在后
- **No Fixes Without Root Cause** - 未找到根因不修复
- **No Production Code Without Failing Test First** - 先写失败测试

---

## 📖 详细文档

- [SIGMA Workflow 详细说明](sigma-workflow/README.md)
- [快速启动指南](sigma-workflow/QUICKSTART.md)

---

## 🤝 来源

本协议整合自以下优秀工作流：

| 工作流 | 贡献 |
|--------|------|
| **SDD-RIPER** | Spec 驱动、RIPER 状态机、CodeMap |
| **SDD-RIPER-Optimized** | Checkpoint 驱动、按需加载 |
| **Superpowers** | TDD、Debug、Subagent、Verification |
| **Test-Dev-Workflow** | 测试开发专用模式 |

---

## 版本

- **v1.0**: 2026-04-12
