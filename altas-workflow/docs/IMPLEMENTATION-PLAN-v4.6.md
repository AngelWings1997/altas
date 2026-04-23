# ALTAS Workflow v4.6 实施方案

> **目标版本**: v4.5 → v4.6
> **制定时间**: 2026-04-17
> **范围**: SDD+TDD 融合工作流的 10 项改进

---

## 方案总览

| # | 方案 | 优先级 | 涉及文件 | 预计改动量 | 风险 |
|---|------|--------|----------|------------|------|
| 1 | TDD 与 Spec-First 执行冲突对齐 | 高 | SKILL.md, spec-template.md, TDD SKILL.md | 3 文件小改 | 低 |
| 2 | Spec 模板增加 Test Strategy 章节 | 高 | spec-template.md, SKILL.md | 2 文件小改 | 低 |
| 3 | 检查点强制暂停约束增强 | 高 | SKILL.md, sdd-riper-one-protocol.md | 2 文件小改 | 中 |
| 4 | 规模再评估机制 | 中 | SKILL.md | 1 文件小改 | 低 |
| 5 | 多项目冲突解决协议 | 中 | sdd-riper-one-protocol.md (新增章节) | 1 文件中改 | 低 |
| 6 | 关闭 SKILL-entry-review 高价值遗留项 | 中 | SKILL.md, SKILL-entry-review.md | 2 文件小改 | 低 |
| 7 | 协议选择指引 (RIPER-5 vs SDD-RIPER-ONE) | 低 | protocols/PROTOCOL-SELECTION.md (新) | 1 文件新增 | 低 |
| 8 | Spec 质量度量标准 | 低 | references/superpowers/requesting-code-review/spec-quality-metrics.md (新) | 1 文件新增 | 低 |
| 9 | Batch Override 失败回滚点定义 | 低 | sdd-riper-one-protocol.md | 1 文件小改 | 低 |
| 10 | scaffold.py 脚手架脚本 | 低 | scripts/scaffold.py (新) | 1 文件新增 | 低 |

---

## 方案 1: TDD 与 Spec-First 执行冲突对齐 🔴

### 问题

[references/superpowers/test-driven-development/SKILL.md](../references/superpowers/test-driven-development/SKILL.md#L37-L46) 要求"写了实现代码的先删掉从头来"，但 [SDD-RIPER-ONE](../references/spec-driven-development/sdd-riper-one-protocol.md#L134-L157) 在 PLAN 阶段已定义了精确的签名和实现细节。当 Plan 已经足够精确时，TDD 的"删掉重写"变成多余的仪式。

### 改动

#### 1.1 SKILL.md → EXECUTE 章节

**当前** ([SKILL.md:393-398](../SKILL.md#L393-L398)):
```markdown
### EXECUTE

- `XS`: 直接执行
- `S`: micro-spec 后执行
- `M/L`: TDD，优先单项循环；`全部` / `all` 仅在用户明确授权时使用
- 读取 `references/superpowers/test-driven-development/SKILL.md`；`L` 可追加 `references/superpowers/subagent-driven-development/SKILL.md`
```

**改为**:
```markdown
### EXECUTE

- `XS`: 直接执行
- `S`: micro-spec 后执行
- `M/L`: TDD 执行（见下方 TDD 适配规则）
- 读取 `references/superpowers/test-driven-development/SKILL.md`；`L` 可追加 `references/superpowers/subagent-driven-development/SKILL.md`

#### TDD 适配规则（M/L Execute）

| Plan 精度 | TDD RED 策略 | 说明 |
|-----------|-------------|------|
| **签名级**（Plan 已定义精确签名、参数、返回类型） | 写测试验证 Plan 定义的行为会失败 | 不"猜"实现，用测试确认 Plan 中声明的接口当前不存在或行为不符 |
| **行为级**（Plan 描述了预期行为但未精确定义签名） | 完整 RED-GREEN-REFACTOR | 先写测试定义行为，再实现，符合标准 TDD |
| **探索级**（Plan 仅标注方向，细节待确定） | 完整 TDD + 设计探索 | 测试驱动接口设计，允许迭代签名 |

**核心原则**:
- Plan 已精确到签名级时，RED 阶段的目标是"验证 Plan 定义的行为当前未被满足"，而非从零猜测实现
- 仍然禁止先写实现代码再补测试——即使 Plan 已定义签名，也必须先让测试失败
- 如果 Plan 中的签名在实际测试中被证明不合理，必须先更新 Spec 再调整实现（铁律#5）
```

#### 1.2 TDD SKILL.md → 新增 "Spec-Aware TDD" 章节

在 [references/superpowers/test-driven-development/SKILL.md](../references/superpowers/test-driven-development/SKILL.md#L351) 的 "Debugging Integration" 章节之前，插入新章节：

```markdown
## Spec-Aware TDD

When working under a Spec-Driven Development workflow (e.g., ALTAS Workflow):

- **The Spec's Plan section defines WHAT, TDD defines HOW to verify it.**
- If the Plan already specifies exact signatures and contracts, your RED test should verify that those contracts are currently unfulfilled — not guess at implementation.
- If the Plan only describes behavior at a high level, follow the standard TDD cycle to design and verify the interface.
- If your test reveals that the Plan's design is flawed, STOP and update the Spec first (Reverse Sync rule).
- The "delete existing code" rule applies when you wrote implementation code BEFORE any test. If the Plan told you what to build and you wrote it before testing, you still must delete and rebuild from tests.
```

**影响**: 消除了"Plan 已定义精确实现 vs TDD 要求先写测试"之间的矛盾，Agent 在两种场景下都有明确的行为指引。

---

## 方案 2: Spec 模板增加 Test Strategy 章节 🔴

### 问题

当前 [spec-template.md](../references/spec-driven-development/spec-template.md#L62-L84) 的 `§4. Plan` 只有 File Changes、Signatures、Checklist、Spec Review Notes，没有专门的测试策略声明。Agent 在 TDD 执行时需要自行决定测试范围、框架和优先级。

### 改动

#### 2.1 spec-template.md → 单项目模板

在 `§4.3 Implementation Checklist` 和 `§4.4 Spec Review Notes` 之间插入 `§4.4 Test Strategy`，原 `§4.4` 顺延为 `§4.5`：

```markdown
### 4.4 Test Strategy (M/L required, S optional)

- **Test Framework**: `<Jest / Pytest / Go test / ...>`
- **Run Command**: `<npm test / pytest / go test / ...>`
- **Test Scope**:
  - [ ] Unit tests: `<覆盖范围，如"所有新增函数/方法">`
  - [ ] Integration tests: `<覆盖范围，如"接口联调路径">`
  - [ ] E2E tests: `<如适用>`
- **Test Priority**:
  - P0 (must): `<核心逻辑，如"注册流程、鉴权校验">`
  - P1 (should): `<边界条件，如"空输入、超长字符串">`
  - P2 (could): `<异常路径，如"网络超时、数据库连接失败">`
- **Mock Strategy**: `<优先用真实依赖 / 必须 Mock 的场景 / 已有 Test Helper>`
- **Existing Test Impact**: `<是否会破坏已有测试，如有，列出受影响的测试文件>`
```

#### 2.2 spec-template.md → 多项目模板

同样在多项目模板的 `§4.3 Implementation Checklist` 后插入，按项目分组：

```markdown
### 4.4 Test Strategy (M/L required, grouped by project)

#### [api-service]
- **Test Framework**: `<...>`
- **Run Command**: `<...>`
- **Test Scope & Priority**: `<...>`

#### [web-console]
- **Test Framework**: `<...>`
- **Run Command**: `<...>`
- **Test Scope & Priority**: `<...>`
```

#### 2.3 SKILL.md → PLAN 章节

在 [SKILL.md:381-391](../SKILL.md#L381-L391) 的 PLAN 章节末尾增加一行：

```markdown
- 必须包含 `§4.4 Test Strategy`：声明测试框架、运行命令、覆盖范围、优先级和 Mock 策略
```

**影响**: Agent 在 Plan 阶段就明确测试策略，避免执行时临时决定测试范围和优先级，减少 TDD 执行的不确定性。

---

## 方案 3: 检查点强制暂停约束增强 🔴

### 问题

当前 [SKILL.md](../SKILL.md#L320-L359) 的检查点契约依赖 Agent 的"自觉"输出，缺少对模型行为的强制约束。QUICKSTART.md 第 677 行承认用户需要手动说"请停止，严格执行检查点机制"来纠正 Agent 暴走。

### 改动

#### 3.1 SKILL.md → 在检查点契约后增加硬约束

在 [SKILL.md:359](../SKILL.md#L359) 的完整检查点模板之后，新增：

```markdown
### 检查点强制暂停规则

- **M/L 规模执行中**：每个 Checklist 项完成后 **必须** 输出检查点 + `[WAITING FOR COMMAND]`，除非用户已触发 Batch Override（`全部` / `all` / `execute all` / `继续完成所有` / `一次性完成`）
- **Batch Override 中的暂停**：即使处于批量执行模式，遇到以下情况也必须立即暂停：
  - 测试失败且原因不明
  - 发现 Spec 中未覆盖的场景
  - 文件冲突或编辑失败
  - 不确定下一步的正确实现方式
- **违反此规则视为违反铁律#4（无批准不执行）和铁律#6（证据驱动）**
```

#### 3.2 sdd-riper-one-protocol.md → Batch Override 章节补充

在 [sdd-riper-one-protocol.md:199-207](../references/spec-driven-development/sdd-riper-one-protocol.md#L199-L207) 的 Batch Override 规则中，在 "Emergency Stop" 后增加：

```markdown
* **Failure Stop**: In batch mode, if ANY test fails, you MUST halt at the current checklist item. Do NOT proceed to subsequent items until the failure is resolved or the user provides direction. Record the failure point in the Execute Log.
```

**影响**: 减少 Agent 一次性输出过多代码的风险，同时保留 Batch Override 的灵活性，只在关键异常时强制暂停。

---

## 方案 4: 规模再评估机制 🟡

### 问题

当前规模评估在首轮响应时完成（[SKILL.md:188-204](../SKILL.md#L188-L204)），但 Agent 在 Research 阶段获得更多信息后，可能发现实际复杂度与初始评估不符，缺少正式的"再评估"机制。

### 改动

#### 4.1 SKILL.md → 在规模评估章节新增 "Research 后重估"

在 [SKILL.md:204](../SKILL.md#L204) 的 "升降级" 节后新增：

```markdown
### Research 后规模重估

- Research 阶段获得完整上下文后，**必须**重新评估规模
- 若重估结果与初始评估不同：
  - 升级（如 S→M / M→L）：在 Spec 中记录 `## 2.2 Scale Re-assessment`，说明升级原因和影响
  - 降级（如 L→M / M→S）：同样记录原因，并精简后续阶段（如 L 降级为 M 则跳过 INNOVATE）
- 用户可随时指示强制升降级，无需等待 Research 完成
```

#### 4.2 spec-template.md → 新增 Scale Re-assessment 章节

在 `## 2. Research Findings` 后新增：

```markdown
## 2.2 Scale Re-assessment (if changed from initial assessment)
- Initial Assessment: `<XS/S/M/L>`
- Re-assessed: `<XS/S/M/L>`
- Reason: `<为什么调整>`
- Impact: `<阶段路径变化，如"跳过 INNOVATE" 或 "新增 Subagent">`
```

**影响**: 避免初始规模评估错误导致的流程不匹配，给 Agent 一个正式的"发现超预期/低于预期"时的处理路径。

---

## 方案 5: 多项目冲突解决协议 🟡

### 问题

[SDD-RIPER-DUAL-COOP.md](../protocols/SDD-RIPER-DUAL-COOP.md) 和 [sdd-riper-one-protocol.md](../references/spec-driven-development/sdd-riper-one-protocol.md#L389-L497) 定义了多项目模式，但当 Internal Model（Scout）发现的代码事实与 External Model（Architect）的 Spec 假设矛盾时，没有明确的仲裁流程。

### 改动

#### 5.1 sdd-riper-one-protocol.md → 在 MULTI 协议末尾新增 §8

在 [sdd-riper-one-protocol.md:527](../references/spec-driven-development/sdd-riper-one-protocol.md#L527) 的 "Guarantee" 节后新增：

```markdown
### 8. Spec Conflict Resolution (Cross-Project)

When multiple projects have active Specs that conflict:

1. **Detection**: Before modifying any file in a project that has its own active Spec, read that Spec's latest version.
2. **Conflict Classification**:
   - **Interface Conflict**: Provider's API contract ≠ Consumer's expected contract → STOP, alert user
   - **Behavior Conflict**: One Spec requires behavior X, another Spec requires behavior Y → STOP, alert user
   - **Version Conflict**: One Spec depends on lib v1.x, another requires lib v2.x → STOP, alert user
3. **Arbitration Rule**:
   - If one project is the **Provider** (API/schema owner) and the other is the **Consumer**, Provider's contract takes precedence for interface definitions
   - If both projects are peers (neither provides to the other), user decides
   - Never silently override another project's active Spec
4. **Spec Sync**: When a cross-project change affects multiple Specs, update ALL affected Specs before proceeding. Record sync in each Spec's `Change Log`.
```

**影响**: 明确跨项目 Spec 冲突的仲裁规则，避免 Agent 在多个 Spec 矛盾时自行猜测或静默覆盖。

---

## 方案 6: 关闭 SKILL-entry-review 高价值遗留项 🟡

### 问题

[SKILL-entry-review.md](../SKILL-entry-review.md#L396-L414) 记录了 17 项低优先级问题，其中 G（渐进式导航）和 X（The Bottom Line 总结）投入产出比最高。

### 改动

#### 6.1 SKILL.md → 新增 Quick Navigation 章节（关闭 G）

在 [SKILL.md:37](../SKILL.md#L37) 的 Overview 章节后新增：

```markdown
## Quick Navigation

| 我要找 | 去这里 |
|--------|--------|
| 触发词/别名 | `references/entry/aliases.md` |
| 完整参考索引 | `reference-index.md` |
| 特殊模式协议 | `references/special-modes/` (DEBUG/REVIEW/REFACTOR/TEST/PERF/MIGRATE) |
| 平台工具映射 | `references/superpowers/using-superpowers/SKILL.md` |
| 异常与恢复 | `references/entry/exceptions-recovery.md` |
| 防绕过机制 | `references/entry/discipline-enforcing.md` |
| 流程可视化 | `workflow-diagrams.md` |
```

#### 6.2 SKILL.md → 新增 The Bottom Line 章节（关闭 X）

在 SKILL.md 末尾（Usage Guide 之后）新增：

```markdown
## The Bottom Line

ALTAS Workflow is TDD applied to the full engineering lifecycle — not just code.

- **No Spec, No Code**: The same discipline as "no production code without a failing test."
- **No Approval, No Execute**: The same checkpoint as "watch it fail before you make it pass."
- **Evidence First**: The same proof as "all tests green."

If you follow TDD for code quality, follow ALTAS for engineering quality. Same rigor, broader scope.
```

#### 6.3 更新 SKILL-entry-review.md

将问题 G 和 X 从"未解决"移至"已解决"列表，并更新统计表。

**影响**: 提升 SKILL.md 的可读性和可导航性，同时保持正文长度不显著增加。

---

## 方案 7: 协议选择指引 🟢

### 问题

`protocols/` 下有 RIPER-5.md（严格手动模式切换）和 SDD-RIPER-DUAL-COOP.md（双模型协作），但缺少说明何时使用哪个协议的指引文件。

### 改动

新建 `protocols/PROTOCOL-SELECTION.md`：

```markdown
# Protocol Selection Guide

## Which Protocol to Use?

| 场景 | 推荐协议 | 说明 |
|------|----------|------|
| **默认工作流** | SDD-RIPER-ONE (via SKILL.md) | 适用于大多数工程任务，自适应阶段切换 |
| **用户完全自主控制模式** | RIPER-5 | 每个模式切换需要用户显式信号（"ENTER RESEARCH MODE" 等），适用于用户希望逐阶段审批的场景 |
| **双模型协作**（强模型规划 + 弱模型执行） | SDD-RIPER-DUAL-COOP | 适用于 External Model（Architect）无法直接读取代码库，需要 Internal Model（Scout）收集上下文的场景 |
| **纯文档撰写** | RIPER-DOC | 文档结构化整理场景 |

## 与 ALTAS Workflow 的关系

- **ALTAS Workflow (SKILL.md)** 是统一入口，内部引用 SDD-RIPER-ONE 作为主协议
- RIPER-5 是 SDD-RIPER-ONE 的"严格子集"（更保守，用户控制更多）
- SDD-RIPER-DUAL-COOP 是 SDD-RIPER-ONE 的"扩展"（增加了双模型信任边界管理）
- 除非用户明确要求使用某个特定协议，否则默认使用 ALTAS Workflow → SDD-RIPER-ONE
```

---

## 方案 8: Spec 质量度量标准 🟢

### 问题

Spec 质量依赖人工 Review，缺少客观评分标准。

### 改动

新建 `references/superpowers/requesting-code-review/spec-quality-metrics.md`：

```markdown
# Spec Quality Metrics

## Scoring Dimensions (0-5 per dimension)

| 维度 | 5 分标准 | 1 分标准 |
|------|----------|----------|
| **完整性** | Goal/In-Scope/Out-of-Scope/Facts/Signatures/Checklist 全部完整且无 TBD | 关键章节缺失或大量 TBD |
| **可验证性** | 每个 Acceptance 都有明确的验证方式（测试/运行命令/人工检查） | 验收标准模糊（如"应该能工作"） |
| **无歧义性** | 所有术语、接口签名、文件路径精确到行号 | 使用"类似 X"、"大概 Y"等模糊表述 |
| **可追溯性** | 每个 Checklist 项可追溯到具体 Requirements 条目 | Checklist 与 Requirements 无明确对应 |
| **风险覆盖** | 已识别风险均有缓解措施或回滚方案 | 未提及风险或风险未处理 |

## Go/No-Go Threshold

- **GO**: 所有维度 ≥ 3 分，且完整性 + 可验证性 ≥ 4 分
- **NO-GO**: 任一维度 < 2 分，或完整性 < 3 分
- **CONDITIONAL**: 其他情况，需用户确认是否带风险执行

## Usage

在 REVIEW SPEC 阶段（§3.5 / §4.5 Spec Review Notes）使用此评分表，输出各维度分数和 Go/No-Go 结论。
```

---

## 方案 9: Batch Override 失败回滚点定义 🟢

### 问题

Batch Override 允许跳过逐步骤确认，但批量执行中某项测试失败时的回滚策略不清晰（见分析第 10 项）。

### 改动

#### 9.1 sdd-riper-one-protocol.md → Batch Override 补充回滚规则

在 [sdd-riper-one-protocol.md:199-207](../references/spec-driven-development/sdd-riper-one-protocol.md#L199-L207) 的 "Emergency Stop" 后增加：

```markdown
* **Rollback Point**: Before entering batch mode, record the current checklist item index as `batch_start=<N>`. If failure occurs at item `<M>`, all items from `<N>` to `<M>` must be reviewed. Items before `<N>` are considered committed. The user decides whether to:
  - (a) Fix the failure at `<M>` and resume batch from `<M+1>`
  - (b) Rollback items `<N>` through `<M>` and re-plan
  - (c) Abort batch entirely and return to PLAN
```

**影响**: 明确批量执行失败时的回滚边界，避免 Agent 在失败后继续执行或不知如何回退。

---

## 方案 10: scaffold.py 脚手架脚本 🟢

### 问题

QUICKSTART.md 第 726-735 行提供了迁移指南，但缺少自动化脚本生成初始骨架。

### 改动

新建 `scripts/scaffold.py`，核心功能：

```python
#!/usr/bin/env python3
"""
ALTAS Workflow Scaffold Generator

Scans project structure and generates initial mydocs/ skeleton:
- mydocs/specs/<task>.md (from spec-template.md)
- mydocs/codemap/ (empty, ready for CodeMap generation)
- mydocs/context/ (empty, ready for Context Bundle)
- mydocs/archive/ (empty, ready for Archive)

Usage:
  python scripts/scaffold.py [task_name] [--template full|lite]
"""
```

功能：
1. 扫描项目根目录，识别项目类型（package.json / pom.xml / go.mod 等）
2. 检测是否已有 mydocs/ 目录，若无则创建骨架
3. 根据 `--template` 参数选择 full（spec-template.md）或 lite（spec-lite-template.md）
4. 输出项目基本信息到 Spec 的 Context Sources 章节

---

## 实施顺序与依赖关系

```
Phase 1 (高优先级 - 核心融合):
  方案 1 → 方案 2 → 方案 3
  (TDD适配 → 测试策略 → 检查点约束)

Phase 2 (中优先级 - 流程完善):
  方案 4 → 方案 5 → 方案 6
  (规模重估 → 冲突解决 → SKILL 入口优化)

Phase 3 (低优先级 - 架构扩展):
  方案 7 → 方案 8 → 方案 9 → 方案 10
  (协议选择 → 质量度量 → 回滚点 → 脚手架)
```

## 版本变更

- **Version**: 4.5 → 4.6
- **Breaking Changes**: 无（所有改动为新增或扩展）
- **Spec Template**: §4.4 Test Strategy 为新章节，已有 Spec 不受影响
- **SKILL.md**: 预计增加约 80-100 行，仍在 500 行限制内
