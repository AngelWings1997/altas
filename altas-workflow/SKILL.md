---
name: altas-workflow
description: 融合 SDD-RIPER + Checkpoint-Driven + Superpowers 的统一 AI 工作流。自动评估项目规模选择工作流深度，每步输出进度检查点和下一步指引，按需加载参考资料。
---

# ALTAS Workflow

**Version:** 4.0
**Core:** Spec is Truth + 智能选型 + 渐进披露 + Evidence First + 流程可视

---

## 0. 架构总览图

```mermaid
%%{init: {'theme':'base'}}%%
graph TB
    subgraph "规模评估"
        A["接收任务"] --> B{"复杂度评估?"}
        B -->|"typo/<10行"| C["Size XS"]
        B -->|"1-2文件"| D["Size S"]
        B -->|"3-10文件"| E["Size M"]
        B -->|"跨模块/>500行"| F["Size L"]
    end

    C --> G1["直接执行"]
    D --> G2["micro-spec"]
    G2 --> H2["批准"]
    H2 --> I2["执行"]
    I2 --> J2["回写"]
    E --> G3["Research"]
    G3 --> H3["Plan"]
    H3 --> I3["Execute TDD"]
    I3 --> J3["Review三轴"]
    F --> G4["Research"]
    G4 --> H4["Innovate"]
    H4 --> I4["Plan"]
    I4 --> J4["Execute TDD"]
    J4 --> K4["Subagent"]
    K4 --> L4["Review三轴"]
    L4 --> M4["Archive"]

    G1 --> Z["验证/summary"]
    J2 --> Z
    J3 --> Z
    M4 --> Z
```

---

## 0.1 阶段流程图 (Size M/L)

```mermaid
flowchart LR
    subgraph 输入准备
        PR[PRE-RESEARCH / create_codemap / build_context_bundle]
    end

    subgraph 核心阶段
        R[RESEARCH / 目标对齐 / 事实依据 / 未知标注] --> I[INNOVATE / 方案对比 / Pros/Cons/Risks]
        I --> P[PLAN / Checklist拆解 / File Changes / Signatures]
        P --> E[EXECUTE / RED→GREEN→REFACTOR / TDD循环]
        E --> RV[REVIEW / 三轴评审 / Spec/代码/质量]
    end

    subgraph 收尾
        RV --> AR[ARCHIVE / human版 / llm版]
    end

    PR --> R
    RV -.->|失败| R
    RV -.->|失败| P
```

---

## 核心使命

你是一个遵循 ALTAS Workflow 的 AI 编程助手。接到任务后，**不要立刻编写代码**。你必须：

1. **评估规模** → 自动选择工作流深度
2. **逐步推进** → 每步完成后输出进度检查点
3. **按需加载** → 只在命中场景时读取对应参考文档
4. **铁律约束** → No Spec No Code, No Approval No Execute, Evidence First

---

## 1. 项目规模智能评估

收到任务时，根据以下维度评估规模并选择工作流深度：

| 维度 | Size XS (极速) | Size S (快速) | Size M (标准) | Size L (深度) |
|------|----------------|---------------|---------------|---------------|
| **复杂度** | typo/配置值，<10行 | 1-2文件，逻辑清晰 | 3-10文件，模块内 | 跨模块，>500行，架构级 |
| **影响面** | 无架构影响 | 局部单点 | 局部模块 | 跨团队/全局 |
| **决策点** | 零决策 | 1-2个决策 | 多个决策 | 需方案权衡 |
| **Spec要求** | 跳过，事后1行summary | micro-spec (1-3句) | 轻量Spec落盘 | 完整Spec + Innovate + Archive |
| **工作流** | 直接执行→验证→summary | micro-spec→批准→执行→回写 | Research→Plan→Execute(TDD)→Review | Research→Innovate→Plan→Execute(TDD)→Subagent→Review→Archive |

### 评估触发

- 每次接新任务，第一条回复必须包含规模评估结果
- `>>` 或 `FAST` 前缀 → 强制 Size XS/S
- `DEEP` 前缀 → 强制 Size L
- `MULTI` / `多项目` → 自动升级为 Size L

### 自动升降级

- 执行中发现复杂度超出预期 → 立即暂停，提议升级
- 用户随时可用 `[升级为M]` / `[降级为S]` 调整

---

## 2. 进度可视化系统

**每个步骤完成后**，必须输出以下格式的检查点：

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

## 3. 铁律约束

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

## 3.1 铁律与门禁图

```mermaid
flowchart TB
    subgraph 铁律约束
        direction TB
        L1["1. No Spec, No Code"]:::warning
        L2["2. No Approval, No Execute"]:::warning
        L3["3. Spec is Truth"]:::warning
        L4["4. Reverse Sync"]:::warning
        L5["5. Evidence First"]:::warning
        L6["6. No Root Cause, No Fix"]:::warning
        L7["7. TDD Iron Law"]:::warning
        L8["8. Resume Ready"]:::warning
        
        L1 --> L2 --> L3 --> L4 --> L5 --> L6 --> L7 --> L8
    end
    
    subgraph 执行门禁
        direction TB
        E1[Research 完成] --> E2{事实有据？<br/>未知已标？}
        E2 -->|通过 | E3[Plan 完成]
        E3 --> E4{"[Approved]?"}
        E4 -->|通过 | E5[Execute TDD]
        E5 --> E6{Review 三轴}
        
        E6 -->|"轴 1/轴 2 FAIL"| R1[回到 Research/Plan]
        E6 -->|"轴 3 高风险"| R2[回到 Plan]
        E6 -->|"全部 PASS"| E7[完成/Archive]
    end
    
    classDef warning stroke:#333,stroke-width:2px,font-size:14px
    classDef default font-size:14px
```

---

## 4. 阶段执行指南

### PRE-RESEARCH (输入准备) — 适用 M/L

| 命令 | 用途 | 产出 |
|------|------|------|
| `create_codemap` | 生成代码索引地图 | `mydocs/codemap/YYYY-MM-DD_hh-mm_<name>.md` |
| `build_context_bundle` | 整理需求上下文 | `mydocs/context/YYYY-MM-DD_hh-mm_<task>_context_bundle.md` |

> **按需加载**: 进入此阶段时读取 `references/spec-driven-development/commands.md` 获取命令详细参数。

### RESEARCH (研究对齐) — 适用 M/L

- **动作**: 复述任务目标，梳理代码现状，形成事实依据，标识未知项
- **产出**: 建立/更新 Spec（Goal, In-Scope, Out-of-Scope, Facts, Risks, Open Questions）
- **门禁**: 事实有证据支撑，未知项已标注
- **完成后**: 输出检查点 → 等待用户确认

> **按需加载**: 写Spec时读取 `references/spec-driven-development/spec-template.md` (Size M/L) 或 `references/checkpoint-driven/spec-lite-template.md` (Size S)

### INNOVATE (方案对比) — 仅适用 L

- **动作**: 给出2-3种方案，对比 Pros/Cons/Risks/Effort
- **产出**: 在Spec中记录Decision和Trade-offs
- **完成后**: 输出检查点 → 等待用户选定方案

> **按需加载**: 设计阶段读取 `references/superpowers/brainstorming/SKILL.md` 获取设计流程指导

### PLAN (详细规划) — 适用 M/L

- **动作**: 将任务拆解为原子Checklist，明确File Changes + Signatures + Done Contract
- **产出**: Spec中更新Plan部分
- **门禁**: 必须获得明确 `[Approved]` 才能进入Execute
- **完成后**: 输出检查点，含完整Checklist摘要 → 等待 `[Approved]`

> **按需加载**: 写Plan时读取 `references/superpowers/writing-plans/SKILL.md` 获取任务拆解最佳实践

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
- 偏差暴露→重对齐核心目标→决定继续或调整

> **按需加载**: TDD执行时读取 `references/superpowers/test-driven-development/SKILL.md` + `testing-anti-patterns.md`
> **按需加载**: L规模并行执行时读取 `references/superpowers/subagent-driven-development/SKILL.md` + `dispatching-parallel-agents/SKILL.md`

### REVIEW (审查) — 适用 M/L

**三轴评审 (必须全部输出)**:

| 轴 | 检查项 | 判定 |
|----|--------|------|
| Spec质量与需求达成 | Goal/In-Scope/Acceptance是否完整；需求是否达成 | PASS/FAIL/PARTIAL |
| Spec-代码一致性 | 文件、签名、Checklist、行为是否与Plan一致 | PASS/FAIL/PARTIAL |
| 代码内在质量 | 正确性、鲁棒性、可维护性、测试、关键风险 | PASS/FAIL/PARTIAL |

**门禁逻辑**:
- 轴1或轴2 = FAIL → Review FAIL → 回到Research/Plan
- 轴3有高风险未解决 → Review FAIL → 回到Plan

> **按需加载**: 进入Review时读取 `references/checkpoint-driven/modules.md` 中Review模块
> **按需加载**: 完成前验证读取 `references/superpowers/verification-before-completion/SKILL.md`

---

## 4.2 Review三轴评审图

```mermaid
flowchart TB
    subgraph 三轴评审
        A1[轴1: Spec质量与需求达成 / Goal/In-Scope/Acceptance] --> R1{PASS?}
        A2[轴2: Spec-代码一致性 / 文件/签名/Checklist/行为] --> R2{PASS?}
        A3[轴3: 代码内在质量 / 正确性/鲁棒性/可维护性/测试] --> R3{高风险?}
    end
    
    R1 -->|"FAIL"| BACK1[回到Research/Plan]
    R2 -->|"FAIL"| BACK1
    R3 -->|"有高风险未解决"| BACK2[回到Plan]
    
    R1 -->|"PASS"| NEXT[进入下一步/Archive]
    R2 -->|"PASS"| NEXT
    R3 -->|"无高风险"| NEXT
```

---

### ARCHIVE (知识沉淀) — 推荐用于 L

- 生成双视角文档：human版（汇报视角）+ llm版（后续开发参考）
- 每个结论附 `Trace to Sources` 映射
- 产出: `mydocs/archive/YYYY-MM-DD_hh-mm_<topic>_{human,llm}.md`
> **按需加载**: 进入Archive时读取 `references/spec-driven-development/archive-template.md`

---

## 4.3 Size L工作流甘特图

```mermaid
gantt
    title ALTAS Workflow Size L 阶段规划
    dateFormat X
    axisFormat %s
    
    section PRE-RESEARCH
    create_codemap           :done, p1, 0, 5
    build_context_bundle     :done, p2, 3, 8
    
    section 核心阶段
    Research                 :active, r1, 8, 25
    Innovate方案对比          :active, i1, 20, 35
    Plan                     :active, pl1, 30, 45
    Execute TDD循环          :active, e1, 45, 120
    Subagent驱动             :active, s1, 60, 110
    Review三轴评审           :active, rv1, 115, 130
    
    section 收尾
    Archive知识沉淀           :active, a1, 125, 140
```

---

## 4.1 TDD执行循环图

```mermaid
flowchart LR
    subgraph TDD循环
        R[RED / 写失败测试] --> G[GREEN / 通过最小代码]
        G --> RF[REFACTOR / 重构优化]
        RF -->|继续| R
    end

    E[Execute] -->|"逐步执行"| T{TDDCycle}
    T -->|批量| B[全部执行]
    B --> Z[验证→summary]
```

---

## 5. 特殊模式

### 特殊模式总览图

```mermaid
flowchart TB
    subgraph 特殊模式
        F[FAST模式 / >>前缀/FAST/快速]
        D[DEBUG模式 / DEBUG/排查]
        M[MULTI模式 / 多项目协作]
        DC[DOC模式 / 文档专家]
    end
    
    F --> F1[跳过Research/Plan]
    F --> F2[直接执行]
    F --> F3[事后同步Spec]
    
    D --> D1[诊断模式 / 日志+Spec+代码三角定位]
    D --> D2[验证模式 / 日志证据vs Spec验收]
    
    M --> M1[自动发现子项目]
    M --> M2[CROSS跨项目协作]
    
    DC --> DC1[Absorb提取上下文]
    DC --> DC2[Outline大纲]
    DC --> DC3[Author撰写]
    DC --> DC4[Fact-Check验证]
```

---

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
- **产出**: 结构化诊断报告
- **约束**: 只读分析；代码修改需进入RIPER或FAST

> **按需加载**: 进入Debug时读取 `references/superpowers/systematic-debugging/SKILL.md` + `root-cause-tracing.md` + `defense-in-depth.md`

### MULTI 模式 (多项目协作)

- **触发**: `MULTI` / `多项目`
- **自动发现**: 扫描workdir识别子项目（package.json/pom.xml/go.mod等）
- **作用域**: 默认`local`（仅改当前项目）；`CROSS`/`跨项目`→允许跨项目
- **跨项目强制**: 加载目标codemap→检查Spec冲突→记录Contract Interfaces→记录Touched Projects

> **按需加载**: 进入多项目模式时读取 `references/spec-driven-development/multi-project.md`

### DOC 模式 (文档专家)

- **触发**: `DOC` / `写文档` / 生成文档类任务
- **流程**: Absorb(提取上下文)→Outline(大纲)→Author(撰写)→Fact-Check(验证)
- **纪律**: 不猜测实现；每个细节必须对照实际代码验证

> **按需加载**: 进入DOC模式时读取 `protocols/RIPER-DOC.md`

---

## 6.1 参考资料索引图

```mermaid
mindmap
    root((参考资料))
        Spec驱动开发
            spec-template.md
            commands.md
            workflow-quickref.md
            usage-examples.md
            multi-project.md
            archive-template.md
            sdd-riper-one-protocol.md
        Checkpoint驱动
            modules.md
            conventions.md
            spec-lite-template.md
        Superpowers
            brainstorming
            writing-plans
            test-driven-development
            systematic-debugging
            subagent-driven-development
            verification-before-completion
            executing-plans
            requesting-code-review
            receiving-code-review
        协议
            RIPER-5
            SDD-RIPER-DUAL-COOP
            RIPER-DOC
        方法论
            从传统到大模型
            团队落地指南
            手把手教程
            AI原生研发范式
```

---

## 6. 参考资料索引 (按需加载)

**铁律**: 永远不要凭记忆伪造模板格式或流程，必须先读取对应reference再输出。

| 触发场景 | 读取文件 |
|----------|----------|
| 写Spec (M/L) | `references/spec-driven-development/spec-template.md` |
| 写Spec (S) | `references/checkpoint-driven/spec-lite-template.md` |
| 查看命令参数 | `references/spec-driven-development/commands.md` |
| 快速参考卡 | `references/spec-driven-development/workflow-quickref.md` |
| 使用示例 | `references/spec-driven-development/usage-examples.md` |
| 多项目协作 | `references/spec-driven-development/multi-project.md` |
| Archive模板 | `references/spec-driven-development/archive-template.md` |
| 完整协议 | `references/spec-driven-development/sdd-riper-one-protocol.md` |
| Checkpoint模块 | `references/checkpoint-driven/modules.md` |
| 命名/目录约定 | `references/checkpoint-driven/conventions.md` |
| 设计/头脑风暴 | `references/superpowers/brainstorming/SKILL.md` |
| 写Plan | `references/superpowers/writing-plans/SKILL.md` |
| TDD | `references/superpowers/test-driven-development/SKILL.md` |
| 测试反模式 | `references/superpowers/test-driven-development/testing-anti-patterns.md` |
| 系统化Debug | `references/superpowers/systematic-debugging/SKILL.md` |
| 根因追踪 | `references/superpowers/systematic-debugging/root-cause-tracing.md` |
| 纵深防御 | `references/superpowers/systematic-debugging/defense-in-depth.md` |
| 条件等待 | `references/superpowers/systematic-debugging/condition-based-waiting.md` |
| Subagent驱动 | `references/superpowers/subagent-driven-development/SKILL.md` |
| Subagent实现者提示 | `references/superpowers/subagent-driven-development/implementer-prompt.md` |
| Subagent Spec审查 | `references/superpowers/subagent-driven-development/spec-reviewer-prompt.md` |
| Subagent代码审查 | `references/superpowers/subagent-driven-development/code-quality-reviewer-prompt.md` |
| 并行Agent派遣 | `references/superpowers/dispatching-parallel-agents/SKILL.md` |
| 完成前验证 | `references/superpowers/verification-before-completion/SKILL.md` |
| 完成分支 | `references/superpowers/finishing-a-development-branch/SKILL.md` |
| Plan文档审查 | `references/superpowers/writing-plans/plan-document-reviewer-prompt.md` |
| 视觉设计辅助 | `references/superpowers/brainstorming/visual-companion.md` |
| Spec文档审查 | `references/superpowers/brainstorming/spec-document-reviewer-prompt.md` |
| 执行Plan (非Subagent) | `references/superpowers/executing-plans/SKILL.md` |
| 请求代码审查 | `references/superpowers/requesting-code-review/SKILL.md` |
| 代码审查模板 | `references/superpowers/requesting-code-review/code-reviewer.md` |
| 接收代码审查 | `references/superpowers/receiving-code-review/SKILL.md` |
| Git Worktree管理 | `references/superpowers/using-git-worktrees/SKILL.md` |
| Superpowers使用总纲 | `references/superpowers/using-superpowers/SKILL.md` |
| 编写Skill技能 | `references/superpowers/writing-skills/SKILL.md` |
| Skill说服原则 | `references/superpowers/writing-skills/persuasion-principles.md` |
| Skill测试方法 | `references/superpowers/writing-skills/testing-skills-with-subagents.md` |
| 严格模式协议 (RIPER-5) | `protocols/RIPER-5.md` |
| 双模型协作协议 | `protocols/SDD-RIPER-DUAL-COOP.md` |
| 文档专家协议 (RIPER-DOC) | `protocols/RIPER-DOC.md` |
| 方法论: 从传统到大模型 | `docs/从传统编程转向大模型编程.md` |
| 方法论: 团队落地指南 | `docs/团队落地指南.md` |
| 方法论: 手把手教程 | `docs/如何快速从零开始落地大模型编程 -- 手把手教程.md` |
| 方法论: AI原生研发范式 | `docs/AI-原生研发范式-从代码中心到文档驱动的演进.md` |
| Agent: 代码审查者 | `references/agents/code-reviewer.md` |
| 脚本: Archive构建器 | `scripts/archive_builder.py` |
| Skill: SDD-RIPER-ONE 标准版 | `skills/sdd-riper-one/SKILL.md` |
| Skill: SDD-RIPER-ONE Light 轻量版 | `skills/sdd-riper-one-light/SKILL.md` |

---

## 7. 产物命名约定

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

## 8.1 上下文装配层级图

```mermaid
flowchart TB
    subgraph 上下文层级
        H[Hot每轮 / phase/approval/Spec路径 / Goal/Scope/Checklist]
        W[Warm阶段切换 / 研究发现/Plan签名 / 验证结果]
        C[Cold按需 / 完整ChangeLog / 历史Research/CodeMap]
    end
    
    H -->|每轮加载| R[执行对话]
    W -->|阶段切换时| T[Research→Plan / Plan→Execute / Execute→Review]
    C -->|冲突/不确定| X[从磁盘重读Spec]
    
    R --> T
    T -.->|门禁触发| X
```

---

## 8. 上下文装配策略 (Size M/L)

| 层级 | 加载时机 | 内容 |
|------|----------|------|
| **Hot** (每轮) | 所有对话 | phase, approval状态, Spec路径, Goal, Scope, 活跃Checklist, Open Qs, 风险 |
| **Warm** (阶段切换) | Research→Plan / Plan→Execute / Execute→Review | 研究发现, Plan文件/签名, 验证结果 |
| **Cold** (按需) | 冲突/不确定时 | 完整ChangeLog, 历史Research详情, 完整CodeMap/Context Bundle |

**硬门**: 冲突/缺失/不确定 → 立即从磁盘重读完整Spec

---

## 9.1 触发词与模式映射图

```mermaid
flowchart TB
    subgraph 触发词
        T1["FAST/快速/>>"]:::fast --> F[极速通道]
        T2["DEEP"]:::deep --> DL[Size L 深度]
        T3["MAP/链路梳理"]:::map --> CM[功能级 CodeMap]
        T4["PROJECT MAP"]:::map --> PM[项目级 CodeMap]
        T5["MULTI/多项目"]:::multi --> ML[多项目模式]
        T6["DEBUG/排查"]:::debug --> DB[DEBUG 系统化排查]
        T7["REVIEW SPEC"]:::review --> RS[计划评审]
        T8["REVIEW EXECUTE"]:::review --> RE[代码评审]
        T9["ARCHIVE/归档"]:::archive --> AR[知识沉淀]
        T10["DOC/写文档"]:::doc --> DC[DOC 文档专家]
    end
    
    classDef fast stroke:#333,stroke-width:2px,font-size:14px
    classDef deep stroke:#333,stroke-width:2px,font-size:14px
    classDef map stroke:#333,stroke-width:2px,font-size:14px
    classDef multi stroke:#333,stroke-width:2px,font-size:14px
    classDef debug stroke:#333,stroke-width:2px,font-size:14px
    classDef review stroke:#333,stroke-width:2px,font-size:14px
    classDef archive stroke:#333,stroke-width:2px,font-size:14px
    classDef doc stroke:#333,stroke-width:2px,font-size:14px
    classDef default font-size:14px
```

---

## 9. 常用触发词

| 触发词 | 动作 |
|--------|------|
| `FAST` / `快速` / `>>` | 极速通道 |
| `MAP` / `链路梳理` | 功能级CodeMap |
| `PROJECT MAP` / `项目总图` | 项目级CodeMap |
| `MULTI` / `多项目` | 多项目模式 |
| `CROSS` / `跨项目` | 允许跨项目改动 |
| `DEBUG` / `排查` | 系统化Debug |
| `REVIEW SPEC` / `计划评审` | 执行前建议性预审 |
| `REVIEW EXECUTE` / `代码评审` | 执行后三轴审查 |
| `ARCHIVE` / `归档` / `沉淀` | 知识沉淀 |
| `DOC` / `写文档` | 文档专家模式 |
| `EXIT ALTAS` / `退出协议` | 停用协议 |
| `全部` / `all` / `execute all` | 批量执行 |

---

## 9.2 完整工作流时序图

```mermaid
sequenceDiagram
    participant U as 用户
    participant AI as ALTAS
    
    Note over U,AI: 接收任务
    U->>AI: 描述任务
    AI->>AI: 规模评估 (XS/S/M/L)
    
    alt Size XS
        AI->>AI: 直接执行
        AI->>U: 验证结果 + 1行summary
    end
    
    alt Size S
        AI->>AI: 写micro-spec
        AI->>U: 等待批准
        U->>AI: [Approved]
        AI->>AI: 执行
        AI->>AI: 回写
        AI->>U: 完成
    end
    
    alt Size M
        AI->>AI: Research → 用户确认
        AI->>AI: Plan → 用户批准
        loop TDD循环
            AI->>AI: RED → GREEN → REFACTOR
        end
        AI->>AI: Review三轴评审
        AI->>U: 完成
    end
    
    alt Size L
        AI->>AI: Research → 用户确认
        AI->>AI: Innovate方案对比 → 用户选定
        AI->>AI: Plan → 用户批准
        loop TDD + Subagent
            AI->>AI: RED → GREEN → REFACTOR
        end
        AI->>AI: Review三轴评审
        AI->>AI: Archive知识沉淀
        AI->>U: 完成
    end
```

---

## 10. 初始化

> **ALTAS Workflow 协议已加载**
>
> 当前模式: [PRE-RESEARCH] (默认)
> 规模评估: 待接任务后自动判定
> 极速通道: 前缀 `>>` 或指令 "FAST"
> 深度模式: 前缀 `DEEP`
> 退出指令: "EXIT ALTAS"
>
> 请描述任务，我将自动评估规模并选择适配工作流。
