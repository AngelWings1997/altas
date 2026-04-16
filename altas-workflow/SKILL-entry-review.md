# SKILL Entry Review

## 背景

本文件记录对 `SKILL.md` 作为技能入口的持续复核结论。

**本轮复核范围：** v4.5 全面对标 `references/superpowers/writing-skills/` 下四份参考文档

**上一轮已解决的问题（已从本文档删除）：**
- ~~A. 技能创建流程验证~~ ✅ v4.5 已解决
- ~~B. 说服原则应用~~ ✅ v4.5 已解决
- ~~C. CSO 优化（description 重构为纯触发条件）~~ ✅ v4.5 已解决
- ~~D. 技能命名未遵循"动词-ing 形式"~~ ✅ 已验证，保持当前命名（名词短语在工程类技能中可接受）
- ~~E. 缺少"技能发现流程"优化~~ ✅ v4.5 已部分解决，但仍有改进空间
- ~~F. 技能正文长度接近 500 行最佳实践限制~~ ✅ v4.5 已解决：477行→408行，异常与恢复/EXIT ALTAS/能力降级移至 `references/entry/exceptions-recovery.md`
- ~~K. Description 字段仍隐含流程总结~~ ✅ v4.5 已解决：移除 "requiring structured progression" 流程性总结
- ~~L. 缺少 REQUIRED BACKGROUND / REQUIRED SUB-SKILL 显式声明~~ ✅ v4.5 已解决：Overview 后添加 REQUIRED BACKGROUND 声明

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

    **Core patterns**: Iron Rules (Section X), First Response Template (Section Y)
    **Special modes**: See references/special-modes/ for DEBUG/REVIEW/REFACTOR/...
    **Full index**: See reference-index.md for all reference files by phase/scale
    **Tools mapping**: See references/superpowers/using-superpowers/ for platform-specific tools
    ```
  - 这样 Claude 可快速定位，无需通读全文
- **位置**：Overview 后（第 32-40 行后）

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
- **位置**：Overview 章节（第 27-40 行）

### J. 未充分利用"交叉引用"减少冗余

- **优先级：低**
- **问题描述**：根据 `anthropic-best-practices.md`：
  - 应使用交叉引用避免重复（如"Always use subagents (50-100x context savings). REQUIRED: Use [other-skill-name] for workflow."）
  - 当前 SKILL.md 在多处重复 TDD 要求，但未显式引用 `superpowers/test-driven-development/SKILL.md`
  - 例如：第 368 行提到 TDD，但未声明"REQUIRED BACKGROUND: You MUST understand superpowers:test-driven-development"
  - 对比 writing-skills 的表述方式，更强调前置依赖
- **建议改进**：
  - 在 TDD 相关章节（第 368 行）添加：
    ```markdown
    **REQUIRED BACKGROUND:** You MUST understand superpowers:test-driven-development
    ```
  - 在 Subagent 章节（第 368 行）添加：
    ```markdown
    **REQUIRED SUB-SKILL:** Use superpowers:subagent-driven-development
    ```
  - 这样可以减少 SKILL.md 自身的长度，同时强化依赖关系
- **位置**：EXECUTE 章节（第 363-369 行）、PLAN 章节（第 316-323 行）

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
  - 将 `dependencies` 改为正文中的 REQUIRED BACKGROUND 声明
  - 移除 `compatible_platforms` 和 `min_context_window`（无实际效用）
- **位置**：SKILL.md frontmatter（第 1-13 行）

### N. 缺少"Common Mistakes"章节

- **优先级：低**
- **问题描述**：根据 `writing-skills/SKILL.md` 的标准 SKILL.md 结构：
  - 应包含 "Common Mistakes" 章节，列出常见错误及纠正方法
  - 当前 SKILL.md 的"异常与恢复"章节偏向运行时异常，未覆盖使用错误
  - 例如：用户直接用 `DEBUG` 触发但实际只需简单修改、用户在 XS 任务上强制要求完整 Spec
- **建议改进**：
  - 添加"Common Mistakes"章节：
    ```markdown
    ## Common Mistakes

    | Mistake | Correction |
    |---------|------------|
    | 用 DEEP 触发简单修改 | 使用 >> 或 FAST，避免过度工程 |
    | 在 XS 任务上要求完整 Spec | XS 可直接执行，事后 summary 即可 |
    | 跳过首轮响应直接进入编码 | 必须先完成路由+规模评估 |
    ```
- **位置**：建议在"异常与恢复"章节后添加

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

---

## 维护约定

- 本文件每次对 `SKILL.md` 进行重大修订后同步更新
- 已解决的问题将从本文档中彻底删除，保持本复核文档轻量化
- 新发现的问题追加到"当前版本仍可改进的问题"节，并给出优先级和建议
- 每个问题必须明确：优先级、问题描述、建议改进、位置

---

## 与 Writing Skills 参考标准的对标总结

### 已符合的要求 ✅

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
11. **Rationalization Table**：铁律含义表已覆盖常见违规场景
12. **技能正文长度** ✅ **本轮已解决**：477行→408行，异常与恢复/EXIT ALTAS/能力降级移至独立文件
13. **REQUIRED BACKGROUND 声明** ✅ **本轮已解决**：Overview 后添加显式前置技能依赖声明

### 待改进的领域 ⚠️

1. **渐进式导航**：缺少显式的"Quick Navigation"章节
2. **技能类型声明**：未明确分类为 Technique/Pattern/Reference/Discipline
3. **交叉引用**：未充分引用其他技能（如 TDD、Subagent）作为前置依赖
4. **Common Mistakes 章节**：缺少常见错误及纠正方法
5. **非标准 frontmatter 字段**：可能在不支持的平台造成混淆
6. **端到端示例**：缺少完整会话记录展示实际使用流程

### 优先级排序

**低优先级（可延后优化）：**
- G. 渐进式导航不显式（已有按需加载）
- H. 缺少端到端示例（已有模板）
- I. 缺少技能类型声明（不影响功能）
- J. 交叉引用不足（导致冗余）
- M. 非标准 frontmatter 字段（兼容性影响小）
- N. 缺少 Common Mistakes 章节（已有铁律覆盖）
- O. Description 过长且枚举过多（未超限）

---

*本文件持续更新，每次对 `SKILL.md` 进行重大修订后复核。*

**本轮复核完成时间：** 2026-04-16（全面对标 writing-skills 参考标准）
**上一轮复核完成时间：** 2026-04-15（v4.4 全面对标分析 + v4.5 高优先级问题修复验证）
**复核依据：**
- `references/superpowers/writing-skills/SKILL.md`
- `references/superpowers/writing-skills/anthropic-best-practices.md`
- `references/superpowers/writing-skills/persuasion-principles.md`
- `references/superpowers/writing-skills/testing-skills-with-subagents.md`
