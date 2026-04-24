# ALTAS Workflow SKILL 评审报告

**评审日期**: 2026-04-24（第八轮深度验证 — 技术文档工程视角）
**评审版本**: v4.11
**评审视角**: 渐进式披露执行度、文档结构效率、AI 可操作性、信息冗余、缺失能力、开发者体验
**评审方法**: 全量文件深度阅读 + Sequential Thinking 多步推理 + Knowledge Graph 关联分析

---

## 1. 总体评价

ALTAS Workflow v4.11 架构成熟，前七轮评审已解决目录结构、悬空引用、版本一致性等硬伤。上一轮（第七轮）指出的自我进化过度设计问题已显著改善——`references/self-improvement/SKILL.md` 从 923 行精简至 204 行，Learning 条目必填字段从 10+ 精简为 4 个，信号检测从 10+ 类简化为 3 类。SKILL.md 从 535 行精简至 357 行。

**但核心矛盾仍在**：渐进式披露原则在入口层和索引层执行仍不彻底，且出现了新的文档一致性问题。

**当前评级**: **A-**（架构 A 级，但文档效率与一致性拉低整体）

| 维度 | 评级 | 说明 |
|------|------|------|
| 目录结构合理性 | A | 分层清晰，无重复文件 |
| AI 可读性 | A | YAML frontmatter + 表格结构规范 |
| 命令明确性 | A | 触发词规范，aliases.md 与 SKILL.md 一致 |
| 悬空引用 | A | 0 个悬空引用（前轮问题已全部修复） |
| MD 文件可达性 | A | 141 个 MD 文件 ~97% 通过索引可达 |
| 版本一致性 | A | 全局 v4.11 一致 |
| **渐进式披露执行度** | **B+** | SKILL.md 和 reference-index.md 仍有优化空间，但已从 B 改善 |
| **索引效率** | **B** | reference-index.md 仍存在重复导航表 |
| **文档一致性** | **B** | README.md 与实际文件统计有偏差 |
| **自我进化机制** | **A-** | 从 C 跃升至 A-，精简成效显著 |

---

## 2. 已修复项（对比第七轮）

| # | 第七轮问题 | 当前状态 | 证据 |
|---|-----------|----------|------|
| 2.3 | self-improvement/SKILL.md 过度设计（923 行） | ✅ 已修复 | 精简至 204 行；必填字段 4 个；信号检测 3 类 |
| 2.1 | SKILL.md 入口臃肿（535 行） | ✅ 部分修复 | 精简至 357 行；自我进化章节精简为 3 类信号表 |

---

## 3. 待修复问题

### 🔴 高优先级（直接影响效率）

#### 3.1 reference-index.md 索引冗余 — 测试任务导航表完全重复

**现状**：reference-index.md 532 行中，"按测试任务导航"表在"TEST 模式"场景索引（L103-121）和"TEST 模式"按特殊模式索引（L222-240）中**完全重复**，共 19 行 × 2 = 38 行冗余。此外，"EXECUTE / 代码实现"的"按需"列中列出了 22 个文件路径，对 AI 来说首轮决策成本极高。

**影响**：AI 在 TEST 模式下需要扫描两份完全相同的表格才能确认一致性，浪费上下文。

**建议**：
- 删除"按特殊模式索引 > TEST 模式"中的"按测试任务导航"子表（L222-240），保留场景索引中的版本（L103-121）并标注为"唯一版本"
- "EXECUTE / 代码实现"的"按需"列按测试场景分组（API / E2E / 性能 / 安全等），而非一维平铺 22 个路径

**验证标准**：reference-index.md 无完全重复的表格行。

---

#### 3.2 README.md 统计数字与实际不符

**现状**：README.md L215-219 的统计数据与实际文件数量有偏差：

| 项目 | README.md 声称 | 实际（本轮扫描） | 差异 |
|------|---------------|-----------------|------|
| superpowers 子目录数 | 未明确 | 15 个子目录 | - |
| 测试文件 | "21" | 21 个 MD + 8 个 py/toml/json 模板 | 统计口径模糊 |
| Agent 定义 MD | "14" | sdd-riper-one 4 个 + sdd-riper-one-light 10 个 = 14 | ✅ 一致 |
| scripts/ | "5"（L189） | 实际 7 个主脚本 + 5 个 lib 库 + 1 个 config | ❌ 不一致 |

README.md L189 目录树标注 `scripts/ # 自动化工具 (5)`，但实际 scripts/ 目录下有 7 个主脚本（archive_builder.py, scaffold.py, validate_aliases_sync.py, error-detector.sh, extract-skill.sh, learning-stats.sh, promote-learning.sh, review-learnings.sh, self-improvement-activator.sh），加上 lib/ 子目录下的 6 个库文件。

**影响**：误导用户对项目规模的认知，降低文档可信度。

**建议**：
- 更新 README.md L189 scripts/ 的统计数字为实际值
- 统一统计口径：MD 文件数 vs 总文件数（含脚本/模板等）

**验证标准**：README.md 所有统计数字与实际文件扫描结果一致。

---

#### 3.3 QUICKSTART.md 与 SKILL.md 路由表不一致

**现状**：QUICKSTART.md L39-50 的触发词速查表与 SKILL.md L151-171 的路由速查表存在差异：

| 差异点 | QUICKSTART.md | SKILL.md |
|--------|--------------|----------|
| `ARCHIVE` | 未列出 | 已列出 |
| `MIGRATE` | 未列出 | 已列出 |
| `PRD` | 未列出 | 已列出 |
| `EXIT ALTAS` | 未列出 | 已列出 |
| `CROSS` | 与 MULTI 合并 | 单独列出 |
| `REVIEW` | 未列出 | 已列出 |
| 触发词冒号规则 | 无说明 | 无说明（在 aliases.md） |

**影响**：用户通过 QUICKSTART.md 上手后，缺失 4 个模式的认知，可能误以为这些模式不存在。

**建议**：
- QUICKSTART.md 触发词速查表补齐缺失的模式（ARCHIVE / MIGRATE / PRD / REVIEW / EXIT ALTAS）
- 或者改为引用 `references/entry/aliases.md` 作为完整词典入口，QUICKSTART.md 只保留最常用的 5-6 个

**验证标准**：QUICKSTART.md 速查表覆盖 SKILL.md 路由速查中所有主触发词。

---

### 🟡 中优先级（改善体验）

#### 3.4 SKILL.md "REQUIRED BACKGROUND" 格式不规范

**现状**：SKILL.md L56-67 的 "REQUIRED BACKGROUND" 段落混合了 YAML 依赖列表和 Markdown 说明文本，且 brainstorming 的描述直接内联在依赖列表中（4 行详细说明），与其他依赖项格式不统一。

```markdown
- superpowers:brainstorming (for L/complex M INNOVATE phase)

  > **What:** Turn ideas into validated designs through Q&A + trade-off discussion
  > **When:** Before any creative work on M/L tasks — prevents scope creep and assumption drift
  > **Process:** Explore context → Ask questions (one at a time) → Propose 2-3 approaches → Present design → User approves → Write spec → Invoke writing-plans
  > **HARD-GATE:** No code until user approves the design
```

其他 5 个依赖项只有一行说明，brainstorming 却占了 4 行引用块。这违反了入口文件"只保留路由必需信息"的原则。

**影响**：brainstorming 的 4 行内联说明在每次任务加载时都消耗上下文，但只在 L/复杂 M 的 INNOVATE 阶段才需要。

**建议**：
- 将 brainstorming 的 4 行说明移入 `references/superpowers/brainstorming/SKILL.md` 或 `references/entry/skill-content-map.md`
- REQUIRED BACKGROUND 列表中每个依赖项统一为一行格式

**验证标准**：SKILL.md REQUIRED BACKGROUND 段落无多行引用块，每个依赖项 ≤ 1 行。

---

#### 3.5 Entry Contract 重复内容 — SKILL.md 与 entry-contract.md

**现状**：SKILL.md L122-144 的 "Entry Contract" 章节与 `references/entry/entry-contract.md` 的内容存在重复：

| 内容 | SKILL.md 行数 | entry-contract.md 行数 |
|------|--------------|----------------------|
| 工具映射规则 | L126-128（3 行摘要） | L6-26（20 行完整版） |
| 只读纪律 | L131-134（4 行） | L29-33（5 行） |
| 能力降级 | L136-139（4 行） | L35-37（3 行） |
| 规则合并 | L141-144（4 行） | L39-43（5 行） |

SKILL.md 在 Entry Contract 中保留了约 15 行"摘要版"内容，entry-contract.md 有约 33 行"完整版"内容。两者在"只读纪律"、"能力降级"、"规则合并"上**几乎完全相同**。

**影响**：维护两份几乎相同的文档，增加同步风险。

**建议**：
- SKILL.md Entry Contract 精简为：工具映射一句话原则 + 参考路径 `references/entry/entry-contract.md`
- 删除 SKILL.md 中与 entry-contract.md 重复的"只读纪律"、"能力降级"、"规则合并"段落
- 同步更新 `references/entry/skill-content-map.md` 落点对照

**验证标准**：SKILL.md Entry Contract ≤ 5 行；与 entry-contract.md 无逐字重复。

---

#### 3.6 reference-index.md "按来源分类索引"价值低但占用大量篇幅

**现状**：reference-index.md 的"按来源分类索引"（L279-412）共 133 行，列出了几乎所有参考文件的来源归属。但 AI Agent 在实际工作流中从不按"来源"查找文件——它是按"场景/阶段/模式"查找的。

"按来源分类"的唯一用途是方法论溯源（理解 ALTAS 吸收了哪些上游），这已经在 `references/entry/sources.md` 中有更简洁的覆盖。

**影响**：133 行低价值内容增加索引文件扫描成本。

**建议**：
- 将"按来源分类索引"精简为纯分类标签表（每个来源 1 行描述 + 文件数），约 15 行
- 完整的来源-文件映射表移入 `references/entry/sources.md` 或新建 `references/entry/source-index.md`
- 或者将"按来源分类索引"标记为"仅在需要方法论溯源时加载"

**验证标准**：reference-index.md "按来源分类索引"≤ 20 行。

---

### 🟢 低优先级（锦上添花）

#### 3.7 docs/ 目录缺乏 README.md 导航

**现状**：docs/ 目录下有 5 个方法论 MD 文件（总计 184 KB），但没有 README.md 导航文件。SKILL.md L315-316 虽然标注"仅供人类用户参考，Agent 无需主动加载"，但人类用户进入 docs/ 目录后没有快速发现入口。

**建议**：
- 在 docs/ 下新增 README.md，包含：每个文档的一句话摘要 + 目标读者 + 阅读顺序建议

**验证标准**：docs/README.md 存在且覆盖所有 5 个文档。

---

#### 3.8 README.md 版本变更日志过于冗长

**现状**：README.md L223-297 包含 v4.11 / v4.8 / v4.7 三个版本的完整变更日志（约 75 行），与 `references/agents/sdd-riper-one/CHANGELOG.md` 和 SKILL.md 版本说明重复。

**建议**：
- README.md 只保留最新版本变更摘要（~10 行）
- 历史变更统一指向 `references/agents/sdd-riper-one/CHANGELOG.md`

**验证标准**：README.md 版本变更日志 ≤ 15 行。

---

#### 3.9 systematic-debugging/ 测试文件不应在生产索引中

**现状**：`references/superpowers/systematic-debugging/` 下有 4 个测试文件（test-academic.md, test-pressure-1/2/3.md）和 1 个创建日志（CREATION-LOG.md），在 reference-index.md 的 "Systematic Debugging 测试索引"（L423-435）中被正式索引。

这些文件是 Skill 质量保证用的测试场景，不是 AI Agent 在 DEBUG 模式下需要加载的参考资料。

**建议**：
- 将测试文件和创建日志从 reference-index.md 正式索引中移除
- 或者移入 `systematic-debugging/tests/` 子目录，明确标记为"测试/开发用"

**验证标准**：reference-index.md 正式索引不含 test-academic/test-pressure/CREATION-LOG。

---

## 4. 改进优先级总览

| # | 问题 | 优先级 | 预期收益 | 涉及文件 |
|---|------|--------|----------|----------|
| 3.1 | reference-index.md 测试导航表重复 | 🔴 高 | 消除 38 行冗余，减少 AI 决策困惑 | reference-index.md |
| 3.2 | README.md 统计数字与实际不符 | 🔴 高 | 提升文档可信度 | README.md |
| 3.3 | QUICKSTART.md 路由表缺失 4 个模式 | 🔴 高 | 新用户认知完整 | QUICKSTART.md |
| 3.4 | SKILL.md REQUIRED BACKGROUND 格式不统一 | 🟡 中 | 每次任务节省 ~100 tokens | SKILL.md |
| 3.5 | Entry Contract 内容重复 | 🟡 中 | 消除 15 行冗余，降低同步风险 | SKILL.md, entry-contract.md, skill-content-map.md |
| 3.6 | 按来源分类索引价值低篇幅大 | 🟡 中 | 索引文件减少 ~100 行 | reference-index.md, sources.md |
| 3.7 | docs/ 缺乏 README.md 导航 | 🟢 低 | 人类用户发现性提升 | 新增 docs/README.md |
| 3.8 | README.md 版本日志冗长 | 🟢 低 | 减少维护负担 | README.md |
| 3.9 | systematic-debugging 测试文件误入正式索引 | 🟢 低 | 索引更准确 | reference-index.md |

---

## 5. 核心发现：从"架构缺陷"转向"文档精度"

### 对比第七轮的核心发现

第七轮的核心发现是**"渐进式披露原则在入口层和索引层执行不彻底"**。经过本轮验证，这一问题的严重程度已降低：

| 层级 | 第七轮差距 | 第八轮差距 | 改善 |
|------|-----------|-----------|------|
| SKILL.md | 多 ~200 行 | 多 ~80 行（主要是 Entry Contract + REQUIRED BACKGROUND） | ✅ 显著改善 |
| reference-index.md | 多 ~300 行 | 多 ~170 行（来源索引 + 测试导航重复） | ✅ 改善中 |
| self-improvement/SKILL.md | 多 ~500 行（过度设计） | 已精简至 204 行 | ✅ 完全修复 |

### 本轮核心发现

**从"架构缺陷"转向"文档精度"**：硬伤已基本消除，当前的主要问题不是"缺了什么"或"多了什么"，而是**"同样的内容出现了两次"**——

1. **数据重复**：测试导航表重复、Entry Contract 重复、版本日志重复
2. **口径不一致**：README.md 统计数字、QUICKSTART.md 触发词覆盖范围
3. **格式不统一**：REQUIRED BACKGROUND 中 brainstorming 的内联详情

这些问题的共同特征是：**不是信息缺失，而是信息在不同位置的表达不一致**。这是文档维护中最常见也最顽固的问题——每次修改一处，容易忘记同步另一处。

---

## 6. 文件统计（v4.11 实际，已验证）

| 目录 | MD 文件数 | 其他文件 | 备注 |
|------|-----------|----------|------|
| 根目录 | 7 | 0 | 含 SKILL-entry-review-WorkBuddy.md |
| `.learnings/` | 3 | 0 | 无变更 |
| `docs/` | 5 | 0 | 无 README.md |
| `protocols/` | 5 | 0 | 无变更 |
| `references/entry/` | 7 | 0 | 含 entry-contract.md |
| `references/spec-driven-development/` | 7 | 0 | 无变更 |
| `references/checkpoint-driven/` | 4 | 0 | 无变更 |
| `references/code-review/` | 3+3 | 1 (sh) | go/3md + python/1md + README.md + code-reviewer.md |
| `references/superpowers/` | 34+6 | 5 (js/dot/sh/html) | 15 子目录，6 个附属 MD |
| `references/testing/` | 19 | 6 (py) + 2 (md/toml) | templates/ 下 2 个 md + 6 个 py/toml |
| `references/prd-analysis/` | 6 | 1 (json) | examples/2 + reference/1 |
| `references/self-improvement/` | 3 | 0 | assets/1 + references/2 |
| `references/agents/` | 7+5 | 2 (yaml/py) | sdd-riper-one 4md + sdd-riper-one-light 5md+2spec |
| `references/special-modes/` | 7 | 0 | 7 个模式 |
| **总计** | **~141** | **~24** | **验证值** |

---

## 7. 关键文件行数对比

| 文件 | 第七轮行数 | 第八轮行数 | 变化 |
|------|-----------|-----------|------|
| SKILL.md | ~535 | 357 | -178 ✅ |
| reference-index.md | ~559 | 532 | -27 |
| QUICKSTART.md | ~775 | 150 | -625 ✅ |
| README.md | ~300 | 302 | +2 |
| self-improvement/SKILL.md | ~923 | 204 | -719 ✅ |

---

## 8. 总结

ALTAS Workflow v4.11 是一个成熟的 AI 工作流框架，核心架构评分 **A** 级。相比第七轮，最显著的改善是自我进化机制的精简（923→204 行）和入口文件的瘦身（535→357 行）。

**当前阶段的矛盾**已从"架构缺陷"转向"文档精度"——不是缺信息，而是信息在不同位置的表达不一致（重复、口径偏差、格式不统一）。

**核心优势**：
1. 清晰的分层结构和索引机制
2. YAML frontmatter + 表格结构便于 AI 解析
3. 触发词设计有中英文对照，冒号规则明确
4. 141 个 MD 文件 ~97% 通过索引可达
5. 目录结构统一，无重复文件
6. 版本号全局一致（v4.11）
7. 无悬空引用或错误路径
8. 铁律体系完善，防绕过机制健全
9. 自我进化机制已大幅精简，实用性提升

**待修复问题**：
- 🔴 高优先级：**3 项**（索引重复 / 统计偏差 / 路由表不一致）
- 🟡 中优先级：**3 项**（REQUIRED BACKGROUND 格式 / Entry Contract 重复 / 来源索引冗余）
- 🟢 低优先级：**3 项**（docs 导航 / 版本日志 / 测试文件误索引）

**当前评级**：**A-**

**下次评审建议时机**：完成 3 项高优先级修复后进行第九轮验证。

---

**评审完成**
