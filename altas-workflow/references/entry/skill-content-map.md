# SKILL.md 删减内容落点对照

> 本文件用于审计 `SKILL.md` 精简后，被移出的内容是否在其他 reference 文档中有明确落点。
> 原则：删掉一段，就必须有对应落点；若现有文档已经完整覆盖，则直接引用，不重复造内容。

## 使用方式

- 当需要确认“入口是否删没了东西”时，先看这里
- 当需要追踪某一段原始规则现在去哪里读时，按“原始段落”查找
- 当需要继续精简 `SKILL.md` 时，以这里作为迁移验收清单

## 对照表

> 约定：落点尽量精确到“文档 + 章节标题”。若只写到文档名，说明该文档本身就是单主题入口。

| 原始段落（旧 `SKILL.md`） | 当前处理方式 | 落点文档 |
|---------------------------|--------------|----------|
| `首轮响应契约 > 只有触发词，没有任务` | 完整迁移 | `references/entry/first-response.md` > `## 只有触发词，没有任务` |
| `首轮响应契约 > 任务不明确` | 完整迁移 | `references/entry/first-response.md` > `## 任务不明确时的澄清规则` |
| `首轮响应契约 > 已有明确任务` | 完整迁移 | `references/entry/first-response.md` > `## 已有明确任务时的最小字段` |
| `首轮响应契约 > 首轮响应固定模板` | 完整迁移 | `references/entry/first-response.md` > `## 首轮响应固定模板` |
| `首轮响应契约 > 从接收任务到 PLAN 的拆解要求` | 完整迁移 | `references/entry/first-response.md` > `## 从接收任务到 PLAN 的拆解要求` |
| `检查点契约 > 触发时机` | 完整迁移 | `references/checkpoint-driven/checkpoints.md` > `## 触发时机` |
| `检查点契约 > 输出要求` | 完整迁移 | `references/checkpoint-driven/checkpoints.md` > `## 输出要求` |
| `检查点契约 > 完整检查点模板（M/L）` | 完整迁移 | `references/checkpoint-driven/checkpoints.md` > `## 完整检查点模板（M/L）` |
| `检查点契约 > 检查点强制暂停规则` | 完整迁移 | `references/checkpoint-driven/checkpoints.md` > `## 检查点强制暂停规则` |
| `检查点契约 > Batch Override Git 回滚强制约束` | 完整迁移 | `references/checkpoint-driven/checkpoints.md` > `## Batch Override Git 约束`、`## Batch Override 失败时的回滚选项` |
| `PLAN > §4.4 Test Strategy 固定最小结构` | 完整迁移 | `references/testing/test-strategy-template.md` > `## 固定最小结构` |
| `PLAN > Test Strategy 字段顺序与统一要求` | 完整迁移 | `references/testing/test-strategy-template.md` > `## 使用原则` |
| `EXECUTE > Python 项目测试专项加载规则` | 直接引用现有文档 | `reference-index.md` > `### EXECUTE / 代码实现`、`### TEST 模式 (新增)` |
| `EXECUTE > API 契约优先、契约识别后的默认动作` | 直接引用现有文档 | `references/testing/api-testing.md` > `## 默认输入源：先找契约文件`；`references/special-modes/test.md` > `### 2) 识别 API 契约来源（API 项目必做）`、`### 4) 基于契约生成测试矩阵（API 项目默认动作）` |
| `EXECUTE > GraphQL / gRPC / WebSocket API 项目指引` | 直接引用现有文档 | `references/testing/api-testing.md` > `## 8. GraphQL API 测试`、`## 9. gRPC API 测试`、`## 10. WebSocket API 测试` |
| `EXECUTE > Go / 契约测试 / E2E / 性能 / 安全 / 视觉 / 移动端 / 可观测性 / 测试环境 / 维护 / 数据管理 / CI` | 直接引用现有文档 | `reference-index.md` > `### EXECUTE / 代码实现`、`### TEST 模式 (新增)` |
| `EXECUTE > TDD 适配规则（签名级 / 行为级 / 探索级）` | 完整迁移 | `references/superpowers/test-driven-development/SKILL.md` > `## Spec-Aware TDD` |
| `REVIEW > implementation-verify 覆盖率阈值与动作` | 直接引用现有文档 | `references/superpowers/implementation-verify/SKILL.md` > `### Coverage Thresholds And Actions` |
| `REVIEW > review pipeline 细节` | 直接引用现有文档 | `references/superpowers/receiving-code-review/SKILL.md` > `## Complete Review Pipeline`、`## Implementation Verification (PRD Coverage Check)`；`references/checkpoint-driven/modules.md` > `## Review` |
| `PRD 分析 > Brainstorm / Discover / Document / Review / Validate` | 直接引用现有文档 | `references/prd-analysis/SKILL.md` > `## Workflow` 下的 `### 0. Brainstorm` 至 `### 4. Validate` |
| `PRD 分析 > WHAT / WHY / MECE 原则` | 直接引用现有文档 | `references/prd-analysis/SKILL.md` > `## PRD Focus Areas`、`## MECE Principle`；`references/prd-analysis/template.md` 中各 `### MECE Check:*`；`references/prd-analysis/validation.md` |
| `自我进化契约 > TRAE IDE 工作流集成（Hook配置、TodoWrite示例、检查点对齐表）` | 精简为要点+引用 | `references/self-improvement/SKILL.md` > `## TRAE IDE 快速操作指南` |
| `自我进化契约 > 实际工作流示例（场景A/B/C：用户纠正、命令失败、新思路）` | 移除（外部文件有更完整示例） | `references/self-improvement/SKILL.md` > `## ALTAS 特定示例` |
| `自我进化契约 > 记录时机（6条规则列表）` | 移除（与触发机制重复） | `references/self-improvement/SKILL.md` > `## 触发机制 > ### 主动触发（Agent 自检 — 检查点契约强制）` |
| `自我进化契约 > 快速记录决策树（21行树形图）` | 移除（可从Checklist和最佳实践推断） | `references/self-improvement/SKILL.md` > `## TRAE IDE 快速操作指南 > ### 常见场景 Checklist` |
| `检查点契约 > SOCIAL PROOF说明` | 移除（非核心路由信息） | 无需落点（原则性说明） |
| `自我进化契约 > 晋升规则完整流程（晋升格式、晋升后更新、Pattern-Key去重）` | 保留核心条件+映射表，详细流程引用 | `references/self-improvement/SKILL.md` > `## 晋升规则` |
| `自我进化契约 > 自动检测触发表（10+信号类型含中英文关键词）` | 精简为3类信号（用户纠正/命令失败/新发现），详细信号表引用 | `references/self-improvement/SKILL.md` > `## 触发机制` |
| `自我进化契约 > TRAE IDE Hook配置详情` | 移除（入口不需要） | `references/self-improvement/SKILL.md` > `## TRAE IDE 快速操作指南` |
| `自我进化契约 > 与TodoWrite/检查点对齐表/工作流示例` | 移除（入口不需要） | `references/self-improvement/SKILL.md` > `## TRAE IDE 快速操作指南`、`## ALTAS 特定示例` |
| `自我进化契约 > 铁律关联表` | 移除（入口只保留铁律#11一句话） | `references/self-improvement/SKILL.md` > `## 铁律关联` |
| `路由冲突优先级 > 完整裁决规则+判定树` | 精简为一句话+引用 | `references/entry/aliases.md` > `## 路由冲突判定树` |
| `Entry Contract > 平台工具映射表（5行×3列）` | 精简为规则+引用 | `references/entry/entry-contract.md` > `## 工具映射规则` |
| `Entry Contract > 只读纪律/能力降级/规则合并` | 移除（入口不需要） | `references/entry/entry-contract.md` > `## 只读纪律`、`## 能力降级`、`## 规则合并` |

## 当前约束

- 若未来继续从 `SKILL.md` 删减内容，必须同步更新本对照表
- 新增落点时优先复用已有 reference 文档；仅在现有文档无法承接时才创建新文件
- 若某条内容只能“语义覆盖”而无法定位到明确章节，不应视为迁移完成
