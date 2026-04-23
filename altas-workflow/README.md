# ALTAS Workflow

> **融合三方优势 | 智能深度适配 | 渐进式披露 | 每步可反馈 | 测试工程师友好 | 自我进化**

**Version:** 4.11 (2026-04-19)

ALTAS Workflow 是一套汲取了 SDD-RIPER、SDD-RIPER-Optimized 与 Superpowers 精华的综合性 AI 工作流程规范，并增强了**测试工程专项**、**代码审查技能包**、**PRD 分析工作流**和**自我进化机制**能力。

本规范致力于解决 AI 编程中的**上下文腐烂**、**审查瘫痪**、**代码不信任**、**难以维护**以及**测试覆盖不足**等核心工程痛点，同时通过自我进化机制实现持续迭代提升。

---

## 核心特性

### 1. 项目规模智能评估

告别"杀鸡用牛刀"或"大意失荆州"。ALTAS 根据复杂度、影响面、决策点自动选择适配的工作流深度：

| 规模 | Spec要求 | 工作流 |
|------|----------|--------|
| **XS 极速** | 跳过，事后1行summary | 直接执行→验证→summary |
| **S 快速** | micro-spec (1-3句) | micro-spec→批准→执行→回写 |
| **M 标准** | 轻量Spec落盘 | Research→Plan→Execute(TDD)→Review |
| **L 深度** | 完整Spec+Innovate+Archive | Research→Innovate→Plan→Execute(TDD)→Subagent→Review→Archive |

### 2. 流程进度可视化

每步完成后输出标准化检查点：
- 进度条展示当前阶段
- 当前成果 + 预期产出
- 结构化下一步操作指引（`[继续]`/`[修改]`/`[升级]`/`[降级]`）

### 3. 渐进式披露

- Research只谈逻辑约束，Plan只谈接口签名与Checklist，Execute才写代码
- 复杂细节写入磁盘Spec，对话中只呈现摘要和高危风险
- 参考文档按需加载，不常驻上下文

### 4. 🆕 测试工程师专项支持 (v4.7)

完整的测试工程体系，覆盖 E2E、API、性能、安全等多维度测试：

| 能力 | 说明 |
|------|------|
| **E2E 测试框架** | Playwright/Cypress 集成指南与最佳实践 |
| **性能/负载测试** | 压测策略、基准测试、性能指标体系 |
| **API 测试完整流程** | 契约测试、安全测试、API 测试矩阵模板 |
| **Pytest 测试模式** | Fixture 设计、参数化、Mock 策略、覆盖率 |
| **测试数据管理** | 工厂模式、Fixture 层级、测试隔离 |
| **测试环境管理** | Docker Compose、依赖注入、环境一致性 |
| **CI/CD 集成测试** | 自动化流水线、质量门禁、测试报告 |
| **测试脚手架模板** | 开箱即用的 conftest.py / factories / fixtures |

### 5. 🆕 代码审查技能包 (v4.7)

多语言代码审查标准化流程：

| 语言 | 审查维度 |
|------|----------|
| **Go** | 静态分析、并发安全、性能审计、错误处理规范 |
| **Python** | 类型安全、异步模式、错误处理、代码风格 |

### 6. 🆕 PRD 分析工作流 (v4.7)

结构化需求分析五阶段流程：

```
Brainstorm → Discover → Document → Review → Validate
```

### 7. 🆕 自我进化机制 (v4.8)

使用过程中自动记录、总结、晋升经验，使工作流持续进化：

| 能力 | 说明 |
|------|------|
| **自动检测** | 用户纠正、命令失败、知识缺口、更优方案自动识别 |
| **三日志文件** | LEARNINGS（学习）/ ERRORS（错误）/ FEATURE_REQUESTS（功能请求） |
| **晋升机制** | 重复出现 3 次+、跨 2 任务+、30 天内的经验晋升到工作流规则 |
| **技能提取** | 通用经验提取为独立 Skill，可跨项目复用 |

### 8. 快速启动

5分钟武装你的AI Agent。详见 [QUICKSTART.md](./QUICKSTART.md)

---

## 架构支柱

1. **Spec is Truth**: 代码是消耗品，Spec才是资产
2. **No Approval, No Execute**: 审代码前置为审计划
3. **Evidence First**: 完成由验证结果证明，非模型自宣布
4. **No Fixes Without Root Cause**: 系统化调试，禁止盲改
5. **TDD Iron Law**: M/L规模先写失败测试再写生产代码
6. **Reverse Sync**: Bug先修Spec再修代码
7. **🆕 Test Coverage First**: 测试覆盖率作为质量门禁
8. **🆕 Code Quality Standards**: 代码审查作为发布前置条件
9. **🆕 Log & Promote Learnings**: 每次任务后自检学习，满足条件的经验晋升到工作流规则

---

## 来源整合

| 来源 | 采纳的核心优势 |
|------|---------------|
| **SDD-RIPER** | Spec中心论、RIPER状态机、三轴Review、Multi-Project自动发现、Debug/Archive协议 |
| **SDD-RIPER-Optimized** | Checkpoint-Driven轻量模式、4级任务深度(zero/fast/standard/deep)、Done Contract、Resume Ready、Hot/Warm/Cold上下文装配 |
| **Superpowers** | TDD铁律与反模式、系统化Debug四阶段法、Subagent驱动+两阶段Review、并行Agent派遣、验证优先铁律、Rationalization预防表 |
| **🆕 Testing Engineering** | E2E/API/Performance/Security测试方法论、Pytest最佳实践、CI/CD集成、测试脚手架模板 |
| **🆕 Code Review Skills** | Go/Python静态分析、类型安全检查、并发安全审计、性能优化建议 |
| **🆕 PRD Analysis** | 结构化需求分析方法论、PRD模板与校验标准、质量度量四维度评估 |
| **🆕 Self-Improvement** | 自动学习记录、经验晋升、技能提取、持续进化机制 |

---

## 目录导航

### 核心文件

| 文件 | 说明 |
|------|------|
| [SKILL.md](./SKILL.md) | Bootstrap 入口提示词（供AI读取，负责路由/规模/门禁） - v4.8 |
| [QUICKSTART.md](./QUICKSTART.md) | 快速启动命令与典型场景 |
| [reference-index.md](./reference-index.md) | 参考资料统一索引入口 |
| [workflow-diagrams.md](./workflow-diagrams.md) | Mermaid 流程图集（可视化参考） |
| [SKILL-entry-review.md](./SKILL-entry-review.md) | SKILL.md 持续复核文档 |

### 目录结构

```
altas-workflow/
├── SKILL.md                    # 主入口 Skill v4.8
├── QUICKSTART.md               # 快速启动指南
├── reference-index.md          # 参考资料总索引
├── workflow-diagrams.md        # 流程图集
├── SKILL-entry-review.md       # Skill 复核文档
├── .learnings/                 # 🆕 自我进化日志 (3)
│   ├── LEARNINGS.md            # 学习/纠正/最佳实践
│   ├── ERRORS.md               # 命令失败/异常
│   └── FEATURE_REQUESTS.md     # 用户请求的不支持能力
├── references/                 # 按需加载的参考资料 (100+)
│   ├── entry/                  # 入口相关 (5)
│   ├── spec-driven-development/# SDD-RIPER 完整协议 (7)
│   ├── checkpoint-driven/      # Checkpoint 轻量模式 (4)
│   ├── superpowers/            # TDD/Debug/Subagent 技能 (50+)
│   │   ├── test-driven-development/  # TDD 铁律
│   │   ├── systematic-debugging/     # 系统化 Debug
│   │   ├── subagent-driven-development/ # Subagent 驱动
│   │   ├── brainstorming/            # 设计头脑风暴
│   │   ├── writing-plans/            # 写 Plan 最佳实践
│   │   ├── code-review/              # 🆕 代码审查 (Go/Python)
│   │   └── ... (更多超级能力)
│   ├── special-modes/          # 特殊模式协议 (5)
│   │   ├── test.md             # 🆕 TEST 模式
│   │   ├── perf.md             # 🆕 PERF 模式
│   │   ├── review.md           # 🆕 REVIEW 模式
│   │   ├── refactor.md         # 🆕 REFACTOR 模式
│   │   └── migrate.md          # 🆕 MIGRATE 模式
│   ├── prd-analysis/           # 🆕 PRD 分析工作流 (6)
│   │   ├── SKILL.md            # PRD 分析主流程
│   │   ├── template.md         # PRD 模板
│   │   ├── validation.md       # PRD 校验标准
│   │   └── examples/           # PRD 示例
│   ├── testing/                # 🆕 测试工程专项 (18+)
│   │   ├── test-strategy-template.md    # 测试策略模板
│   │   ├── pytest-patterns.md           # Pytest 最佳实践
│   │   ├── e2e-testing.md               # E2E 测试指引
│   │   ├── api-testing.md               # API 测试参考
│   │   ├── performance-testing.md       # 性能测试方法论
│   │   ├── security-testing.md          # 安全测试
│   │   ├── contract-testing.md          # 契约测试
│   │   ├── test-data-management.md      # 测试数据管理
│   │   ├── test-environment.md          # 测试环境管理
│   │   ├── ci-cd-integration.md         # CI/CD 集成
│   │   └── templates/                   # 测试脚手架模板
│   ├── self-improvement/       # 🆕 自我进化机制
│   │   └── SKILL.md            # 自我进化完整机制
│   └── agents/                 # Agent 定义 (22)
│       ├── sdd-riper-one/      # 标准 RIPER Agent
│       └── sdd-riper-one-light/# Checkpoint 轻量 Agent
├── protocols/                  # 专用协议 (4)
│   ├── RIPER-5.md              # 严格模式
│   ├── RIPER-DOC.md            # 文档专家
│   ├── SDD-RIPER-DUAL-COOP.md  # 双模型协作
│   └── PROTOCOL-SELECTION.md   # 协议选择指南
├── docs/                       # 方法论文档 (5)
└── scripts/                    # 自动化工具 (5)
    ├── archive_builder.py      # Archive 构建器
    ├── scaffold.py             # 项目脚手架
    ├── validate_aliases_sync.py # 别名同步验证
    ├── self-improvement-activator.sh # 🆕 自我进化激活钩子
    └── error-detector.sh       # 🆕 错误检测钩子
```

---

## 参考资料索引

所有参考文件的统一索引位于 [reference-index.md](./reference-index.md)，包含：
- 按工作流阶段索引（PRE-RESEARCH → ARCHIVE）
- 按特殊模式索引（DEBUG / MULTI / DOC / REVIEW / REFACTOR / TEST / PERF / MIGRATE / PRD）
- 按来源分类索引（SDD-RIPER / Superpowers / Testing / PRD Analysis / Self-Improvement）
- 按规模等级索引（XS / S / M / L）
- Agent 定义与参考资料索引
- Testing 模板索引 / Code Review 参考索引

> 入口触发词、别名与 `MULTI` 模式控制词统一维护在 [references/entry/aliases.md](./references/entry/aliases.md)。

---

## 统计

- **参考文件总数**: 147+ (MD), 185+ (含脚本/模板等非 MD 文件)
- **来源分布**: SDD-RIPER (14), SDD-RIPER-Opt (6), Superpowers (80+), PRD Analysis (7), 测试工程 (24+), 代码审查 (8+), Self-Improvement (6), Agent 定义 (25), 工具脚本 (10)
- **目录结构**: references/ (8大类: entry/spec-driven-development/checkpoint-driven/superpowers/testing/prd-analysis/agents/self-improvement), protocols/ (4), docs/ (5), scripts/ (10), .learnings/ (3)
- **🆕 技能包**: 7 个独立技能包 (API Testing, Go Review, Python Review, Pytest, Requirements Spec, Implementation Verify, Self-Improvement)
- **版本**: v4.11 (2026-04-19)

---

## v4.11 核心变更

### 🔍 Code Review 流程优化

明确代码审查入口和语言分发规则：

- ✅ **入口强制**：所有代码审查任务必须先通过 `receiving-code-review/SKILL.md` 进入
- ✅ **语言分发**：自动识别代码语言，分发到 `python-code-review` 或 `go-code-review`
- ✅ **流程图**：添加清晰的流程图说明 Code Review 完整流程
- ✅ **索引更新**：在 `reference-index.md` 添加 Code Review 入口说明

### 🔧 悬空引用修复

- ✅ **路径错误**：修复 `docs/团队落地指南.md` 第9行路径空格问题
- ✅ **重定向文件**：创建 `protocols/SDD-RIPER-ONE.md` 重定向文件
- ✅ **示例标注**：在 `anthropic-best-practices.md` 标注示例引用

---

## v4.8 核心变更

### 🔄 自我进化机制 (Self-Improvement System)

自动记录、总结、晋升经验，使工作流持续进化：

- ✅ **自动检测触发**: 用户纠正、命令失败、知识缺口、更优方案自动识别
- ✅ **三日志文件**: LEARNINGS.md / ERRORS.md / FEATURE_REQUESTS.md
- ✅ **标准化格式**: LRN-/ERR-/FEAT- ID 系统，包含优先级/区域/元数据
- ✅ **晋升规则**: 重复 ≥3 次 + 跨 ≥2 任务 + 30 天内 → 晋升到工作流规则
- ✅ **技能提取**: 通用经验提取为独立 Skill，可跨项目复用
- ✅ **铁律 #11**: Log & Promote Learnings — 任务后自检，经验必须晋升
- ✅ **钩子脚本**: self-improvement-activator.sh / error-detector.sh

---

## v4.7 核心变更

### 🧪 测试工程专项 (Testing Engineering Specialty)

新增完整的测试工程体系：

- ✅ **E2E 测试框架**: Playwright/Cypress 集成指南
- ✅ **性能/负载测试**: 压测策略、基准测试、性能指标
- ✅ **API 测试**: 契约测试、安全测试、测试矩阵模板
- ✅ **Pytest 测试模式**: Fixture、参数化、Mock、覆盖率
- ✅ **测试数据管理**: 工厂模式、Fixture 层级、测试隔离
- ✅ **测试环境管理**: Docker Compose、依赖注入、环境一致性
- ✅ **CI/CD 集成**: 自动化流水线、质量门禁、测试报告
- ✅ **测试脚手架**: 开箱即用的模板集合

### 🔍 代码审查技能包 (Code Review Skills)

多语言代码审查标准化：

- ✅ **Go 代码审查**: 静态分析、并发安全、性能审计
- ✅ **Python 代码审查**: 类型安全、异步模式、错误处理
- ✅ **高级 API 测试**: 幂等性、输入验证、错误处理、并发测试

### 📋 PRD 分析工作流 (PRD Analysis Workflow)

结构化需求分析：

- ✅ **五阶段流程**: Brainstorm → Discover → Document → Review → Validate
- ✅ **PRD 模板**: 产品概述、用户画像、旅程、功能需求、成功指标
- ✅ **校验标准**: 结构完整性、内容质量、边界验证、跨节一致性
- ✅ **示例参考**: 优质 PRD 示例和输出格式

### 🛠️ 其他改进

- ✅ 别名同步验证脚本
- ✅ 项目脚手架自动化工具
- ✅ 实现验证技能包
- ✅ 需求规格说明技能包

---

*Powered by the integration of SDD-RIPER, SDD-RIPER-Optimized (Checkpoint-Driven), Superpowers, and enhanced with Testing Engineering, Code Review, PRD Analysis & Self-Improvement capabilities.*

**最后更新**: 2026-04-19
**当前版本**: v4.11
