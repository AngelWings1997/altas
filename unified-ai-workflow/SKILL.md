---
name: unified-ai-workflow
description: 统一 AI 工作流程规范 - 集合 Spec驱动、Checkpoint驱动、Subagent驱动三方优势，兼顾速度和质量
---

# Unified AI Workflow (统一 AI 工作流程)

> **集合 Spec驱动 + Checkpoint驱动 + Subagent驱动三方优势，兼顾速度与质量**

---

## 🎯 核心理念

```
Spec is Truth + Checkpoint Gates + Progressive Disclosure + Quality First
```

| 铁律 | 来源 | 含义 |
|------|------|------|
| **No Spec, No Code** | Spec驱动 | 未形成 Spec 不写代码（FAST 模式除外） |
| **Checkpoint Gates** | Checkpoint驱动 | 关键节点必须暂停等待确认 |
| **Evidence before Claims** | Subagent驱动 | 验证在前，断言在后 |
| **No Fixes Without Root Cause** | Subagent驱动 | 未找到根因不修复 |
| **Reverse Sync** | Spec驱动 | 执行后发现偏差先更新 Spec 再修复代码 |
| **Fresh Context Per Task** | Subagent驱动 | 每个任务使用独立上下文 |

---

## 🚀 快速开始

### 1. 极速模式 (Zero/Fast) - 2分钟任务

**适用场景**: 单文件修改、配置调整、文案修改、简单 Bug 修复

```text
>> 修复登录页面的错别字
>> 将超时时间从 30 秒改为 60 秒
>> 添加一个 console.log 用于调试
```

**特点**:
- 跳过 Research/Plan，直接执行
- 执行后自动同步 Spec
- 适合 < 5 行代码的改动

---

### 2. 标准模式 (Standard) - 30分钟任务

**适用场景**: 功能开发、模块重构、接口修改

```text
启动标准工作流：
- task: 用户认证功能重构
- goal: 从 Session 迁移到 JWT 方案
- scope: src/auth/*
```

**完整流程**:
```
Research → Plan → Execute → Review
```

---

### 3. 深度模式 (Deep) - 2小时+ 任务

**适用场景**: 架构改造、复杂功能、多项目协作

```text
启动深度工作流：
- task: 微服务架构拆分
- goal: 从单体拆分为 3 个独立服务
- projects: [api-service, web-console, admin-portal]
```

**完整流程**:
```
Research → Innovate → Plan → [Spec Review] → Execute → Review → Archive
```

---

## 📊 项目大小评估与模式选择

| 评估维度 | 极速模式 | 标准模式 | 深度模式 |
|----------|----------|----------|----------|
| **代码行数** | < 50 行 | 50-500 行 | > 500 行 |
| **文件数** | 1-2 个 | 3-10 个 | > 10 个 |
| **模块跨越** | 单一模块 | 2-3 个模块 | 多模块/跨项目 |
| **架构影响** | 无 | 局部 | 全局 |
| **风险等级** | 低 | 中 | 高 |
| **预估时间** | < 10 分钟 | 10-60 分钟 | > 60 分钟 |

### 自动评估逻辑

```
IF 触发词包含 ">>" OR "FAST" OR "快速"
  → 极速模式
ELSE IF 明确指定 "deep" OR "深度" OR "复杂"
  → 深度模式
ELSE IF 涉及多项目 OR 架构改造 OR 预估 > 1 小时
  → 深度模式
ELSE
  → 标准模式（默认）
```

---

## 🔄 工作流阶段详解

### 阶段总览

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
├─────────────┼─────────────┼─────────────┼─────────────┼─────────────────────┤
│ 产出:       │ 产出:       │ 产出:       │ 产出:       │ 产出:               │
│ 代码地图     │ Spec 初稿   │ 执行计划     │ 实现代码     │ Review Report       │
│ 需求汇总     │ STOP-WAIT   │ STOP-WAIT   │ 测试用例     │ Archive (可选)      │
└─────────────┴─────────────┴─────────────┴─────────────┴─────────────────────┘
```

---

## 🔒 阶段 0: PRE-RESEARCH（预研准备）

**状态**: `[OPTIONAL]`

**触发条件**:
- 复杂任务需要代码地图
- 需求文档分散需要汇总
- 用户明确要求

### 0.1 CodeMap（代码地图）

**触发词**: `MAP`, `Code Map`, `链路梳理`, `PROJECT MAP`, `全局地图`

**两种模式**:

| 模式 | 适用场景 | 输出 |
|------|----------|------|
| `feature` | 单个功能/接口 | 功能级代码地图 |
| `project` | 整个项目 | 项目架构总图 |

**命令示例**:
```text
MAP: scope=用户认证模块, mode=feature
PROJECT MAP: scope=整个后端服务
```

**产出位置**: `mydocs/codemap/YYYY-MM-DD_hh-mm_<name>.md`

### 0.2 Context Bundle（需求汇总）

**触发词**: `build_context_bundle`, `整理上下文`, `汇总需求`

**两种粒度**:

| 粒度 | 适用场景 | 输出 |
|------|----------|------|
| `Lite` | 需求明确/小任务 | 精简版需求快照 |
| `Standard` | 需求复杂/多文档 | 完整需求分析 |

**命令示例**:
```text
build_context_bundle: ./docs/requirements, level=Standard
```

**产出位置**: `mydocs/context/YYYY-MM-DD_hh-mm_<task>_context_bundle.md`

---

## 🔒 阶段 1: RESEARCH（研究分析）

**状态**: `[LOCKED]` - 禁止写代码

**入口命令**: `sdd_bootstrap` 或自动进入

### 核心任务

1. **需求理解**
   - 明确 Goal（目标）
   - 界定 In-Scope（范围内）
   - 界定 Out-of-Scope（范围外）

2. **现状分析**
   - 读取相关代码
   - 理解现有实现
   - 识别依赖关系

3. **风险识别**
   - 技术风险
   - 业务风险
   - 时间风险

### 产出要求

创建 `The Spec File`:
```markdown
# Spec: <任务名称>

## 0. Open Questions
- [ ] 待确认问题 1
- [ ] 待确认问题 2

## 1. Requirements
- **Goal**: ...
- **In-Scope**: ...
- **Out-of-Scope**: ...

## 1.1 Context Sources
- Requirement Source: ...
- Code References: ...

## 2. Research Findings
- 现状: ...
- 约束: ...
- 风险: ...

## 2.1 Next Actions
- [ ] 下一步动作
```

**产出位置**: `mydocs/specs/YYYY-MM-DD_hh-mm_<TaskName>.md`

### ⛔ STOP-AND-WAIT 检查点

完成 Research 后必须:
1. **保存 Spec 文件**
2. **显示当前进度**
3. **列出待确认问题**（如有）
4. **等待用户指令**

**下一步提示**:
```
✅ Research 阶段完成
📄 Spec 已保存至: mydocs/specs/2026-04-12_10-30_用户认证重构.md

🚨 待确认问题:
1. JWT 过期时间设置为多少？
2. 是否需要支持 Refresh Token？

💡 下一步可选:
- 回复 "继续" → 进入 Plan 阶段
- 回复 "创新" → 进入 Innovate 阶段（复杂任务）
- 回复 "FAST" → 切换到极速模式
```

---

## 🔒 阶段 2: INNOVATE（创新设计）- 可选

**状态**: `[LOCKED]` - 禁止写代码

**触发条件**:
- 复杂架构决策
- 多方案选择
- 用户明确要求

### 核心任务

1. **方案对比**
   - 方案 A: Pros / Cons
   - 方案 B: Pros / Cons
   - 方案 C: Pros / Cons（如需要）

2. **决策记录**
   - 选择哪个方案
   - 决策理由

### 产出要求

更新 Spec:
```markdown
## 3. Innovate

### Option A: 方案一名称
- **Pros**: ...
- **Cons**: ...

### Option B: 方案二名称
- **Pros**: ...
- **Cons**: ...

### Decision
- **Selected**: Option A
- **Why**: ...
```

### ⛔ STOP-AND-WAIT 检查点

**下一步提示**:
```
✅ Innovate 阶段完成
📊 方案对比已记录

💡 下一步:
- 回复 "继续" → 进入 Plan 阶段
- 回复 "选择 B" → 修改决策为方案 B
```

---

## 🔒 阶段 3: PLAN（详细规划）

**状态**: `[LOCKED]` - 禁止写代码

**核心原则**: 计划是契约，必须可执行、可验证

### 强制内容

1. **File Changes**（文件变更清单）
   ```markdown
   ### 4.1 File Changes
   - `src/auth/jwt.ts`: 新增 JWT 生成和验证函数
   - `src/auth/middleware.ts`: 修改认证中间件
   - `tests/auth/jwt.test.ts`: 新增单元测试
   ```

2. **Signatures**（接口签名）
   ```markdown
   ### 4.2 Signatures
   - `function generateToken(payload: UserPayload, expiresIn: string): string`
   - `function verifyToken(token: string): UserPayload`
   ```

3. **Implementation Checklist**（执行清单）
   ```markdown
   ### 4.3 Implementation Checklist
   - [ ] 1. 安装 JWT 依赖库
   - [ ] 2. 实现 generateToken 函数
   - [ ] 3. 实现 verifyToken 函数
   - [ ] 4. 更新认证中间件
   - [ ] 5. 编写单元测试
   - [ ] 6. 运行测试并修复问题
   ```

### 可选：Spec Review（计划预审）

**触发词**: `REVIEW SPEC`, `评审规格`, `计划评审`

**输出**:
```markdown
### 4.4 Spec Review Notes
- **Spec Review Matrix**:
  | Check | Verdict | Evidence |
  |-------|---------|----------|
  | Requirement clarity | PASS | Goal 明确 |
  | Plan executability | PASS | File Changes 完整 |
  | Risk coverage | PARTIAL | 缺少回滚方案 |
- **Readiness Verdict**: GO (建议性)
- **Risks**: ...
```

### ⛔ STOP-AND-WAIT 检查点

**下一步提示**:
```
✅ Plan 阶段完成
📋 执行计划已制定

📄 计划摘要:
- 修改文件: 3 个
- 新增文件: 2 个
- 预计步骤: 6 步

💡 下一步:
- 回复 "批准" / "Plan Approved" → 进入 Execute 阶段
- 回复 "REVIEW SPEC" → 执行计划预审
- 回复 "修改" → 返回修改计划
```

---

## ✅ 阶段 4: EXECUTE（执行实现）

**状态**: `[ACTIVE]` - 可以写代码

**核心原则**: 严格按照 Plan 执行，零偏差

### 执行策略

| 模式 | 触发词 | 适用场景 |
|------|--------|----------|
| **Step-by-Step** | 默认 | 关键路径、复杂逻辑 |
| **Batch** | `全部`, `all`, `execute all` | 简单任务、时间紧迫 |

### 每步执行流程

```
1. 读取当前 Checklist 项
2. 实现代码（遵循 TDD: 先写测试，再写实现）
3. 验证（运行测试）
4. 保存文件
5. 更新 Spec Execute Log
6. 汇报进度
```

### TDD 要求

**铁律**: No Production Code Without Failing Test First

```
RED → GREEN → REFACTOR
```

1. **RED**: 写失败测试
2. **GREEN**: 写最小实现让测试通过
3. **REFACTOR**: 重构代码（保持测试通过）

### 进度汇报格式

```
🔄 执行进度: 3/6
✅ 已完成:
  - [x] 1. 安装 JWT 依赖库
  - [x] 2. 实现 generateToken 函数
  - [x] 3. 实现 verifyToken 函数
⏳ 当前:
  - [ ] 4. 更新认证中间件
⏸️ 待开始:
  - [ ] 5. 编写单元测试
  - [ ] 6. 运行测试并修复问题

💡 下一步:
- 回复 "继续" → 执行下一步
- 回复 "全部" → 批量执行剩余步骤
- 回复 "暂停" → 暂停执行
```

### 错误处理

如果发现 Plan 有问题:
1. **STOP** - 立即停止执行
2. **REPORT** - 报告问题
3. **RETURN** - 返回 Plan 阶段修正

---

## 🔒 阶段 5: REVIEW（审查复盘）

**状态**: `[LOCKED]`

**触发词**: `REVIEW EXECUTE`, `代码评审`, `实现复盘`

### 三轴评审

| 轴 | 检查内容 | 通过标准 |
|----|----------|----------|
| **Axis-1** | Spec 质量与需求达成 | Goal 达成，Acceptance 可验证 |
| **Axis-2** | Spec-代码一致性 | File/Signature/Behavior 与 Plan 一致 |
| **Axis-3** | 代码内在质量 | 正确性、鲁棒性、可维护性、测试覆盖 |

### 产出要求

更新 Spec:
```markdown
## 6. Review Verdict

### Review Matrix
| Axis | Key Checks | Verdict | Evidence |
|------|------------|---------|----------|
| Spec Quality | Goal/In-Scope/Acceptance | PASS | §1 Requirements |
| Spec-Code Fidelity | File/Signature/Checklist | PASS | diff + code refs |
| Code Quality | Correctness/Robustness/Tests | PASS | test/lint |

### Overall Verdict: PASS

### Blocking Issues
- None

### Plan-Execution Diff
- 无偏差

### Regression Risk
- Low
```

### 评审结果处理

| 结果 | 处理 |
|------|------|
| **PASS** | 任务完成，可进入 Archive |
| **PARTIAL** | 修复问题后重新评审 |
| **FAIL** | 返回 Research/Plan 重新闭环 |

---

## 📦 阶段 6: ARCHIVE（知识沉淀）- 可选

**触发词**: `ARCHIVE`, `归档`, `沉淀`

**目的**: 将中间产物转化为可复用知识资产

### 输出

1. **Human 版本**: 汇报用，侧重决策和结果
2. **LLM 版本**: 复用用，侧重约束和接口

**产出位置**:
- `mydocs/archive/YYYY-MM-DD_hh-mm_<topic>_human.md`
- `mydocs/archive/YYYY-MM-DD_hh-mm_<topic>_llm.md`

---

## 🐛 DEBUG 模式（系统调试）

**触发词**: `DEBUG`, `排查`, `日志分析`

**适用场景**: Bug 修复、问题排查、测试失败

### 四阶段调试法

| 阶段 | 任务 | 产出 |
|------|------|------|
| **Phase 1** | 读日志 + 复现 + 查变更 + 追踪数据流 | 根因假设 |
| **Phase 2** | 找相似代码 + 比较差异 + 理解依赖 | 差异分析 |
| **Phase 3** | 形成假设 + 最小化测试 | 验证假设 |
| **Phase 4** | 创建失败测试 + 单点修复 + 验证 | 修复 + 测试 |

**铁律**: 3+ 修复失败 → 质疑架构

---

## 🤖 SUBAGENT 模式（子代理派遣）

**触发词**: `SUBAGENT`, `派遣`, `并行执行`

**适用场景**: 多独立任务并行执行

### 执行流程

```
读取 Plan → 提取所有任务 → 创建 TodoWrite → 
循环:
  派遣 Implementer Subagent → 
  派遣 Spec Reviewer → 
  派遣 Code Quality Reviewer → 
  标记完成
→ 最终评审 → 完成
```

### 三种 Subagent

| Subagent | 职责 | 模型选择 |
|----------|------|----------|
| **Implementer** | 实现任务 | 根据复杂度选择 |
| **Spec Reviewer** | 检查 Spec 合规性 | 标准模型 |
| **Code Quality Reviewer** | 检查代码质量 | 最强模型 |

---

## 📋 命令速查表

### 模式切换

| 命令 | 作用 |
|------|------|
| `>>` / `FAST` / `快速` | 极速模式 |
| `启动标准工作流` | 标准模式 |
| `启动深度工作流` | 深度模式 |
| `EXIT` / `退出` | 退出工作流 |

### 阶段控制

| 命令 | 作用 |
|------|------|
| `继续` / `下一步` | 执行下一步 |
| `全部` / `all` | 批量执行 |
| `暂停` | 暂停执行 |
| `批准` / `Plan Approved` | 批准计划进入执行 |

### 辅助功能

| 命令 | 作用 |
|------|------|
| `MAP` | 生成代码地图 |
| `PROJECT MAP` | 生成项目总图 |
| `build_context_bundle` | 汇总需求上下文 |
| `REVIEW SPEC` | 计划预审 |
| `REVIEW EXECUTE` | 执行后评审 |
| `ARCHIVE` | 知识沉淀 |
| `DEBUG` | 启动调试模式 |
| `SUBAGENT` | 启用子代理模式 |
| `TDD` | 强调 TDD 模式 |

---

## 📁 文件结构约定

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

## 🎓 最佳实践

### 1. 渐进式披露

- 不要一次性展示所有内容
- 按阶段逐步展开
- 按需加载信息

### 2. 明确进度指示

- 每步完成后汇报进度
- 使用进度条或计数
- 清晰标识已完成/进行中/待开始

### 3. 用户控制点

- 关键决策点必须暂停
- 提供清晰的选项
- 尊重用户选择

### 4. 质量门禁

- 严格执行 Review
- 不绕过 Checkpoint
- 发现问题立即返回

---

## 📝 示例对话

### 示例 1: 极速模式

**用户**: `>> 把登录按钮的颜色从蓝色改成绿色`

**AI**:
```
🚀 极速模式启动

✅ 已完成:
- 修改 src/components/LoginButton.tsx
- 将 background-color 从 blue 改为 green

📄 变更:
```diff
- background-color: blue;
+ background-color: green;
```

💡 任务完成！
```

---

### 示例 2: 标准模式

**用户**: `启动标准工作流：实现用户注册功能`

**AI**:
```
🔄 UNIFIED AI WORKFLOW 启动
📊 模式: 标准模式

🔒 [LOCKED] 进入 RESEARCH 阶段

正在分析需求...
...

✅ Research 阶段完成
📄 Spec 已保存至: mydocs/specs/2026-04-12_10-30_用户注册功能.md

💡 下一步:
- 回复 "继续" → 进入 Plan 阶段
```

**用户**: `继续`

**AI**:
```
🔒 [LOCKED] 进入 PLAN 阶段

正在制定执行计划...
...

✅ Plan 阶段完成
📋 执行计划已制定

📄 计划摘要:
- 修改文件: 2 个
- 新增文件: 3 个
- 预计步骤: 8 步

💡 下一步:
- 回复 "批准" → 进入 Execute 阶段
```

**用户**: `批准`

**AI**:
```
✅ [ACTIVE] 进入 EXECUTE 阶段

🔄 执行进度: 1/8
⏳ 当前: 安装依赖库
...

✅ 步骤 1 完成
💡 回复 "继续" 执行下一步，或 "全部" 批量执行
```

---

### 示例 3: 深度模式

**用户**: `启动深度工作流：重构支付模块`

**AI**:
```
🔄 UNIFIED AI WORKFLOW 启动
📊 模式: 深度模式

🔒 [LOCKED] 进入 RESEARCH 阶段

检测到复杂任务，建议生成代码地图...
...

✅ Research 阶段完成
📄 Spec 已保存

🚨 发现架构决策点:
1. 是否引入事件驱动架构？
2. 如何处理分布式事务？

💡 下一步:
- 回复 "创新" → 进入 Innovate 阶段进行方案对比
- 回复 "继续" → 跳过 Innovate 进入 Plan
```

---

## ✅ 自检清单

- [ ] 是否根据任务大小选择了合适的模式？
- [ ] 是否在 LOCKED 阶段写了代码？
- [ ] 是否在关键节点执行了 STOP-AND-WAIT？
- [ ] 是否给出了清晰的下一步提示？
- [ ] 是否按渐进式披露原则展示信息？
- [ ] 是否提供了快速启动命令？
- [ ] 是否在执行后进行了 Review？
- [ ] 是否同步更新了 Spec？

---

**版本**: v1.0  
**更新**: 2026-04-12
