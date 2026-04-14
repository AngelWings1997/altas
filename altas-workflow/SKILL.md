---
name: altas-workflow
version: "4.0"
description: Auto-evaluates task size (XS/S/M/L) and routes to Spec-Driven, Checkpoint-Driven, or Superpowers workflow. Entry point for coding, debugging, docs, mapping, archiving, review, refactor, test, perf, migrate.
trigger_keywords: ["FAST", "DEEP", "DEBUG", "MULTI", "DOC", "MAP", "ARCHIVE", "REVIEW", "REFACTOR", "TEST", "PERF", "MIGRATE", ">>", "sdd_bootstrap", "快速", "排查", "多项目", "写文档", "链路梳理", "归档", "全部", "代码审查", "重构", "写测试", "性能优化", "迁移"]
dependencies:
  - references/  # 按需加载的参考资料目录
  - protocols/   # 专用协议
compatible_platforms: [cursor, trae, claude, openai, qoder]
min_context_window: 32k
---

# ALTAS Workflow

**Version:** 4.0 — 变更日志参考 [SDD-RIPER-ONE Agent Changelog](./references/agents/sdd-riper-one/CHANGELOG.md)（ALTAS Workflow 基于该 Agent 演进）

## Overview

ALTAS Workflow 是融合 Spec-Driven Development、Checkpoint-Driven 与 Superpowers 的综合性 AI 工作流程规范，也是编码、调试、文档、链路梳理、归档等工程任务的统一入口。

**RIPER** = Research → Innovate → Plan → Execute → Review（五阶段门禁状态机）

接到任务后，**不要立刻编写代码**。你必须：

1. **评估规模** → 自动选择工作流深度
2. **判定模式** → 先决定这是 Coding / Debug / Doc / Map / Archive 中的哪一种入口
3. **逐步推进** → 每步完成后输出进度检查点
4. **按需加载** → 只在命中场景时读取对应参考文档
5. **铁律约束** → No Spec No Code, No Approval No Execute, Evidence First

**核心原则：**
- **Spec is Truth** — Spec 是唯一真相源，代码是消耗品
- **No Approval, No Execute** — 进入高影响执行前必须有明确执行许可
- **Evidence First** — 完成由验证结果证明，非模型自宣布

---

## 入口约定

> 本节定义 AI 读取本 Skill 后的默认行为约束，必须严格遵守。

### 动作语法约定

- `create_codemap` / `build_context_bundle` / `sdd_bootstrap` / `archive` 等名称是**技能内部动作语法**，不是终端 Shell 命令
- 应通过原生检索、读写、任务跟踪工具完成，不得在终端中执行这些名称的 Shell 脚本

### 只读模式约定

- 若任务是只读分析（如 `MAP` / `DEBUG` / 部分 `DOC` / `ARCHIVE`），先走只读模式，不要默认进入代码修改流程
- 只读任务产出 CodeMap/分析报告后暂停，等待用户指示是否进入编码流程

### 能力降级约定

- 若环境**不支持** Subagent / 并行 Agent / 专用任务面板，则自动降级为单会话执行 + 原子 Checklist + 常规检查点
- 不得因工具缺失而阻塞主流程

### 规则优先级约定

- 本 Skill 的铁律约束优先于通用行为准则（如 `AGENTS.md` / `CLAUDE.md`）
- 两者重叠时以本文件为准

---

## When to Use

- 作为工程任务总入口使用：编码、调试、文档、代码链路梳理、归档
- 实现新功能、修复 Bug、重构代码
- 需要只读分析仓库、生成 CodeMap、整理知识沉淀
- 需要结构化开发流程和规范约束
- 用户请求涉及多文件、跨模块改动
- 需要生成 Spec、CodeMap、Archive 等产物
- 用户输入触发词：`FAST`、`DEEP`、`DEBUG`、`MULTI`、`DOC`、`MAP`、`ARCHIVE`、`REVIEW`、`REFACTOR`、`TEST`、`PERF`、`MIGRATE`、`sdd_bootstrap`

## When NOT to Use

- 纯粹的闲聊、概念问答、与当前仓库无关的信息查询
- 用户只要一个极短答案，且不需要工作流路由、代码上下文或产物落盘
- 用户明确要求跳过标准流程时，可用 `>>` / `FAST` 进入极速通道，而不是完全退出本入口

---

## Quick Reference

### 规模评估速查

| 规模 | 触发条件 | Spec要求 | 工作流 |
|------|----------|----------|--------|
| **XS** | typo/配置值，<10行 | 跳过，事后1行summary | 直接执行→验证→summary |
| **S** | 1-2文件，逻辑清晰 | micro-spec (1-3句) | micro-spec→批准→执行→回写 |
| **M** | 3-10文件，模块内 | 轻量Spec落盘 | Research→Plan→Execute(TDD)→Review |
| **L** | 跨模块，>500行，架构级 | 完整Spec+Innovate+Archive | Research→Innovate→Plan→Execute(TDD)→Subagent(若支持)→Review→Archive |

### 自动升降级

- 执行中发现复杂度超出预期 → 立即暂停，提议升级
- 用户随时可用 `[升级为 M]` / `[降级为 S]` 调整

### 规模评估决策优先级

**当多个条件冲突时，按以下优先级判定**:

1. **影响面 > 文件数 > 代码行数**
2. **跨模块/架构级影响 → 至少 M**
3. **核心链路变更 → 至少 M**
4. **不确定时 → 向上取整**

**示例**:
- "3 个文件但每个改动很小" → 若跨模块 → M；若模块内 → S
- "1 个文件但涉及核心架构" → M（向上取整）
- "跨 2 个模块但只是配置变更" → S（影响面小）

### 触发词速查

| 触发词 | 动作 |
|--------|------|
| `>>` / `FAST` / `快速` | 极速通道 (Size XS/S) |
| `DEEP` | Size L 深度模式 |
| `DEBUG` / `排查` | 系统化Debug |
| `MULTI` / `多项目` | 多项目模式 |
| `DOC` / `写文档` | 文档专家模式 |
| `MAP` / `链路梳理` | 功能级CodeMap |
| `ARCHIVE` / `归档` | 知识沉淀 |
| `REVIEW` / `代码审查` | 代码审查模式 |
| `REFACTOR` / `重构` | 重构专项（默认 M/L） |
| `TEST` / `写测试` / `补测试` | 测试专项 |
| `PERF` / `性能优化` | 性能优化（先 Profile） |
| `MIGRATE` / `迁移` | 数据/版本迁移 |
| `全部` / `all` | 批量执行 |

### 入口路由速查

| 用户意图 | 默认路由 | 首轮重点 |
|----------|----------|----------|
| 改代码 / 修 Bug / 重构 | XS/S/M/L 标准流 | 规模评估 + Spec/Plan/Execute 门禁 |
| 排查问题 / 看日志 / 验证行为 | `DEBUG` | 只读定位 + 根因分析，必要时再转编码流 |
| 写文档 / 汇总说明 | `DOC` | 事实提取 + 大纲 + 对照代码验证 |
| 只看代码 / 梳理链路 | `MAP` | 只读分析 + CodeMap 产出 |
| 归档沉淀 / 总结经验 | `ARCHIVE` | 基于已完成 Spec/CodeMap 提炼知识 |
| 代码审查 / 审查 PR | `REVIEW` | 三轴评审 + requesting/receiving-code-review 协议 |
| 重构代码 | `REFACTOR` | 默认 M/L，必须先 CodeMap 再 Plan |
| 补测试 / 写测试 | `TEST` | TDD 模式，先 RED 后 GREEN |
| 性能优化 | `PERF` | 先 Profile 定位瓶颈，再进入标准流 |
| 数据迁移 / 版本升级 | `MIGRATE` | 默认 L，必须有回滚方案 |

### 能力探测与降级

- 若环境支持 Subagent / 并行 Agent，`L` 规模可启用并行执行与两阶段 Review。
- 若环境不支持 Subagent / 并行 Agent，则 `L` 规模自动降级为单代理串行执行，不降低 Spec、Review、Evidence 等门禁要求。
- 若环境支持 Todo/Task 面板，则在 Plan / Execute 期间同步原子 Checklist；否则直接在对话和 Spec 中维护 Checklist 即可。

---

## 溯源

本 Skill 整合了以下来源的核心能力，已内化至本文件，**无需额外加载独立 Skill**:

| 来源 | 采纳的核心能力 |
|------|---------------|
| **SDD-RIPER** | Spec 中心论、RIPER 状态机、三轴 Review、Multi-Project、Debug/Archive 协议 |
| **SDD-RIPER-ONE Light** | Checkpoint-Driven 轻量模式、4 级任务深度、Done Contract、Hot/Warm/Cold 上下文 |
| **Superpowers** | TDD 铁律、系统化 Debug、Subagent 驱动、并行 Agent、验证优先 |

> 完整参考文档仍存在于 `references/` 目录，按需加载获取详细参数和模板。

---

## 铁律约束

| # | 铁律 | 含义 |
|---|------|------|
| 1 | **No Spec, No Code** | 未形成最小Spec前不写代码 (Size XS豁免) |
| 2 | **No Approval, No Execute** | 进入高影响执行前必须获得明确执行许可；XS/FAST 或用户明确要求直接执行时可视为已授权 |
| 3 | **Spec is Truth** | Spec与代码冲突时，代码是错的；Bug先修Spec再修代码 |
| 4 | **Reverse Sync** | 执行中发现偏差→先更新Spec→再修代码 |
| 5 | **Evidence First** | 完成由验证结果证明，非模型自宣布 |
| 6 | **No Fixes Without Root Cause** | Bug修复前必须有根因分析，禁止盲改 |
| 7 | **TDD Iron Law** | Size M/L: 无失败测试不写生产代码 (Size XS/S豁免) |
| 8 | **Resume Ready** | 长任务暂停前在Spec中留恢复锚点 |

---

## 异常恢复与降级策略

> 本节定义 AI 执行过程中遇到异常情况时的处理策略。

| 场景 | 处理方式 |
|------|----------|
| **参考文件读取失败**（路径正确但权限/编码问题） | 降级为基于常识的标准模式执行，输出警告提醒用户补全依赖；不因单个参考文件缺失而阻塞主流程 |
| **Spec 文件损坏或中途丢失** | 从代码现状 + 对话历史重建最小 Spec（Goal + Scope），标记 `[RECOVERED]`，请求用户确认后继续 |
| **用户执行取消 / `EXIT ALTAS`** | 输出当前阶段摘要（已完成项 / 待完成项 / 恢复锚点写入 Spec）；半成品保留在 mydocs/ 不自动删除 |
| **TDD 红灯连续 3 次无法变绿** | 暂停执行，输出根因分析候选（测试逻辑错 / 接口签名不匹配 / 依赖 mock 缺失），请求用户指示后再继续 |
| **Plan 执行中频繁偏差（>2 次 Reverse Sync）** | 自动提议 `[升级规模]` 或 `[重新 Plan]`，表明当前 Plan 与实际复杂度不匹配 |
| **Review 轴 1 或轴 2 FAIL** | 必须回到 Research/Plan 修正，不得自行绕过；输出具体 FAIL 项与修复建议 |
| **上下文窗口即将耗尽** | 立即执行 Resume Ready：将完整状态写入 Spec 的恢复锚点，输出 `[CONTEXT_FULL]` + 恢复指令 |

> **核心原则**: 任何异常都不应导致静默失败或数据丢失。每一步都必须有可观测的中间状态。

---

## 进度可视化系统

> 本节定义 AI 执行过程中的进度输出规范。

### 进度输出策略 (按规模差异化)

| 规模 | 输出格式 |
|------|----------|
| **XS** | 1 行 summary (完成什么 + 验证结果) |
| **S** | 短 checkpoint: 当前理解 / 核心目标 / 下一步 |
| **M/L** | 完整检查点 (如下模板) |

### 完整检查点模板 (仅 M/L)

**每个步骤完成后**，必须输出以下格式：

```markdown
### 进度 [Phase ▸ Step]
[已完成] ▸ **[当前]** ▸ [下一步] ▸ [后续...]

### 当前成果
- 刚完成了什么（具体产出）

### 预期产出
- 下一步将会产出什么

### 下一步操作
- **[继续/Approved/直接执行]**: 同意，进入下一步
- **[修改]** + 意见: 调整当前成果
- **[升级为X]** / **[降级为X]**: 调整规模
- **[加载参考: XXX]**: 查看某参考文档的详情
```

---

## 阶段执行指南

> 本节仅保留入口阶段所需的门禁级摘要。需要模板、完整命令参数或扩展规则时，跳转到文末索引或 `reference-index.md` 按需加载。

**IDE 原生工具调用建议**:
- **检索优先**: 先用原生 `SearchCodebase`、`Grep`、`Glob` 做全局定位，再决定读哪些文件，避免盲目逐个 `ls` / `cat`。
- **读取其次**: 确认目标后再用原生读文件工具精读关键文件，不在探索期大面积顺序通读。
- **写入专用**: 产物落盘、Spec 回写、代码修改优先用原生文件工具完成；终端主要用于测试、构建、脚本执行与验证。
- **任务跟踪**: 若环境支持 Todo/Task 面板，则在 Plan / Execute 期间同步原子任务；若不支持，则在对话检查点与 Spec 中维护 Checklist。

### PRE-RESEARCH (输入准备) — 适用 M/L

> *说明：以下名称是 AI 内部动作语法，请自行通过原生检索、读写、任务跟踪工具完成，不要在终端中执行这些名称的 Shell 脚本。*

| 命令 | 用途 | 产出 |
|------|------|------|
| `create_codemap` | 生成代码索引地图 | `mydocs/codemap/YYYY-MM-DD_hh-mm_<name>.md` |
| `build_context_bundle` | 整理需求上下文 | `mydocs/context/YYYY-MM-DD_hh-mm_<task>_context_bundle.md` |
| `sdd_bootstrap` | RIPER 启动，汇总输入产出首版 Spec | `mydocs/specs/YYYY-MM-DD_hh-mm_<TaskName>.md` |

> **按需加载**: 进入此阶段时读取 `references/spec-driven-development/commands.md`

### RESEARCH (研究对齐) — 适用 M/L

- **动作**: 复述任务目标，梳理代码现状，形成事实依据，标识未知项
- **产出**: 建立/更新 Spec（Goal, In-Scope, Out-of-Scope, Facts, Risks, Open Questions）
- **门禁**: 事实有证据支撑，未知项已标注；(铁律 #1) Spec 未落盘前不进入代码实现
- **完成后**: 输出检查点 → 等待用户确认

> **按需加载**: 写Spec时读取 `references/spec-driven-development/spec-template.md` (M/L) 或 `references/checkpoint-driven/spec-lite-template.md` (S)

### INNOVATE (方案对比) — 仅适用 L

- **动作**: 给出2-3种方案，对比 Pros/Cons/Risks/Effort
- **产出**: 在Spec中记录Decision和Trade-offs
- **完成后**: 输出检查点 → 等待用户选定方案

> **按需加载**: 设计阶段读取 `references/superpowers/brainstorming/SKILL.md`

### PLAN (详细规划) — 适用 M/L

- **动作**: 将任务拆解为原子Checklist，明确File Changes + Signatures + Done Contract
- **产出**: Spec中更新Plan部分
- **门禁**: (铁律 #2) 必须获得明确执行许可才能进入Execute；`[Approved]`、`按此计划继续`、`直接执行` 等同意图均可视为许可
- **完成后**: 输出检查点，含完整Checklist摘要 → 等待执行许可

> **按需加载**: 写Plan时读取 `references/superpowers/writing-plans/SKILL.md`

### EXECUTE (执行实现) — 适用 XS/S/M/L

| 规模 | 执行策略 |
|------|----------|
| **XS** | 直接修改→验证→1行summary |
| **S** | micro-spec→批准→执行→回写 |
| **M** | TDD: RED→GREEN→REFACTOR，逐步或批量 |
| **L** | TDD: RED→GREEN→REFACTOR + Subagent驱动（若环境支持）+ 两阶段Review |

**M/L 执行纪律**:
- **红线**: 严格禁止在一个对话轮次中实现多个 Checklist 项。必须严格遵守“实现单项 → 输出检查点请求 Review → 获批后再执行下一项”的单步循环，防止上下文超载。
- `全部`/`all`/`execute all` → 批量执行剩余项（仅在用户明确授权时可用）
- 编译错误可自动修；逻辑变更必须回到Plan
- 偏差暴露→(铁律 #4) 先更新Spec→再修代码→重对齐核心目标

> **按需加载**: TDD执行时读取 `references/superpowers/test-driven-development/SKILL.md`
> **按需加载**: L规模并行执行时读取 `references/superpowers/subagent-driven-development/SKILL.md`

### REVIEW (审查) — 适用 M/L；S 规模简单回写验证即可

**三轴评审 (M/L 必须全部输出)**:

| 轴 | 检查项 | **PASS 判定** | **FAIL 判定** | **PARTIAL 判定** |
|----|--------|--------------|--------------|----------------|
| Spec质量与需求达成 | Goal/In-Scope/Acceptance是否完整；需求是否达成 | Goal 明确可验证，In-Scope 边界清晰，所有 Acceptance Criteria 有对应测试通过 | Goal 模糊或缺失验收标准；核心需求未实现；Out-of-Scope 项被误实现 | 非核心 Acceptance 缺测试覆盖；Goal 描述可进一步精确化 |
| Spec-代码一致性 | 文件、签名、Checklist、行为是否与Plan一致 | 所有 Plan 中的文件变更、函数签名、Checklist 项均有对应代码且行为匹配 | 计划外的文件被修改；签名与 Plan 不符；Checklist 项遗漏或多余 | 注释/日志等非关键差异；次要文件路径调整未回写 Plan |
| 代码内在质量 | 正确性、鲁棒性、可维护性、测试、关键风险 | 核心逻辑有测试覆盖；无已知 bug 或安全漏洞；错误处理完备 | 存在未处理的异常路径；安全漏洞；关键逻辑无测试 | 代码风格不统一（不影响正确性）；性能非瓶颈处可优化 |

**门禁逻辑**:
- 轴1或轴2 = FAIL → 回到Research/Plan
- 轴3有高风险未解决 → 回到Plan

> **按需加载**: 进入Review时读取 `references/checkpoint-driven/modules.md`

### ARCHIVE (知识沉淀) — 推荐用于 L，M 也可按需使用

- 生成双视角文档：human版（汇报视角）+ llm版（后续开发参考）
- 每个结论附 `Trace to Sources` 映射
- 产出: `mydocs/archive/YYYY-MM-DD_hh-mm_<topic>_{human,llm}.md`
- 自动化: 若本地存在 `scripts/archive_builder.py` 脚本，可调用执行；若不存在，AI 应直接通过读写文件工具自行生成 Markdown 沉淀，切勿盲目执行 Shell 命令。

> **按需加载**: 进入Archive时读取 `references/spec-driven-development/archive-template.md`

---

## 特殊模式

> 以下仅保留“何时进入 / 首轮做什么 / 何时升级”的入口摘要。模式细节、模板和扩展策略统一从文末索引或 `reference-index.md` 获取。

### FAST 模式 (极速通道)

- **触发**: `>>` 前缀 / `FAST` / `快速`
- **流程**: 跳过Research和Plan → 直接执行 → 事后同步Spec
- **允许**: UI微调、配置修改、单文件逻辑、typo、日志
- **升级**: 触及>2核心文件或架构 → 暂停，提议切换到标准模式

### DEBUG 模式 (系统化排查)

- **触发**: `DEBUG` / `排查` / `日志分析`
- **铁律**: 无根因不修复
- **子模式**:
  - 诊断模式(有issue): 日志+Spec+代码三角定位→根因候选
  - 验证模式(有spec): 日志证据 vs Spec验收标准→PASS/FAIL/INCONCLUSIVE
- **约束**: 只读分析；代码修改需进入RIPER或FAST

> **按需加载**: 进入Debug时读取 `references/superpowers/systematic-debugging/SKILL.md`；根因不明时追加 `root-cause-tracing.md`，异步问题时追加 `condition-based-waiting.md`

### MULTI 模式 (多项目协作)

- **触发**: `MULTI` / `多项目`
- **自动发现**: 扫描workdir识别子项目（package.json/pom.xml/go.mod等）
- **作用域**: 默认`local`（仅改当前项目）；`CROSS`/`跨项目`→允许跨项目

> **按需加载**: 进入多项目模式时读取 `references/spec-driven-development/multi-project.md`

### DOC 模式 (文档专家)

- **触发**: `DOC` / `写文档` / 生成文档类任务
- **首轮动作**: 先提取事实与文档范围，再给大纲，不直接长篇撰写
- **纪律**: 不猜测实现；每个细节必须对照实际代码验证

> **按需加载**: 进入DOC模式时读取 `protocols/RIPER-DOC.md`

### MAP 模式 (代码链路梳理)

- **触发**: `MAP` / `链路梳理` / `只看代码`
- **约束**: **只读分析，不改代码** — 输出 CodeMap 后暂停等待用户指示
- **产出**: `mydocs/codemap/YYYY-MM-DD_hh-mm_<feature>功能.md`
- **升级**: 用户要求基于 CodeMap 修改代码 → 进入 Research→Plan→Execute 标准流程

> **按需加载**: 进入MAP模式时读取 `references/spec-driven-development/commands.md` (create_codemap 参数)

### ARCHIVE 模式 (知识沉淀)

- **触发**: `ARCHIVE` / `归档` / `沉淀`
- **前提**: 目标 Spec 已完成 Review
- **完整流程与产物规范 → 见 [阶段执行指南 ARCHIVE 节](#archive-知识沉淀--推荐用于-lm-也可按需使用)**

> **按需加载**: 进入 Archive 时读取 `references/spec-driven-development/archive-template.md`

### REVIEW 模式 (代码审查)

- **触发**: `REVIEW` / `代码审查` / `审查 PR`
- **流程**: 确认审查范围/目标/深度 → 三轴评审 → 问题分级 → 输出审查报告
- **门禁**: 轴 1 或轴 2=FAIL → 回到 Research/Plan；轴 3 有 P0 问题 → 必须修复

> **按需加载**: 进入 REVIEW 时读取 `references/special-modes/review.md`；三轴评审标准追加 `references/checkpoint-driven/modules.md`

### REFACTOR 模式 (重构专项)

- **触发**: `REFACTOR` / `重构`
- **流程**: CodeMap 先行 → 坏味道识别 → 制定重构计划 → 小步执行 (TDD 循环) → 重构后审查
- **铁律**: 每步重构后必须验证行为不变；不允许重构中混入新功能

> **按需加载**: 进入 REFACTOR 时读取 `references/special-modes/refactor.md`；TDD 执行追加 `references/superpowers/test-driven-development/SKILL.md`

### TEST 模式 (测试专项)

- **触发**: `TEST` / `写测试` / `补测试`
- **流程**: 测试现状分析 → 优先级排序 → 编写测试 → 覆盖率验证 → 输出测试报告
- **注意**: 新功能/新 Bug 修复使用标准工作流的 Execute(TDD) 阶段，不需要单独触发 TEST 模式

> **按需加载**: 进入 TEST 时读取 `references/special-modes/test.md`；测试反模式追加 `references/superpowers/test-driven-development/testing-anti-patterns.md`

### PERF 模式 (性能优化)

- **触发**: `PERF` / `性能优化`
- **流程**: 基准测试 (建立基线) → Profile 定位瓶颈 → 优化方案对比 → 小步执行 (优化→验证循环) → 优化后验证
- **铁律**: 每次只应用一个优化；每个优化必须有可量化的性能提升；不允许以牺牲正确性为代价换取性能

> **按需加载**: 进入 PERF 时读取 `references/special-modes/perf.md`；验证策略追加 `references/superpowers/verification-before-completion/SKILL.md`

### MIGRATE 模式 (数据/版本迁移)

- **触发**: `MIGRATE` / `迁移` / `数据迁移` / `版本升级`
- **流程**: 风险评估 → 制定迁移方案 → 制定回滚方案 (必须) → 预演迁移 (强烈推荐) → 执行迁移 → 迁移后验证
- **铁律**: 未备份禁止执行；未验证回滚禁止执行；达到回滚触发条件必须立即回滚

> **按需加载**: 进入 MIGRATE 时读取 `references/special-modes/migrate.md`；风险评估追加 `references/superpowers/brainstorming/SKILL.md`

---

## 参考资料索引 (按需加载)

> 本节只保留入口级高频导航；完整索引请读取 [reference-index.md](./reference-index.md)。
> *注意：所有参考路径相对于本规范所在目录或 `altas-workflow/`。如果尝试读取时找不到文件，请使用全局搜索（Glob/Search）定位；若确实缺失，请基于自身常识按标准模式执行，并提醒用户补全依赖。*

**入口优先级：**

| 触发场景 | 读取文件 |
|----------|----------|
| 快速回忆整体流程 | `references/spec-driven-development/workflow-quickref.md` |
| 查看完整参考目录 | `reference-index.md` |
| 写 Spec / 命名约定 | `references/spec-driven-development/spec-template.md`、`references/checkpoint-driven/spec-lite-template.md`、`references/checkpoint-driven/conventions.md` |
| 查看动作参数 | `references/spec-driven-development/commands.md` |
| 写 Plan / Execute | `references/superpowers/writing-plans/SKILL.md`、`references/superpowers/test-driven-development/SKILL.md` |
| Debug / Review | `references/superpowers/systematic-debugging/SKILL.md`、`references/checkpoint-driven/modules.md` |
| **特殊模式** | |
| 代码审查 (REVIEW) | `references/special-modes/review.md` |
| 重构专项 (REFACTOR) | `references/special-modes/refactor.md` |
| 测试专项 (TEST) | `references/special-modes/test.md` |
| 性能优化 (PERF) | `references/special-modes/perf.md` |
| 数据/版本迁移 (MIGRATE) | `references/special-modes/migrate.md` |
| **L 规模扩展能力** | |
| 并行 Agent 派遣 | `references/superpowers/dispatching-parallel-agents/SKILL.md` |
| 非 Subagent 执行 Plan | `references/superpowers/executing-plans/SKILL.md` |
| Git Worktree 隔离开发 | `references/superpowers/using-git-worktrees/SKILL.md` |
| 请求 / 接收代码审查 | `references/superpowers/requesting-code-review/SKILL.md`、`references/superpowers/receiving-code-review/SKILL.md` |
| 完成分支决策 | `references/superpowers/finishing-a-development-branch/SKILL.md` |
| 严格模式协议 (高风险) | `protocols/RIPER-5.md` |
| 双模型协作 | `protocols/SDD-RIPER-DUAL-COOP.md` |
| 文档 / 归档 / 可视化 | `protocols/RIPER-DOC.md`、`references/spec-driven-development/archive-template.md`、`workflow-diagrams.md` |

---

## 产物命名约定

统一时间前缀: `YYYY-MM-DD_hh-mm_`

| 产物 | 路径 |
|------|------|
| CodeMap(功能级) | `mydocs/codemap/YYYY-MM-DD_hh-mm_<feature>功能.md` |
| CodeMap(项目级) | `mydocs/codemap/YYYY-MM-DD_hh-mm_<project>项目总图.md` |
| Context Bundle | `mydocs/context/YYYY-MM-DD_hh-mm_<task>_context_bundle.md` |
| Spec (M/L) | `mydocs/specs/YYYY-MM-DD_hh-mm_<TaskName>.md` |
| Micro-spec (S) | `mydocs/micro_specs/YYYY-MM-DD_hh-mm_<TaskName>.md` |
| Archive(human) | `mydocs/archive/YYYY-MM-DD_hh-mm_<topic>_human.md` |
| Archive(llm) | `mydocs/archive/YYYY-MM-DD_hh-mm_<topic>_llm.md` |

---

## 上下文装配策略

### Size XS/S

无需显式上下文装配，依赖对话上下文即可。S 规模的 micro-spec 回写时确保 Goal 和验证结果已落盘。

### Size M/L

| 层级 | 加载时机 | 内容 |
|------|----------|------|
| **Hot** (每轮) | 所有对话 | phase, approval状态, Spec路径, Goal, Scope, 活跃Checklist |
| **Warm** (阶段切换) | Research→Plan / Plan→Execute / Execute→Review | 研究发现, Plan文件/签名, 验证结果 |
| **Cold** (按需) | 冲突/不确定时 | 完整ChangeLog, 历史Research详情, 完整CodeMap |

**硬门**: 冲突/缺失/不确定 → 立即从磁盘重读完整Spec

---

## 初始化

当用户的 Prompt 包含 trigger_keywords 且当前上下文中没有正在进行的活跃任务时：

- **若只有触发词、没有明确任务内容** → 输出以下初始化提示，并暂停等待用户补充任务描述
- **若已包含明确任务内容** → 不输出寒暄式初始化，直接进入“任务复述 / 模式判断 / 规模评估 / 下一步”首轮响应

> **ALTAS Workflow v4.0 已加载**
>
> 当前模式: [IDLE] ▸ 等待任务输入
> 可用触发: `>>` (极速) | `FAST` (小任务) | `sdd_bootstrap` (标准入口) | `DEEP` (深度) | `DEBUG` (排查) | `MULTI` (多项目) | `DOC` (文档) | `MAP` (链路) | `ARCHIVE` (归档) | `REVIEW` (代码审查) | `REFACTOR` (重构) | `TEST` (补测试) | `PERF` (性能优化) | `MIGRATE` (迁移) | `全部` (批量执行)
> 退出指令: "EXIT ALTAS"
>
> 请描述你的任务，我将先给出：任务复述 / 模式判断 / 规模评估 / 是否需要参考文档 / 下一步动作。

**行为约束**:
- 仅在命中触发条件时主动输出，后续对话轮次不再重复
- 接收到任务后先判定模式（Coding / Debug / Doc / Map / Archive），再进行规模评估并进入对应工作流
- 首轮回复默认包含：`任务复述`、`模式`、`规模`、`是否只读`、`是否需要用户确认/执行许可`、`下一步`

---

## 首轮响应示例

### 示例 A：标准开发任务 (Size M)

> **用户**: 帮我给用户注册接口加上邮箱验证码功能，防止恶意注册
>
> **AI 首轮响应**:
>
> **任务复述**: 为用户注册接口添加邮箱验证码防刷机制，目标是提升安全性，防止批量恶意注册。
>
> - **模式**: Coding（新功能开发）
> - **规模**: **M**（涉及 3-5 个文件：注册接口 + 邮箱服务 + 配置 + 测试；模块内改动）
> - **只读**: 否，需要代码修改
> - **执行许可**: 需要 Plan 阶段的 `[Approved]` 后方可进入 Execute
> - **参考文档**: Plan 时需加载 `spec-template.md`、`writing-plans/SKILL.md`；Execute 时需加载 `test-driven-development/SKILL.md`
>
> **下一步**: 进入 RESEARCH → 先读取现有注册接口代码和项目邮件服务依赖，形成事实依据后输出检查点。请确认是否继续？

### 示例 B：只读分析任务 (MAP)

> **用户**: MAP: 梳理一下订单支付链路，从下单到回调通知
>
> **AI 首轮响应**:
>
> **任务复述**: 对订单支付的完整链路进行只读梳理，覆盖从用户下单到支付回调通知的全流程。
>
> - **模式**: Map（只读代码链路梳理）
> - **规模**: **M**（跨多个模块的链路分析）
> - **只读**: **是** — 仅读取和分析代码，不修改任何文件
> - **执行许可**: 不需要，纯分析任务
> - **参考文档**: 需加载 `commands.md`（create_codemap 参数）获取产物规范
>
> **下一步**: 开始扫描订单相关文件，生成 CodeMap 产出至 `mydocs/codemap/`。请确认范围是否有偏移？

---

## 产物生命周期管理

| 产物类型 | 保留策略 | 清理建议 |
|----------|----------|----------|
| **Spec** | 长期保留，视为项目资产 | 不主动删除；同一功能的迭代 Spec 通过时间前缀区分版本 |
| **Micro-spec** | 保留至对应功能上线后 | 可在每次发版后归档或清理超过 30 天的已完成 micro-spec |
| **CodeMap** | 长期保留，随代码演进定期更新 | 大重构后建议重新生成而非修改旧版 |
| **Context Bundle** | 一次性用完即可归档 | 任务完成后移至 `mydocs/_archive/context/` 或直接删除 |
| **Archive** | 长期保留，团队知识沉淀 | 永不自动清理；按季度整理索引 |

## 产物版本演进策略

**同一功能/模块的产物版本关联规则**:

| 产物 | 版本关联规则 |
|------|-------------|
| **Spec** | 新版 Spec 必须在文件头标注 `Supersedes: <旧版路径>`；旧版在 Review 通过后标记 `[SUPERSEDED]` |
| **CodeMap** | 新版 CodeMap 必须在文件头标注 `Updates: <旧版路径>`；旧版保留作为历史参考 |
| **Archive** | 不标记 supersede，多个版本并存作为不同时间点的知识快照 |

**版本命名示例**:

```markdown
# Spec 文件头示例

## 版本信息
- **当前版本**: 2026-04-14_10-30_UserReg.md
- **替代版本**: 2026-04-13_15-20_UserReg.md (SUPERSEDED)
- **变更原因**: 新增邮箱验证码功能
```

**目录增长控制**:
- `mydocs/specs/` 和 `mydocs/archive/` 纳入 Git 版本管理，作为项目组织记忆
- `mydocs/codemap/` 纳入 Git，大版本更新时重新生成
- `mydocs/context/` 和 `mydocs/micro_specs/` 建议加入 `.gitignore`，避免噪音提交
