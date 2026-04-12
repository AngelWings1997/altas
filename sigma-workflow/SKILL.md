---
name: sigma-workflow
description: Sigma Workflow - 统一AI工作流规范。融合SDD-RIPER的Spec驱动、Checkpoint-Driver的轻量按需加载、Superpowers的TDD+Subagent优势。自动评估项目规模，渐进式披露，关键节点暂停反馈。
---

# Sigma Workflow

> **融合三方优势 | 智能深度适配 | 渐进式披露 | 每步可反馈**

---

## 🎯 核心理念

```
Spec is Truth + 按需加载 + Evidence First + 智能选型
```

### 铁律体系

| 铁律 | 来源 | 含义 |
|------|------|------|
| **No Spec, No Code** | SDD-RIPER | 未形成Spec不写代码（FAST模式除外） |
| **Spec is Truth** | SDD-RIPER | Chat历史可衰减，Spec是持久化真相源 |
| **Reverse Sync** | SDD-RIPER | 发现Bug先更新Spec再修复代码 |
| **Checkpoint Gates** | Checkpoint | 关键节点暂停等待确认 |
| **Evidence before Claims** | Superpowers | 验证在前，断言在后，未运行命令不声称通过 |
| **No Fixes Without Root Cause** | Superpowers | 未找到根因不修复，3次失败需质疑架构 |
| **TDD First** | Superpowers | 先写失败测试，再写实现代码 |
| **Fresh Context Per Task** | Superpowers | 每个Subagent任务使用独立构建的上下文 |

---

## 🚀 快速开始

### 极速启动命令

```bash
# 零Spec模式 - 直接执行（typo/配置/日志修改）
>> 修复登录页错别字

# 标准启动 - 描述任务
sdd_bootstrap: task=实现用户注册功能, goal=支持邮箱+验证码

# 深度启动 - 复杂任务
sdd_bootstrap: task=微服务拆分, mode=deep, projects=[api,web,admin]

# 代码理解
MAP: scope=认证模块, mode=feature
PROJECT MAP: scope=整个后端
```

### 三种深度模式速查

| 模式 | 触发 | 代码量 | 阶段 | 适合场景 |
|------|------|--------|------|----------|
| **Zero** | `>>` 前缀 | <10行 | 直接执行→同步Spec | typo/日志/配置 |
| **Fast** | `FAST`/`快速` | <100行 | 最小Spec→执行→Review | 单文件修改 |
| **Standard** | 默认 | 100-1000行 | Research→Plan→Execute→Review | 功能开发 |
| **Deep** | `deep`/`深度` | >1000行 | 完整流程+Innovate+Archive | 架构改造 |

---

## 📊 智能深度评估

### 自动判断逻辑

```
┌─────────────────────────────────────────────────────────────┐
│                      项目规模评估                            │
├─────────────────────────────────────────────────────────────┤
│  评估维度:                                                   │
│  ├── 代码行数改动     <50行 → Zero/Fast                      │
│  ├── 文件数量         1-2个 → Fast, 3-10个 → Standard        │
│  │                   >10个 → Deep                            │
│  ├── 模块跨越         单一模块 → Fast, 多模块 → Standard     │
│  │                   跨项目 → Deep                           │
│  ├── 架构影响         无 → Fast, 局部 → Standard, 全局 → Deep│
│  └── 风险等级         低 → Fast, 中 → Standard, 高 → Deep    │
│                                                              │
│  触发词优先级:                                                 │
│  >> / FAST / 快速 → Zero/Fast                               │
│  deep / 深度 / 复杂 → Deep                                  │
│  无前缀 → Standard（默认）                                   │
└─────────────────────────────────────────────────────────────┘
```

### 模式特征对比

| 阶段 | Zero | Fast | Standard | Deep |
|------|------|------|----------|------|
| **Research** | ❌跳过 | 最小理解 | ✅完整分析 | ✅+Innovate |
| **Plan** | ❌跳过 | micro-spec | ✅详细Checklist | ✅+方案比较 |
| **Execute** | 直接改 | 单步确认 | ✅TDD+分步 | ✅Subagent并行 |
| **Review** | 同步Spec | 简化Review | ✅三轴Review | ✅完整Review |
| **Archive** | ❌ | 可选 | 可选 | ✅必须 |
| **Checkpoint** | 无 | 1个 | 每个阶段前 | 每个阶段前 |
| **Spec详细度** | 1-3行 | micro-spec | 标准Spec | 完整Spec |

---

## 🔄 工作流阶段详解

### 阶段总览图

```
┌────────────────────────────────────────────────────────────────────────────┐
│                        SIGMA WORKFLOW                                       │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│   ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐         │
│   │PRE-RESEARCH│    │ RESEARCH │     │   PLAN  │     │  EXECUTE │         │
│   │  (可选)   │ ──► │ (LOCKED) │ ──► │ (LOCKED) │ ──► │ (ACTIVE) │         │
│   └──────────┘     └──────────┘     └──────────┘     └──────────┘         │
│        │                                      │              │             │
│        │              ┌──────────┐           │              ▼             │
│        │              │ INNOVATE │           │     ┌──────────────┐        │
│        │              │ (可选)    │           │     │    REVIEW    │        │
│        │              └──────────┘           │     │   (LOCKED)   │        │
│        │                                      │     └──────────────┘        │
│        │                                      │              │               │
│        ▼                                      ▼              ▼               │
│   ┌──────────┐                         ┌──────────┐  ┌──────────┐         │
│   │  ARCHIVE  │                         │SPEC REVIEW│  │  DEBUG   │         │
│   │  (可选)   │                         │ (建议性)  │  │ (按需)   │         │
│   └──────────┘                         └──────────┘  └──────────┘         │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## 🔒 阶段 0: PRE-RESEARCH（按需）

**状态**: `[OPTIONAL]`

**触发条件**: 复杂代码库、分散需求文档、用户明确要求

### 0.1 CodeMap（代码地图）

**触发词**: `MAP`, `链路梳理`, `PROJECT MAP`, `全局地图`

**两种模式**:

| 模式 | 适用场景 | 输出文件 |
|------|----------|----------|
| `feature` | 单功能/接口理解 | `mydocs/codemap/YYYY-MM-DD_<feature>功能.md` |
| `project` | 整个项目架构 | `mydocs/codemap/YYYY-MM-DD_<project>项目总图.md` |

**产出示例**:
```markdown
# CodeMap: 用户认证模块 (feature)

## 入口点
- `src/auth/login.ts` - POST /api/login
- `src/auth/register.ts` - POST /api/register

## 核心逻辑
- `src/auth/jwt.ts` - Token生成与验证
- `src/auth/middleware.ts` - 认证中间件

## 数据模型
- `User` model: id, email, passwordHash, createdAt
```

### 0.2 Context Bundle（需求汇总）

**触发词**: `build_context_bundle`, `整理上下文`, `汇总需求`

**两种粒度**:

| 粒度 | 触发条件 | 输出 |
|------|----------|------|
| `Lite` | 需求明确、小任务 | 精简快照：Source Index + 需求摘要 + Open Questions |
| `Standard` | 需求复杂、多文档 | 完整分析：事实、约束、冲突、Open Questions |

**产出文件**: `mydocs/context/YYYY-MM-DD_<task>_context_bundle.md`

---

## 🔒 阶段 1: RESEARCH（研究分析）

**状态**: `[LOCKED]` - 禁止写代码

**入口命令**: `sdd_bootstrap` 或自动进入

### 核心任务

```
1. 复述对齐 ─ 用自己的话复述用户任务，确认核心目标一致
2. 事实收集 ─ 读取相关代码、理解现有实现、识别依赖
3. 风险识别 ─ 技术风险、业务风险、未知项
4. Spec落盘 ─ 尽快持久化最小Spec
```

### Zero/Fast模式最小Spec

```markdown
# Spec: <TaskName>

## Goal
- 核心目标: ...

## Done Contract
- 完成定义: ...
- 证明来源: ...

## Scope
- In: ...
- Out: ...

## Open Questions
- [ ] 待确认项

## Restated Understanding
- 我理解当前任务是: ...

## Checkpoint Summary  
- 当前进度: Research完成
- 下一步: 执行代码改动
- Execution Approval: Pending
```

### Standard/Deep模式标准Spec

```markdown
# Spec: <TaskName>

## 0. Open Questions
- [ ] 问题1

## 1. Requirements
- **Goal**: ...
- **In-Scope**: ...
- **Out-of-Scope**: ...

## 1.1 Context Sources
- Requirement Source: ...
- Codemap: ...

## 2. Research Findings
- 事实与约束: ...
- 风险与不确定项: ...

## 2.1 Next Actions
- [ ] 下一步动作1
- [ ] 下一步动作2
```

**产出文件**: `mydocs/specs/YYYY-MM-DD_hh-mm_<TaskName>.md`

### ⛔ STOP-AND-WAIT 检查点

完成Research后必须执行 STOP-AND-WAIT Protocol:

```
1. ACT: 完成Research分析
2. PERSIST: 立即保存Spec到磁盘
3. DISPLAY: 输出当前进度
4. BATCH CHECK: 列出待确认问题
5. STOP: 输出"[WAITING FOR COMMAND]"

═══════════════════════════════════════════════════

✅ Research 阶段完成
📄 Spec 已保存: mydocs/specs/2026-04-12_14-30_用户认证.md

📊 当前理解:
- 目标: 实现邮箱+验证码注册流程
- 范围: 注册API + 验证码服务
- 风险: 验证码有效期待确认

🚨 待确认问题:
1. 验证码过期时间设置为多少？(建议5分钟)
2. 是否需要支持短信验证码？

💡 下一步选项:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[A] 回复 "继续" → 进入 Plan 阶段
[B] 回复 "创新" → 进入 Innovate 阶段（多方案比较）
[C] 回复 "FAST" → 切换极速模式直接执行
[D] 回复问题编号 → 回答该问题
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 🔒 阶段 2: INNOVATE（创新设计）- Deep模式必选

**状态**: `[LOCKED]` - 禁止写代码

**触发条件**: 架构决策、多方案选择、复杂设计

### 核心任务

```
1. 方案对比 ─ 分析2-3个可行方案的Pros/Cons
2. 决策记录 ─ 选择方案并记录理由
3. 风险评估 ─ 每个方案的风险等级
```

### Spec更新

```markdown
## 3. Innovate

### Option A: 方案A名称
- **Pros**: ...
- **Cons**: ...
- **风险**: 低/中/高

### Option B: 方案B名称
- **Pros**: ...
- **Cons**: ...
- **风险**: 低/中/高

### Decision
- **Selected**: Option A
- **Why**: 理由
- **Risks**: 已知风险及缓解措施
```

### ⛔ STOP-AND-WAIT 检查点

```
═══════════════════════════════════════════════════

✅ Innovate 阶段完成
📊 方案对比已记录

🔄 方案比较:
┌─────────────┬──────────────────┬──────────────────┐
│             │ Option A (JWT)   │ Option B (Session)│
├─────────────┼──────────────────┼──────────────────┤
│ Pros        │ 可扩展、无状态    │ 简单、直观       │
│ Cons        │ 实现复杂         │ 占用服务端资源    │
│ 风险        │ 低              │ 中               │
└─────────────┴──────────────────┴──────────────────┘

✅ 已选择: Option A (JWT方案)

💡 下一步选项:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[A] 回复 "继续" → 进入 Plan 阶段
[B] 回复 "选择 B" → 切换为方案B
[C] 回复 "问题" → 针对某个方案提问
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 🔒 阶段 3: PLAN（详细规划）

**状态**: `[LOCKED]` - 禁止写代码

**核心原则**: 计划是契约，必须可执行、可验证

### 强制内容

```markdown
## 4. Plan

### 4.1 File Changes
- `path/to/file`: 变更说明

### 4.2 Signatures
- `function name(args): returnType` - 说明

### 4.3 Implementation Checklist
- [ ] 1. 第一步操作
- [ ] 2. 第二步操作
- [ ] 3. 第三步操作

### 4.4 Done Contract
- 完成定义: ...
- 证明来源: ...
```

### Zero/Fast模式micro-spec

```markdown
## Plan (micro)

### File
- `src/auth/login.ts`: 添加验证码校验

### Signature  
- `validateCode(email: string, code: string): boolean`

### Done Contract
- 完成: validateCode函数实现并通过测试
- 证明: `npm test auth.test.ts` 全通过
```

### ⛔ STOP-AND-WAIT 检查点

```
═══════════════════════════════════════════════════

✅ Plan 阶段完成
📋 执行计划已制定

📄 计划摘要:
┌─────────────────────────────────────────────────┐
│ 📁 修改文件: 3 个                               │
│    - src/auth/login.ts                         │
│    - src/auth/verify.ts                        │
│    - tests/auth/verify.test.ts                 │
│                                                 │
│ 🔧 新增签名: 2 个                               │
│    - validateCode(email, code): boolean        │
│    - generateCode(email): string               │
│                                                 │
│ 📝 执行步骤: 6 步                              │
└─────────────────────────────────────────────────┘

✅ Done Contract:
- 完成: 验证码功能实现并通过测试
- 证明: npm test 全通过 + 手动验证

💡 下一步选项:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[A] 回复 "批准" / "Plan Approved" → 进入 Execute 阶段
[B] 回复 "REVIEW SPEC" → 执行计划预审（建议性）
[C] 回复 "修改 + 具体内容" → 返回修改计划
[D] 回复 "全部" → 批准后批量执行（不暂停）
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 可选: Spec Review（计划预审）

**触发词**: `REVIEW SPEC`, `评审规格`

**输出**:

```markdown
### 4.5 Spec Review Notes
- **Spec Review Matrix**:
  | Check | Verdict | Evidence |
  |-------|---------|----------|
  | Requirement clarity | PASS | Goal明确 |
  | Plan executability | PASS | Checklist完整 |
  | Risk coverage | PARTIAL | 缺少回滚方案 |
- **Readiness Verdict**: GO / NO-GO (advisory)
- **Risks**: ...
```

---

## ✅ 阶段 4: EXECUTE（执行实现）

**状态**: `[ACTIVE]` - 可以写代码

**核心原则**: 严格按照Plan执行，Zero Deviation

### 执行策略

| 模式 | 触发词 | 行为 |
|------|--------|------|
| **Step-by-Step** | 默认 | 每步执行后暂停等待确认 |
| **Batch** | `全部`/`all`/`execute all` | 批量执行剩余所有步骤 |

### TDD铁律（Standard/Deep模式）

```
┌─────────────────────────────────────────────────┐
│           RED → GREEN → REFACTOR               │
│                                                 │
│  RED:    写失败测试                              │
│  GREEN:  写最小实现让测试通过                     │
│  REFACTOR: 重构（保持测试通过）                   │
└─────────────────────────────────────────────────┘

铁律: No Production Code Without Failing Test First
```

### 每步执行流程

```
1. 读取 ─ 读取当前Spec Checklist项
2. RED ─ 写失败测试（先测试模式）
3. GREEN ─ 写最小实现
4. VERIFY ─ 运行测试确认通过
5. REFACTOR ─（如需要）重构
6. SAVE ─ 保存文件
7. LOG ─ 更新Spec Execute Log
8. REPORT ─ 汇报进度
9. WAIT ─ [WAITING FOR COMMAND]
```

### Zero/Fast模式执行流程

```
1. 实现 ─ 直接编写代码
2. VERIFY ─ 运行测试/lint
3. SAVE ─ 保存文件
4. SYNC ─ 更新Spec（事后同步）
5. REPORT ─ 汇报完成
```

### 进度汇报格式

```
═══════════════════════════════════════════════════

🔄 执行进度: 3/6  ████████░░░░░░░░░  50%

✅ 已完成:
   [x] 1. 安装验证码依赖库 (jsonwebtoken)
   [x] 2. 实现 generateCode 函数
   [x] 3. 实现 validateCode 函数

⏳ 当前执行:
   [ ] 4. 集成验证码到登录流程

⏸️ 待开始:
   [ ] 5. 编写 validateCode 单元测试
   [ ] 6. 运行完整测试套件

📝 Execute Log:
- 2026-04-12 14:35: Step 1-3 completed

💡 下一步选项:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[A] 回复 "继续" → 执行步骤4
[B] 回复 "全部" → 批量执行步骤5-6
[C] 回复 "暂停" → 暂停执行，保存进度
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 错误处理

```
⚠️ 执行中发现Plan问题:

1. STOP ─ 立即停止执行
2. REPORT ─ 报告问题
   ┌─────────────────────────────────────────┐
   │ 问题: validateCode签名与现有接口冲突     │
   │ 影响: 需要修改3个调用点                   │
   │ 建议: 返回Plan修改签名或调整方案          │
   └─────────────────────────────────────────┘
3. WAIT ─ [WAITING FOR DECISION]

💡 选项:
[A] 返回Plan修改 ─ 返回Plan阶段重新制定
[B] 继续执行 ─ 忽略警告继续（需记录偏差）
[C] FAST修复 ─ 直接修复（事后同步Spec）
```

---

## 🔒 阶段 5: REVIEW（审查复盘）

**状态**: `[LOCKED]`

**触发词**: `REVIEW EXECUTE`, `代码评审`, `实现复盘`

### 三轴评审

| 轴 | 检查内容 | 通过标准 |
|----|----------|----------|
| **Axis-1** | Spec质量与需求达成 | Goal达成，Acceptance可验证 |
| **Axis-2** | Spec-代码一致性 | File/Signature/Behavior与Plan一致 |
| **Axis-3** | 代码内在质量 | 正确性、鲁棒性、可维护性、测试覆盖 |

### Evidence Before Claims铁律

```
⚠️ 铁律: NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE

错误示例:
❌ "测试通过了" (未运行)
❌ "应该没问题了" 
❌ "看起来正确"

正确示例:
✅ [Run: npm test] → 34/34 pass "所有测试通过"
✅ [Run: npm run lint] → 0 errors "Lint检查通过"
✅ [Manual: 访问 /api/login] → 200 OK "登录接口正常"
```

### Spec更新

```markdown
## 6. Review Verdict

### Review Matrix
| Axis | Key Checks | Verdict | Evidence |
|------|------------|---------|----------|
| Spec Quality | Goal达成 | PASS | §1 定义Goal已实现 |
| Spec-Code Fidelity | File/Signature一致 | PASS | diff确认 |
| Code Quality | 测试覆盖/安全 | PASS | 34/34 pass |

### Overall Verdict: PASS ✅

### Plan-Execution Diff
- 无偏差

### Validation Evidence
- Self-check: ✅
- Static checks (lint): ✅ 0 errors
- Tests: ✅ 34/34 pass
- Manual verification: ✅ 完成

### Regression Risk
- Low
```

### ⛔ STOP-AND-WAIT 检查点

```
═══════════════════════════════════════════════════

✅ Review 阶段完成

📊 Review Matrix:
┌─────────────┬────────────────────┬──────────┐
│ Axis        │ Key Checks          │ Verdict  │
├─────────────┼────────────────────┼──────────┤
│ Spec Quality│ Goal达成            │ ✅ PASS  │
│ Spec-Code   │ 文件/签名一致        │ ✅ PASS  │
│ Code Quality│ 测试/安全/可维护     │ ✅ PASS  │
└─────────────┴────────────────────┴──────────┘

📋 Validation Evidence:
- Self-check: ✅ 通过
- Lint: ✅ 0 errors
- Tests: ✅ 34/34 pass
- Manual: ✅ 验证码功能正常

✅ Overall Verdict: PASS

💡 下一步选项:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[A] 回复 "完成" → 任务收口，可选Archive
[B] 回复 "ARCHIVE" → 执行知识沉淀
[C] 回复 "继续" → 继续其他任务
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 📦 阶段 6: ARCHIVE（知识沉淀）- Deep模式推荐

**触发词**: `ARCHIVE`, `归档`, `沉淀`

### 输出

```markdown
# Archive: <Topic>

## Source Index
- Spec: mydocs/specs/2026-04-12_用户认证.md
- Codemap: mydocs/codemap/2026-04-12_认证模块.md

## Human Version (汇报用)
### 目标
- 实现邮箱+验证码注册流程

### 决策
- 选择JWT方案（无状态、可扩展）

### 风险
- 验证码有效期需监控

### 结果
- 完成，34个测试通过

## LLM Version (复用用)
### 约束
- Token有效期: 24小时
- 验证码有效期: 5分钟

### 接口
- validateCode(email, code): boolean
- generateToken(payload): string

### 代码touch点
- src/auth/*.ts
- tests/auth/*.test.ts

### Anti-patterns
- 不要在token中存储敏感信息
```

**产出文件**:
- `mydocs/archive/YYYY-MM-DD_hh-mm_<topic>_human.md`
- `mydocs/archive/YYYY-MM-DD_hh-mm_<topic>_llm.md`

---

## 🐛 DEBUG 模式（按需触发）

**触发词**: `DEBUG`, `排查`, `日志分析`

### 四阶段调试法

```
┌─────────────────────────────────────────────────────────────────┐
│                    系统化调试流程                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Phase 1: 根因调查 ──────────────────────────────────────►      │
│  ├── 仔细阅读错误信息                                           │
│  ├── 稳定复现问题                                               │
│  ├── 检查最近变更                                               │
│  └── 追踪数据流（按 root-cause-tracing.md）                    │
│                                                                 │
│  Phase 2: 模式分析 ──────────────────────────────────────►      │
│  ├── 找相似工作代码                                             │
│  ├── 对比差异                                                   │
│  └── 理解依赖                                                   │
│                                                                 │
│  Phase 3: 假设验证 ──────────────────────────────────────►      │
│  ├── 形成单一假设                                               │
│  ├── 最小化测试验证                                             │
│  └── 成功? → Phase 4; 失败? → 新假设                            │
│                                                                 │
│  Phase 4: 修复实现                                              │
│  ├── 创建失败测试（先TDD）                                       │
│  ├── 单点修复根因                                               │
│  └── 验证修复 + 无回归                                          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

⚠️ 铁律: 3次修复失败 → 质疑架构（不是继续修复）
```

### Diagnosis vs Verification

| 模式 | 触发 | 输入 | 输出 |
|------|------|------|------|
| **Diagnosis** | `DEBUG + issue描述` | log_path + issue | 根因分析报告 |
| **Verification** | `验证功能 + spec` | log_path + spec | Spec逐条验证结果 |

---

## 🤖 SUBAGENT 模式（Deep模式可选）

**触发词**: `SUBAGENT`, `并行执行`

### 执行流程

```
1. READ PLAN ─ 读取完整Plan文件
2. EXTRACT TASKS ─ 提取所有任务及其完整上下文
3. CREATE TODO ─ 创建TodoWrite追踪所有任务

循环（每个任务）:
   ┌─────────────────────────────────────┐
   │ dispatch Implementer Subagent       │ ← 完整任务文本+上下文
   │     ↓ (如有问题)                    │
   │ 回答问题 → 重新派遣                   │
   │     ↓ (完成)                        │
   │ dispatch Spec Reviewer Subagent      │ ← 检查Spec合规性
   │     ↓ (有问题)                       │
   │ Implementer修复 → 重新Review         │
   │     ↓ (通过)                         │
   │ dispatch Code Quality Reviewer       │ ← 检查代码质量
   │     ↓ (有问题)                       │
   │ Implementer修复 → 重新Review         │
   │     ↓ (通过)                         │
   │ 标记任务完成                         │
   └─────────────────────────────────────┘

4. FINAL REVIEW ─ 全局代码评审
5. FINISH ─ 使用 finishing-a-development-branch
```

### 模型选择策略

| 任务类型 | 模型选择 | 理由 |
|----------|----------|------|
| 机械实现（1-2文件，清晰Spec） | 快速/便宜模型 | 大多数实现任务都是机械性的 |
| 集成任务（多文件、协调） | 标准模型 | 需要判断力 |
| 架构/设计/评审 | 最强模型 | 高复杂度高风险 |

### 处理Subagent状态

| 状态 | 含义 | 处理 |
|------|------|------|
| **DONE** | 完成 | 进入Spec Review |
| **DONE_WITH_CONCERNS** | 完成但有疑虑 | 评估疑虑是否需要解决 |
| **NEEDS_CONTEXT** | 需要上下文 | 提供缺失信息，重新派遣 |
| **BLOCKED** | 无法完成 | 评估原因，增加能力/拆分/上报 |

---

## 📋 命令速查表

### 模式切换

| 命令 | 作用 | 模式 |
|------|------|------|
| `>>` | 零Spec极速执行 | Zero |
| `FAST`/`快速` | 快速执行+同步Spec | Fast |
| 无前缀 | 标准工作流 | Standard |
| `deep`/`深度` | 完整流程+Archive | Deep |

### 阶段控制

| 命令 | 作用 |
|------|------|
| `继续`/`下一步` | 执行下一步骤 |
| `全部`/`all` | 批量执行剩余步骤 |
| `暂停` | 暂停执行，保存进度 |
| `批准`/`Plan Approved` | 批准计划进入执行 |
| `EXIT`/`退出` | 退出工作流协议 |

### 辅助功能

| 命令 | 作用 |
|------|------|
| `MAP: scope=<范围>` | 生成功能级代码地图 |
| `PROJECT MAP` | 生成项目架构总图 |
| `build_context_bundle` | 汇总需求上下文 |
| `REVIEW SPEC` | 计划预审（建议性） |
| `REVIEW EXECUTE` | 执行后三轴评审 |
| `ARCHIVE` | 知识沉淀 |
| `DEBUG` | 启动调试模式 |
| `SUBAGENT` | 启用子代理模式 |
| `TDD` | 强调测试驱动开发 |
| `验证功能` | 全链路日志vs Spec验证 |

### 多项目协作

| 命令 | 作用 |
|------|------|
| `MULTI`/`多项目` | 多项目模式（自动发现） |
| `CROSS`/`跨项目` | 允许跨项目改动 |
| `SWITCH <id>` | 切换活跃项目 |
| `REGISTRY` | 显示项目注册表 |
| `SCOPE LOCAL` | 回到本地作用域 |

---

## 📁 文件结构约定

```
mydocs/
├── specs/                              # Spec文件
│   └── YYYY-MM-DD_hh-mm_<TaskName>.md
├── codemap/                            # 代码地图
│   ├── YYYY-MM-DD_hh-mm_<feature>功能.md
│   └── YYYY-MM-DD_hh-mm_<project>项目总图.md
├── context/                            # 需求汇总
│   └── YYYY-MM-DD_hh-mm_<task>_context_bundle.md
├── archive/                            # 知识沉淀
│   ├── YYYY-MM-DD_hh-mm_<topic>_human.md
│   └── YYYY-MM-DD_hh-mm_<topic>_llm.md
├── micro_specs/                        # 微Spec（Fast模式）
│   └── YYYY-MM-DD_hh-mm_<TaskName>.md
└── plans/                              # 执行计划
    └── YYYY-MM-DD-<feature-name>.md
```

---

## 📝 示例对话

### 示例1: Zero/Fast模式

**用户**: `>> 把登录按钮的颜色从蓝色改成绿色`

**AI**:
```
🚀 极速模式 [Zero]

✅ 已完成:
- 修改 src/components/LoginButton.tsx:42
- 将 background-color: blue → green

📝 Execute Log:
- 2026-04-12 15:00: 一句话同步Spec

💡 [完成] - 如需其他修改请继续描述
```

---

### 示例2: Standard模式

**用户**: `sdd_bootstrap: task=实现图片上传功能, goal=支持拖拽上传到OSS`

**AI**:
```
🔄 SIGMA WORKFLOW 启动
📊 模式: Standard（自动评估）

🔒 [LOCKED] 进入 RESEARCH 阶段

[分析需求，理解现有代码结构...]
[创建Spec并保存到 mydocs/specs/2026-04-12_15-05_图片上传.md]

═══════════════════════════════════════════════════

✅ Research 阶段完成
📄 Spec 已保存: mydocs/specs/2026-04-12_15-05_图片上传.md

📊 当前理解:
- 目标: 实现拖拽上传图片到OSS
- 范围: 前端组件 + OSS SDK集成
- 风险: OSS配置安全性

🚨 待确认问题:
1. 使用哪个OSS服务？（阿里云/腾讯云/S3）

💡 下一步选项:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[A] 回复 "继续" → 进入 Plan 阶段
[B] 回复 "使用阿里云OSS" → 回答问题后继续
[C] 回复 "FAST" → 切换极速模式
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**用户**: `使用阿里云OSS`

**AI**:
```
📝 已确认: 使用阿里云OSS

🔒 [LOCKED] 进入 PLAN 阶段

[分析代码结构，制定详细计划...]
[更新Spec: 添加File Changes/Signatures/Checklist]

═══════════════════════════════════════════════════

✅ Plan 阶段完成
📋 执行计划已制定

📄 计划摘要:
┌─────────────────────────────────────────────────┐
│ 📁 修改文件: 4 个                               │
│    - src/components/ImageUploader.tsx           │
│    - src/services/oss.ts                       │
│    - src/hooks/useUpload.ts                    │
│    - tests/oss.test.ts                         │
│                                                 │
│ 🔧 新增签名: 2 个                               │
│    - uploadToOSS(file): Promise<string>        │
│    - validateImage(file): boolean               │
│                                                 │
│ 📝 执行步骤: 6 步                              │
│    1. 安装阿里云OSS SDK                         │
│    2. 实现 uploadToOSS 函数                    │
│    3. 实现 validateImage 函数                  │
│    4. 创建 ImageUploader 组件                   │
│    5. 编写单元测试                              │
│    6. 集成测试                                  │
└─────────────────────────────────────────────────┘

✅ Done Contract:
- 完成: 图片上传功能实现并通过测试
- 证明: npm test 全通过 + 手动拖拽测试

💡 下一步选项:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[A] 回复 "批准" → 进入 Execute 阶段
[B] 回复 "REVIEW SPEC" → 执行计划预审
[C] 回复 "修改 + 内容" → 修改计划
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**用户**: `批准`

**AI**:
```
✅ [ACTIVE] 进入 EXECUTE 阶段

🔄 执行进度: 0/6  ░░░░░░░░░░░░░░░░░  0%

⏳ 当前执行:
   [ ] 1. 安装阿里云OSS SDK

💡 回复 "继续" 开始执行步骤1
```

**用户**: `继续`

**AI**:
```
🔄 执行进度: 1/6  █░░░░░░░░░░░░░░░░  17%

✅ 已完成:
   [x] 1. 安装阿里云OSS SDK
       - 执行: npm install ali-oss
       - 验证: package.json 已添加

⏳ 当前执行:
   [ ] 2. 实现 uploadToOSS 函数

💡 下一步选项:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[A] 回复 "继续" → 执行步骤2
[B] 回复 "全部" → 批量执行步骤2-6
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## ✅ 自检清单

### 阶段检查

- [ ] **Research**: 是否理解了核心目标？是否有Open Questions？
- [ ] **Plan**: Checklist是否原子化？Signature是否精确？
- [ ] **Execute**: 是否遵循TDD？每步是否验证？
- [ ] **Review**: 是否运行了验证命令？Evidence是否充分？

### 铁律检查

- [ ] Zero/Fast模式外是否都有Spec？
- [ ] Spec是否在LOCKED阶段后更新？
- [ ] 是否在关键节点执行了STOP-AND-WAIT？
- [ ] 是否先验证再声称通过？
- [ ] Debug是否先找根因再修复？

### 用户体验检查

- [ ] 每步是否给出了清晰的下一步提示？
- [ ] 是否按渐进式披露信息？
- [ ] 是否提供了明确的选项供用户选择？
- [ ] 是否说明了当前进度和状态？

---

## 🎓 设计原则总结

### 1. 智能选型
- 自动评估任务复杂度
- 选择合适的深度模式
- 平衡速度与质量

### 2. Spec为真
- Spec是持久化真相源
- 任何变更先更新Spec
- Chat历史可衰减，Spec持久

### 3. Checkpoint驱动
- 关键节点暂停等待确认
- 提供明确的下一步选项
- 用户主导工作流节奏

### 4. Evidence优先
- 未运行验证命令不声称通过
- 测试失败先TDD再实现
- 根因调查先于修复

### 5. 渐进式披露
- 按需加载信息
- 分阶段展示内容
- 不一次性展示全部

### 6. 可反馈闭环
- 每步完成提供反馈
- 清晰的下一步提示
- 多种用户选择路径

---

**版本**: v2.0
**更新**: 2026-04-12
**融合自**: SDD-RIPER + Checkpoint-Driver + Superpowers
