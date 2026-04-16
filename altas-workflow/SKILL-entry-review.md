# SKILL Entry Review

## 背景

本文件记录对 `SKILL.md` 作为技能入口的持续复核结论。

**本轮复核范围：** v4.5 深度对标 `references/superpowers/writing-skills/` 下四份参考文档，重点验证 discipline-enforcing skill 的完整性

**上一轮已解决的问题（已从本文档删除）：**
- ~~A. 技能创建流程验证~~ ✅ v4.5 已解决
- ~~B. 说服原则应用~~ ✅ v4.5 已解决
- ~~C. CSO 优化（description 重构为纯触发条件）~~ ✅ v4.5 已解决
- ~~D. 技能命名未遵循"动词-ing 形式"~~ ✅ 已验证，保持当前命名（名词短语在工程类技能中可接受）
- ~~E. 缺少"技能发现流程"优化~~ ✅ v4.5 已部分解决，但仍有改进空间
- ~~F. 技能正文长度接近 500 行最佳实践限制~~ ✅ v4.5 已解决：477行→408行，异常与恢复/EXIT ALTAS/能力降级移至 `references/entry/exceptions-recovery.md`
- ~~K. Description 字段仍隐含流程总结~~ ✅ v4.5 已解决：移除 "requiring structured progression" 流程性总结
- ~~L. 缺少 REQUIRED BACKGROUND / REQUIRED SUB-SKILL 显式声明~~ ✅ v4.5 已解决：Overview 后添加显式前置技能依赖声明
- ~~N. 缺少"Common Mistakes"章节~~ ✅ **v4.6 已解决**：在异常与恢复章节后添加 Common Mistakes 章节（10 个使用错误及纠正方法）
- ~~P. 缺少"Red Flags - STOP"自检章节~~ ✅ **v4.6 已解决**：在 Hard Rules 后添加 Red Flags 章节（8 个 Red Flag 映射到具体铁律）
- ~~Q. 缺少 Rationalization Table（合理化借口反驳表）~~ ✅ **v4.6 已解决**：在 Red Flags 后添加 Rationalization Table（10 个常见借口及 Reality 反驳）

---

## 当前版本仍可改进的问题

### G. 缺少"渐进式披露"架构的显式导航

- **优先级：低**
- **问题描述**：根据 `anthropic-best-practices.md` 的"Progressive Disclosure"模式：
  - 应使用"高层指南 + 引用"模式组织内容
  - 当前 SKILL.md 已使用按需加载，但缺少显式的"目录式"导航
  - 例如：未明确声明"完整索引见 reference-index.md，特殊模式细节见 references/special-modes/"
  - 对比 writing-skills 的示例：应有"Quick start"→"Advanced features"→"API reference"的层次
- **建议改进**：
  - 在 Overview 后添加"Quick Navigation"章节：
    ```markdown
    ## Quick Navigation

    **Core patterns**: Iron Rules (§Hard Rules), First Response Template (§首轮响应契约)
    **Special modes**: See `references/special-modes/` for DEBUG/REVIEW/REFACTOR/...
    **Full index**: See `reference-index.md` for all reference files by phase/scale
    **Tools mapping**: See `references/superpowers/using-superpowers/` for platform-specific tools
    ```
  - 这样 Claude 可快速定位，无需通读全文
- **位置**：Overview 后（第 27-37 行后）
- **v4.5 状态**：❌ 未解决。第 397-401 行有简短提及，但无独立导航章节

### H. 代码示例的"质量 vs 数量"平衡可优化

- **优先级：低**
- **问题描述**：根据 `writing-skills/SKILL.md`：
  - "One excellent example beats many mediocre ones"
  - 当前 SKILL.md 包含多个表格和模板，但缺少"完整可运行"的端到端示例
  - 例如：首轮响应模板是固定的，但缺少"真实会话记录"展示完整流程
  - 对比 `testing-skills-with-subagents.md` 中的压力场景示例，更具象
- **建议改进**：
  - 考虑在 SKILL.md 末尾或独立文件添加"Example Session"章节
  - 展示一个完整会话：用户输入→路由判断→规模评估→首轮响应→检查点→完成
  - 或链接到 `examples/` 目录下的真实会话记录
  - 参考 `writing-skills/examples/CLAUDE_MD_TESTING.md` 的格式
- **位置**：建议在 SKILL.md 末尾或 `examples/skill-usage-example.md`
- **v4.5 状态**：❌ 未解决

### I. 缺少对"技能类型"的显式分类声明

- **优先级：低**
- **问题描述**：根据 `writing-skills/SKILL.md` 的技能类型分类：
  - Technique（具体方法步骤）
  - Pattern（问题思考方式）
  - Reference（API 文档/语法指南）
  - 当前 SKILL.md 是混合体（包含 Technique+Pattern+Reference），但未显式声明
  - 这可能导致测试方法不清晰（不同技能类型需要不同的测试方法）
- **建议改进**：
  - 在 Overview 中添加技能类型声明：
    ```markdown
    **Skill Type:** Hybrid (Technique + Pattern + Discipline)

    - **Technique**: Provides step-by-step workflow (RIPER phases)
    - **Pattern**: Mental model for routing and scale assessment
    - **Discipline**: Enforces rules (Iron Rules, TDD, verification)

    **Testing approach:** Combine academic questions (understand rules) +
    pressure scenarios (compliance under stress)
    ```
  - 这有助于明确测试策略
- **位置**：Overview 章节（第 27-37 行）
- **v4.5 状态**：❌ 未解决

### J. 未充分利用"交叉引用"减少冗余

- **优先级：低**
- **问题描述**：根据 `anthropic-best-practices.md`：
  - 应使用交叉引用避免重复（如"Always use subagents (50-100x context savings). REQUIRED: Use [other-skill-name] for workflow."）
  - 当前 SKILL.md 在多处重复 TDD 要求，但未显式引用 `superpowers:test-driven-development/SKILL.md`
  - 例如：第 382 行提到 TDD，但未声明"REQUIRED BACKGROUND: You MUST understand superpowers:test-driven-development"
  - 对比 writing-skills 的表述方式，更强调前置依赖
- **v4.5 部分进展**：✅ 第 39-43 行已有全局 REQUIRED BACKGROUND 声明
- **剩余问题**：EXECUTE/PLAN 章节内的引用未使用显式格式
- **建议改进**：
  - 在 EXECUTE 章节（第 382 行）添加：
    ```markdown
    **REQUIRED SUB-SKILL:** Use `superpowers:test-driven-development` for TDD cycle details
    ```
  - 在 PLAN 章节（第 376 行）已有引用，保持现状即可
- **位置**：EXECUTE 章节（第 378-384 行）
- **v4.5 状态**：⚠️ 部分解决（全局声明已有，章节内引用待加强）

### M. Frontmatter 使用非标准字段

- **优先级：低**
- **问题描述**：根据 `writing-skills/SKILL.md` 和 `anthropic-best-practices.md`：
  - SKILL.md 标准 frontmatter 仅要求 `name` 和 `description` 两个字段
  - 当前 SKILL.md 额外使用了 `version`, `trigger_keywords`, `dependencies`, `compatible_platforms`, `min_context_window`
  - 这些非标准字段在大多数平台（Claude Code、Cursor 等）中不会被解析，可能造成混淆
  - `min_context_window` 对技能加载无实际影响
- **建议改进**：
  - 保留 `version`（对版本追踪有价值）
  - 将 `trigger_keywords` 内容合并到 description（纯触发条件）
  - 将 `dependencies` 改为正文中的 REQUIRED BACKGROUND 声明（✅ v4.5 已完成）
  - 移除 `compatible_platforms` 和 `min_context_window`（无实际效用）
- **位置**：SKILL.md frontmatter（第 1-13 行）
- **v4.5 状态**：❌ 未解决

### O. Frontmatter description 字段过长且包含枚举列表

- **优先级：低**
- **问题描述**：当前 description 为 188 字符，虽未超过 500 字符限制，但：
  - 包含括号内 9 个枚举项 `(coding, debugging, documentation, ...)`，使描述冗长
  - `writing-skills/SKILL.md` 建议保持简洁，使用概括性描述而非枚举
  - 对比好的示例："Use when implementing any feature or bugfix, before writing implementation code"
- **建议改进**：
  - 简化为更紧凑的描述：
    ```
    Use when handling repository-grounded engineering tasks requiring structured, phased execution
    ```
  - 将具体触发场景留给 `When to Use` 章节
- **位置**：SKILL.md 第 4 行
- **v4.5 状态**：❌ 未解决

---

## 本轮新发现的问题

### R. Description 可进一步优化症状触发词 ⭐ 新增

- **优先级：低**
- **问题描述**：根据 `anthropic-best-practices.md`（第 197-199 行）：
  - Description 应包含 specific symptoms, situations, and contexts
  - 当前 description 较抽象："repository-grounded engineering tasks: coding, debugging, documentation, mapping, review, refactoring, testing, performance optimization, or migration"
  - 可加入更具体的触发场景描述，如：
    - "when tasks span multiple files or modules"
    - "when you need structured approach with checkpoints"
    - "when user uses trigger keywords like DEBUG, REVIEW, REFATOR..."
- **建议改进**（可选）：
  ```
  Use when handling repository-grounded engineering tasks spanning multiple files, modules, or projects that require structured phased execution with checkpoints and verification gates
  ```
  - 或保持现状（当前 description 已可用，188 字符 < 500 限制）
- **参考依据**：`anthropic-best-practices.md` 第 197-199 行："Be specific and include key terms"
- **v4.5 状态**：⚠️ 可选优化（不影响功能）

### S. Discovery Workflow 可进一步优化关键词覆盖 ⭐ 新增

- **优先级：低**
- **问题描述**：根据 `writing-skills/SKILL.md`（第 637-645 行）Discovery Workflow：
  1. Encounters problem ("tests are flaky")
  2. Finds SKILL (description matches)
  3. Scans overview (is this relevant?)
  4. Reads patterns (quick reference table)
  5. Loads example (only when implementing)
- 当前 SKILL.md 的结构基本符合此流程，但可进一步优化：
  - `trigger_keywords` 字段（第 5 行）包含丰富的中英文触发词 ✅
  - `When to Use` 章节（第 49-55 行）清晰说明适用场景 ✅
  - 路由速查表（第 125-144 行）提供快速模式匹配 ✅
- **潜在改进**：
  - 在 description 中加入更多 Claude 会搜索的症状词
  - 如："multi-file changes", "code review needed", "debug production issue", "write tests", "performance bottleneck"
- **参考依据**：`writing-skills/SKILL.md` 第 200-205 行："Keyword Coverage"
- **v4.5 状态**：✅ 基本符合（trigger_keywords 已很丰富）

### T. 缺少压力测试用例文档 ⭐ 新新增

- **优先级：低**
- **问题描述**：根据 `testing-skills-with-subagents.md`：
  - 作为 discipline-enforcing skill，应有对应的压力测试用例文档
  - 用于验证 Agent 在压力下是否仍遵守铁律
  - 当前仓库中 `references/superpowers/systematic-debugging/` 有完整的测试文件（test-academic.md, test-pressure-1/2/3.md）
  - 但主 SKILL.md 无对应测试
- **建议改进**：
  - 创建 `tests/` 目录或利用现有 `references/superpowers/systematic-debugging/` 的测试模式
  - 编写 3+ 压力场景：
    - 时间压力 + sunk cost：工作 4 小时后想跳过 TDD
    - 权威压力：高级工程师说"直接改别走流程"
    - 疲劳压力：快下班了想跳过 review 直接提交
  - 记录 baseline behavior（无 SKILL 时 Agent 的选择）
  - 验证有 SKILL 时 Agent 是否合规
- **参考依据**：
  - `testing-skills-with-subagents.md` 完整 TDD for Skills 方法论
  - `writing-skills/SKILL.md` 第 597-633 行：Skill Creation Checklist
- **v4.5 状态**：❌ 完全缺失（可作为后续迭代）

---

## 维护约定

- 本文件每次对 `SKILL.md` 进行重大修订后同步更新
- 已解决的问题将从本文档中彻底删除，保持本复核文档轻量化
- 新发现的问题追加到"当前版本仍可改进的问题"节，并给出优先级和建议
- 每个问题必须明确：优先级、问题描述、建议改进、位置、v4.5 状态

---

## 与 Writing Skills 参考标准的对标总结

### 已符合的要求 ✅（16项，v4.6 新增 3 项 discipline-enforcing 防绕过机制）

1. **TDD 核心原则**：已内化"无 Spec 不代码"、"无批准不执行"等铁律
2. **原子化拆解**：已全面覆盖目标/前置条件/操作步骤/预期结果四字段
3. **不确定性处理**：已明确要求澄清、禁止假设、必须确认
4. **按需加载架构**：已使用 reference-index.md 实现渐进式披露
5. **平台工具映射**：已提供多平台工具映射表
6. **版本升级指引**：已添加 changelog 链接和升级说明
7. **说服原则应用**：已显式使用 Authority/Commitment/Social Proof 原则
8. **CSO 优化**：description 字段已重构为纯触发条件
9. **When to Use / When NOT to Use**：已明确区分
10. **Hard Rules**：已使用绝对语言（YOU MUST）和非谈判框架
11. **Rationalization 含义表**：铁律含义表已覆盖常见违规场景
12. **技能正文长度** ✅ **已解决**：477行→408行→463行（v4.6 新增 55 行），< 500行限制
13. **REQUIRED BACKGROUND 声明** ✅ **已解决**：Overview 后添加显式前置技能依赖声明
14. **✨ Red Flags 自检机制** ✅ **v4.6 新增**：8 个 Red Flag 映射到具体铁律，提供快速自检清单
15. **✨ Rationalization Table** ✅ **v4.6 新增**：10 个常见借口及 Reality 反驳，有效防止绕过规则
16. **✨ Common Mistakes 章节** ✅ **v4.6 新增**：10 个使用错误及纠正方法，覆盖非运行时异常场景

### 待改进的领域 ⚠️（9项，v4.6 已解决 3 项中优先级问题）

**高优先级（建议近期解决）：**
- （无 - 当前所有问题均为低/中优先级）

**中优先级（建议下版本解决）：**
- （无 - 原 P/Q/N 已在 v4.6 解决）

**低优先级（可延后优化）：**
- G. 渐进式导航不显式（已有按需加载，第 397-401 行有简短提及）
- H. 缺少端到端示例（已有模板，可补充完整会话）
- I. 缺少技能类型声明（不影响功能，但有助测试策略）
- J. 交叉引用不足（全局声明已有，章节内引用待加强）
- M. 非标准 frontmatter 字段（兼容性影响小，version 有保留价值）
- O. Description 过长且枚举过多（未超限，188字符 < 500）
- R. Description 可优化症状触发词（可选优化）
- S. Discovery Workflow 基本符合（trigger_keywords 已丰富）
- T. 缺少压力测试用例（可作为后续迭代工作）

### 新增能力差距分析

**Discipline-Enforcing Skill 完整性检查：**

根据 `testing-skills-with-subagents.md` 和 `persuasion-principles.md`，一个完整的 discipline-enforming skill 应包含：

| 组件 | 标准 | v4.6 状态 | 优先级 |
|------|------|-----------|--------|
| Authority 语言（YOU MUST） | 必须 | ✅ 已有 | - |
| Non-negotiable framing | 必须 | ✅ 已有 | - |
| Commitment mechanism | 必须 | ✅ 已有（COMMITMENT 声明） | - |
| Social proof patterns | 必须 | ✅ 已有（Every time） | - |
| Rationalization Table | 强烈推荐 | **✅ v4.6 已补齐** | - |
| Red Flags list | 强烈推荐 | **✅ v4.6 已补齐** | - |
| Common Mistakes | 推荐 | **✅ v4.6 已补齐** | - |
| Pressure test cases | 推荐 | ❌ 缺失 | 低 |

**结论：** v4.6 已完整覆盖 discipline-enforcing skill 的所有核心组件（Authority/Commitment/Social Proof + 防绕过机制）。剩余唯一缺口是压力测试用例文档（低优先级，可作为后续迭代工作）。

---

*本文件持续更新，每次对 `SKILL.md` 进行重大修订后复核。*

**本轮复核完成时间：** 2026-04-16（v4.6 实现：补齐 Red Flags + Rationalization Table + Common Mistakes 三项 discipline-enforcing 防绕过机制）
**上一轮复核完成时间：** 2026-04-15（v4.4 全面对标分析 + v4.5 高优先级问题修复验证）
**下轮待办：** 可考虑补充压力测试用例（T, 低优先级）或优化低优先级项（G-J, M-O, R-S）
**复核依据：**
- `references/superpowers/writing-skills/SKILL.md`
- `references/superpowers/writing-skills/anthropic-best-practices.md`
- `references/superpowers/writing-skills/persuasion-principles.md`
- `references/superpowers/writing-skills/testing-skills-with-subagents.md`

---

## 问题索引速查

| ID | 问题 | 优先级 | 状态 | 建议位置 |
|----|------|--------|------|----------|
| G | 缺少渐进式导航 | 低 | ❌ 未解决 | Overview 后 |
| H | 缺少端到端示例 | 低 | ❌ 未解决 | SKILL.md 末尾 |
| I | 缺少技能类型声明 | 低 | ❌ 未解决 | Overview |
| J | 交叉引用不足 | 低 | ⚠️ 部分 | EXECUTE 章节 |
| M | 非标准 frontmatter | 低 | ❌ 未解决 | frontmatter |
| O | Description 过长 | 低 | ❌ 未解决 | frontmatter |
| **N** | **缺少 Common Mistakes** | **中** | **✅ v4.6 已解决** | **异常与恢复后** |
| **P** | **缺少 Red Flags** | **中** | **✅ v4.6 已解决** | **Hard Rules 后** |
| **Q** | **缺少 Rationalization Table** | **中** | **✅ v4.6 已解决** | **Hard Rules 后** |
| R | Description 可优化 | 低 | ⚠️ 可选 | frontmatter |
| S Discovery Workflow | 低 | ✅ 基本符合 | - |
| T | 缺少压力测试 | 低 | ❌ 未解决 | tests/ 目录 |

**统计：**
- ✅ 已解决：16 项（A-L, N, P, Q）
- ❌ 未解决：9 项（G, H, I, J, M, O, R, S, T）
- ⚠️ 部分解决：2 项（J, R）
