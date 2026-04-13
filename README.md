# ALTAS Workflow

> **融合三方优势 | 智能深度适配 | 渐进式披露 | 每步可反馈**

**Version:** 4.0 (2026-04-13)  
**仓库规模:** 924KB, 85+ Markdown 文件, 70+ 参考资料

---

## 🎯 这是什么？

**ALTAS Workflow** 是一套综合性 AI 原生研发工作流规范，融合了 **SDD-RIPER**、**SDD-RIPER-Optimized (Checkpoint-Driven)** 与 **Superpowers** 三大优秀工作流的精华。

### 核心使命

致力于解决 AI 编程中的四大工程痛点：

| 痛点 | ALTAS 解法 |
|------|-----------|
| **上下文腐烂** | CodeMap 索引 + 渐进式披露，按需加载参考资料 |
| **审查瘫痪** | 4 级智能深度 (XS/S/M/L)，小任务不卡审批 |
| **代码不信任** | Spec 中心论 + 三轴评审，Spec is Truth |
| **难以维护** | Archive 知识沉淀 + TDD 铁律，完成即资产 |

### 核心铁律

1. **No Spec, No Code** — 未形成最小 Spec 前不写代码 (Size XS 豁免)
2. **No Approval, No Execute** — Plan 阶段人类不点头，绝不写代码
3. **Spec is Truth** — Spec 与代码冲突时，代码是错的
4. **Reverse Sync** — 执行中发现偏差→先更新 Spec→再修代码
5. **Evidence First** — 完成由验证结果证明，非模型自宣布
6. **No Root Cause, No Fix** — Bug 修复前必须有根因分析，禁止盲改
7. **TDD Iron Law** — Size M/L: 无失败测试不写生产代码
8. **Resume Ready** — 长任务暂停前在 Spec 中留恢复锚点

---

## 📦 包含什么？

### 仓库结构总览

```
altas/
├── altas-workflow/              # 主协议目录 (924KB, 70+ 文件)
│   ├── SKILL.md                 # ⭐ 核心系统提示词 (AI 读取)
│   ├── README.md                # ALTAS 详细说明
│   ├── QUICKSTART.md            # 场景化快速指南
│   ├── reference-index.md       # 参考资料总索引
│   ├── protocols/               # 专用协议 (3 个)
│   │   ├── RIPER-5.md           # 严格模式协议
│   │   ├── RIPER-DOC.md         # 文档专家协议
│   │   └── SDD-RIPER-DUAL-COOP.md # 双模型协作协议
│   ├── docs/                    # 方法论文档 (4 篇)
│   │   ├── 从传统编程转向大模型编程.md
│   │   ├── AI-原生研发范式.md
│   │   ├── 团队落地指南.md
│   │   └── 手把手教程.md
│   ├── references/              # 按需加载的参考资料 (70+ 文件)
│   │   ├── spec-driven-development/  # Spec 驱动开发 (7 个核心文档)
│   │   ├── checkpoint-driven/        # Checkpoint 轻量模式 (4 个文档)
│   │   ├── superpowers/              # 超级能力 (24+ 个文档)
│   │   │   ├── test-driven-development/  # TDD 铁律
│   │   │   ├── systematic-debugging/     # 系统化 Debug
│   │   │   ├── subagent-driven-development/ # Subagent 驱动
│   │   │   ├── brainstorming/            # 设计头脑风暴
│   │   │   ├── writing-plans/            # 写 Plan 最佳实践
│   │   │   └── ... (更多超级能力)
│   │   └── agents/                       # Agent 定义 (2 个完整 Agent)
│   │       ├── sdd-riper-one/            # 标准版 Agent
│   │       └── sdd-riper-one-light/      # 轻量版 Agent
│   └── scripts/                 # 自动化工具
│       └── archive_builder.py   # Archive 构建器
├── AGENTS.md                    # 通用 AI 行为准则
├── CLAUDE.md                    # 通用 AI 行为准则
└── EXAMPLES.md                  # 四大原则代码示例
```

### 核心资产统计

| 类别 | 数量 | 说明 |
|------|------|------|
| **核心协议** | 1 个 | SKILL.md (ALTAS Workflow 主协议) |
| **专用协议** | 3 个 | RIPER-5 / RIPER-DOC / DUAL-COOP |
| **方法论** | 4 篇 | 从传统到大模型 / AI 原生范式 / 团队落地 / 手把手教程 |
| **参考资料** | 70+ | Spec 驱动 / Checkpoint / Superpowers 三大类 |
| **独立 Agent** | 2 个 | SDD-RIPER-ONE (标准版/轻量版) |
| **代码示例** | 1 个 | EXAMPLES.md (四大原则实战示例) |

---

## 🚀 如何快速使用？

### 30 秒安装

**方法 1**: 复制 `altas-workflow/SKILL.md` 内容到 AI 助手的 Custom Instructions

**方法 2**: 在 Cursor/Trae 中运行：
```bash
cp altas-workflow/SKILL.md .cursorrules
```

**方法 3**: 项目配置
```bash
mkdir -p mydocs/{codemap,context,specs,micro_specs,archive}
```

### 平台适配

| 平台 | 安装方式 |
|------|----------|
| **Cursor / Trae** | 将 `SKILL.md` 内容复制到 `.cursorrules` 或全局 AI Rules |
| **Claude / OpenAI Agent** | 将 `SKILL.md` 内容作为 System Prompt 注入 |
| **Qoder** | 将 `SKILL.md` 放入项目 `.qoder/skills/` 目录 |

---

### 立即使用

**极速修改 (Size XS)**:
```
>> 将 src/config.ts 中的 MAX_RETRIES 从 3 改为 5
```

**小任务 (Size S)**:
```
FAST: 为登录接口添加图形验证码
```

**标准开发 (Size M)**:
```
sdd_bootstrap: task=用户注册接口添加防刷功能，goal=安全性提升
```

**架构重构 (Size L)**:
```
DEEP: 重构认证模块拆分为独立微服务
```

**Bug 排查**:
```
DEBUG: log_path=./logs/error.log, issue=审批通过后未获得授权
```

**多项目协作**:
```
MULTI: task=前后端联动发布新功能
```

---

## 📚 核心命令

### 命令总览

| 命令 | 用途 | 适用规模 | 流程影响 |
|------|------|----------|----------|
| `>>` / `FAST` | 快速通道，跳过 Research/Plan | XS/S | 直接执行→验证→summary |
| `sdd_bootstrap` | 启动 RIPER 流程 | M/L | Research→Plan→Execute→Review |
| `create_codemap` | 生成代码地图 | M/L | 只读分析，不改代码 |
| `MAP` / `PROJECT MAP` | 只读分析项目 | 所有 | 生成架构地图 |
| `DEBUG` | 系统调试模式 | - | 根因分析→诊断报告 |
| `MULTI` | 多项目协作 | L | 自动发现+作用域隔离 |
| `ARCHIVE` | 知识沉淀 | L | human 版 + llm 版双视角 |
| `DOC` | 文档专家模式 | - | ABSORB→OUTLINE→AUTHOR→FACT-CHECK |
| `REVIEW SPEC` | 执行前评审 | M/L | 建议性预审 |
| `REVIEW EXECUTE` | 执行后三轴审查 | M/L | Spec/代码/质量三轴评审 |

### 触发词速查

| 触发词 | 动作 | 规模 |
|--------|------|------|
| `FAST` / `快速` / `>>` | 极速通道 | XS/S |
| `DEEP` | 深度模式 | L |
| `MAP` / `链路梳理` | 功能级 CodeMap | - |
| `PROJECT MAP` / `项目总图` | 项目级 CodeMap | - |
| `MULTI` / `多项目` | 多项目模式 | L |
| `CROSS` / `跨项目` | 允许跨项目改动 | L |
| `DEBUG` / `排查` | 系统化 Debug | - |
| `REVIEW SPEC` / `计划评审` | 执行前建议性预审 | M/L |
| `REVIEW EXECUTE` / `代码评审` | 执行后三轴审查 | M/L |
| `ARCHIVE` / `归档` / `沉淀` | 知识沉淀 | L |
| `DOC` / `写文档` | 文档专家模式 | - |
| `EXIT ALTAS` / `退出协议` | 停用协议 | - |
| `全部` / `all` / `execute all` | 批量执行 | M/L |

---

## 🏗️ 工作流阶段

### Size M (标准) 流程

```mermaid
flowchart LR
    R[Research<br/>Spec 初稿] --> P[Plan<br/>任务清单]
    P --> E[Execute(TDD)<br/>失败测试]
    E --> RV[Review<br/>三轴评审]
    RV --> V[Verification<br/>验证证据]
```

**流程说明**:
- **Research**: 研究对齐，形成 Spec（Goal, In-Scope, Out-of-Scope, Facts, Risks, Open Questions）
- **Plan**: 详细规划，拆解为原子 Checklist，明确 File Changes + Signatures + Done Contract
- **Execute**: TDD 驱动实现（RED→GREEN→REFACTOR）
- **Review**: 三轴评审（Spec 质量 / Spec-代码一致性 / 代码内在质量）
- **Verification**: 验证证据，确保测试通过

### Size L (深度) 流程

```mermaid
flowchart LR
    R[Research<br/>Spec 初稿] --> I[Innovate<br/>方案对比]
    I --> P[Plan<br/>任务清单]
    P --> E[Execute(TDD+Subagent)<br/>并行实现]
    E --> RV[Review<br/>三轴评审]
    RV --> A[Archive<br/>知识沉淀]
```

**流程说明**:
- **Research**: 深度研究，梳理现状链路，标识风险
- **Innovate**: 方案对比，给出 2-3 种方案（Pros/Cons/Risks/Effort）
- **Plan**: 原子 Checklist + Subagent 分配
- **Execute**: TDD 驱动 + Subagent 并行实现 + 两阶段 Review
- **Review**: 三轴评审 + Archive 沉淀
- **Archive**: 生成双视角文档（human 版 + llm 版）

---

## ⚡ 智能深度适配

### 四级任务深度

| 规模 | 触发条件 | Spec 要求 | 工作流 | 典型场景 |
|------|----------|----------|--------|----------|
| **XS (极速)** | typo、配置值、<10 行 | 跳过，事后 1 行 summary | 直接执行→验证→summary | 改配置、修 typo、日志 |
| **S (快速)** | 1-2 文件，逻辑清晰 | micro-spec (1-3 句) | micro-spec→批准→执行→回写 | 加参数、简单功能 |
| **M (标准)** | 3-10 文件，模块内 | 轻量 Spec 落盘 | Research→Plan→Execute(TDD)→Review | 新增接口、模块重构 |
| **L (深度)** | 跨模块、>500 行、架构级 | 完整 Spec + Innovate + Archive | Research→Innovate→Plan→Execute→Subagent→Review→Archive | 架构拆分、跨团队改造 |

### 规模评估速查表

| 信号 | 推荐规模 | 说明 |
|------|----------|------|
| "改个 typo" | XS | 纯机械改动 |
| "加个配置项" | XS | 无架构影响 |
| "改个按钮文案" | XS/S | 边界场景 |
| "这个接口加个参数" | S | 单文件小改动 |
| "给这个函数加错误处理" | S | 逻辑清晰 |
| "新增一个 CRUD 接口" | M | 模块内开发 |
| "重构这个模块" | M/L | 边界场景 |
| "跨模块改数据模型" | L | 跨模块影响 |
| "架构级重构" | L | 全局影响 |
| "前后端联动" | L (MULTI) | 多项目协作 |

### 自动升降级

- **执行中发现复杂度超出预期** → AI 立即暂停，提议升级
- **用户随时可用** `[升级为 M]` / `[降级为 S]` 调整
- **强制指定**: `>>`=XS, `FAST`=S, 默认=M, `DEEP`=L

---

## 🛡️ 质量铁律

| # | 铁律 | 含义 |
|---|------|------|
| 1 | **No Spec, No Code** | 未形成最小 Spec 前不写代码 (Size XS 豁免) |
| 2 | **No Approval, No Execute** | Plan 阶段人类不点头，绝不写代码 |
| 3 | **Spec is Truth** | Spec 与代码冲突时，代码是错的 |
| 4 | **Reverse Sync** | 执行中发现偏差→先更新 Spec→再修代码 |
| 5 | **Evidence First** | 完成由验证结果证明，非模型自宣布 |
| 6 | **No Root Cause, No Fix** | Bug 修复前必须有根因分析，禁止盲改 |
| 7 | **TDD Iron Law** | Size M/L: 无失败测试不写生产代码 |
| 8 | **Resume Ready** | 长任务暂停前在 Spec 中留恢复锚点 |

---

## 🎯 进度可视化系统

### 检查点机制

**每个步骤完成后**，AI 必须输出标准化检查点：

```markdown
### 进度 [Phase ▸ Step]
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

### 检查点示例

**Research 完成后**:
```markdown
### 进度 [Research ▸ Complete]
[ ] ▸ **[Research]** ▸ [Plan] ▸ [Execute] ▸ [Review]

### 当前成果
- 已完成现状分析，识别 3 个核心文件
- 发现现有注册接口无图形库依赖
- Spec 初稿已建立（Goal/Scope/Facts/Risks）

### 预期产出
- Plan 阶段将拆解为原子 Checklist
- 明确每个文件的具体改动和签名

### 下一步操作
- **[继续]**: 进入 Plan 阶段
- **[修改]**: 调整 Spec 中的风险项
- **[加载参考：spec-template.md]**: 查看 Spec 模板详情
```

**Plan 完成后**:
```markdown
### 进度 [Plan ▸ Complete]
[Research] ▸ **[Plan]** ▸ [Execute] ▸ [Review]

### 当前成果
- Checklist 已拆解为 5 个原子任务
- 明确 3 个文件改动 + 函数签名
- Done Contract 已定义

### 预期产出
- Execute 阶段将按 Checklist 逐项实现
- TDD 驱动：先写失败测试→实现逻辑→验证通过

### 下一步操作
- **[Approved]**: 批准 Plan，进入 Execute
- **[修改]**: 调整 Checklist 顺序或实现方案
- **[升级为 L]**: 需要 Subagent 并行实现
```

---

## 📖 详细文档

### 核心文档（必读）

| 文档 | 用途 | 长度 |
|------|------|------|
| [ALTAS Workflow 详细说明](altas-workflow/README.md) | 完整工作流协议 | 650+ 行 |
| [快速启动指南](altas-workflow/QUICKSTART.md) | 30 秒上手 | 170+ 行 |
| [参考资料总索引](altas-workflow/reference-index.md) | 按需加载地图 | 200+ 行 |
| [SKILL.md](altas-workflow/SKILL.md) | AI 系统提示词 | 650+ 行 |

### 方法论文档（理论）

| 文档 | 主题 | 适用人群 |
|------|------|----------|
| [从传统编程转向大模型编程](altas-workflow/docs/从传统编程转向大模型编程.md) | 范式转换 | 全员 |
| [AI 原生研发范式](altas-workflow/docs/AI-原生研发范式 - 从代码中心到文档驱动的演进.md) | 文档驱动 | 架构师/Tech Lead |
| [团队落地指南](altas-workflow/docs/团队落地指南.md) | 团队推广 | Tech Lead/Manager |
| [手把手教程](altas-workflow/docs/如何快速从零开始落地大模型编程%20--%20手把手教程.md) | 从零开始 | 新手 |

### 专用协议（特殊场景）

| 协议 | 用途 | 触发方式 |
|------|------|----------|
| [RIPER-5 严格模式](altas-workflow/protocols/RIPER-5.md) | 严格阶段门禁 | 高风险项目 |
| [RIPER-DOC 文档专家](altas-workflow/protocols/RIPER-DOC.md) | 文档撰写 | `DOC` 命令 |
| [双模型协作协议](altas-workflow/protocols/SDD-RIPER-DUAL-COOP.md) | 多模型协作 | 复杂架构 |

### 技能包（独立 Agent）

| Agent | 定位 | 适用场景 |
|-------|------|----------|
| [SDD-RIPER-ONE 标准版](altas-workflow/references/agents/sdd-riper-one/SKILL.md) | 完整 RIPER 流程 | 中大型任务 |
| [SDD-RIPER-ONE Light 轻量版](altas-workflow/references/agents/sdd-riper-one-light/SKILL.md) | Checkpoint 驱动 | 高频多轮/强模型 |

### 超级能力（Superpowers）

| 能力 | 文档 | 调用时机 |
|------|------|----------|
| **TDD** | [test-driven-development/SKILL.md](altas-workflow/references/superpowers/test-driven-development/SKILL.md) | Size M/L 执行阶段 |
| **系统化 Debug** | [systematic-debugging/SKILL.md](altas-workflow/references/superpowers/systematic-debugging/SKILL.md) | DEBUG 模式 |
| **Subagent 驱动** | [subagent-driven-development/SKILL.md](altas-workflow/references/superpowers/subagent-driven-development/SKILL.md) | Size L 并行实现 |
| **设计头脑风暴** | [brainstorming/SKILL.md](altas-workflow/references/superpowers/brainstorming/SKILL.md) | Innovate 阶段 |
| **写 Plan 最佳实践** | [writing-plans/SKILL.md](altas-workflow/references/superpowers/writing-plans/SKILL.md) | Plan 阶段 |
| **完成前验证** | [verification-before-completion/SKILL.md](altas-workflow/references/superpowers/verification-before-completion/SKILL.md) | Review 阶段 |

---

## 🤝 来源整合

### 三大来源总览

| 来源 | 核心优势 | 采纳内容 |
|------|----------|----------|
| **SDD-RIPER** | Spec 中心论、RIPER 状态机 | Spec 模板、三轴 Review、Multi-Project 自动发现、Debug/Archive 协议、CodeMap 索引 |
| **SDD-RIPER-Optimized** | Checkpoint-Driven 轻量模式 | 4 级任务深度 (zero/fast/standard/deep)、Done Contract、Resume Ready、Hot/Warm/Cold上下文装配、micro-spec |
| **Superpowers** | TDD 铁律、系统化 Debug | TDD 反模式、Debug 四阶段法、Subagent 驱动 + 两阶段 Review、并行 Agent 派遣、验证优先铁律 |

### 来源贡献统计

| 来源 | 文档数 | 核心文件 |
|------|--------|----------|
| **SDD-RIPER** | 14+ | spec-template.md, commands.md, multi-project.md, archive-template.md |
| **SDD-RIPER-Optimized** | 6+ | spec-lite-template.md, modules.md, conventions.md |
| **Superpowers** | 24+ | TDD, Debug, Subagent, Brainstorming, Writing-Plans, Verification |

---

## 🎓 典型使用场景

### 场景一：日常功能迭代 (Size M)

**输入**:
```
sdd_bootstrap: task=为用户注册接口添加图形验证码防刷功能，goal=安全性提升
```

**AI 行为**:
1. ✅ 自动评估规模 → Size M (Standard)
2. ✅ **Research** → 读取现有注册接口，发现没有图形库依赖 → 输出检查点
3. ✅ **Plan** → 列出 Checklist（引入库→改接口→加测试）→ 输出检查点等 [Approved]
4. ✅ **Execute** → TDD: 先写失败测试→实现逻辑→验证通过
5. ✅ **Review** → 三轴评审 → 确认通过

**产出**:
- Spec 文档：`mydocs/specs/YYYY-MM-DD_hh-mm_用户注册图形验证码.md`
- 代码改动：`src/api/auth.ts`, `src/utils/captcha.ts`
- 测试文件：`src/api/auth.test.ts`

---

### 场景二：紧急修复线上配置 (Size XS)

**输入**:
```
>> 将 src/config.ts 中的 MAX_RETRIES 从 3 改为 5
```

**AI 行为**:
1. ✅ 识别为 Size XS (极速)
2. ✅ 直接修改代码→运行验证→1 行 summary

**产出**:
- 1 行 summary: `修改 MAX_RETRIES 从 3→5，验证通过`

---

### 场景三：架构重构 (Size L)

**输入**:
```
DEEP: 重构认证模块拆分为独立微服务
```

**AI 行为**:
1. ✅ 识别为 Size L (深度)
2. ✅ **create_codemap** → 生成认证模块代码索引
3. ✅ **Research** → 梳理现状链路，标识风险
4. ✅ **Innovate** → 给出 3 种方案（服务化/模块化/网关层）对比
5. ✅ **Plan** → 原子 Checklist + Subagent 分配
6. ✅ **Execute** → TDD 驱动 + Subagent 并行实现 + 两阶段 Review
7. ✅ **Review** → 三轴评审 + Archive 沉淀

**产出**:
- CodeMap: `mydocs/codemap/YYYY-MM-DD_hh-mm_认证模块.md`
- Spec: `mydocs/specs/YYYY-MM-DD_hh-mm_认证服务化.md`
- Archive: `mydocs/archive/YYYY-MM-DD_hh-mm_认证服务化_{human,llm}.md`

---

### 场景四：Bug 排查

**输入**:
```
DEBUG: log_path=./logs/error.log, issue=审批通过后未获得授权
```

**AI 行为**:
1. ✅ 进入 Debug 模式（只读分析）
2. ✅ 读取日志+Spec+CodeMap → 三角定位
3. ✅ 输出：症状/预期行为/根因候选/建议修复
4. ✅ 如需修复 → 进入 RIPER 流程或 FAST

**产出**:
- 结构化诊断报告：症状 / 预期行为 / 根因候选 (3 个) / 建议修复

---

### 场景五：多项目协作

**输入**:
```
MULTI: task=前后端联动发布功能
```

**AI 行为**:
1. ✅ 自动扫描 workdir → 发现 web-console + api-service
2. ✅ 输出 Project Registry 请确认
3. ✅ 生成双项目 codemap
4. ✅ Plan 按项目分组：api-service(Provider)→web-console(Consumer)
5. ✅ 执行按依赖顺序，记录 Contract Interfaces

**产出**:
- Project Registry: 识别的子项目列表
- Contract Interfaces: API 接口契约文档
- Touched Projects: 改动的项目清单

---

## 📊 规模评估速查

| 信号 | 推荐规模 |
|------|----------|
| "改个 typo" | XS |
| "加个配置项" | XS |
| "改个按钮文案" | XS/S |
| "这个接口加个参数" | S |
| "给这个函数加错误处理" | S |
| "新增一个 CRUD 接口" | M |
| "重构这个模块" | M/L |
| "跨模块改数据模型" | L |
| "架构级重构" | L |
| "前后端联动" | L (MULTI) |

---

## 🔧 常见问题 (FAQ)

### 流程控制类

**Q: AI 一次性输出太多代码，跑完所有步骤怎么办？**

A: ALTAS 内置检查点机制，AI 完成一步后**必须**暂停等确认。如果 AI 暴走，回复："请停止，严格执行检查点机制，每次只推进一步。"

**Q: 如何中途干预 AI 的计划？**

A: 在任意检查点回复 `[修改] 请不要使用 Redis，改为内存缓存`，AI 会根据反馈调整 Plan 后重新请求 Approve。

**Q: 如何选择 XS/S/M/L？**

A: ALTAS 会自动评估。你也可以强制指定：`>>`=XS, `FAST`=S, 默认=M, `DEEP`=L。执行中可随时 `[升级为 M]` 或 `[降级为 S]`。

---

### TDD 类

**Q: 为什么 AI 总是先写测试？太慢了。**

A: 这是 Evidence First + TDD 铁律。没有失败测试，AI 生成的代码可能没被执行过。如果任务极简，用 `>>` 触发 XS 模式跳过 TDD。

**Q: 什么情况下可以跳过 TDD？**

A: Size XS/S（typo、配置、单文件小改动）可豁免 TDD。Size M/L 必须遵守 TDD 铁律。

---

### 文档管理类

**Q: mydocs/下太多 md 文件，要提交 Git 吗？**

A: **强烈建议提交**。Spec 和 Archive 是项目的唯一真相源，防止上下文腐烂，帮助新人接手。

**Q: 如何管理 mydocs/下的文件？**

A: 使用统一时间前缀 `YYYY-MM-DD_hh-mm_`，定期归档旧文件。Archive 脚本可自动生成 human/llm 双视角文档。

---

### 参考资料类

**Q: 参考资料 (references/) 太多，AI 每次都要全部读取吗？**

A: **不需要**。ALTAS 采用渐进式披露，只在命中场景时按需读取对应文件。SKILL.md 中的参考索引表明确了每个文件的调用时机。

**Q: 参考资料如何按需加载？**

A: 查看 [reference-index.md](altas-workflow/reference-index.md)，每个文件都标注了调用时机。例如：
- 写 Spec 时 → 读取 `spec-template.md`
- TDD 执行时 → 读取 `test-driven-development/SKILL.md`
- Debug 时 → 读取 `systematic-debugging/SKILL.md`

---

### 团队协作类

**Q: 多人团队如何协作？**

A: Spec 是团队共享的真相源。每个人创建自己的 Spec 文件，通过 Git 协作。核心开发者只需 Review Plan，不必 Review 全部代码。

**Q: 什么模型适合用 ALTAS？**

A: 任何模型都能使用标准模式 (M/L)。轻量模式 (S/XS) 特别适合强模型（Claude Opus/GPT-4+）高频多轮场景。新团队建议从标准模式开始。

**Q: 如何培训团队成员？**

A: 先阅读 [从传统编程转向大模型编程](altas-workflow/docs/从传统编程转向大模型编程.md)，再实践 [手把手教程](altas-workflow/docs/如何快速从零开始落地大模型编程%20--%20手把手教程.md)。

---

## 📋 版本历史

| 版本 | 日期 | 名称 | 状态 | 关键变更 |
|------|------|------|------|----------|
| **v4.0** | 2026-04-13 | ALTAS Workflow | ✅ 当前版本 | 融合三大工作流，新增智能深度适配、进度可视化、按需加载 |
| **v1.0** | 2026-04-12 | SIGMA Workflow | ❌ 已废弃 | 初始版本 |

### v4.0 核心特性

- ✅ **智能深度适配**: 4 级任务深度 (XS/S/M/L)，自动评估 + 手动升降级
- ✅ **进度可视化**: 标准化检查点机制，每步完成后暂停等确认
- ✅ **渐进式披露**: 按需加载参考资料，避免上下文污染
- ✅ **核心铁律**: 8 条不可违背的铁律（No Spec No Code, TDD Iron Law 等）
- ✅ **完整文档**: 70+ 参考资料，覆盖 Spec 驱动/Checkpoint/Superpowers 三大类
- ✅ **独立 Agent**: SDD-RIPER-ONE 标准版/轻量版

---

## 📊 仓库统计

```
仓库大小：924KB
Markdown 文件：85+
参考资料：70+
核心协议：1 个 (SKILL.md)
专用协议：3 个 (RIPER-5/RIPER-DOC/DUAL-COOP)
方法论：4 篇
独立 Agent: 2 个 (标准版/轻量版)
```

---

## 🎯 快速导航

### 新手入门

1. [快速启动指南](altas-workflow/QUICKSTART.md) - 30 秒上手
2. [从传统编程转向大模型编程](altas-workflow/docs/从传统编程转向大模型编程.md) - 范式转换
3. [手把手教程](altas-workflow/docs/如何快速从零开始落地大模型编程%20--%20手把手教程.md) - 从零开始

### 快速参考

- [核心命令](#-核心命令) - 所有触发词和命令
- [规模评估](#-智能深度适配) - XS/S/M/L 如何选择
- [参考资料索引](altas-workflow/reference-index.md) - 按需加载地图
- [详细文档](#-详细文档) - 完整文档列表

### 高级用法

- [RIPER-5 严格模式](altas-workflow/protocols/RIPER-5.md) - 高风险项目
- [Subagent 驱动开发](altas-workflow/references/superpowers/subagent-driven-development/SKILL.md) - 并行实现
- [系统化 Debug](altas-workflow/references/superpowers/systematic-debugging/SKILL.md) - 根因分析

---

*Powered by the integration of SDD-RIPER, SDD-RIPER-Optimized (Checkpoint-Driven), and Superpowers.*

**最后更新**: 2026-04-13
