# ALTAS Workflow 参考资料总索引

> 本文件是 ALTAS Workflow 所有参考资料的统一发现入口。
> AI Agent 无需常驻全部内容，只需在命中场景时按需加载对应文件。

## 按需加载指南

当 `SKILL.md` 将任务路由到某一模式或阶段后，按以下顺序查找参考文件：

1. **最快路径**：从"按特殊模式索引"或"按工作流阶段索引"直接定位对应章节
2. **完整扫描**：需要了解全貌时，从"按来源分类索引"查看方法论来源
3. **规模规划**：需要规划完整加载集时，从"按规模等级索引"确认所需文件

**优先级**：
- "按特殊模式"和"按工作流阶段"对 AI 来说最直观，是日常使用的主要入口
- "按来源"和"按规模"主要在需要了解方法论背景或规划完整加载集时使用

> 若路径读取失败，先使用全局搜索定位；若文件确实缺失，则按标准模式继续，并明确提醒用户依赖不完整。

### Self-Improvement (自我进化)

| 文件 | 主题 |
|------|------|
| `references/self-improvement/SKILL.md` | 自我进化完整机制（触发/记录/晋升/提取） |
| `.learnings/LEARNINGS.md` | 学习条目日志 |
| `.learnings/ERRORS.md` | 错误条目日志 |
| `.learnings/FEATURE_REQUESTS.md` | 功能请求日志 |
| `scripts/self-improvement-activator.sh` | 自我进化激活钩子 |
| `scripts/error-detector.sh` | 错误检测钩子 |

---

## 流程可视化参考

| 文件 | 调用时机 |
|------|----------|
| `workflow-diagrams.md` | 需要可视化理解工作流、规模评估、铁律门禁、TDD循环、三轴评审等流程时 |

---

## 入口参考

| 文件 | 调用时机 |
|------|----------|
| `references/entry/aliases.md` | 需要确认入口触发词、别名，或查看 `MULTI` 模式控制词时 |
| `references/entry/first-response.md` | 需要初始化提示、首轮响应模板、澄清规则或原子化拆解要求时 |
| `references/entry/skill-content-map.md` | 需要核对 `SKILL.md` 精简后，被移出内容的落点映射时 |
| `references/entry/sources.md` | 需要了解入口整合来源、方法论来源映射或做工作流介绍时 |
| `references/entry/glossary.md` | 需要查看核心术语定义（Spec/CodeMap/SDD/RIPER/触发词/规模等级等）时 |
| `references/entry/discipline-enforcing.md` | Agent 即将违反铁律、使用借口绕过规则、或出现常见使用错误时 |
| `references/entry/exceptions-recovery.md` | 遇到问题升级、不确定、需要退出协议或能力降级时 |
| `references/self-improvement/SKILL.md` | 需要自我进化机制：记录学习、错误、功能请求、经验晋升、技能提取时 |

---

## 按工作流阶段索引

### PRE-RESEARCH / 输入准备

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/spec-driven-development/commands.md` | SDD-RIPER | 需要create_codemap/build_context_bundle/sdd_bootstrap命令参数时 |
| `references/spec-driven-development/sdd-riper-one-protocol.md` | SDD-RIPER | 需要完整协议定义时 |
| `references/spec-driven-development/workflow-quickref.md` | SDD-RIPER | 忘记流程快速查阅时 |

### RESEARCH / 研究对齐

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/spec-driven-development/spec-template.md` | SDD-RIPER | 写Spec (Size M/L) 时 |
| `references/checkpoint-driven/spec-lite-template.md` | SDD-RIPER-Opt | 写Spec (Size S) 时 |
| `references/checkpoint-driven/conventions.md` | SDD-RIPER-Opt | 需要落盘命名约定时 |

### INNOVATE / 方案对比

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/superpowers/brainstorming/SKILL.md` | Superpowers | Innovate阶段设计流程时 |
| `references/superpowers/brainstorming/visual-companion.md` | Superpowers | 设计需可视化展示时 |
| `references/superpowers/brainstorming/spec-document-reviewer-prompt.md` | Superpowers | 审查设计Spec时 |

### PLAN / 详细规划

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/superpowers/writing-plans/SKILL.md` | Superpowers | 写Plan拆解任务时 |
| `references/superpowers/writing-plans/plan-document-reviewer-prompt.md` | Superpowers | Plan文档审查时 |
| `references/testing/test-strategy-template.md` | ALTAS | 需要统一输出 `Test Strategy` 结构时 |

### EXECUTE / 代码实现

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/superpowers/test-driven-development/SKILL.md` | Superpowers | M/L 规模进入 Execute 时 |
| `references/superpowers/test-driven-development/testing-anti-patterns.md` | Superpowers | TDD 遇到阻力时 |
| `references/superpowers/test-driven-development/pytest-tdd-cycle.md` | Superpowers | pytest 版 TDD 循环（RED-GREEN-REFACTOR + Bug Fix + Spec-Aware） |
| `references/superpowers/subagent-driven-development/SKILL.md` | Superpowers | L 规模使用子agent时 |
| `references/superpowers/dispatching-parallel-agents/SKILL.md` | Superpowers | 并行执行多个检查点项时 |
| `references/testing/pytest-patterns.md` | Advanced Testing Skills | Python 项目编写测试时 |
| `references/testing/api-testing.md` | Advanced Testing Skills | Python API 项目编写测试时 |
| `references/testing/e2e-testing.md` | Advanced Testing Skills | Python E2E 测试时 |
| `references/testing/performance-testing.md` | Advanced Testing Skills | Python 性能/负载测试时 |
| `references/testing/test-data-management.md` | Advanced Testing Skills | 复杂测试数据场景（批量数据、关联对象、并发） |
| `references/testing/ci-cd-integration.md` | Advanced Testing Skills | CI/CD 集成需求或性能敏感功能 |
| `references/testing/test-quality-metrics.md` | Advanced Testing Skills | 质量门禁/度量报告需求 |
| `references/testing/contract-testing.md` | Advanced Testing Skills | 微服务项目契约测试（Pact CDC） |
| `references/testing/visual-testing.md` | Advanced Testing Skills | 视觉回归测试（Chromatic/Playwright） |
| `references/testing/security-testing.md` | Advanced Testing Skills | 安全测试（SAST/DAST/SCA） |
| `references/testing/test-observability.md` | Advanced Testing Skills | 测试可观测性（日志/追踪/指标） |
| `references/testing/mobile-testing.md` | Advanced Testing Skills | 移动端测试（iOS/Android） |
| `references/testing/test-maintenance.md` | Advanced Testing Skills | 测试维护（Flaky 处理/重构/债务管理） |
| `references/testing/test-environment.md` | Advanced Testing Skills | 测试环境管理（Test Containers/Docker Compose/隔离） |
| `references/testing/go-testing.md` | Advanced Testing Skills | Go 项目测试（testify/ginkgo） |
| `protocols/PROTOCOL-SELECTION.md` | ALTAS | 需要切换协议时 |
| `references/superpowers/requesting-code-review/spec-quality-metrics.md` | ALTAS | REVIEW SPEC 阶段质量评估时 |

#### 非 Python 项目测试参考

| 语言 | 测试参考文档 | 测试框架 | 运行命令 |
|------|-------------|---------|----------|
| Go | `references/testing/go-testing.md` | `testing` 内置 + `testify` / `ginkgo` | `go test ./...` |

### REVIEW / 审查

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/checkpoint-driven/checkpoints.md` | ALTAS | 需要完整检查点模板、暂停规则或 Batch Override 约束时 |
| `references/checkpoint-driven/modules.md` | SDD-RIPER-Opt | 进入Review时 (含Deep/Debug/Review/Multi模块) |
| `references/superpowers/verification-before-completion/SKILL.md` | Superpowers | 完成前验证时 |
| `references/superpowers/requesting-code-review/SKILL.md` | Superpowers | 请求代码审查时 |
| `references/superpowers/requesting-code-review/code-reviewer.md` | Superpowers | 派遣审查Agent模板 |
| `references/superpowers/receiving-code-review/SKILL.md` | Superpowers | 收到审查反馈时 |

### ARCHIVE / 知识沉淀

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/spec-driven-development/archive-template.md` | SDD-RIPER | 进入Archive时 |
| `scripts/archive_builder.py` | SDD-RIPER-Opt | 自动化归档生成时 |
| `references/superpowers/finishing-a-development-branch/SKILL.md` | Superpowers | 完成分支决策时 |

### PRD 分析 / 需求文档

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/prd-analysis/SKILL.md` | specify-requirements | PRD分析完整工作流（Brainstorm → Discover → Document → Review → Validate） |
| `references/prd-analysis/template.md` | specify-requirements | PRD模板结构（产品概述/用户画像/旅程/功能需求/成功指标） |
| `references/prd-analysis/validation.md` | specify-requirements | PRD验证清单（结构验证/内容质量/边界验证/跨节一致性） |
| `references/prd-analysis/reference/output-format.md` | specify-requirements | PRD状态报告格式和多角度最终验证指南 |
| `references/prd-analysis/examples/good-prd.md` | specify-requirements | 优质PRD参考示例 |
| `references/prd-analysis/examples/output-example.md` | specify-requirements | 预期输出格式具体示例 |

---

## 测试工程师快速入口

| 我要做 | 先加载 | 再加载 | 可选 |
|--------|--------|--------|------|
| **起测试骨架** | `references/testing/test-scaffold-templates.md` | `references/testing/pytest-patterns.md` | `references/testing/templates/conftest.py` |
| **写 API 测试** | `references/testing/api-testing.md` | `references/testing/pytest-patterns.md` | `references/testing/test-data-management.md` |
| **写契约测试** | `references/testing/contract-testing.md` | `references/testing/api-testing.md` | `references/testing/ci-cd-integration.md` |
| **写 Go 测试** | `references/testing/go-testing.md` | `references/testing/api-testing.md` | `references/testing/contract-testing.md` |
| **写 E2E 测试** | `references/testing/e2e-testing.md` | `references/testing/pytest-patterns.md` | `references/testing/api-testing.md` |
| **写性能测试** | `references/testing/performance-testing.md` | `references/testing/pytest-patterns.md` | `references/testing/ci-cd-integration.md` |
| **写安全测试** | `references/testing/security-testing.md` | `references/testing/api-testing.md` §11 | `references/testing/ci-cd-integration.md` |
| **写视觉测试** | `references/testing/visual-testing.md` | `references/testing/e2e-testing.md` | `references/testing/pytest-patterns.md` |
| **移动端测试** | `references/testing/mobile-testing.md` | `references/testing/e2e-testing.md` | `references/testing/api-testing.md` |
| **测试可观测性** | `references/testing/test-observability.md` | `references/testing/test-quality-metrics.md` | `references/superpowers/systematic-debugging/SKILL.md` |
| **补测试覆盖率** | `references/special-modes/test.md` | `references/testing/pytest-patterns.md` | `references/testing/test-task-pressure-scenarios.md` |
| **PRD 可测试性评审** | `references/prd-analysis/testability-checklist.md` | `references/prd-analysis/SKILL.md` | `references/special-modes/test.md` |
| **优化 CI 测试** | `references/testing/ci-cd-integration.md` | `references/testing/test-quality-metrics.md` | `references/testing/test-maintenance.md` |
| **搭建测试环境** | `references/testing/test-environment.md` | `references/testing/ci-cd-integration.md` | `references/testing/test-data-management.md` |
| **维护测试套件** | `references/testing/test-maintenance.md` | `references/testing/test-review-checklist.md` | `references/testing/test-quality-metrics.md` |
| **TDD 开发新功能** | `references/superpowers/test-driven-development/SKILL.md` | `references/testing/pytest-patterns.md` | `references/superpowers/test-driven-development/pytest-tdd-cycle.md` |

---

## 按特殊模式索引

### DEBUG 模式

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/superpowers/systematic-debugging/SKILL.md` | Superpowers | 进入 Debug 模式时 |
| `references/superpowers/systematic-debugging/root-cause-tracing.md` | Superpowers | 根因不明需追溯时 |
| `references/superpowers/systematic-debugging/defense-in-depth.md` | Superpowers | 需要多层防御时 |
| `references/superpowers/systematic-debugging/condition-based-waiting.md` | Superpowers | 异步/条件等待问题时 |
| `references/special-modes/debug.md` | Special Modes | DEBUG 模式协议入口 |

### MULTI 模式

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/spec-driven-development/multi-project.md` | SDD-RIPER | 多项目协作时 |
| `references/checkpoint-driven/modules.md` (Multi-project 模块) | SDD-RIPER-Opt | 多项目场景时 |

### DOC 模式

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `protocols/RIPER-DOC.md` | SDD-RIPER | 文档撰写模式时 |
| `references/special-modes/doc.md` | Special Modes | DOC 模式协议入口 |

### REVIEW 模式 (新增)

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/special-modes/review.md` | Special Modes | 进入 REVIEW 模式时 |
| `references/checkpoint-driven/modules.md` (Review 模块) | SDD-RIPER-Opt | 三轴评审标准 |
| `references/superpowers/requesting-code-review/SKILL.md` | Superpowers | 请求代码审查时 |
| `references/superpowers/receiving-code-review/SKILL.md` | Superpowers | 接收审查反馈时 |

### REFACTOR 模式 (新增)

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/special-modes/refactor.md` | Special Modes | 进入 REFACTOR 模式时 |
| `references/superpowers/test-driven-development/SKILL.md` | Superpowers | TDD 执行验证 |
| `references/spec-driven-development/commands.md` (create_codemap) | SDD-RIPER | CodeMap 生成 |

### TEST 模式 (新增)

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/special-modes/test.md` | Special Modes | 进入 TEST 模式时 |
| `references/testing/test-strategy-template.md` | ALTAS | 需要统一 `Test Strategy` 字段结构时 |
| `references/prd-analysis/testability-checklist.md` | PRD Analysis | PRD 阶段进行可测试性评审时 |
| `references/testing/pytest-patterns.md` | Advanced Testing Skills | Python 项目编写测试时 |
| `references/testing/api-testing.md` | Advanced Testing Skills | Python API 项目编写测试时 |
| `references/testing/e2e-testing.md` | Advanced Testing Skills | Python E2E 测试时 |
| `references/testing/performance-testing.md` | Advanced Testing Skills | Python 性能/负载测试时 |
| `references/testing/visual-testing.md` | Advanced Testing Skills | 视觉回归测试（Chromatic/Playwright）时 |
| `references/testing/security-testing.md` | Advanced Testing Skills | 安全测试（SAST/DAST/SCA）时 |
| `references/testing/test-observability.md` | Advanced Testing Skills | 测试可观测性（日志/追踪/指标）时 |
| `references/testing/mobile-testing.md` | Advanced Testing Skills | 移动端测试（iOS/Android）时 |
| `references/testing/test-scaffold-templates.md` | Advanced Testing Skills | 需要快速生成 pytest/API 测试骨架时 |
| `references/testing/test-quality-metrics.md` | Advanced Testing Skills | 需要输出 coverage/pass rate/flaky risk/slow tests/mock ratio 等质量度量时 |
| `references/testing/test-task-pressure-scenarios.md` | Advanced Testing Skills | 需要验证 TEST 模式纪律执行力或做压力回归时 |
| `references/testing/ci-cd-integration.md` | Advanced Testing Skills | 需要 CI/CD 测试集成、回归测试选择、安全扫描、报告自动化时 |
| `references/testing/test-maintenance.md` | Advanced Testing Skills | 需要测试维护、Flaky 处理、重构策略、债务管理时 |
| `references/testing/test-review-checklist.md` | Advanced Testing Skills | 需要测试代码审查清单时 |
| `references/testing/test-data-management.md` | Advanced Testing Skills | 需要测试数据管理（factory/fixture/seed/清理）时 |
| `references/testing/contract-testing.md` | Advanced Testing Skills | 微服务项目契约测试（Pact CDC）时 |
| `references/superpowers/test-driven-development/SKILL.md` | Superpowers | TDD 最佳实践 |
| `references/superpowers/test-driven-development/testing-anti-patterns.md` | Superpowers | 测试反模式 |
| `references/superpowers/test-driven-development/pytest-tdd-cycle.md` | Superpowers | pytest TDD 完整循环 |

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
| 写安全测试 | `references/testing/security-testing.md` | `references/testing/api-testing.md` §11 | `references/testing/ci-cd-integration.md` |
| 移动端测试 | `references/testing/mobile-testing.md` | `references/testing/e2e-testing.md` | `references/testing/api-testing.md` |
| 测试可观测性 | `references/testing/test-observability.md` | `references/testing/test-quality-metrics.md` | `references/superpowers/systematic-debugging/SKILL.md` |
| PRD 可测试性评审 | `references/prd-analysis/testability-checklist.md` | `references/prd-analysis/SKILL.md` | `references/special-modes/test.md` |
| 优化 CI 测试 | `references/testing/ci-cd-integration.md` | `references/testing/test-quality-metrics.md` | `references/testing/test-maintenance.md` |
| 搭建测试环境 | `references/testing/test-environment.md` | `references/testing/ci-cd-integration.md` | `references/testing/test-data-management.md` |
| 维护测试套件 | `references/testing/test-maintenance.md` | `references/testing/test-review-checklist.md` | `references/testing/test-quality-metrics.md` |
| 补测试覆盖率 | `references/testing/pytest-patterns.md` | `references/testing/test-task-pressure-scenarios.md` | `references/testing/test-data-management.md` |
| 安全合规测试 | `references/testing/api-testing.md` §11 | `references/testing/security-testing.md` | `references/testing/ci-cd-integration.md` |

### PERF 模式 (新增)

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/special-modes/perf.md` | Special Modes | 进入 PERF 模式时 |
| `references/superpowers/verification-before-completion/SKILL.md` | Superpowers | 验证策略 |
| `references/superpowers/finishing-a-development-branch/SKILL.md` | Superpowers | 完成分支决策 |

### MIGRATE 模式 (新增)

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/special-modes/migrate.md` | Special Modes | 进入 MIGRATE 模式时 |
| `references/superpowers/brainstorming/SKILL.md` | Superpowers | 风险评估 |
| `references/superpowers/verification-before-completion/SKILL.md` | Superpowers | 迁移后验证 |

### PRD 分析模式 (新增)

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/prd-analysis/SKILL.md` | specify-requirements | 进入 PRD 分析模式时 |
| `references/prd-analysis/template.md` | specify-requirements | 使用 PRD 模板结构时 |
| `references/prd-analysis/validation.md` | specify-requirements | 运行 PRD 验证清单时 |
| `references/prd-analysis/reference/output-format.md` | specify-requirements | 生成 PRD 状态报告时 |
| `references/prd-analysis/examples/good-prd.md` | specify-requirements | 参考优质 PRD 示例时 |

### 🆕 SELF-IMPROVEMENT 模式 (v4.8)

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/self-improvement/SKILL.md` | Self-Improvement Agent | 需要记录学习、错误、功能请求、经验晋升、技能提取时 |
| `.learnings/LEARNINGS.md` | Self-Improvement Agent | 回顾已记录的学习条目、纠正、知识缺口、最佳实践时 |
| `.learnings/ERRORS.md` | Self-Improvement Agent | 回顾已记录的命令失败、异常、意外行为时 |
| `.learnings/FEATURE_REQUESTS.md` | Self-Improvement Agent | 回顾已记录的用户请求的不支持能力时 |

---

## 按来源分类索引

### SDD-RIPER (Spec-Driven Development)

| 文件 | 主题 |
|------|------|
| `references/spec-driven-development/sdd-riper-one-protocol.md` | 完整RIPER协议 (696行) |
| `references/spec-driven-development/spec-template.md` | Spec模板 (单项目+多项目) |
| `references/spec-driven-development/commands.md` | 7个原生命令详细参数 |
| `references/spec-driven-development/workflow-quickref.md` | 快速参考卡 |
| `references/spec-driven-development/usage-examples.md` | 使用示例 (含多项目/Debug/Archive) |
| `references/spec-driven-development/multi-project.md` | 多项目协作规则 |
| `references/spec-driven-development/archive-template.md` | Archive输出模板 |
| `protocols/RIPER-5.md` | 严格模式协议 |
| `protocols/RIPER-DOC.md` | 文档专家协议 |
| `protocols/SDD-RIPER-DUAL-COOP.md` | 双模型协作协议 |
| `docs/从传统编程转向大模型编程.md` | 方法论: 范式转换 |
| `docs/团队落地指南.md` | 方法论: 团队推广 |
| `docs/如何快速从零开始落地大模型编程-手把手教程.md` | 方法论: 入门教程 |
| `docs/AI-原生研发范式-从代码中心到文档驱动的演进.md` | 方法论: 理论深化 |
| `docs/IMPLEMENTATION-PLAN-v4.6.md` | 方法论: 版本升级实施方案 |

### SDD-RIPER-Optimized (Checkpoint-Driven)

| 文件 | 主题 |
|------|------|
| `references/agents/sdd-riper-one-light/SKILL.md` | 轻量Skill定义 |
| `references/checkpoint-driven/spec-lite-template.md` | 最小Spec模板 |
| `references/checkpoint-driven/modules.md` | 按需模块 (Deep/Debug/Review/Multi) |
| `references/checkpoint-driven/conventions.md` | 命名与目录约定 |
| `references/agents/sdd-riper-one/SKILL.md` | 标准版 Skill |
| `references/agents/sdd-riper-one-light/SKILL.md` | 轻量版 Skill |

### Superpowers

| 文件 | 主题 |
|------|------|
| `references/superpowers/brainstorming/SKILL.md` | 设计头脑风暴 |
| `references/superpowers/brainstorming/visual-companion.md` | 视觉设计辅助 |
| `references/superpowers/brainstorming/spec-document-reviewer-prompt.md` | 设计Spec审查 |
| `references/superpowers/writing-plans/SKILL.md` | 写Plan最佳实践 |
| `references/superpowers/writing-plans/plan-document-reviewer-prompt.md` | Plan文档审查 |
| `references/superpowers/executing-plans/SKILL.md` | 执行Plan (非Subagent) |
| `references/superpowers/test-driven-development/SKILL.md` | TDD铁律 |
| `references/superpowers/test-driven-development/testing-anti-patterns.md` | 测试反模式 |
| `references/superpowers/systematic-debugging/SKILL.md` | 系统化Debug四阶段 |
| `references/superpowers/systematic-debugging/root-cause-tracing.md` | 根因追踪 |
| `references/superpowers/systematic-debugging/defense-in-depth.md` | 纵深防御 |
| `references/superpowers/systematic-debugging/condition-based-waiting.md` | 条件等待 |
| `references/superpowers/subagent-driven-development/SKILL.md` | Subagent驱动开发 |
| `references/superpowers/subagent-driven-development/implementer-prompt.md` | 实现者提示 |
| `references/superpowers/subagent-driven-development/spec-reviewer-prompt.md` | Spec审查提示 |
| `references/superpowers/subagent-driven-development/code-quality-reviewer-prompt.md` | 代码质量审查提示 |
| `references/superpowers/dispatching-parallel-agents/SKILL.md` | 并行Agent派遣 |
| `references/superpowers/verification-before-completion/SKILL.md` | 完成前验证 |
| `references/superpowers/implementation-verify/SKILL.md` | 实现验证（实现与 Spec 一致性校验） |
| `references/superpowers/finishing-a-development-branch/SKILL.md` | 完成分支 |
| `references/superpowers/requesting-code-review/SKILL.md` | 请求代码审查 |
| `references/superpowers/requesting-code-review/code-reviewer.md` | 审查Agent模板 |
| `references/superpowers/receiving-code-review/SKILL.md` | 接收代码审查 |
| `references/superpowers/using-git-worktrees/SKILL.md` | Git Worktree管理 |
| `references/superpowers/using-superpowers/SKILL.md` | Superpowers使用总纲 |
| `references/superpowers/writing-skills/SKILL.md` | 编写Skill |
| `references/superpowers/writing-skills/persuasion-principles.md` | Skill说服原则 |
| `references/superpowers/writing-skills/testing-skills-with-subagents.md` | Skill测试方法 |
| `references/code-review/code-reviewer.md` | 代码审查Agent定义 |

### PRD Analysis (specify-requirements)

| 文件 | 主题 |
|------|------|
| `references/prd-analysis/SKILL.md` | PRD分析完整工作流定义 |
| `references/prd-analysis/template.md` | PRD模板结构（10大章节） |
| `references/prd-analysis/validation.md` | PRD验证清单（结构/质量/边界/一致性） |
| `references/prd-analysis/reference/output-format.md` | 状态报告和多角度验证指南 |
| `references/prd-analysis/examples/good-prd.md` | 优质PRD示例参考 |
| `references/prd-analysis/examples/output-example.md` | 预期输出格式示例 |
| `references/prd-analysis/testability-checklist.md` | PRD可测试性评审清单 |

### Agent 定义与参考资料

#### SDD-RIPER-ONE 标准版

| 文件 | 主题 |
|------|------|
| `references/agents/sdd-riper-one/SKILL.md` | 标准版 Skill 定义 |
| `references/agents/sdd-riper-one/README.md` | Agent 使用说明 |
| `references/agents/sdd-riper-one/CHANGELOG.md` | 版本变更日志 |
| `references/agents/sdd-riper-one/agents.md` | Agent 配置文件 |
| `references/agents/sdd-riper-one/agents/openai.yaml` | OpenAI Agent 配置 |
| `references/agents/sdd-riper-one/references/sdd-riper-one-protocol.md` | Agent 专用 RIPER 协议 |
| `references/agents/sdd-riper-one/references/spec-template.md` | Agent 专用 Spec 模板 |
| `references/agents/sdd-riper-one/references/commands.md` | Agent 专用命令参数 |
| `references/agents/sdd-riper-one/references/workflow-quickref.md` | Agent 快速参考 |
| `references/agents/sdd-riper-one/references/multi-project.md` | Agent 多项目协作规则 |
| `references/agents/sdd-riper-one/references/archive-template.md` | Agent 专用归档模板 |
| `references/agents/sdd-riper-one/references/usage-examples.md` | Agent 使用示例 |

#### SDD-RIPER-ONE Light 轻量版

| 文件 | 主题 |
|------|------|
| `references/agents/sdd-riper-one-light/SKILL.md` | 轻量版 Skill 定义 |
| `references/agents/sdd-riper-one-light/README.md` | 轻量版使用说明 |
| `references/agents/sdd-riper-one-light/CHANGELOG.md` | 轻量版变更日志 |
| `references/agents/sdd-riper-one-light/references/spec-lite-template.md` | 轻量版 Spec 模板 |
| `references/agents/sdd-riper-one-light/references/conventions.md` | 轻量版命名约定 |
| `references/agents/sdd-riper-one-light/references/modules.md` | 轻量版按需模块 |
| `references/agents/sdd-riper-one-light/examples/README.md` | 示例说明 |
| `references/agents/sdd-riper-one-light/examples/codemap/codemap-feature-content-control.md` | CodeMap 示例 |
| `references/agents/sdd-riper-one-light/examples/specs/spec-light-runtime-compat.md` | 运行时兼容 Spec 示例 |
| `references/agents/sdd-riper-one-light/examples/specs/spec-standard-security-status-race.md` | 竞态条件 Spec 示例 |

### Self-Improvement 参考索引

| 文件 | 主题 |
|------|------|
| `references/self-improvement/SKILL.md` | 自我进化完整机制 |
| `references/self-improvement/assets/SKILL-TEMPLATE.md` | 技能模板 |
| `references/self-improvement/references/examples.md` | 自我进化示例 |
| `references/self-improvement/references/hooks-setup.md` | Hook 配置说明 |
| `references/self-improvement/references/openclaw-integration.md` | OpenClaw 集成指南 |

### Writing Skills 参考索引

| 文件 | 主题 |
|------|------|
| `references/superpowers/writing-skills/SKILL.md` | 编写 Skill |
| `references/superpowers/writing-skills/persuasion-principles.md` | Skill 说服原则 |
| `references/superpowers/writing-skills/testing-skills-with-subagents.md` | Skill 测试方法 |
| `references/superpowers/writing-skills/anthropic-best-practices.md` | Anthropic 最佳实践 |
| `references/superpowers/writing-skills/examples/CLAUDE_MD_TESTING.md` | Claude.md 测试示例 |
| `references/superpowers/writing-skills/graphviz-conventions.dot` | Graphviz 流程图源文件 |
| `references/superpowers/writing-skills/render-graphs.js` | Graphviz 渲染脚本 |

### Using Superpowers 平台工具映射

| 文件 | 主题 |
|------|------|
| `references/superpowers/using-superpowers/SKILL.md` | Superpowers 使用总纲 |
| `references/superpowers/using-superpowers/references/copilot-tools.md` | GitHub Copilot CLI 工具映射 |
| `references/superpowers/using-superpowers/references/codex-tools.md` | OpenAI Codex 工具映射 |
| `references/superpowers/using-superpowers/references/gemini-tools.md` | Google Gemini 工具映射 |

### Systematic Debugging 测试索引

| 文件 | 主题 |
|------|------|
| `references/superpowers/systematic-debugging/SKILL.md` | 系统化 Debug 四阶段 |
| `references/superpowers/systematic-debugging/root-cause-tracing.md` | 根因追踪 |
| `references/superpowers/systematic-debugging/defense-in-depth.md` | 纵深防御 |
| `references/superpowers/systematic-debugging/condition-based-waiting.md` | 条件等待 |
| `references/superpowers/systematic-debugging/CREATION-LOG.md` | Skill 创建日志 |
| `references/superpowers/systematic-debugging/test-academic.md` | 学术场景测试 |
| `references/superpowers/systematic-debugging/test-pressure-1.md` | 压力测试场景 1 |
| `references/superpowers/systematic-debugging/test-pressure-2.md` | 压力测试场景 2 |
| `references/superpowers/systematic-debugging/test-pressure-3.md` | 压力测试场景 3 |

### Subagent-Driven Development 提示词

| 文件 | 主题 |
|------|------|
| `references/superpowers/subagent-driven-development/SKILL.md` | Subagent 驱动开发 |
| `references/superpowers/subagent-driven-development/implementer-prompt.md` | 实现者 Agent 提示词 |
| `references/superpowers/subagent-driven-development/spec-reviewer-prompt.md` | Spec 审查 Agent 提示词 |
| `references/superpowers/subagent-driven-development/code-quality-reviewer-prompt.md` | 代码质量审查 Agent 提示词 |

### Code Review 参考索引

> **⚠️ 重要**：所有代码审查任务**必须**先通过 `receiving-code-review/SKILL.md` 进入，然后再根据代码语言分发到对应的语言专家。
>
> **流程**：`receiving-code-review` → 识别语言 → `python-code-review` / `go-code-review` → `implementation-verify`

#### Code Review 入口（必经）

| 文件 | 主题 |
|------|------|
| `references/superpowers/receiving-code-review/SKILL.md` | **代码审查入口**：验证反馈合理性、识别代码语言、分发到语言专家 |

#### Go 代码审查

| 文件 | 主题 |
|------|------|
| `references/code-review/go/SKILL.md` | Go 代码审查主流程 |
| `references/code-review/go/references/WEB-SERVER.md` | Web 服务器审查要点 |
| `references/code-review/go/assets/review-template.md` | Go 审查报告模板 |

#### Python 代码审查

| 文件 | 主题 |
|------|------|
| `references/code-review/python/SKILL.md` | Python 代码审查主流程 |
| `references/code-review/python/references/pep8-style.md` | PEP8 风格规范 |
| `references/code-review/python/references/type-safety.md` | 类型安全检查 |
| `references/code-review/python/references/async-patterns.md` | 异步模式检查 |
| `references/code-review/python/references/error-handling.md` | 错误处理检查 |
| `references/code-review/python/references/common-mistakes.md` | 常见错误汇总 |

### Testing 模板索引

| 文件 | 主题 |
|------|------|
| `references/testing/templates/conftest.py` | pytest conftest 基础模板 |
| `references/testing/templates/api_client_fixture.py` | API 客户端 fixture 模板 |
| `references/testing/templates/auth_fixture.py` | 认证 fixture 模板 |
| `references/testing/templates/db_rollback_fixture.py` | 数据库回滚 fixture 模板 |
| `references/testing/templates/factories.py` | 测试工厂模板 |
| `references/testing/templates/pytest_config.toml` | pytest 配置模板 |
| `references/testing/templates/api_test_matrix.md` | API 测试矩阵模板 |
| `references/testing/templates/test_report.md` | 测试报告模板 |

### Spec-Driven-Development 使用示例

| 文件 | 主题 |
|------|------|
| `references/spec-driven-development/usage-examples.md` | SDD-RIPER 使用示例 (含多项目/Debug/Archive) |

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

- **参考文件总数**: 149 (MD), 185+ (含脚本/模板等非 MD 文件)
- **来源分布**: SDD-RIPER (14), SDD-RIPER-Opt (6), Superpowers (80+), PRD Analysis (7), 测试工程 (24+), 代码审查 (8+), Self-Improvement (6), Agent 定义 (25), 工具脚本 (10)
- **目录结构**: references/ (8大类: entry/spec-driven-development/checkpoint-driven/superpowers/testing/prd-analysis/agents/self-improvement), protocols/ (4), docs/ (5), scripts/ (10), .learnings/ (3)
