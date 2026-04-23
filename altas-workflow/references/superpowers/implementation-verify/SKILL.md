---
name: implementation-verify
description: Use after code review to verify that implementation fulfills PRD/spec requirements, checks task completion, and validates contract implementation. Generates a fulfillment report with coverage metrics.
trigger_keywords: ["IMPLEMENTATION VERIFY", "VERIFY PRD", "PRD CHECK", "REQUIREMENT CHECK", "SPEC VERIFY", "COVERAGE CHECK", "需求验证", "PRD 检查", "规格验证", "实现检查", "覆盖率检查"]
---

# Implementation Verification

## Overview

Verify implementation against PRD/specifications **after** code review completes, before marking a task as done.

**Core principle:** Code review checks *code quality*; implementation verification checks *requirement fulfillment*. Both are required.

```
Code Review → implementation-verify → Fulfillment Report → (if gaps) → Back to Plan/Execute
```

## When to Use

**Mandatory:**
- After code review completes (REVIEW phase gate)
- Before marking M/L tasks as "done"
- Before merge to main branch
- When user requests PRD/spec verification

**Optional but valuable:**
- After major refactoring to verify requirements still met
- When uncertain whether all spec items are covered
- Before handing off to QA/testing

## What Gets Checked

| Check | Input | Method | Output |
|-------|-------|--------|--------|
| **FR Fulfillment** | spec.md (FR-XXX) + tasks.md | Cross-reference FRs with completed tasks | % of requirements addressed |
| **Task Completion** | tasks.md | Count [X]/[x] vs [ ] items | % of tasks done |
| **Contract Implementation** | contracts/ directory | Parse endpoint definitions vs actual code | API coverage % |
| **Test Coverage Alignment** | spec.md §Test Strategy + actual tests | Verify test files cover specified scenarios | Gap analysis |

## Workflow

```
WHEN code review is complete:

1. LOCATE spec artifacts
   - Find spec.md / requirements.md in feature directory
   - Find tasks.md with task checklist
   - Find contracts/ directory (if exists)

2. EXTRACT requirements
   - Parse all FR-XXX references from spec
   - Extract task checklist items
   - Parse contract endpoint definitions

3. CROSS-REFERENCE with implementation
   - Match each FR to completed tasks
   - Identify FRs with no corresponding completed task
   - Check contract endpoints have real implementations

4. GENERATE Fulfillment Report
   - Coverage metrics (FR, task, contract %)
   - List of unimplemented requirements
   - Recommended actions

### Coverage Thresholds And Actions

5. ACT on results
   - 100% coverage → Proceed to merge/archive
   - >80% coverage → Note gaps, user decides
   - <80% coverage → Block, return to Execute
```

## Fulfillment Report Format

```markdown
## Fulfillment Report: implementation-verify

**Branch**: feature/xxx
**Timestamp**: 2025-01-01T00:00:00Z

### Coverage Metrics

| Metric | Value | Status |
|--------|-------|--------|
| Task Completion | 8/10 (80%) | ⚠️ |
| FR Fulfillment | 5/7 (71%) | ⚠️ |
| Contract Implementation | 3/3 (100%) | ✅ |

### Unimplemented Requirements

- **FR-003**: User authentication flow with OAuth2...
- **FR-007**: Export to PDF format with custom templates...

### Recommended Actions

1. Complete remaining 2 task(s) in tasks.md
2. Address 2 unimplemented requirement(s)
3. Re-run implementation-verify after fixes
```

## Exit Codes

| Code | Status | Meaning | Action |
|------|--------|---------|--------|
| 0 | Complete | 100% fulfillment | Proceed |
| 1 | Partial | >80% fulfillment | User decides |
| 2 | Low | <80% fulfillment | Block, return to Execute |
| 3 | Error | Required files missing | Fix environment |

## Integration Points

### With ALTAS Workflow REVIEW Phase

```
REVIEW Phase (三轴评审):
  ├─ 轴 1: 需求达成 → requirements.md / spec.md
  ├─ 轴 2: Spec-Code 一致性 → THIS SKILL
  └─ 轴 3: 代码质量 → code-review/go / code-review/python

轴 2 使用本技能执行自动化验证，输出 Fulfillment Report。
```

### With Code Review Reception

After understanding and implementing code review feedback (receiving-code-review):

```
receiving-code-review → implement fixes → code-review/go / code-review/python → implementation-verify
```

### With Requesting Code Review

Before dispatching code-reviewer subagent, ensure spec artifacts exist:

```
tasks complete? → implementation-verify → (pass) → requesting-code-review → merge
                                      → (fail) → back to Execute
```

## Script Usage

For automated verification, run the embedded script:

```bash
# Manual run
npx skills run implementation-verify

# Or execute script directly (if available)
bash references/superpowers/implementation-verify/scripts/verify.sh
```

The script:
1. Resolves repository root and feature directory
2. Locates spec.md and tasks.md
3. Parses FR requirements and task completion
4. Checks contract implementations
5. Outputs Fulfillment Report to stdout
6. Returns exit code per coverage level

## Requirements

| File | Required | Purpose |
|------|----------|---------|
| spec.md / requirements.md | Yes | FR requirement definitions |
| tasks.md | Yes | Task checklist with completion status |
| contracts/ | Optional | API contract definitions |
| check-prerequisites.sh | Yes (for script) | Path resolution |

## Common Patterns

### Pattern 1: Post-Review Gate

```markdown
You: Code review complete. All Critical/Important issues fixed.

You: Now running implementation-verify to check PRD coverage...

[Run verification]

Result: 100% FR coverage, 95% task completion.
All requirements addressed. Ready for merge.
```

### Pattern 2: Gap Detection

```markdown
You: Code review complete. Running implementation-verify...

Result: 71% FR fulfillment. 2 requirements unimplemented:
  - FR-003: OAuth2 authentication
  - FR-007: PDF export

⚠️ Coverage below 80%. Returning to Execute phase.

You: I see 2 unimplemented requirements. Should I:
  (a) Implement them now
  (b) Defer to a follow-up PRD
  (c) Confirm they're out of scope
```

### Pattern 3: Pre-Merge Checklist

```markdown
Pre-merge verification:
✅ Code review: All issues addressed
✅ implementation-verify: 100% FR coverage
✅ Tests: All passing
✅ Spec: Updated to match implementation

Ready to merge.
```

## The Bottom Line

**Code review = "Is the code good?"**
**Implementation verify = "Did we build what was specified?"**

Both must pass before considering a task complete.
