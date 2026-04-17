# SDD Spec Template (Workflow-aligned)

本模板包含两个版本：**单项目模板**（默认）和 **多项目模板**（`mode=multi_project` 时使用）。Agent 根据启动模式自动选择对应模板。

---

## 单项目模板（默认）

```markdown
# SDD Spec: <Task Name>

## 0. Open Questions
- [ ] None

## 1. Requirements (Context)
- **Goal**: ...
- **In-Scope**: ...
- **Out-of-Scope**: ...

## 1.1 Context Sources
- Requirement Source: `...`
- Design Refs: `...`
- Chat/Business Refs: `...`
- Extra Context: `...`

## 1.5 Codemap Used (Feature/Project Index)
- Codemap Mode: `feature` / `project`
- Codemap File: `mydocs/codemap/YYYY-MM-DD_hh-mm_<name>.md`
- Key Index:
  - Entry Points / Architecture Layers: ...
  - Core Logic / Cross-Module Flows: ...
  - Dependencies / External Systems: ...

## 1.6 Context Bundle Snapshot (Lite/Standard)
- Bundle Level: `Lite` / `Standard`
- Bundle File: `mydocs/context/YYYY-MM-DD_hh-mm_<task>_context_bundle.md`
- Key Facts: ...
- Open Questions: ...

## 2. Research Findings
- 事实与约束: ...
- 风险与不确定项: ...

## 2.2 Scale Re-assessment (if changed from initial assessment)
- Initial Assessment: `<XS/S/M/L>`
- Re-assessed: `<XS/S/M/L>`
- Reason: `<为什么调整>`
- Impact: `<阶段路径变化，如"跳过 INNOVATE" 或 "新增 Subagent">`

## 2.1 Next Actions
- 下一步动作 1 ...
- 下一步动作 2 ...

## 3. Innovate (Optional: Options & Decision)
### Option A
- Pros: ...
- Cons: ...
### Option B
- Pros: ...
- Cons: ...
### Decision
- Selected: ...
- Why: ...
### Skip (for small/simple tasks)
- Skipped: true/false
- Reason: ...

## 4. Plan (Contract)
### 4.1 File Changes
- `path/to/file`: 变更说明

### 4.2 Signatures
- `fn/class signature`: ...

### 4.3 Implementation Checklist
- [ ] 1. ...
- [ ] 2. ...
- [ ] 3. ...

### 4.4 Test Strategy (M/L required, S optional)

> 按固定字段顺序填写；不适用项显式写 `N/A`，不要省略整个小节。

- **Test Framework**: `<Jest / Pytest / Go test / ...>`
- **Run Command**: `<npm test / pytest / go test / ...>`
- **Test Levels**:
  - Unit: `<覆盖范围；如不适用写 N/A>`
  - Component: `<覆盖范围；如不适用写 N/A>`
  - Integration: `<覆盖范围；如不适用写 N/A>`
  - E2E: `<覆盖范围；如不适用写 N/A>`
- **Risk & Priority Matrix**:
  - P0 (must): `<核心逻辑 / 主流程 / 契约主路径>`
  - P1 (should): `<边界条件 / 状态切换 / 权限差异>`
  - P2 (could): `<异常路径 / 降级 / 超时 / 重试>`
- **Requirement / Contract Traceability**:
  - Source Requirements / Contracts: `<需求条目 / 接口文档 / Spec 行为来源>`
  - Planned Cases:
    - `<REQ/API-1>` -> `<对应测试类型与用例>`
    - `<REQ/API-2>` -> `<对应测试类型与用例>`
- **Mock / Stub / Fake Strategy**: `<优先用真实依赖 / 必须隔离的依赖 / 使用何种替身>`
- **Test Data Strategy**:
  - Data Source: `<factory / fixture / seed / 手写样例>`
  - Isolation: `<transaction rollback / tmp dir / dedicated db / fake service>`
  - Cleanup: `<自动清理方式>`
- **Existing Test Impact**: `<是否会破坏已有测试，如有，列出受影响的测试文件>`
- **Quality Gates**:
  - Pass Rate: `<如 100%>`
  - Coverage Target: `<如 line >= 80%, critical paths >= 95%>`
  - Flaky Tolerance: `<如 0 known flaky in changed scope>`
  - Time Budget: `<如 unit < 2 min / full suite < 10 min>`
- **Deferred / Out of Scope Tests**: `<本轮明确不做但需记录的测试项；无则写 None>`

### 4.6 Spec Review Notes (Optional Advisory, Pre-Execute)
- Spec Review Matrix:
| Check | Verdict | Evidence |
|---|---|---|
| Requirement clarity & acceptance | PASS/FAIL/PARTIAL | ... |
| Plan executability | PASS/FAIL/PARTIAL | ... |
| Risk / rollback readiness | PASS/FAIL/PARTIAL | ... |
- Readiness Verdict: GO/NO-GO (Advisory)
- Risks & Suggestions: ...
- Phase Reminders (for later sections): ...
- User Decision (if NO-GO): Proceed / Revise

## 5. Execute Log
- [ ] Step 1: ...
- [ ] Step 2: ...

### 5.1 Batch Execution Record (only when Batch Override is triggered)
> 仅在用户触发批量执行（`全部`/`all`/`execute all` 等）时填写。每次 Batch Override 创建一个独立记录块。

```
### Batch Execution #1
- batch_id: 1
- batch_start_item: <N> (Checklist 起始项索引)
- batch_trigger_command: "<用户原始指令>"
- batch_checkpoint_branch: checkpoint/batch-YYYYMMDD-HHmmss
- batch_rollback_command: git reset --hard <checkpoint_branch>
- batch_baseline_test_result: PASS/FAIL (进入批量执行前的测试基线)
- batch_status: in_progress / completed / failed / rolled_back
- batch_completed_items: [<N>, <N+1>, ...] (已成功执行的 Checklist 项)
- batch_failure_point: null / <M> (失败项索引，null 表示无失败)
- batch_failure_reason: "<具体错误信息，如有>"
- batch_failed_test: "<测试文件名>: <测试用例名，如有>"
- batch_rollback_option: null / a(Fix & Resume) / b(Rollback to Checkpoint) / c(Partial Rollback) / d(Abort & Re-plan)
- batch_rollback_confirmed_at: <timestamp，如有>
- batch_rollback_confirmed_by: <user/agent，如有>
```

## 6. Review Verdict
- Review Matrix (Mandatory):
| Axis | Key Checks | Verdict | Evidence |
|---|---|---|---|
| Spec Quality & Requirement Completion | Goal/In-Scope/Acceptance 是否完整清晰；需求是否达成 | PASS/FAIL/PARTIAL | `spec section + test/log/人工验收` |
| Spec-Code Fidelity | 文件、签名、checklist、行为是否与 Plan 一致 | PASS/FAIL/PARTIAL | `diff + code refs + execute log` |
| Code Intrinsic Quality | 正确性、鲁棒性、可维护性、测试、关键风险 | PASS/FAIL/PARTIAL | `test/lint/review evidence` |
- Overall Verdict: PASS/FAIL
- Blocking Issues: ...
- Regression risk: Low/Medium/High
- Follow-ups: ...

## 7. Plan-Execution Diff
- Any deviation from plan: ...

## 8. Archive Record (Recommended at closure)
- Archive Mode: `snapshot` / `thematic`
- Audience: `human` / `llm` / `both`
- Source Targets:
  - `mydocs/specs/...`
  - `mydocs/codemap/...`
- Archive Outputs:
  - `mydocs/archive/YYYY-MM-DD_hh-mm_<topic>_human.md`
  - `mydocs/archive/YYYY-MM-DD_hh-mm_<topic>_llm.md`
- Key Distilled Knowledge: ...
```

---

## 多项目模板（`mode=multi_project` 时使用）

```markdown
# SDD Spec: <Task Name>

## 0. Open Questions
- [ ] None

## 0.1 Project Registry
| project_id | project_path | project_type | marker_file |
|---|---|---|---|
| web-console | ./web-console | typescript | package.json |
| api-service | ./api-service | java | pom.xml |

## 0.2 Multi-Project Config
- **workdir**: `./`
- **active_project**: `web-console`
- **active_workdir**: `./web-console`
- **change_scope**: `local`
- **related_projects**: `api-service`

## 1. Requirements (Context)
- **Goal**: ...
- **In-Scope**: ...
- **Out-of-Scope**: ...

## 1.1 Context Sources
- Requirement Source: `...`
- Design Refs: `...`
- Chat/Business Refs: `...`
- Extra Context: `...`

## 1.5 Codemap Used (Per-Project Index)
### web-console
- Codemap File: `mydocs/codemap/YYYY-MM-DD_hh-mm_web-console项目总图.md`
- Key Index: ...

### api-service
- Codemap File: `mydocs/codemap/YYYY-MM-DD_hh-mm_api-service项目总图.md`
- Key Index: ...

## 1.6 Context Bundle Snapshot (Lite/Standard)
- Bundle Level: `Lite` / `Standard`
- Bundle File: `mydocs/context/YYYY-MM-DD_hh-mm_<task>_context_bundle.md`
- Key Facts: ...
- Open Questions: ...

## 2. Research Findings
- 事实与约束: ...
- 风险与不确定项: ...
- 跨项目依赖关系: ...

## 2.1 Next Actions
- 下一步动作 1 ...
- 下一步动作 2 ...

## 3. Innovate (Optional: Options & Decision)
### Option A
- Pros: ...
- Cons: ...
### Option B
- Pros: ...
- Cons: ...
### Decision
- Selected: ...
- Why: ...
### Skip (for small/simple tasks)
- Skipped: true/false
- Reason: ...

## 4. Plan (Contract)
### 4.1 File Changes (grouped by project)
#### [web-console]
- `src/pages/release.tsx`: 变更说明

#### [api-service]
- `src/main/java/.../ReleaseController.java`: 变更说明

### 4.2 Signatures (grouped by project)
#### [web-console]
- `function triggerRelease(config: ReleaseConfig): Promise<Result>`: ...

#### [api-service]
- `public ResponseEntity<Result> release(ReleaseRequest req)`: ...

### 4.3 Implementation Checklist (grouped by project, dependency order)
#### [api-service] (provider first)
- [ ] 1. ...
- [ ] 2. ...

#### [web-console] (consumer second)
- [ ] 3. ...
- [ ] 4. ...

### 4.4 Test Strategy (M/L required, grouped by project)

> 每个项目都按同一字段顺序填写；不适用项显式写 `N/A`，不要省略整个小节。

#### [api-service]
- **Test Framework**: `<...>`
- **Run Command**: `<...>`
- **Test Levels**:
  - Unit: `<... / N/A>`
  - Component: `<... / N/A>`
  - Integration: `<... / N/A>`
  - E2E: `<... / N/A>`
- **Risk & Priority Matrix**:
  - P0: `<...>`
  - P1: `<...>`
  - P2: `<...>`
- **Requirement / Contract Traceability**:
  - `<REQ/API-1>` -> `<对应测试类型与用例>`
  - `<REQ/API-2>` -> `<对应测试类型与用例>`
- **Mock / Stub / Fake Strategy**: `<...>`
- **Test Data Strategy**:
  - Data Source: `<...>`
  - Isolation: `<...>`
  - Cleanup: `<...>`
- **Existing Test Impact**: `<是否会破坏已有测试，如有，列出受影响的测试文件>`
- **Quality Gates**:
  - Pass Rate: `<...>`
  - Coverage Target: `<...>`
  - Flaky Tolerance: `<...>`
  - Time Budget: `<...>`
- **Deferred / Out of Scope Tests**: `<...>`

#### [web-console]
- **Test Framework**: `<...>`
- **Run Command**: `<...>`
- **Test Levels**:
  - Unit: `<... / N/A>`
  - Component: `<... / N/A>`
  - Integration: `<... / N/A>`
  - E2E: `<... / N/A>`
- **Risk & Priority Matrix**:
  - P0: `<...>`
  - P1: `<...>`
  - P2: `<...>`
- **Requirement / Contract Traceability**:
  - `<REQ/UI-1>` -> `<对应测试类型与用例>`
  - `<REQ/UI-2>` -> `<对应测试类型与用例>`
- **Mock / Stub / Fake Strategy**: `<...>`
- **Test Data Strategy**:
  - Data Source: `<...>`
  - Isolation: `<...>`
  - Cleanup: `<...>`
- **Existing Test Impact**: `<是否会破坏已有测试，如有，列出受影响的测试文件>`
- **Quality Gates**:
  - Pass Rate: `<...>`
  - Coverage Target: `<...>`
  - Flaky Tolerance: `<...>`
  - Time Budget: `<...>`
- **Deferred / Out of Scope Tests**: `<...>`

### 4.5 Contract Interfaces (cross-project only)
| Provider | Interface / API | Consumer(s) | Breaking Change? | Migration Plan |
|---|---|---|---|---|
| api-service | `POST /api/release` | web-console | No | N/A |

### 4.6 Spec Review Notes (Optional Advisory, Pre-Execute)
- Spec Review Matrix:
| Check | Verdict | Evidence |
|---|---|---|
| Requirement clarity & acceptance | PASS/FAIL/PARTIAL | ... |
| Plan executability | PASS/FAIL/PARTIAL | ... |
| Risk / rollback readiness | PASS/FAIL/PARTIAL | ... |
| Cross-project contract completeness | PASS/FAIL/PARTIAL | ... |
- Readiness Verdict: GO/NO-GO (Advisory)
- Risks & Suggestions: ...
- Phase Reminders (for later sections): ...
- User Decision (if NO-GO): Proceed / Revise

## 5. Execute Log (grouped by project)
#### [api-service]
- [ ] Step 1: ...

#### [web-console]
- [ ] Step 2: ...

### 5.1 Batch Execution Record (only when Batch Override is triggered)
> 仅在用户触发批量执行（`全部`/`all`/`execute all` 等）时填写。每次 Batch Override 创建一个独立记录块。

```
### Batch Execution #1
- batch_id: 1
- batch_start_item: <N> (Checklist 起始项索引)
- batch_trigger_command: "<用户原始指令>"
- batch_checkpoint_branch: checkpoint/batch-YYYYMMDD-HHmmss
- batch_rollback_command: git reset --hard <checkpoint_branch>
- batch_baseline_test_result: PASS/FAIL (进入批量执行前的测试基线)
- batch_status: in_progress / completed / failed / rolled_back
- batch_completed_items: [<N>, <N+1>, ...] (已成功执行的 Checklist 项)
- batch_failure_point: null / <M> (失败项索引，null 表示无失败)
- batch_failure_reason: "<具体错误信息，如有>"
- batch_failed_test: "<测试文件名>: <测试用例名，如有>"
- batch_rollback_option: null / a(Fix & Resume) / b(Rollback to Checkpoint) / c(Partial Rollback) / d(Abort & Re-plan)
- batch_rollback_confirmed_at: <timestamp，如有>
- batch_rollback_confirmed_by: <user/agent，如有>
```

## 6. Review Verdict
- Review Matrix (Mandatory):
| Axis | Key Checks | Verdict | Evidence |
|---|---|---|---|
| Spec Quality & Requirement Completion | Goal/In-Scope/Acceptance 是否完整清晰；需求是否达成 | PASS/FAIL/PARTIAL | `spec section + test/log/人工验收` |
| Spec-Code Fidelity | 文件、签名、checklist、行为是否与 Plan 一致 | PASS/FAIL/PARTIAL | `diff + code refs + execute log` |
| Code Intrinsic Quality | 正确性、鲁棒性、可维护性、测试、关键风险 | PASS/FAIL/PARTIAL | `test/lint/review evidence` |
- Overall Verdict: PASS/FAIL
- Blocking Issues: ...
- Regression risk (per project):
  - web-console: Low/Medium/High
  - api-service: Low/Medium/High
- Cross-project consistency: PASS/FAIL
- Follow-ups: ...

## 6.1 Touched Projects
| project_id | Files Changed | Reason |
|---|---|---|
| api-service | `ReleaseController.java` | 新增发布接口 |
| web-console | `release.tsx` | 对接发布接口 |

## 7. Plan-Execution Diff
- Any deviation from plan: ...
- Orphan changes (files outside registered projects): None

## 8. Archive Record (Recommended at closure)
- Archive Mode: `snapshot` / `thematic`
- Audience: `human` / `llm` / `both`
- Source Targets:
  - `mydocs/specs/...`
  - `mydocs/codemap/...`
- Archive Outputs:
  - `mydocs/archive/YYYY-MM-DD_hh-mm_<topic>_human.md`
  - `mydocs/archive/YYYY-MM-DD_hh-mm_<topic>_llm.md`
- Key Distilled Knowledge: ...
```

---

## 使用要求

### 通用

- 中大型任务建议先具备 `Codemap + Context Bundle + 首版 Spec`；小任务可先出首版 Spec 再补齐。
- 首版 Spec 允许先完成 Research 最小章节，后续章节按 RIPER 阶段逐步补齐。
- 未经 `Plan Approved` 禁止进入 Execute。
- `review_spec` 为建议性预审：`NO-GO` 不强制阻塞执行；若继续执行需记录用户决策。
- `review_spec` 按阶段检查：未到阶段的缺失内容仅记录为 Reminder。
- Review 未通过则返回 Research/Plan 重新闭环。
- 任务收口时建议填写 `§8 Archive Record` 并执行 `archive` 生成沉淀文档。

### 多项目专属

- `§0.1 Project Registry` 和 `§0.2 Multi-Project Config` 在 bootstrap 时由 Agent 自动生成（通过 Auto-Discovery 或用户提供的 projects 列表）。
- `§4. Plan` 的 File Changes、Signatures、Checklist 必须按项目分组，Provider 优先于 Consumer。
- `§4.4 Contract Interfaces` 仅在 `change_scope=cross` 时必填。
- `§6.1 Touched Projects` 在任何跨项目改动后必填。
- `§6. Review Verdict` 必须包含 per-project regression risk 和 cross-project consistency 检查。
- 建议在 closure 阶段执行 `archive`，沉淀跨项目契约与演进结论。
