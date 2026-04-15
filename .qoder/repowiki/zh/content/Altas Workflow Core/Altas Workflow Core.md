# Altas Workflow 核心

<cite>
**本文档引用的文件**
- [README.md](file://README.md)
- [SKILL.md](file://altas-workflow/SKILL.md)
- [reference-index.md](file://altas-workflow/reference-index.md)
- [aliases.md](file://altas-workflow/references/entry/aliases.md)
- [sources.md](file://altas-workflow/references/entry/sources.md)
- [RIPER-5.md](file://altas-workflow/protocols/RIPER-5.md)
- [RIPER-DOC.md](file://altas-workflow/protocols/RIPER-DOC.md)
- [modules.md](file://altas-workflow/references/checkpoint-driven/modules.md)
- [multi-project.md](file://altas-workflow/references/spec-driven-development/multi-project.md)
- [review.md](file://altas-workflow/references/special-modes/review.md)
- [refactor.md](file://altas-workflow/references/special-modes/refactor.md)
- [test.md](file://altas-workflow/references/special-modes/test.md)
- [perf.md](file://altas-workflow/references/special-modes/perf.md)
- [migrate.md](file://altas-workflow/references/special-modes/migrate.md)
</cite>

## 更新摘要
**变更内容**
- 新增统一触发词字典系统，实现入口瘦身理念
- 引入统一引用索引结构，支持按需加载机制
- 更新版本至 4.2，反映新的入口瘦身和索引统一特性
- 新增专项模式系统，包括 REVIEW、REFACTOR、TEST、PERF、MIGRATE
- 完善入口来源整合说明，下沉方法论来源说明

## 目录
1. [简介](#简介)
2. [项目结构](#项目结构)
3. [核心组件](#核心组件)
4. [架构概览](#架构概览)
5. [详细组件分析](#详细组件分析)
6. [依赖分析](#依赖分析)
7. [性能考虑](#性能考虑)
8. [故障排除指南](#故障排除指南)
9. [结论](#结论)
10. [附录](#附录)

## 简介

Altas Workflow 是一套综合性 AI 原生研发工作流规范，融合了 SDD-RIPER、SDD-RIPER-Optimized (Checkpoint-Driven) 与 Superpowers 三大优秀工作流的精华。该项目致力于解决 AI 编程中的四大工程痛点：

- **上下文腐烂**：通过 CodeMap 索引 + 渐进式披露，按需加载参考资料
- **审查瘫痪**：4 级智能深度 (XS/S/M/L)，小任务不卡审批
- **代码不信任**：Spec 中心论 + 三轴评审，Spec is Truth
- **难以维护**：Archive 知识沉淀 + TDD 铁律，完成即资产

### 核心铁律

1. **No Spec, No Code** — 未形成最小 Spec 前不写代码 (Size XS 豁免)
2. **No Approval, No Execute** — Plan 阶段人类不点头，绝不写代码
3. **Spec is Truth** — Spec 与代码冲突时，代码是错的
4. **Reverse Sync** — 执行中发现偏差→先更新 Spec→再修代码
5. **Evidence First** — 完成由验证结果证明，非模型自宣布
6. **No Root Cause, No Fix** — Bug 修复前必须有根因分析，禁止盲改
7. **TDD Iron Law** — Size M/L: 无失败测试不写生产代码
8. **Resume Ready** — 长任务暂停前在 Spec 中留恢复锚点

## 项目结构

Altas Workflow 采用模块化设计，主要包含以下核心目录：

```mermaid
graph TB
subgraph "核心工作流"
A[altas-workflow/] --> B[SKILL.md]
A --> C[reference-index.md]
A --> D[references/entry/]
D --> E[aliases.md]
D --> F[sources.md]
end
subgraph "协议模块"
A --> G[protocols/]
G --> H[RIPER-5.md]
G --> I[RIPER-DOC.md]
end
subgraph "参考资料"
A --> J[references/]
J --> K[spec-driven-development/]
J --> L[checkpoint-driven/]
J --> M[superpowers/]
J --> N[special-modes/]
end
subgraph "自动化工具"
A --> O[scripts/]
end
```

**图表来源**
- [README.md:62-76](file://README.md#L62-L76)
- [SKILL.md:17-17](file://altas-workflow/SKILL.md#L17-L17)

### 核心资产统计

| 类别 | 数量 | 说明 |
|------|------|------|
| **核心协议** | 1 个 | SKILL.md (ALTAS Workflow 主协议) |
| **专用协议** | 3 个 | RIPER-5 / RIPER-DOC / DUAL-COOP |
| **方法论** | 4 篇 | 从传统编程转向大模型编程 / 团队落地指南 / 快速入门教程 / AI 原生研发范式 |
| **参考资料** | 50+ 个 | Spec 驱动 (14) / Checkpoint (6) / Superpowers (24+) / Special Modes (5) |
| **独立 Agent** | 2 个 | SDD-RIPER-ONE (标准版/轻量版) |
| **代码示例** | 1 个 | EXAMPLES.md (四大原则实战示例) |
| **自动化工具** | 1 个 | archive_builder.py (Archive 构建器) |

**章节来源**
- [README.md:84-95](file://README.md#L84-L95)
- [README.md:628-643](file://README.md#L628-L643)

## 核心组件

### 1. 智能深度适配系统

Altas Workflow 采用四级任务深度评估机制：

```mermaid
flowchart LR
A[接收任务] --> B{复杂度评估}
B --> |"typo/<10行"| C[Size XS 极速]
B --> |"1-2文件"| D[Size S 快速]
B --> |"3-10文件"| E[Size M 标准]
B --> |"跨模块/>500行"| F[Size L 深度]
C --> G[直接执行→验证→summary]
D --> H[micro-spec→批准→执行→回写]
E --> I[Research→Plan→Execute(TDD)→Review]
F --> J[Research→Innovate→Plan→Execute→Subagent→Review→Archive]
```

**图表来源**
- [README.md:237-245](file://README.md#L237-L245)
- [SKILL.md:102-122](file://altas-workflow/SKILL.md#L102-L122)

### 2. 进度可视化系统

每个步骤完成后，AI 必须输出标准化检查点：

```markdown
### 进度 [阶段 ▸ 步骤]
[已完成] ▸ **[当前]** ▸ [下一步] ▸ [后续...]

### 当前成果
- 刚完成了什么（具体产出）

### 预期产出
- 下一步将会产出什么

### 下一步操作
- **[继续/Approved]**: 同意，进入下一步
- **[修改]** + 意见：调整当前成果
- **[升级为 X]** / **[降级为 X]**: 调整规模
- **[加载参考：XXX]**: 查看某参考文档的详情
```

**章节来源**
- [README.md:286-306](file://README.md#L286-L306)
- [README.md:307-348](file://README.md#L307-L348)

### 3. 三轴评审机制

Altas Workflow 采用独特的三轴评审体系：

```mermaid
flowchart TB
subgraph "三轴评审"
A1[轴1: Spec质量与需求达成<br/>Goal/In-Scope/Acceptance] --> R1{PASS?}
A2[轴2: Spec-代码一致性<br/>文件/签名/Checklist/行为] --> R2{PASS?}
A3[轴3: 代码内在质量<br/>正确性/鲁棒性/可维护性/测试] --> R3{高风险?}
end
R1 --> |"FAIL"| BACK1[回到Research/Plan]
R2 --> |"FAIL"| BACK1
R3 --> |"有高风险未解决"| BACK2[回到Plan]
R1 --> |"PASS"| NEXT[进入下一步/Archive]
R2 --> |"PASS"| NEXT
R3 --> |"无高风险"| NEXT
```

**图表来源**
- [SKILL.md:211-221](file://altas-workflow/SKILL.md#L211-L221)

**章节来源**
- [SKILL.md:211-221](file://altas-workflow/SKILL.md#L211-L221)

## 架构概览

Altas Workflow 采用分层架构设计，结合三种工作流的优势：

```mermaid
graph TB
subgraph "用户交互层"
U[用户输入] --> P[触发词解析]
end
subgraph "智能路由层"
P --> S{规模评估}
S --> |XS| X1[极速通道]
S --> |S| X2[micro-spec]
S --> |M| X3[标准工作流]
S --> |L| X4[深度工作流]
end
subgraph "工作流引擎"
X1 --> C1[直接执行]
X2 --> C2[Spec驱动]
X3 --> C3[RIPER状态机]
X4 --> C4[Subagent并行]
end
subgraph "知识管理层"
C1 --> K1[验证/summary]
C2 --> K2[Spec文档]
C3 --> K3[三轴评审]
C4 --> K4[知识沉淀]
end
subgraph "工具集成层"
K1 --> T1[测试框架]
K2 --> T2[文件系统]
K3 --> T3[代码审查]
K4 --> T4[归档工具]
end
```

**图表来源**
- [workflow-diagrams.md:7-42](file://altas-workflow/workflow-diagrams.md#L7-L42)
- [SKILL.md:153-163](file://altas-workflow/SKILL.md#L153-L163)

### 触发词与模式映射

**更新** 4.2 版本引入统一触发词字典系统

Altas Workflow 现在采用统一的触发词字典管理系统，将所有触发词、别名和模式控制词统一维护在一个中心位置：

#### 触发词字典结构

**全局触发词**
- `FAST` / `DEEP` / `>>` - 极速通道
- `DEBUG` / `排查` - 系统化调试
- `MULTI` / `多项目` - 多项目协作
- `DOC` / `写文档` - 文档专家
- `MAP` / `链路梳理` - 代码映射
- `PROJECT MAP` / `MAP ALL` / `项目总图` - 项目映射
- `ARCHIVE` / `归档` - 知识沉淀
- `REVIEW` / `代码审查` / `审查 PR` - 代码审查
- `REVIEW SPEC` / `计划评审` - 规划审查
- `REVIEW EXECUTE` / `实现复盘` - 执行审查
- `REFACTOR` / `重构` - 重构模式
- `TEST` / `写测试` / `补测试` - 测试模式
- `PERF` / `性能优化` - 性能模式
- `MIGRATE` / `迁移` / `版本升级` - 迁移模式
- `CROSS` / `跨项目` - 跨项目模式
- `EXIT ALTAS` / `退出协议` - 协议退出

**模式内控制词**
- `SWITCH <project_id>` - 切换项目
- `REGISTRY` - 显示项目注册表
- `SCOPE LOCAL` - 回到本地作用域
- `全部` / `all` - 全量执行权限

**章节来源**
- [SKILL.md:5-5](file://altas-workflow/SKILL.md#L5-L5)
- [aliases.md:12-33](file://altas-workflow/references/entry/aliases.md#L12-L33)

## 详细组件分析

### 组件 A：SDD-RIPER-ONE 标准版

SDD-RIPER-ONE 是 Altas Workflow 的核心执行引擎，提供完整的 RIPER 状态机：

```mermaid
classDiagram
class SDD_RIPER_ONE {
+create_codemap(scope, path)
+build_context_bundle(dir)
+sdd_bootstrap(task, goal, requirement)
+review_spec(spec)
+review_execute(spec, changes)
+archive(spec, codemap)
+debug(log_path, issue)
-phase : string
-approval_status : string
-spec_path : string
}
class RIPER_State_Machine {
+Research()
+Innovate()
+Plan()
+Execute()
+Review()
+ARCHIVE()
}
class Spec_Document {
+Goal : string
+Scope : string
+In_Scope : string[]
+Out_of_Scope : string[]
+Checklist : ChecklistItem[]
+Validation : ValidationRecord[]
}
SDD_RIPER_ONE --> RIPER_State_Machine : "执行"
RIPER_State_Machine --> Spec_Document : "维护"
```

**图表来源**
- [sdd-riper-one/SKILL.md:6-26](file://altas-workflow/references/agents/sdd-riper-one/SKILL.md#L6-L26)
- [sdd-riper-one/SKILL.md:72-124](file://altas-workflow/references/agents/sdd-riper-one/SKILL.md#L72-L124)

#### 核心执行流程

```mermaid
sequenceDiagram
participant User as 用户
participant Agent as SDD-RIPER-ONE
participant Spec as Spec文档
participant Code as 代码库
User->>Agent : 任务描述
Agent->>Agent : 规模评估
Agent->>Spec : 创建首版Spec
Agent->>Agent : Research阶段
Agent->>Spec : 更新Research发现
Agent->>Agent : Plan阶段
Agent->>Spec : 生成Checklist
User->>Agent : [Approved]
Agent->>Agent : Execute阶段
Agent->>Code : 实施变更
Agent->>Spec : 记录执行日志
Agent->>Agent : Review阶段
Agent->>Spec : 三轴评审
Agent->>User : 完成报告
```

**图表来源**
- [workflow-diagrams.md:291-338](file://altas-workflow/workflow-diagrams.md#L291-L338)

**章节来源**
- [sdd-riper-one/SKILL.md:28-36](file://altas-workflow/references/agents/sdd-riper-one/SKILL.md#L28-L36)
- [sdd-riper-one/SKILL.md:177-196](file://altas-workflow/references/agents/sdd-riper-one/SKILL.md#L177-L196)

### 组件 B：Checkpoint 驱动轻量模式

Checkpoint 驱动模式专为高频多轮交互设计，提供高效的 micro-spec 工作流：

```mermaid
flowchart TD
A[用户输入] --> B{任务类型判断}
B --> |typo/配置| C[Size XS 极速]
B --> |小功能| D[Size S 快速]
B --> |复杂功能| E[Size M/L 标准]
C --> F[直接修改→验证→summary]
D --> G[micro-spec→批准→执行→回写]
E --> H[完整RIPER流程]
G --> I[Done Contract]
I --> J[Execution Approval]
J --> K[验证结果]
K --> L[回写到Spec]
```

**图表来源**
- [SKILL.md:102-122](file://altas-workflow/SKILL.md#L102-L122)
- [spec-lite-template.md:5-69](file://altas-workflow/references/checkpoint-driven/spec-lite-template.md#L5-L69)

#### 上下文装配策略

| 层级 | 加载时机 | 内容 |
|------|----------|------|
| **Hot** (每轮) | 所有对话 | phase, approval状态, Spec路径, Goal, Scope, 活跃Checklist |
| **Warm** (阶段切换) | Research→Plan / Plan→Execute / Execute→Review | 研究发现, Plan文件/签名, 验证结果 |
| **Cold** (按需) | 冲突/不确定时 | 完整ChangeLog, 历史Research详情, 完整CodeMap |

**章节来源**
- [SKILL.md:476-490](file://altas-workflow/SKILL.md#L476-L490)

### 组件 C：Superpowers 超级能力

Superpowers 模块提供了丰富的专业技能：

```mermaid
graph TB
subgraph "TDD 铁律"
A1[RED: 写失败测试] --> A2[GREEN: 最小代码]
A2 --> A3[REFACTOR: 重构优化]
A3 --> A1
end
subgraph "系统化调试"
B1[根因调查] --> B2[模式分析]
B2 --> B3[假设验证]
B3 --> B4[实施修复]
end
subgraph "Subagent 驱动"
C1[实现者子代理] --> C2[Spec合规审查]
C2 --> C3[代码质量审查]
C3 --> C1
end
```

**图表来源**
- [test-driven-development/SKILL.md:47-69](file://altas-workflow/references/superpowers/test-driven-development/SKILL.md#L47-L69)
- [systematic-debugging/SKILL.md:46-87](file://altas-workflow/references/superpowers/systematic-debugging/SKILL.md#L46-L87)
- [subagent-driven-development/SKILL.md:40-85](file://altas-workflow/references/superpowers/subagent-driven-development/SKILL.md#L40-L85)

**章节来源**
- [test-driven-development/SKILL.md:31-46](file://altas-workflow/references/superpowers/test-driven-development/SKILL.md#L31-L46)
- [systematic-debugging/SKILL.md:16-23](file://altas-workflow/references/superpowers/systematic-debugging/SKILL.md#L16-L23)

### 组件 D：协议系统

Altas Workflow 支持多种专用协议：

#### RIPER-5 严格模式协议

RIPER-5 提供严格的五阶段门禁控制：

```mermaid
stateDiagram-v2
[*] --> RESEARCH
RESEARCH --> INNOVATE
INNOVATE --> PLAN
PLAN --> EXECUTE
EXECUTE --> REVIEW
REVIEW --> [*]
RESEARCH : 信息收集仅限观察
INNOVATE : 方案讨论仅限可能性
PLAN : 详尽技术规范
EXECUTE : 严格按计划执行
REVIEW : 严格验证实现
```

**图表来源**
- [RIPER-5.md:25-125](file://altas-workflow/protocols/RIPER-5.md#L25-L125)

#### RIPER-DOC 文档专家协议

文档专家协议提供四阶段文档创作流程：

```mermaid
flowchart LR
A[ABSORB: 上下文提取] --> B[OUTLINE: 结构规划]
B --> C[AUTHOR: 内容生成]
C --> D[FACT-CHECK: 准确性验证]
A -.-> E[技术细节收集]
B -.-> F[文档结构设计]
C -.-> G[Markdown/LaTeX撰写]
D -.-> H[代码交叉验证]
```

**图表来源**
- [RIPER-DOC.md:9-60](file://altas-workflow/protocols/RIPER-DOC.md#L9-L60)

**章节来源**
- [RIPER-5.md:15-22](file://altas-workflow/protocols/RIPER-5.md#L15-L22)
- [RIPER-DOC.md:5-7](file://altas-workflow/protocols/RIPER-DOC.md#L5-L7)

### 组件 E：Special Modes 专项模式

**新增** 4.2 版本引入的专项模式系统

Altas Workflow 现在支持 7 种专项工作模式：

```mermaid
graph TB
subgraph "专项模式"
A[REVIEW 模式] --> A1[代码审查]
A --> A2[Spec审查]
A --> A3[执行后评审]
B[REFACTOR 模式] --> B1[代码重构]
B --> B2[坏味道识别]
B --> B3[小步重构]
C[TEST 模式] --> C1[测试现状分析]
C --> C2[补测试]
C --> C3[TDD执行]
D[PERF 模式] --> D1[性能瓶颈定位]
D --> D2[优化策略]
D --> D3[验证策略]
E[MIGRATE 模式] --> E1[迁移风险评估]
E --> E2[回滚策略]
E --> E3[预演验证]
end
```

**图表来源**
- [review.md:1-137](file://altas-workflow/references/special-modes/review.md#L1-L137)
- [refactor.md:1-181](file://altas-workflow/references/special-modes/refactor.md#L1-L181)

**章节来源**
- [review.md:1-137](file://altas-workflow/references/special-modes/review.md#L1-L137)
- [refactor.md:1-181](file://altas-workflow/references/special-modes/refactor.md#L1-L181)

## 依赖分析

### 模块耦合关系

```mermaid
graph TB
subgraph "核心依赖"
A[SKILL.md] --> B[reference-index.md]
A --> C[references/entry/aliases.md]
A --> D[references/entry/sources.md]
end
subgraph "工作流依赖"
B --> E[spec-template.md]
B --> F[spec-lite-template.md]
B --> G[test-driven-development/SKILL.md]
B --> H[subagent-driven-development/SKILL.md]
B --> I[systematic-debugging/SKILL.md]
B --> J[review.md]
B --> K[refactor.md]
B --> L[test.md]
B --> M[perf.md]
B --> N[migrate.md]
end
subgraph "协议依赖"
A --> O[RIPER-5.md]
A --> P[RIPER-DOC.md]
A --> Q[SDD-RIPER-DUAL-COOP.md]
end
```

**图表来源**
- [reference-index.md:16-81](file://altas-workflow/reference-index.md#L16-L81)
- [SKILL.md:425-455](file://altas-workflow/SKILL.md#L425-L455)

### 外部依赖

| 依赖类型 | 用途 | 版本要求 |
|----------|------|----------|
| **Python** | 归档构建器 | 3.6+ |
| **文件系统** | 产物存储 | 任意平台 |
| **测试框架** | TDD验证 | npm test / pytest / go test |
| **Git** | 版本控制 | 任意版本 |
| **IDE 工具** | 代码搜索 | SearchCodebase / Grep / Glob |

**章节来源**
- [archive_builder.py:1-8](file://altas-workflow/scripts/archive_builder.py#L1-L8)
- [QUICKSTART.md:30-33](file://altas-workflow/QUICKSTART.md#L30-L33)

## 性能考虑

### 上下文窗口优化

Altas Workflow 采用三层上下文装配策略：

1. **Hot 上下文**（每轮）：包含当前阶段状态和活跃任务
2. **Warm 上下文**（阶段切换）：包含跨阶段的重要信息
3. **Cold 上下文**（按需）：包含完整的历史记录

### 并行执行优化

对于支持并行的环境，Altas Workflow 可以：

- 同时执行多个子代理任务
- 自动进行两阶段审查（Spec 合规 → 代码质量）
- 使用 Git Worktree 进行隔离开发

### 资源消耗控制

- **内存使用**：通过渐进式披露避免一次性加载所有参考资料
- **计算资源**：根据任务复杂度动态选择工作流深度
- **存储空间**：提供产物生命周期管理策略

## 故障排除指南

### 常见问题与解决方案

| 问题类型 | 症状 | 解决方案 |
|----------|------|----------|
| **流程失控** | AI 一次性输出所有步骤 | 使用检查点机制，要求每次只推进一步 |
| **规格不符** | Plan 与实际实现不一致 | 使用 Reverse Sync 先更新 Spec 再修代码 |
| **测试失败** | TDD 红灯连续3次无法变绿 | 暂停执行，输出根因分析候选 |
| **上下文溢出** | 上下文窗口即将耗尽 | 执行 Resume Ready，输出恢复锚点 |
| **审查不通过** | 三轴评审失败 | 回到 Research/Plan 修正，不得绕过 |

### 异常恢复策略

```mermaid
flowchart TD
A[异常发生] --> B{异常类型}
B --> |参考文件读取失败| C[降级为标准模式]
B --> |Spec文件损坏| D[重建最小Spec]
B --> |用户取消| E[输出阶段摘要]
B --> |TDD红灯| F[根因分析+修复建议]
B --> |上下文不足| G[Resume Ready]
C --> H[继续执行]
D --> I[请求用户确认]
E --> F
F --> G
G --> H
```

**图表来源**
- [SKILL.md:253-260](file://altas-workflow/SKILL.md#L253-L260)

**章节来源**
- [SKILL.md:253-260](file://altas-workflow/SKILL.md#L253-L260)

## 结论

Altas Workflow 通过整合 SDD-RIPER、Checkpoint-Driven 和 Superpowers 三大工作流的优势，为企业级 AI 编程提供了完整的解决方案。其核心价值体现在：

### 主要优势

1. **工程化程度高**：通过严格的门禁机制和三轴评审，确保代码质量和可维护性
2. **适应性强**：支持四种不同的任务深度，从小型修改到架构重构
3. **知识管理完善**：通过 Spec、CodeMap、Archive 等产物实现知识沉淀
4. **工具链完整**：提供自动化脚本和多种协议支持
5. **路由智能化**：统一触发词系统，自动识别任务类型和规模
6. **按需加载**：精简入口，按需加载参考资料，降低资源消耗

### 应用场景

- **日常功能迭代**：通过 Size M 工作流保证质量
- **紧急修复**：通过 Size XS 极速通道快速响应
- **架构重构**：通过 Size L 深度工作流确保系统稳定性
- **团队协作**：通过统一的协议和工具链提高协作效率
- **专项任务**：通过 Special Modes 模块化处理特定需求

### 发展前景

Altas Workflow 代表了 AI 原生研发的发展方向，通过将人工智能与工程实践深度融合，为企业数字化转型提供了强有力的技术支撑。

## 附录

### 快速开始指南

1. **环境配置**
   - 安装 Skill/Prompt 到目标平台
   - 创建 `mydocs/` 目录结构
   - 配置测试框架

2. **基本使用**
   - 极速修改：`>> 任务描述`
   - 小任务：`FAST: 任务描述`
   - 标准开发：`sdd_bootstrap: task=..., goal=...`
   - 深度重构：`DEEP: 任务描述`

3. **高级功能**
   - 系统化调试：`DEBUG: 日志路径`
   - 多项目协作：`MULTI: 跨项目任务`
   - 文档专家：`DOC: 文档任务`
   - 知识沉淀：`ARCHIVE: 目标文件`
   - 代码审查：`REVIEW: 范围`
   - 重构模式：`REFACTOR: 目标`
   - 性能优化：`PERF: 目标`
   - 迁移任务：`MIGRATE: 任务描述`

**章节来源**
- [QUICKSTART.md:7-33](file://altas-workflow/QUICKSTART.md#L7-L33)
- [QUICKSTART.md:36-49](file://altas-workflow/QUICKSTART.md#L36-L49)

### 参考资料索引

**更新** 4.2 版本引入统一引用索引系统

| 类别 | 文件 | 用途 |
|------|------|------|
| **核心协议** | `SKILL.md` | 主协议定义 |
| **工作流模板** | `spec-template.md` | 完整 Spec 模板 |
| | `spec-lite-template.md` | micro-spec 模板 |
| **执行技能** | `test-driven-development/SKILL.md` | TDD 铁律 |
| | `systematic-debugging/SKILL.md` | 系统化调试 |
| | `subagent-driven-development/SKILL.md` | Subagent 驱动 |
| **专项模式** | `review.md` | 代码审查协议 |
| | `refactor.md` | 重构专项协议 |
| | `test.md` | 测试专项协议 |
| | `perf.md` | 性能专项协议 |
| | `migrate.md` | 迁移专项协议 |
| **工具脚本** | `archive_builder.py` | 知识归档 |
| **专用协议** | `RIPER-5.md` | 严格模式 |
| | `RIPER-DOC.md` | 文档专家 |
| | `SDD-RIPER-DUAL-COOP.md` | 双模型协作 |

**章节来源**
- [reference-index.md:425-455](file://altas-workflow/reference-index.md#L425-L455)

### 触发词速查表

**新增** 4.2 版本的完整触发词列表

| 分类 | 触发词 | 中文对应 | 用途 |
|------|--------|----------|------|
| **基础操作** | `>>` | 快速 | 极速通道 |
| | `FAST` | 快速 | 小任务 |
| | `DEEP` | 深度 | 大型任务 |
| | `EXIT ALTAS` | 退出协议 | 协议退出 |
| **代码开发** | `sdd_bootstrap` | - | 标准开发 |
| | `REFACTOR` | 重构 | 代码重构 |
| | `TEST` | 写测试 | 测试相关 |
| | `PERF` | 性能优化 | 性能优化 |
| | `MIGRATE` | 迁移 | 迁移任务 |
| **分析调试** | `DEBUG` | 排查 | 系统化调试 |
| | `REVIEW` | 代码审查 | 代码审查 |
| | `REVIEW SPEC` | 计划评审 | 规划审查 |
| | `REVIEW EXECUTE` | 实现复盘 | 执行审查 |
| **文档分析** | `DOC` | 写文档 | 文档专家 |
| | `MAP` | 链路梳理 | 功能级 CodeMap |
| | `PROJECT MAP`/`MAP ALL` | 项目总图 | 项目级 CodeMap |
| **项目协作** | `MULTI` | 多项目 | 多项目协作 |
| | `CROSS` | 跨项目 | 跨项目改动 |
| **归档沉淀** | `ARCHIVE` | 归档 | 知识沉淀 |

**章节来源**
- [SKILL.md:5-5](file://altas-workflow/SKILL.md#L5-L5)
- [workflow-quickref.md:102-122](file://altas-workflow/references/spec-driven-development/workflow-quickref.md#L102-L122)
- [modules.md:45-57](file://altas-workflow/references/checkpoint-driven/modules.md#L45-L57)
- [multi-project.md:41-47](file://altas-workflow/references/spec-driven-development/multi-project.md#L41-L47)

### 统一触发词字典系统

**新增** 4.2 版本的核心改进

Altas Workflow 4.2 版本引入了全新的统一触发词字典系统，实现了以下改进：

#### 字典管理架构

```mermaid
graph TB
subgraph "统一触发词字典"
A[references/entry/aliases.md] --> B[全局触发词]
A --> C[模式内控制词]
end
subgraph "引用系统"
B --> D[SKILL.md]
B --> E[QUICKSTART.md]
B --> F[workflow-quickref.md]
C --> G[multi-project.md]
C --> H[modules.md]
end
subgraph "依赖声明"
I[SKILL.md frontmatter] --> J[dependencies]
J --> A
end
```

**图表来源**
- [SKILL.md:8-8](file://altas-workflow/SKILL.md#L8-L8)
- [SKILL-entry-review.md:19-34](file://altas-workflow/SKILL-entry-review.md#L19-L34)

#### 字典内容结构

**全局触发词（20+ 个）**
- 编码开发：`FAST` / `DEEP` / `>>` / `sdd_bootstrap`
- 代码分析：`DEBUG` / `REVIEW` / `REVIEW SPEC` / `REVIEW EXECUTE`
- 文档写作：`DOC` / `MAP` / `PROJECT MAP` / `MAP ALL`
- 项目管理：`MULTI` / `CROSS` / `SWITCH` / `REGISTRY` / `SCOPE LOCAL`
- 专项模式：`REFACTOR` / `TEST` / `PERF` / `MIGRATE`
- 知识管理：`ARCHIVE` / `EXIT ALTAS`

**模式内控制词**
- 多项目控制：`SWITCH <project_id>` / `REGISTRY` / `SCOPE LOCAL`
- 执行权限：`全部` / `all`（仅在用户明确授权时使用）
- 作用域控制：`change_scope=cross` / `change_scope=local`

#### 系统优势

1. **集中管理**：所有触发词统一维护在一个文件中，避免分散管理
2. **自动同步**：入口文件、快速启动文件、工作流参考文件自动引用字典
3. **语言支持**：同时支持英文主形式和中文别名
4. **版本控制**：便于追踪触发词变更历史
5. **一致性保证**：确保所有引用文件使用相同的触发词定义

**章节来源**
- [SKILL.md:5-5](file://altas-workflow/SKILL.md#L5-L5)
- [SKILL-entry-review.md:19-34](file://altas-workflow/SKILL-entry-review.md#L19-L34)
- [workflow-quickref.md:5-5](file://altas-workflow/references/spec-driven-development/workflow-quickref.md#L5-L5)

### 入口来源整合说明

**新增** 4.2 版本的入口来源说明

Altas Workflow 4.2 版本引入了专门的入口来源整合文件，用于承载入口层的"来源整合"说明：

#### 来源整合内容

| 来源 | 采纳能力 |
|------|----------|
| **SDD-RIPER** | Spec 中心论、RIPER 状态机、三轴 Review、Multi-Project、Debug/Archive 协议 |
| **Checkpoint-Driven** | 轻量模式、4 级规模、Done Contract、Resume Ready、Hot/Warm/Cold 上下文策略 |
| **Superpowers** | TDD 铁律、系统化 Debug、Subagent、并行 Agent、验证优先 |

#### 使用时机

- 需要解释 ALTAS Workflow 吸收了哪些上游方法论时读取
- 需要说明某条入口规则来自哪类工作流传统时读取
- 需要做方法论介绍、团队推广或入口设计复盘时读取

#### 维护规则

- 若入口只新增了引用路径或索引，不需要更新本文件
- 只有在"采纳了新的方法来源"或"调整了来源与能力映射"时，才更新本文件

**章节来源**
- [sources.md:1-24](file://altas-workflow/references/entry/sources.md#L1-L24)