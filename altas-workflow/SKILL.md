---
name: altas-workflow
version: "4.1"
description: Use when handling repository-grounded engineering tasks that need routing across coding, debugging, review, docs, mapping, archiving, refactoring, testing, performance, or migration workflows.
trigger_keywords: ["FAST", "DEEP", "DEBUG", "MULTI", "DOC", "MAP", "PROJECT MAP", "MAP ALL", "ARCHIVE", "REVIEW", "REVIEW SPEC", "REVIEW EXECUTE", "REFACTOR", "TEST", "PERF", "MIGRATE", "CROSS", ">>", "sdd_bootstrap", "EXIT ALTAS", "快速", "排查", "多项目", "写文档", "链路梳理", "只看代码", "项目总图", "全局地图", "归档", "沉淀", "全部", "代码审查", "审查 PR", "评审规格", "计划评审", "代码评审", "实现复盘", "重构", "写测试", "补测试", "性能优化", "迁移", "版本升级", "跨项目", "验证功能", "退出协议"]
dependencies:
  - reference-index.md  # 统一参考索引入口
  - references/entry/aliases.md  # 入口触发词与模式内控制词词典
  - references/  # 按需加载的参考资料目录
  - protocols/   # 专用协议
compatible_platforms: [cursor, trae, claude, openai, qoder]
min_context_window: 32k
---

# ALTAS Workflow

**Version:** 4.1 — 入口瘦身版。变更日志参考 [SDD-RIPER-ONE Agent Changelog](./references/agents/sdd-riper-one/CHANGELOG.md)。

## Overview

ALTAS Workflow 是仓库工程任务的统一 Bootstrap 入口。它负责三件事：

1. **识别路由**：先判断任务属于 Coding / Debug / Doc / Map / Archive / Review / Refactor / Test / Perf / Migrate / Multi 中哪一类。
2. **评估规模**：再判断 `XS / S / M / L`，决定需要多重的 Spec、Plan、Review 与验证门禁。
3. **按需加载**：入口只保留高杠杆约束；模板、阶段细节、特殊模式协议一律去 `reference-index.md` 与 `references/` 按需读取。

**RIPER** = Research -> Innovate -> Plan -> Execute -> Review

读取本 Skill 后，默认不要立刻写代码。先路由、再定规模、再判断是否只读、再决定是否需要执行许可。

## When to Use

- 需要在当前仓库内做真实工程任务，不只是抽象问答。
- 用户请求涉及编码、调试、文档、链路梳理、归档、代码审查、重构、补测试、性能优化或迁移。
- 任务需要结构化推进，而不是一次性自由发挥。
- 任务可能涉及多文件、跨模块、跨项目、落盘产物或长期知识沉淀。
- 用户命中入口触发词或别名；完整词典见 `references/entry/aliases.md`。

## When NOT to Use

- 纯闲聊、概念解释、与当前仓库无关的信息查询。
- 用户只要极短答案，且不需要工作流路由、代码上下文或落盘产物。
- 任务已经在其他专用协议中明确进行，且无须再经过本入口重新路由。

## Hard Rules

| # | 铁律 | 含义 |
|---|------|------|
| 1 | **Restate First** | 先复述任务，再进入分析、Spec 或执行。 |
| 2 | **Route Before Action** | 先判定模式，再决定是否只读、是否改代码。 |
| 3 | **No Spec, No Code** | 未形成最小 Spec 前不写代码；`XS` 可豁免为事后 summary。 |
| 4 | **No Approval, No Execute** | 高影响执行前必须有明确许可；`XS`、`FAST` 或用户明确要求直接执行时视为已授权。 |
| 5 | **Spec is Truth** | 发现目标、计划或行为偏差时，先修 Spec 再修代码。 |
| 6 | **Evidence First** | 完成由测试、日志、构建、运行结果或代码证据证明，不靠自宣布。 |
| 7 | **No Fixes Without Root Cause** | `DEBUG` 或 Bugfix 任务在根因未清楚前禁止盲改。 |
| 8 | **Resume Ready** | 长任务、中断或上下文紧张时，必须留下恢复锚点。 |

## Entry Contract

### 动作语法

- `create_codemap` / `build_context_bundle` / `sdd_bootstrap` / `archive` 是内部动作语法，不是终端 Shell 命令。
- 这些动作应通过原生检索、读写、任务跟踪工具完成，不要直接在终端执行同名脚本。

### 只读纪律

- `MAP` / `PROJECT MAP` / `DEBUG` / 部分 `DOC` / 部分 `ARCHIVE` 默认是只读路由。
- 只读任务完成分析、CodeMap 或报告后暂停，等待用户决定是否进入编码流。

### 能力降级

- 不支持 Subagent / 并行 Agent / Todo 面板时，自动降级为单会话 + 原子 Checklist + 常规检查点。
- 工具缺失不应阻塞主流程，但必须明确说明降级行为。

### 规则合并

- 本 Skill 负责工程工作流路由与门禁，不负责覆盖宿主平台的系统安全规则。
- 若与宿主平台规则、项目规则或安全约束冲突，优先遵守更严格、更保守的规则。

## 路由速查

完整别名字典与 `MULTI` 模式控制词见 `references/entry/aliases.md`。

| 触发/意图 | 默认路由 | 只读 | 首轮重点 | 按需加载 |
|-----------|----------|------|----------|----------|
| 改代码 / 修 Bug / 新功能 | 标准 Coding 流 | 否 | 规模评估 + 最小 Spec + 门禁 | `references/spec-driven-development/spec-template.md` / `references/checkpoint-driven/spec-lite-template.md` |
| `>>` | FAST | 否 | 确认是否为 `XS/S` | `references/spec-driven-development/workflow-quickref.md` |
| `DEEP` | 深度标准流 | 否 | 默认按 `L` 处理 | `references/superpowers/brainstorming/SKILL.md` |
| `DEBUG` | DEBUG | 是 | 症状、预期、证据、根因候选 | `references/superpowers/systematic-debugging/SKILL.md` |
| `DOC` | DOC | 通常是 | 先抽事实与范围，再给大纲 | `protocols/RIPER-DOC.md` |
| `MAP` | MAP | 是 | 输出功能级 CodeMap | `references/spec-driven-development/commands.md` |
| `PROJECT MAP` | MAP | 是 | 输出项目级 CodeMap | `references/spec-driven-development/commands.md` |
| `ARCHIVE` | ARCHIVE | 通常是 | 基于完成产物做知识沉淀 | `references/spec-driven-development/archive-template.md` |
| `REVIEW` | REVIEW | 是 | 确定范围、目标、深度，再三轴评审 | `references/special-modes/review.md` |
| `REVIEW SPEC` | REVIEW | 是 | 执行前审查 Spec/Plan | `references/superpowers/requesting-code-review/SKILL.md` |
| `REVIEW EXECUTE` | REVIEW | 是 | 执行后三轴评审 | `references/checkpoint-driven/modules.md` |
| `REFACTOR` | REFACTOR | 否 | 先 CodeMap，再计划 | `references/special-modes/refactor.md` |
| `TEST` | TEST | 否 | 先测试现状与优先级 | `references/special-modes/test.md` |
| `PERF` | PERF | 否 | 先基线与瓶颈定位 | `references/special-modes/perf.md` |
| `MIGRATE` | MIGRATE | 否 | 风险、回滚、预演优先 | `references/special-modes/migrate.md` |
| `MULTI` | MULTI | 视任务而定 | 扫描子项目并确认作用域；进入后可使用 `SWITCH` / `REGISTRY` / `SCOPE LOCAL` | `references/spec-driven-development/multi-project.md` |
| `CROSS` | MULTI 扩展 | 否 | 允许跨项目改动，必须明示范围；必要时再切回 `SCOPE LOCAL` | `references/spec-driven-development/multi-project.md` |
| `EXIT ALTAS` | 停止协议 | - | 输出摘要与恢复锚点后退出 | 无 |

## 规模评估

| 规模 | 典型信号 | Spec要求 | 默认流转 |
|------|----------|----------|----------|
| **XS** | typo、配置值、日志、小于 10 行 | 跳过，事后 1 行 summary | 直接执行 -> 验证 -> summary |
| **S** | 1-2 文件、逻辑清晰、影响小 | micro-spec（1-3 句） | micro-spec -> 批准 -> 执行 -> 回写 |
| **M** | 3-10 文件、模块内、需要计划 | 轻量 Spec 落盘 | Research -> Plan -> Execute(TDD) -> Review |
| **L** | 跨模块、架构级、迁移、多项目 | 完整 Spec + Innovate + Archive | Research -> Innovate -> Plan -> Execute(TDD) -> Review -> Archive |

### 判定优先级

1. **影响面 > 文件数 > 代码行数**
2. 跨模块、公共接口、核心链路、数据模型变更至少按 `M`
3. 架构调整、多项目、迁移、重大性能改造默认按 `L`
4. 不确定时向上取整

### 升降级

- 发现复杂度超出预期时立刻暂停，提议 `[升级为 M]` / `[升级为 L]`
- 用户可随时指示 `[降级为 S]` / `[降级为 XS]`

## 首轮响应契约

### 只有触发词，没有任务

输出初始化提示并暂停：

> **ALTAS Workflow v4.1 已加载**
>
> 当前状态: `[IDLE]`
> 可用触发（主形式）: `>>` | `sdd_bootstrap` | `DEEP` | `DEBUG` | `MULTI` | `CROSS` | `DOC` | `MAP` | `PROJECT MAP` | `ARCHIVE` | `REVIEW` | `REVIEW SPEC` | `REVIEW EXECUTE` | `REFACTOR` | `TEST` | `PERF` | `MIGRATE`
> 退出指令: `EXIT ALTAS`
>
> 请描述任务，我将先给出：任务复述 / 模式 / 规模 / 是否只读 / 是否需要执行许可 / 下一步。
>
> `MULTI` 进入后可继续使用：`SWITCH <project_id>` | `REGISTRY` | `SCOPE LOCAL`
> 完整别名字典: `references/entry/aliases.md`

### 已有明确任务

首轮回复默认包含：

- `任务复述`
- `模式`
- `规模`
- `是否只读`
- `是否需要执行许可`
- `参考文档`
- `下一步`

## 检查点契约

| 规模 | 输出要求 |
|------|----------|
| **XS** | 1 行 summary：做了什么 + 如何验证 |
| **S** | 短 checkpoint：当前理解 / 核心目标 / 下一步 |
| **M/L** | 完整检查点，逐步推进 |

### 完整检查点模板（M/L）

```markdown
### 进度 [Phase ▸ Step]
[已完成] ▸ **[当前]** ▸ [下一步] ▸ [后续...]

### 当前成果
- 刚完成了什么

### 预期产出
- 下一步将产出什么

### 下一步操作
- **[继续/Approved/直接执行]**: 同意，进入下一步
- **[修改]** + 意见: 调整当前成果
- **[升级为X]** / **[降级为X]**: 调整规模
- **[加载参考: XXX]**: 查看某参考文档
```

## 阶段门禁摘要

### PRE-RESEARCH

- 适用 `M/L`
- 生成或更新 `CodeMap`、`Context Bundle`、首版 Spec
- 读取 `references/spec-driven-development/commands.md`

### RESEARCH

- 梳理目标、边界、事实、风险、未知项
- Spec 未落盘前不进入实现
- 写 Spec 时读取 `references/spec-driven-development/spec-template.md` 或 `references/checkpoint-driven/spec-lite-template.md`

### INNOVATE

- 仅适用 `L`
- 给出 2-3 个方案并记录取舍
- 读取 `references/superpowers/brainstorming/SKILL.md`

### PLAN

- 拆分原子 Checklist，明确文件、签名、Done Contract
- 未获批不进入 Execute
- 读取 `references/superpowers/writing-plans/SKILL.md`

### EXECUTE

- `XS`: 直接执行
- `S`: micro-spec 后执行
- `M/L`: TDD，优先单项循环；`全部` / `all` 仅在用户明确授权时使用
- 读取 `references/superpowers/test-driven-development/SKILL.md`；`L` 可追加 `references/superpowers/subagent-driven-development/SKILL.md`

### REVIEW

- `M/L` 必须做三轴评审：需求达成、Spec-代码一致、代码质量
- 轴 1 或轴 2 FAIL，回到 Research/Plan
- 读取 `references/checkpoint-driven/modules.md`

### ARCHIVE

- 生成 human / llm 双视角沉淀
- 优先利用现有 Spec、CodeMap、Review 结论，不重新猜测
- 读取 `references/spec-driven-development/archive-template.md`

## 高价值参考索引

| 场景 | 读取文件 |
|------|----------|
| 查看触发词与模式内控制词 | `references/entry/aliases.md` |
| 查看来源整合 | `references/entry/sources.md` |
| 快速回忆整体流程 | `references/spec-driven-development/workflow-quickref.md` |
| 查看完整索引 | `reference-index.md` |
| 写 Spec / 命名约定 | `references/spec-driven-development/spec-template.md`、`references/checkpoint-driven/spec-lite-template.md`、`references/checkpoint-driven/conventions.md` |
| 看动作参数 | `references/spec-driven-development/commands.md` |
| 写 Plan / Execute | `references/superpowers/writing-plans/SKILL.md`、`references/superpowers/test-driven-development/SKILL.md` |
| Debug / Root Cause | `references/superpowers/systematic-debugging/SKILL.md`、`references/superpowers/systematic-debugging/root-cause-tracing.md` |
| Review | `references/special-modes/review.md`、`references/checkpoint-driven/modules.md` |
| Refactor / Test / Perf / Migrate | `references/special-modes/refactor.md`、`references/special-modes/test.md`、`references/special-modes/perf.md`、`references/special-modes/migrate.md` |
| 并行 Agent / Worktree / 双模型 | `references/superpowers/dispatching-parallel-agents/SKILL.md`、`references/superpowers/using-git-worktrees/SKILL.md`、`protocols/SDD-RIPER-DUAL-COOP.md` |
| 高风险严格模式 | `protocols/RIPER-5.md` |

> 若路径读取失败，先使用全局搜索定位；若文件确实缺失，则按标准模式继续，并明确提醒用户依赖不完整。

## 常用产物

统一时间前缀：`YYYY-MM-DD_hh-mm_`

| 产物 | 路径 |
|------|------|
| 功能级 CodeMap | `mydocs/codemap/YYYY-MM-DD_hh-mm_<feature>功能.md` |
| 项目级 CodeMap | `mydocs/codemap/YYYY-MM-DD_hh-mm_<project>项目总图.md` |
| Context Bundle | `mydocs/context/YYYY-MM-DD_hh-mm_<task>_context_bundle.md` |
| Spec | `mydocs/specs/YYYY-MM-DD_hh-mm_<TaskName>.md` |
| Micro-spec | `mydocs/micro_specs/YYYY-MM-DD_hh-mm_<TaskName>.md` |
| Archive | `mydocs/archive/YYYY-MM-DD_hh-mm_<topic>_{human,llm}.md` |

## 异常与恢复

- `EXIT ALTAS`：输出当前阶段摘要、待办、恢复锚点后退出协议。
- Spec 丢失或损坏：基于代码现状和对话重建最小 Spec，标记 `[RECOVERED]` 后请求确认。
- TDD 红灯连续失败：暂停并给出根因候选，不继续盲改。
- Reverse Sync 频繁出现：提议重做 Plan 或升级规模。
- 上下文将满：立即执行 Resume Ready，将状态写回 Spec 后再继续。

本文件是入口，不是完整手册。需要细节时，进入 `reference-index.md` 和 `references/` 按需加载。
