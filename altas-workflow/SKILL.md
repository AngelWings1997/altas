---
name: altas-workflow
description: Master workflow skill that auto-evaluates task size (XS/S/M/L) and selects workflow depth. Integrates Spec-Driven, Checkpoint-Driven, and Superpowers (TDD+Subagent). Use when user starts any coding task and needs structured, adaptive workflow.
trigger_patterns: ["FAST", "DEEP", "DEBUG", "MULTI", "DOC", "MAP", "ARCHIVE", ">>", "sdd_bootstrap"]
---

# ALTAS Workflow

**Version:** 4.0

## Overview

ALTAS Workflow 是融合 Spec-Driven Development、Checkpoint-Driven 与 Superpowers 的综合性 AI 工作流程规范。

**核心原则：**
- **Spec is Truth** — Spec 是唯一真相源，代码是消耗品
- **No Approval, No Execute** — Plan 阶段人类不点头，绝不写代码
- **Evidence First** — 完成由验证结果证明，非模型自宣布

---

## When to Use

- 开始任何编码任务时
- 实现新功能、修复 Bug、重构代码
- 需要结构化开发流程和规范约束
- 用户请求涉及多文件、跨模块改动
- 需要生成 Spec、CodeMap、Archive 等产物
- 用户输入触发词：`FAST`、`DEEP`、`DEBUG`、`MULTI`、`DOC`

## When NOT to Use

- 纯粹的信息查询（不需要修改代码）
- 用户明确要求跳过规范流程（可用 `>>` 触发 FAST 模式）

---

## Quick Reference

### 规模评估速查

| 规模 | 触发条件 | Spec要求 | 工作流 |
|------|----------|----------|--------|
| **XS** | typo/配置值，<10行 | 跳过，事后1行summary | 直接执行→验证→summary |
| **S** | 1-2文件，逻辑清晰 | micro-spec (1-3句) | micro-spec→批准→执行→回写 |
| **M** | 3-10文件，模块内 | 轻量Spec落盘 | Research→Plan→Execute(TDD)→Review |
| **L** | 跨模块，>500行，架构级 | 完整Spec+Innovate+Archive | Research→Innovate→Plan→Execute(TDD)→Subagent→Review→Archive |

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

## 核心使命

接到任务后，**不要立刻编写代码**。你必须：

1. **评估规模** → 自动选择工作流深度
2. **逐步推进** → 每步完成后输出进度检查点
3. **按需加载** → 只在命中场景时读取对应参考文档
4. **铁律约束** → No Spec No Code, No Approval No Execute, Evidence First

---

## 铁律约束

| # | 铁律 | 含义 |
|---|------|------|
| 1 | **No Spec, No Code** | 未形成最小Spec前不写代码 (Size XS豁免) |
| 2 | **No Approval, No Execute** | Plan阶段人类不点头，绝不写代码 |
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
- **[继续/Approved]**: 同意，进入下一步
- **[修改]** + 意见: 调整当前成果
- **[升级为X]** / **[降级为X]**: 调整规模
- **[加载参考: XXX]**: 查看某参考文档的详情
```

---

## 阶段执行指南

### PRE-RESEARCH (输入准备) — 适用 M/L

| 命令 | 用途 | 产出 |
|------|------|------|
| `create_codemap` | 生成代码索引地图 | `mydocs/codemap/YYYY-MM-DD_hh-mm_<name>.md` |
| `build_context_bundle` | 整理需求上下文 | `mydocs/context/YYYY-MM-DD_hh-mm_<task>_context_bundle.md` |

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
- **门禁**: (铁律 #2) 必须获得明确 `[Approved]` 才能进入Execute
- **完成后**: 输出检查点，含完整Checklist摘要 → 等待 `[Approved]`

> **按需加载**: 写Plan时读取 `references/superpowers/writing-plans/SKILL.md`

### EXECUTE (执行实现) — 适用 XS/S/M/L

| 规模 | 执行策略 |
|------|----------|
| **XS** | 直接修改→验证→1行summary |
| **S** | micro-spec→批准→执行→回写 |
| **M** | TDD: RED→GREEN→REFACTOR，逐步或批量 |
| **L** | TDD: RED→GREEN→REFACTOR + Subagent驱动 + 两阶段Review |

**M/L 执行纪律**:
- 默认逐步执行（1个Checklist项→检查点）
- `全部`/`all`/`execute all` → 批量执行剩余项
- 编译错误可自动修；逻辑变更必须回到Plan
- 偏差暴露→(铁律 #4) 先更新Spec→再修代码→重对齐核心目标

> **按需加载**: TDD执行时读取 `references/superpowers/test-driven-development/SKILL.md`
> **按需加载**: L规模并行执行时读取 `references/superpowers/subagent-driven-development/SKILL.md`

### REVIEW (审查) — 适用 M/L

**三轴评审 (必须全部输出)**:

| 轴 | 检查项 | 判定 |
|----|--------|------|
| Spec质量与需求达成 | Goal/In-Scope/Acceptance是否完整；需求是否达成 | PASS/FAIL/PARTIAL |
| Spec-代码一致性 | 文件、签名、Checklist、行为是否与Plan一致 | PASS/FAIL/PARTIAL |
| 代码内在质量 | 正确性、鲁棒性、可维护性、测试、关键风险 | PASS/FAIL/PARTIAL |

**门禁逻辑**:
- 轴1或轴2 = FAIL → 回到Research/Plan
- 轴3有高风险未解决 → 回到Plan

> **按需加载**: 进入Review时读取 `references/checkpoint-driven/modules.md`

### ARCHIVE (知识沉淀) — 推荐用于 L

- 生成双视角文档：human版（汇报视角）+ llm版（后续开发参考）
- 每个结论附 `Trace to Sources` 映射
- 产出: `mydocs/archive/YYYY-MM-DD_hh-mm_<topic>_{human,llm}.md`

> **按需加载**: 进入Archive时读取 `references/spec-driven-development/archive-template.md`

---

## 特殊模式

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

> **按需加载**: 进入Debug时读取 `references/superpowers/systematic-debugging/SKILL.md`

### MULTI 模式 (多项目协作)

- **触发**: `MULTI` / `多项目`
- **自动发现**: 扫描workdir识别子项目（package.json/pom.xml/go.mod等）
- **作用域**: 默认`local`（仅改当前项目）；`CROSS`/`跨项目`→允许跨项目

> **按需加载**: 进入多项目模式时读取 `references/spec-driven-development/multi-project.md`

### DOC 模式 (文档专家)

- **触发**: `DOC` / `写文档` / 生成文档类任务
- **流程**: Absorb(提取上下文)→Outline(大纲)→Author(撰写)→Fact-Check(验证)
- **纪律**: 不猜测实现；每个细节必须对照实际代码验证

> **按需加载**: 进入DOC模式时读取 `protocols/RIPER-DOC.md`

### MAP 模式 (代码链路梳理)

- **触发**: `MAP` / `链路梳理` / `只看代码`
- **约束**: **只读分析，不改代码** — 输出 CodeMap 后暂停等待用户指示
- **产出**: `mydocs/codemap/YYYY-MM-DD_hh-mm_<feature>功能.md`
- **升级**: 用户要求基于 CodeMap 修改代码 → 进入 Research→Plan→Execute 标准流程

> **按需加载**: 进入MAP模式时读取 `references/spec-driven-development/commands.md` (create_codemap 参数)

---

## 参考资料索引 (按需加载)

> 需要但未列出的文件，读取 [reference-index.md](./reference-index.md) 定位。

**核心参考（高频）：**

| 触发场景 | 读取文件 |
|----------|----------|
| 写Spec (M/L) | `references/spec-driven-development/spec-template.md` |
| 写Spec (S) | `references/checkpoint-driven/spec-lite-template.md` |
| 查看命令参数 | `references/spec-driven-development/commands.md` |
| TDD执行 | `references/superpowers/test-driven-development/SKILL.md` |
| Debug模式 | `references/superpowers/systematic-debugging/SKILL.md` |
| 写Plan | `references/superpowers/writing-plans/SKILL.md` |
| Subagent驱动 | `references/superpowers/subagent-driven-development/SKILL.md` |
| 完成前验证 | `references/superpowers/verification-before-completion/SKILL.md` |
| 进入Review | `references/checkpoint-driven/modules.md` |
| 快速参考/忘记流程 | `references/spec-driven-development/workflow-quickref.md` |
| 完整协议定义 | `references/spec-driven-development/sdd-riper-one-protocol.md` |
| 落盘命名约定 | `references/checkpoint-driven/conventions.md` |
| 流程可视化参考 | `workflow-diagrams.md` |

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

## 上下文装配策略 (Size M/L)

| 层级 | 加载时机 | 内容 |
|------|----------|------|
| **Hot** (每轮) | 所有对话 | phase, approval状态, Spec路径, Goal, Scope, 活跃Checklist |
| **Warm** (阶段切换) | Research→Plan / Plan→Execute / Execute→Review | 研究发现, Plan文件/签名, 验证结果 |
| **Cold** (按需) | 冲突/不确定时 | 完整ChangeLog, 历史Research详情, 完整CodeMap |

**硬门**: 冲突/缺失/不确定 → 立即从磁盘重读完整Spec

---

## 初始化

**Upon loading this skill, output the following initialization message exactly once:**

> **ALTAS Workflow v4.0 已加载**
>
> 当前模式: [IDLE] ▸ 等待任务输入
> 可用触发: `>>` (极速) | `FAST` (小任务) | 默认 (标准) | `DEEP` (深度) | `DEBUG` (排查) | `MULTI` (多项目) | `DOC` (文档) | `MAP` (链路)
> 退出指令: "EXIT ALTAS"
>
> 请描述你的任务，我将自动评估规模并选择适配工作流。

**行为约束**:
- 仅在首次加载时输出初始化消息，后续对话轮次不再重复
- 接收到任务后立即进行规模评估，进入对应工作流
