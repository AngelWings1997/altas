# ALTAS Workflow 参考资料总索引

> 本文件是 ALTAS Workflow 所有参考资料的统一发现入口。
> AI Agent 无需常驻全部内容，只需在命中场景时按需加载对应文件。

## 按需加载指南

当 `SKILL.md` 将任务路由到某一模式或阶段后，从"场景索引"直接定位对应场景，加载必读文件即可开始。

> 若路径读取失败，先使用全局搜索定位；若文件确实缺失，则按标准模式继续，并明确提醒用户依赖不完整。

---

## 场景索引

> 每个场景列出 **必读**（1-3 个，首轮必须加载）和 **按需**（后续根据具体需求加载）。
> "按来源分类"和"按规模等级"在文末，仅在需要方法论背景或规划完整加载集时使用。

### PRE-RESEARCH / 输入准备

| 必读 | 按需 |
|------|------|
| `references/spec-driven-development/commands.md` | `references/spec-driven-development/sdd-riper-one-protocol.md`, `references/spec-driven-development/workflow-quickref.md` |

### RESEARCH / 研究对齐

| 必读 | 按需 |
|------|------|
| `references/spec-driven-development/spec-template.md` (M/L) 或 `references/checkpoint-driven/spec-lite-template.md` (S) | `references/checkpoint-driven/conventions.md` |

### INNOVATE / 方案对比

| 必读 | 按需 |
|------|------|
| `references/superpowers/brainstorming/SKILL.md` | `references/superpowers/brainstorming/visual-companion.md`, `references/superpowers/brainstorming/spec-document-reviewer-prompt.md` |

### PLAN / 详细规划

| 必读 | 按需 |
|------|------|
| `references/superpowers/writing-plans/SKILL.md`, `references/testing/test-strategy-template.md` | `references/superpowers/writing-plans/plan-document-reviewer-prompt.md` |

### EXECUTE / 代码实现

| 必读 | 按需 |
|------|------|
| `references/superpowers/test-driven-development/SKILL.md` (M/L) | `references/testing/pytest-patterns.md`, `references/testing/api-testing.md`, `references/superpowers/test-driven-development/testing-anti-patterns.md`, `references/superpowers/test-driven-development/pytest-tdd-cycle.md`, `references/superpowers/subagent-driven-development/SKILL.md` (L), `references/superpowers/dispatching-parallel-agents/SKILL.md` (L), `references/testing/e2e-testing.md`, `references/testing/performance-testing.md`, `references/testing/test-data-management.md`, `references/testing/ci-cd-integration.md`, `references/testing/test-quality-metrics.md`, `references/testing/contract-testing.md`, `references/testing/visual-testing.md`, `references/testing/security-testing.md`, `references/testing/test-observability.md`, `references/testing/mobile-testing.md`, `references/testing/test-maintenance.md`, `references/testing/test-environment.md`, `references/testing/go-testing.md`, `references/testing/test-scaffold-templates.md`, `references/testing/test-task-pressure-scenarios.md`, `references/testing/test-review-checklist.md`, `protocols/PROTOCOL-SELECTION.md`, `references/superpowers/requesting-code-review/spec-quality-metrics.md` |

#### 非 Python 项目测试参考

| 语言 | 测试参考文档 | 测试框架 | 运行命令 |
|------|-------------|---------|----------|
| Go | `references/testing/go-testing.md` | `testing` 内置 + `testify` / `ginkgo` | `go test ./...` |

### REVIEW / 审查

| 必读 | 按需 |
|------|------|
| `references/checkpoint-driven/checkpoints.md`, `references/checkpoint-driven/modules.md` | `references/superpowers/verification-before-completion/SKILL.md`, `references/superpowers/requesting-code-review/SKILL.md`, `references/superpowers/requesting-code-review/code-reviewer.md`, `references/superpowers/receiving-code-review/SKILL.md` |

### ARCHIVE / 知识沉淀

| 必读 | 按需 |
|------|------|
| `references/spec-driven-development/archive-template.md` | `scripts/archive_builder.py`, `references/superpowers/finishing-a-development-branch/SKILL.md` |

### PRD 分析 / 需求文档

| 必读 | 按需 |
|------|------|
| `references/prd-analysis/SKILL.md` | `references/prd-analysis/template.md`, `references/prd-analysis/validation.md`, `references/prd-analysis/reference/output-format.md`, `references/prd-analysis/examples/good-prd.md`, `references/prd-analysis/examples/output-example.md`, `references/prd-analysis/testability-checklist.md` |

### DEBUG 模式

| 必读 | 按需 |
|------|------|
| `references/superpowers/systematic-debugging/SKILL.md`, `references/special-modes/debug.md` | `references/superpowers/systematic-debugging/root-cause-tracing.md`, `references/superpowers/systematic-debugging/defense-in-depth.md`, `references/superpowers/systematic-debugging/condition-based-waiting.md` |

### DOC 模式

| 必读 | 按需 |
|------|------|
| `protocols/RIPER-DOC.md`, `references/special-modes/doc.md` | — |

### REVIEW 模式

| 必读 | 按需 |
|------|------|
| `references/special-modes/review.md` | `references/checkpoint-driven/modules.md` (Review 模块), `references/superpowers/requesting-code-review/SKILL.md`, `references/superpowers/receiving-code-review/SKILL.md` |

### REFACTOR 模式

| 必读 | 按需 |
|------|------|
| `references/special-modes/refactor.md` | `references/superpowers/test-driven-development/SKILL.md`, `references/spec-driven-development/commands.md` (create_codemap) |

### TEST 模式

| 必读 | 按需 |
|------|------|
| `references/special-modes/test.md`, `references/testing/pytest-patterns.md`, `references/testing/api-testing.md` | `references/testing/test-strategy-template.md`, `references/prd-analysis/testability-checklist.md`, `references/testing/e2e-testing.md`, `references/testing/performance-testing.md`, `references/testing/visual-testing.md`, `references/testing/security-testing.md`, `references/testing/test-observability.md`, `references/testing/mobile-testing.md`, `references/testing/test-scaffold-templates.md`, `references/testing/test-quality-metrics.md`, `references/testing/test-task-pressure-scenarios.md`, `references/testing/ci-cd-integration.md`, `references/testing/test-maintenance.md`, `references/testing/test-review-checklist.md`, `references/testing/test-data-management.md`, `references/testing/contract-testing.md`, `references/testing/go-testing.md`, `references/superpowers/test-driven-development/SKILL.md`, `references/superpowers/test-driven-development/testing-anti-patterns.md`, `references/superpowers/test-driven-development/pytest-tdd-cycle.md` |

#### 按测试任务导航

| 任务 | 先加载 | 再加载 | 可选 |
|------|--------|--------|------|
| 起测试环境 | `references/testing/test-scaffold-templates.md` | `references/testing/pytest-patterns.md` | `references/testing/api-testing.md` |
| 写 API 测试 | `references/testing/api-testing.md` | `references/testing/pytest-patterns.md` | `references/testing/test-data-management.md` |
| 写契约测试 | `references/testing/contract-testing.md` | `references/testing/api-testing.md` | `references/testing/ci-cd-integration.md` |
| 写 Go 测试 | `references/testing/go-testing.md` | `references/testing/api-testing.md` | `references/testing/contract-testing.md` |
| 写 E2E 测试 | `references/testing/e2e-testing.md` | `references/testing/pytest-patterns.md` | `references/testing/api-testing.md` |
| 写性能测试 | `references/testing/performance-testing.md` | `references/testing/pytest-patterns.md` | `references/testing/ci-cd-integration.md` |
| 写视觉测试 | `references/testing/visual-testing.md` | `references/testing/e2e-testing.md` | `references/testing/pytest-patterns.md` |
| 写安全测试 | `references/testing/security-testing.md` | `references/testing/api-testing.md` | `references/testing/ci-cd-integration.md` |
| 移动端测试 | `references/testing/mobile-testing.md` | `references/testing/e2e-testing.md` | `references/testing/api-testing.md` |
| 测试可观测性 | `references/testing/test-observability.md` | `references/testing/test-quality-metrics.md` | `references/superpowers/systematic-debugging/SKILL.md` |
| PRD 可测试性评审 | `references/prd-analysis/testability-checklist.md` | `references/prd-analysis/SKILL.md` | `references/special-modes/test.md` |
| 优化 CI 测试 | `references/testing/ci-cd-integration.md` | `references/testing/test-quality-metrics.md` | `references/testing/test-maintenance.md` |
| 搭建测试环境 | `references/testing/test-environment.md` | `references/testing/ci-cd-integration.md` | `references/testing/test-data-management.md` |
| 维护测试套件 | `references/testing/test-maintenance.md` | `references/testing/test-review-checklist.md` | `references/testing/test-quality-metrics.md` |
| 补测试覆盖率 | `references/testing/pytest-patterns.md` | `references/testing/test-task-pressure-scenarios.md` | `references/testing/test-data-management.md` |
| 安全合规测试 | `references/testing/api-testing.md` | `references/testing/security-testing.md` | `references/testing/ci-cd-integration.md` |
| TDD 开发新功能 | `references/superpowers/test-driven-development/SKILL.md` | `references/testing/pytest-patterns.md` | `references/superpowers/test-driven-development/pytest-tdd-cycle.md` |

### PERF 模式

| 必读 | 按需 |
|------|------|
| `references/special-modes/perf.md` | `references/superpowers/verification-before-completion/SKILL.md`, `references/superpowers/finishing-a-development-branch/SKILL.md` |

### MIGRATE 模式

| 必读 | 按需 |
|------|------|
| `references/special-modes/migrate.md` | `references/superpowers/brainstorming/SKILL.md`, `references/superpowers/verification-before-completion/SKILL.md` |

### MULTI 模式

| 必读 | 按需 |
|------|------|
| `references/spec-driven-development/multi-project.md` | `references/checkpoint-driven/modules.md` (Multi-project 模块) |

### SELF-IMPROVEMENT 模式

| 必读 | 按需 |
|------|------|
| `references/self-improvement/SKILL.md` | `.learnings/LEARNINGS.md`, `.learnings/ERRORS.md`, `.learnings/FEATURE_REQUESTS.md` |

---

## 按来源分类索引

> 以下仅列出分类标签和核心入口文件。需要了解方法论背景时，从入口文件深入。

| 来源 | 核心入口 | 覆盖范围 |
|------|---------|----------|
| **SDD-RIPER** | `references/spec-driven-development/commands.md` | Spec 模板、RIPER 协议、命令参数、多项目协作、归档、使用示例 |
| **SDD-RIPER-Opt** | `references/checkpoint-driven/spec-lite-template.md` | 轻量 Spec、按需模块、命名约定 |
| **Superpowers** | `references/superpowers/using-superpowers/SKILL.md` | 头脑风暴、Plan 编写、TDD、Debug、Subagent、并行 Agent、验证、代码审查、Git Worktree、Skill 编写 |
| **PRD Analysis** | `references/prd-analysis/SKILL.md` | PRD 工作流、模板、验证清单、可测试性评审 |
| **Testing** | `references/testing/pytest-patterns.md` | API/E2E/性能/安全/视觉/移动/契约/Go 测试、CI/CD、质量度量、维护、环境、数据管理 |
| **Code Review** | `references/superpowers/receiving-code-review/SKILL.md` | Python/Go 代码审查、审查流程、报告模板 |
| **Self-Improvement** | `references/self-improvement/SKILL.md` | 触发机制、记录格式、晋升规则、技能提取 |
| **Agent 定义** | `references/agents/sdd-riper-one/SKILL.md` | 标准版/轻量版 Agent、配置文件、示例 |
| **Protocols** | `protocols/PROTOCOL-SELECTION.md` | RIPER-5 严格模式、DOC 文档模式、双模型协作 |

---

## 按规模等级索引

### Size XS — 无需加载任何参考

### Size S — 按需加载

- `references/checkpoint-driven/spec-lite-template.md`
- `references/checkpoint-driven/conventions.md`

### Size M — 标准加载

- `references/spec-driven-development/spec-template.md`
- `references/spec-driven-development/commands.md`
- `references/superpowers/writing-plans/SKILL.md`
- `references/superpowers/test-driven-development/SKILL.md`
- `references/superpowers/verification-before-completion/SKILL.md`
- `references/checkpoint-driven/modules.md` (Review模块)

### Size L — 完整加载

- 全部 M 规模文件（包含TDD），加上:
- `references/superpowers/brainstorming/SKILL.md`
- `references/superpowers/subagent-driven-development/SKILL.md`
- `references/superpowers/dispatching-parallel-agents/SKILL.md`
- `references/spec-driven-development/multi-project.md`
- `references/spec-driven-development/archive-template.md`
- `references/superpowers/finishing-a-development-branch/SKILL.md`

---

## 统计

- **参考文件总数**: 141 (MD), 185+ (含脚本/模板等非 MD 文件)
- **来源分布**: SDD-RIPER (14), SDD-RIPER-Opt (6), Superpowers (80+), PRD Analysis (7), 测试工程 (24+), 代码审查 (8+), Self-Improvement (6), Agent 定义 (25), 工具脚本 (10)
- **目录结构**: references/ (8大类: entry/spec-driven-development/checkpoint-driven/superpowers/testing/prd-analysis/agents/self-improvement), protocols/ (4), docs/ (5), scripts/ (10), .learnings/ (3)
