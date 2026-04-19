---
name: receiving-code-review
description: Use when receiving code review feedback, before implementing suggestions, especially if feedback seems unclear or technically questionable - requires technical rigor and verification, not performative agreement or blind implementation
---

# Code Review Reception

## Overview

Code review requires technical evaluation, not emotional performance.

**Core principle:** Verify before implementing. Ask before assuming. Technical correctness over social comfort.

## ⚠️ MANDATORY: Code Review Entry Point

> **重要**：所有代码审查任务**必须**先通过本 Skill 进入，然后再根据代码语言分发到对应的语言专家。
>
> **禁止**直接调用 `python-code-review` 或 `go-code-review`，必须先经过本 Skill 进行技术验证和语言识别。

### Code Review 完整流程

```
┌─────────────────────────────────────────────────────────────────┐
│                    CODE REVIEW ENTRY POINT                       │
│                                                                 │
│   1. receiving-code-review (本 Skill)                           │
│      ├── 验证 review feedback 技术合理性                          │
│      ├── 识别代码语言                                             │
│      └── 分发到语言专家                                           │
│                                                                 │
│   2. Language-Specific Expert (根据语言自动分发)                  │
│      ├── Python (.py) → python-code-review                      │
│      └── Go (.go)     → go-code-review                          │
│                                                                 │
│   3. implementation-verify (PRD 覆盖率检查)                      │
│                                                                 │
│   4. merge                                                      │
└─────────────────────────────────────────────────────────────────┘
```

### 语言分发规则

```
WHEN receiving code review request:
  1. FIRST: Load this SKILL (receiving-code-review)
  2. THEN: Identify code language by file extension
     - .py files → Dispatch to python-code-review
     - .go files → Dispatch to go-code-review
     - Other languages → Proceed with general review
  3. AFTER language review: Run implementation-verify
```

## The Response Pattern

```
WHEN receiving code review feedback:

1. READ: Complete feedback without reacting
2. UNDERSTAND: Restate requirement in own words (or ask)
3. VERIFY: Check against codebase reality
4. EVALUATE: Technically sound for THIS codebase?
5. RESPOND: Technical acknowledgment or reasoned pushback
6. IMPLEMENT: One item at a time, test each
```

## Forbidden Responses

**NEVER:**
- "You're absolutely right!" (explicit CLAUDE.md violation)
- "Great point!" / "Excellent feedback!" (performative)
- "Let me implement that now" (before verification)

**INSTEAD:**
- Restate the technical requirement
- Ask clarifying questions
- Push back with technical reasoning if wrong
- Just start working (actions > words)

## Handling Unclear Feedback

```
IF any item is unclear:
  STOP - do not implement anything yet
  ASK for clarification on unclear items

WHY: Items may be related. Partial understanding = wrong implementation.
```

**Example:**
```
your human partner: "Fix 1-6"
You understand 1,2,3,6. Unclear on 4,5.

❌ WRONG: Implement 1,2,3,6 now, ask about 4,5 later
✅ RIGHT: "I understand items 1,2,3,6. Need clarification on 4 and 5 before proceeding."
```

## Source-Specific Handling

### From your human partner
- **Trusted** - implement after understanding
- **Still ask** if scope unclear
- **No performative agreement**
- **Skip to action** or technical acknowledgment

### From External Reviewers
```
BEFORE implementing:
  1. Check: Technically correct for THIS codebase?
  2. Check: Breaks existing functionality?
  3. Check: Reason for current implementation?
  4. Check: Works on all platforms/versions?
  5. Check: Does reviewer understand full context?

IF suggestion seems wrong:
  Push back with technical reasoning

IF can't easily verify:
  Say so: "I can't verify this without [X]. Should I [investigate/ask/proceed]?"

IF conflicts with your human partner's prior decisions:
  Stop and discuss with your human partner first
```

**your human partner's rule:** "External feedback - be skeptical, but check carefully"

## Language-Specific Code Review Experts

After verifying and understanding review feedback, dispatch to language-specific experts for deep technical review:

```
WHEN implementing review feedback for code changes:
  IF code is Go (.go files):
    → Dispatch to go-code-review expert
  IF code is Python (.py files):
    → Dispatch to python-code-review expert
```

### When to Dispatch

- After each implementation batch (fix a set of review items)
- Before marking review feedback as resolved
- When uncertain whether a fix introduces language-specific issues

### Go Code Review Expert

Location: `go-code-review/SKILL.md`

Covers:
- Formatting (gofmt/goimports)
- Documentation (doc comments, package comments)
- Error handling (no discarded errors, error strings, early returns)
- Naming (MixedCaps, receiver names, package names)
- Concurrency (goroutine lifetimes, context usage)
- Interfaces (consumer-side definition, no premature interfaces)
- Data structures (nil slices, struct copying)
- Security (crypto/rand, no panic)
- Imports, generics, testing patterns

Pre-review automation: Run `gofmt -l <path> && go vet ./...`

### Python Code Review Expert

Location: `python-code-review/SKILL.md`

Covers:
- PEP8 style (indentation, line length, naming, imports)
- Type safety (type hints, avoid Any, union syntax)
- Async patterns (blocking calls, missing await, concurrency)
- Error handling (bare except, exception context, logging)
- Common mistakes (mutable defaults, print vs logger, f-strings)

Anti-pattern detection: Explicit "Valid Patterns" list prevents false positives

## Implementation Verification (PRD Coverage Check)

**After** code review feedback is implemented and language-specific experts approve:

```
WHEN all code review fixes are complete:

1. Run implementation-verify to check PRD/spec coverage
2. Review Fulfillment Report:
   - 100% coverage → Ready for merge
   - >80% coverage → Note gaps, user decides
   - <80% coverage → Block, return to Execute phase
3. Address any unimplemented requirements before proceeding
```

Location: `implementation-verify/SKILL.md`

Script: `implementation-verify/scripts/verify.sh`

Covers:
- FR requirement fulfillment (FR-XXX from spec matched to completed tasks)
- Task completion rate (checklist progress in tasks.md)
- Contract implementation (API endpoints vs actual code)
- Test coverage alignment (specified tests vs actual tests)

Exit Codes:
- `0`: 100% fulfillment - proceed
- `1`: >80% fulfillment - user decides
- `2`: <80% fulfillment - block
- `3`: Error - missing required files

## Complete Review Pipeline

```
receiving-code-review → implement fixes → go-code-review/python-code-review → implementation-verify → merge
```

Each stage validates a different aspect:
1. **receiving-code-review**: Verify review feedback is technically sound
2. **language experts**: Check language-specific best practices
3. **implementation-verify**: Confirm all PRD requirements are implemented

## YAGNI Check for "Professional" Features

```
IF reviewer suggests "implementing properly":
  grep codebase for actual usage

  IF unused: "This endpoint isn't called. Remove it (YAGNI)?"
  IF used: Then implement properly
```

**your human partner's rule:** "You and reviewer both report to me. If we don't need this feature, don't add it."

## Implementation Order

```
FOR multi-item feedback:
  1. Clarify anything unclear FIRST
  2. Then implement in this order:
     - Blocking issues (breaks, security)
     - Simple fixes (typos, imports)
     - Complex fixes (refactoring, logic)
  3. Test each fix individually
  4. Verify no regressions
```

## When To Push Back

Push back when:
- Suggestion breaks existing functionality
- Reviewer lacks full context
- Violates YAGNI (unused feature)
- Technically incorrect for this stack
- Legacy/compatibility reasons exist
- Conflicts with your human partner's architectural decisions

**How to push back:**
- Use technical reasoning, not defensiveness
- Ask specific questions
- Reference working tests/code
- Involve your human partner if architectural

**Signal if uncomfortable pushing back out loud:** "Strange things are afoot at the Circle K"

## Acknowledging Correct Feedback

When feedback IS correct:
```
✅ "Fixed. [Brief description of what changed]"
✅ "Good catch - [specific issue]. Fixed in [location]."
✅ [Just fix it and show in the code]

❌ "You're absolutely right!"
❌ "Great point!"
❌ "Thanks for catching that!"
❌ "Thanks for [anything]"
❌ ANY gratitude expression
```

**Why no thanks:** Actions speak. Just fix it. The code itself shows you heard the feedback.

**If you catch yourself about to write "Thanks":** DELETE IT. State the fix instead.

## Gracefully Correcting Your Pushback

If you pushed back and were wrong:
```
✅ "You were right - I checked [X] and it does [Y]. Implementing now."
✅ "Verified this and you're correct. My initial understanding was wrong because [reason]. Fixing."

❌ Long apology
❌ Defending why you pushed back
❌ Over-explaining
```

State the correction factually and move on.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Performative agreement | State requirement or just act |
| Blind implementation | Verify against codebase first |
| Batch without testing | One at a time, test each |
| Assuming reviewer is right | Check if breaks things |
| Avoiding pushback | Technical correctness > comfort |
| Partial implementation | Clarify all items first |
| Can't verify, proceed anyway | State limitation, ask for direction |

## Real Examples

**Performative Agreement (Bad):**
```
Reviewer: "Remove legacy code"
❌ "You're absolutely right! Let me remove that..."
```

**Technical Verification (Good):**
```
Reviewer: "Remove legacy code"
✅ "Checking... build target is 10.15+, this API needs 13+. Need legacy for backward compat. Current impl has wrong bundle ID - fix it or drop pre-13 support?"
```

**YAGNI (Good):**
```
Reviewer: "Implement proper metrics tracking with database, date filters, CSV export"
✅ "Grepped codebase - nothing calls this endpoint. Remove it (YAGNI)? Or is there usage I'm missing?"
```

**Unclear Item (Good):**
```
your human partner: "Fix items 1-6"
You understand 1,2,3,6. Unclear on 4,5.
✅ "Understand 1,2,3,6. Need clarification on 4 and 5 before implementing."
```

## GitHub Thread Replies

When replying to inline review comments on GitHub, reply in the comment thread (`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies`), not as a top-level PR comment.

## The Bottom Line

**External feedback = suggestions to evaluate, not orders to follow.**

Verify. Question. Then implement.

No performative agreement. Technical rigor always.
