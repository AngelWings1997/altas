---
name: altas-workflow
description: Master workflow skill that auto-evaluates task size (XS/S/M/L) and selects workflow depth. Integrates Spec-Driven, Checkpoint-Driven, and Superpowers. Use as the entry skill for engineering tasks such as coding, debugging, documentation, code mapping, and archiving.
trigger_keywords: ["FAST", "DEEP", "DEBUG", "MULTI", "DOC", "MAP", "ARCHIVE", ">>", "sdd_bootstrap", "快速", "排查", "多项目", "写文档", "链路梳理", "归档", "全部"]
---

# ALTAS Workflow

**Version:** 4.0

## Overview

ALTAS Workflow 是融合 Spec-Driven Development、Checkpoint-Driven 与 Superpowers 的综合性 AI 工作流程规范，也是编码、调试、文档、链路梳理、归档等工程任务的统一入口。

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

**入口约定：**
- `create_codemap` / `build_context_bundle` / `sdd_bootstrap` / `archive` 等名称是**技能内部动作语法**，不是终端 Shell 命令；应通过原生检索、读写、任务跟踪工具完成。
- 若任务是只读分析（如 `MAP` / `DEBUG` / 部分 `DOC` / `ARCHIVE`），先走只读模式，不要默认进入代码修改流程。
- 若环境**不支持** Subagent / 并行 Agent / 专用任务面板，则自动降级为单会话执行 + 原子 Checklist + 常规检查点，不得因工具缺失而阻塞主流程。

---

## When to Use

- 作为工程任务总入口使用：编码、调试、文档、代码链路梳理、归档
- 实现新功能、修复 Bug、重构代码
- 需要只读分析仓库、生成 CodeMap、整理知识沉淀
- 需要结构化开发流程和规范约束
- 用户请求涉及多文件、跨模块改动
- 需要生成 Spec、CodeMap、Archive 等产物
- 用户输入触发词：`FAST`、`DEEP`、`DEBUG`、`MULTI`、`DOC`、`MAP`、`ARCHIVE`、`sdd_bootstrap`

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
- 用户随时可用 `[升级为M]` / `[降级为S]` 调整

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
| `全部` / `all` | 批量执行 |

### 入口路由速查

| 用户意图 | 默认路由 | 首轮重点 |
|----------|----------|----------|
| 改代码 / 修 Bug / 重构 | XS/S/M/L 标准流 | 规模评估 + Spec/Plan/Execute 门禁 |
| 排查问题 / 看日志 / 验证行为 | `DEBUG` | 只读定位 + 根因分析，必要时再转编码流 |
| 写文档 / 汇总说明 | `DOC` | 事实提取 + 大纲 + 对照代码验证 |
| 只看代码 / 梳理链路 | `MAP` | 只读分析 + CodeMap 产出 |
| 归档沉淀 / 总结经验 | `ARCHIVE` | 基于已完成 Spec/CodeMap 提炼知识 |

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

## 进度可视化系统

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

| 轴 | 检查项 | 判定 |
|----|--------|------|
| Spec质量与需求达成 | Goal/In-Scope/Acceptance是否完整；需求是否达成 | PASS/FAIL/PARTIAL |
| Spec-代码一致性 | 文件、签名、Checklist、行为是否与Plan一致 | PASS/FAIL/PARTIAL |
| 代码内在质量 | 正确性、鲁棒性、可维护性、测试、关键风险 | PASS/FAIL/PARTIAL |

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
- 动作: 生成双视角归档（human 汇报视角 + llm 开发参考视角），每个结论附 `Trace to Sources`
- 产出: `mydocs/archive/YYYY-MM-DD_hh-mm_<topic>_{human,llm}.md`
- 自动化: 若本地存在 `scripts/archive_builder.py` 脚本，可调用执行；若不存在，AI 应直接通过读写文件工具自行生成 Markdown 沉淀。

> **按需加载**: 进入Archive时读取 `references/spec-driven-development/archive-template.md`

---

## 参考资料索引 (按需加载)

> 本节只保留入口级高频导航；完整索引请读取 [reference-index.md](./reference-index.md)。
> *注意：所有参考路径相对于本规范所在目录或 `altas-workflow/`。如果尝试读取时找不到文件，请使用全局搜索（Glob/Search）定位；若确实缺失，请基于自身常识按标准模式执行，并提醒用户补全依赖。*

**入口优先级：**

| 触发场景 | 读取文件 |
|----------|----------|
| 快速回忆整体流程 | `references/spec-driven-development/workflow-quickref.md` |
| 查看完整参考目录 | `reference-index.md` |
| 写Spec / 命名约定 | `references/spec-driven-development/spec-template.md`、`references/checkpoint-driven/spec-lite-template.md`、`references/checkpoint-driven/conventions.md` |
| 查看动作参数 | `references/spec-driven-development/commands.md` |
| 写Plan / Execute | `references/superpowers/writing-plans/SKILL.md`、`references/superpowers/test-driven-development/SKILL.md` |
| Debug / Review | `references/superpowers/systematic-debugging/SKILL.md`、`references/checkpoint-driven/modules.md` |
| L规模扩展能力 | `references/superpowers/subagent-driven-development/SKILL.md`、`references/superpowers/verification-before-completion/SKILL.md` |
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
> 可用触发: `>>` (极速) | `FAST` (小任务) | `sdd_bootstrap` (标准入口) | `DEEP` (深度) | `DEBUG` (排查) | `MULTI` (多项目) | `DOC` (文档) | `MAP` (链路) | `ARCHIVE` (归档) | `全部` (批量执行)
> 退出指令: "EXIT ALTAS"
>
> 请描述你的任务，我将先给出：任务复述 / 模式判断 / 规模评估 / 是否需要参考文档 / 下一步动作。

**行为约束**:
- 仅在命中触发条件时主动输出，后续对话轮次不再重复
- 接收到任务后先判定模式（Coding / Debug / Doc / Map / Archive），再进行规模评估并进入对应工作流
- 首轮回复默认包含：`任务复述`、`模式`、`规模`、`是否只读`、`是否需要用户确认/执行许可`、`下一步`
