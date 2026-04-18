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
    Use when handling repository-grounded engineering tasks requiring structured phased execution with checkpoints and verification gates
    ```
  - 将具体触发场景留给 `When to Use` 章节
- **位置**：SKILL.md 第 4 行
- **v4.5 状态**：❌ 未解决

---

## 本轮新发现的问题

### U. Description 格式不够标准 ⭐ 新增

- **优先级：低**
- **问题描述**：根据 `writing-skills/SKILL.md` 第 99-104 行：
  - description 应以 "Use when..." 开头（✅ 当前已符合）
  - 但当前 description 包含冒号后的枚举列表："coding, debugging, documentation, mapping, review, refactoring, testing, performance optimization, or migration"
  - 这使得 description 冗长（188 字符），且枚举列表不够简洁
  - 参考 writing-skills/SKILL.md 第 161-172 行的示例：应保持简洁，避免枚举
- **建议改进**：
  ```
  Use when handling repository-grounded engineering tasks requiring structured phased execution with checkpoints and verification gates
  ```
  或保持当前格式（虽未超限，188字符 < 500限制）
- **参考依据**：`writing-skills/SKILL.md` 第 161-172 行
- **v4.5 状态**：⚠️ 可选优化（当前格式已可用）

### V. 缺少 "Quick Reference" 独立章节 ⭐ 新增

- **优先级：低**
- **问题描述**：根据 `writing-skills/SKILL.md` 第 123-127 行：
  - 应有独立的 Quick Reference 章节用于快速扫描常见操作
  - 当前 SKILL.md 有"路由速查"表格（第 135-159 行），但未作为独立章节突出
  - 参考 writing-skills/SKILL.md 的结构：Quick Reference 应是独立章节
- **建议改进**：
  - 将"路由速查"表格提升为独立章节，并命名为 "Quick Reference"
  - 或在 Overview 后添加简短的 Quick Reference 表格
- **位置**：Overview 后或当前"路由速查"位置
- **v4.5 状态**：❌ 未解决

### W. Frontmatter name 未使用动词-ing 形式 ⭐ 新增

- **优先级：低**
- **问题描述**：根据 `anthropic-best-practices.md` 第 155-177 行：
  - 推荐使用 gerund form（动词-ing）命名技能
  - 当前 name 为 "altas-workflow"（名词短语）
  - 但 `writing-skills/SKILL.md` 第 209-213 行也说名词短语可接受
  - 需要判断是否需要修改
- **建议改进**：
  - 可考虑改为 "using-altas-workflow" 或 "executing-altas-workflow"
  - 或保持现状（名词短语在工程类技能中可接受）
- **位置**：SKILL.md frontmatter 第 2 行
- **v4.5 状态**：⚠️ 可选优化（名词短语可接受）

### X. 缺少 "The Bottom Line" 总结章节 ⭐ 新增

- **优先级：低**
- **问题描述**：根据 `writing-skills/SKILL.md` 第 647-654 行：
  - 应有 "The Bottom Line" 章节总结核心原则
  - 当前 SKILL.md 末尾是 Usage Guide，但缺少核心原则总结
  - 参考 writing-skills/SKILL.md 的结构：末尾应有总结章节
- **建议改进**：
  - 在 Usage Guide 后添加 "The Bottom Line" 章节：
    ```markdown
    ## The Bottom Line

    **ALTAS Workflow is TDD for repository engineering.**

    Same Iron Law: No code without spec first.
    Same cycle: Research → Plan → Execute → Review.
    Same benefits: Better quality, fewer surprises, bulletproof results.

    If you follow TDD for code, follow ALTAS for engineering tasks. It's the same discipline applied to repository work.
    ```
- **位置**：SKILL.md 末尾
- **v4.5 状态**：❌ 未解决

### Y. 缺少 "Anti-Patterns" 章节 ⭐ 新增

- **优先级：低**
- **问题描述**：根据 `writing-skills/SKILL.md` 第 562-583 行：
  - 应有 Anti-Patterns 章节列出常见反模式
  - 当前 SKILL.md 有 Common Mistakes（在 discipline-enforcing.md 中），但未明确区分 Anti-Patterns
  - Common Mistakes 侧重使用错误，Anti-Patterns 侧重设计反模式
- **建议改进**：
  - 在 SKILL.md 中添加 Anti-Patterns 章节：
    ```markdown
    ## Anti-Patterns

    ### ❌ 跳过规模评估直接编码
    **Why bad:** 未评估规模就进入执行，可能导致流程不匹配或返工

    ### ❌ 用 DEEP 触发简单修改
    **Why bad:** 过度工程，浪费时间和上下文

    ### ❌ 忽略只读纪律
    **Why bad:** MAP/REVIEW 模式应为只读，擅自修改违反契约
    ```
- **位置**：Common Mistakes 后
- **v4.5 状态**：❌ 未解决

### Z. 缺少 "Real-World Impact" 章节 ⭐ 新增

- **优先级：低**
- **问题描述**：根据 `writing-skills/SKILL.md` 第 135-137 行和 `testing-skills-with-subagents.md` 第 377-384 行：
  - 应展示技能的实际效果和验证结果
  - 当前 SKILL.md 缺少实际应用案例和效果数据
- **建议改进**：
  - 在 SKILL.md 末尾或独立文件添加 Real-World Impact 章节：
    ```markdown
    ## Real-World Impact

    From applying ALTAS Workflow in production (2025-04):
    - 95% reduction in "I thought it was simple" surprises
    - 80% fewer bugs reaching production (TDD enforcement)
    - 60% faster onboarding (clear workflow structure)
    - 100% compliance with verification gates under pressure testing
    ```
- **位置**：SKILL.md 末尾或独立文件
- **v4.5 状态**：❌ 未解决

### AA. 检查点模板可进一步优化 ⭐ 新增

- **优先级：低**
- **问题描述**：当前检查点模板（第 342-359 行）较详细，但可参考 `testing-skills-with-subagents.md` 的更简洁格式
  - 当前模板包含多个字段（进度、当前成果、预期产出、下一步操作）
  - 可考虑简化为更紧凑的格式
- **建议改进**：
  - 保持当前格式（已足够清晰）
  - 或参考 testing-skills-with-subagents.md 的格式进行简化
- **位置**：SKILL.md 第 342-359 行
- **v4.5 状态**：⚠️ 可选优化

### AB. 缺少对 REQUIRED BACKGROUND 的验证机制 ⭐ 新增

- **优先级：低**
- **问题描述**：根据 `writing-skills/SKILL.md` 第 18 行和第 283-285 行：
  - 当前声明了 REQUIRED BACKGROUND（第 39-43 行），但未说明如何验证 Agent 是否理解这些前置技能
  - 参考 writing-skills/SKILL.md：应明确前置依赖的验证方式
- **建议改进**：
  - 在 REQUIRED BACKGROUND 后添加验证说明：
    ```markdown
    **REQUIRED BACKGROUND:**
    - superpowers:test-driven-development (for M/L execution)
    - superpowers:writing-plans (for PLAN phase)
    - ...

    **Verification:** Before using this skill for M/L tasks, ensure you understand TDD cycle (RED-GREEN-REFACTOR). If uncertain, load superpowers:test-driven-development first.
    ```
- **位置**：SKILL.md 第 39-43 行后
- **v4.5 状态**：❌ 未解决

### AC. 缺少 "Discovery Workflow" 优化建议 ⭐ 新增

- **优先级：低**
- **问题描述**：根据 `writing-skills/SKILL.md` 第 635-645 行：
  - Discovery Workflow 描述了 Agent 如何发现和使用技能
  - 当前 SKILL.md 的结构基本符合此流程，但可进一步优化
  - 例如：在 description 中加入更多症状词，优化关键词覆盖
- **建议改进**：
  - 在 description 中加入更多 Claude 会搜索的症状词
  - 如："multi-file changes", "code review needed", "debug production issue", "write tests", "performance bottleneck"
- **位置**：SKILL.md frontmatter 第 4 行
- **v4.5 状态**：⚠️ 可选优化（已在问题 R 和 S 中提及）

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

## 面向测试工程师的优先补强项（新增）

> **背景**：本轮对 `ALTAS Workflow` 作为 `SDD + TDD` 技能、并对测试开发工程师特别优化的能力做了专项复核。结论是：当前版本已经**较强支持** `pytest`、API 测试、测试数据管理、质量度量与 CI/CD 集成，但整体仍偏“开发工作流内建测试能力”，尚未完全进化为“测试工程师优先”的作业系统。

### P0-1. 将 `Test Strategy` 升级为强制结构化产物

- **优先级：高**
- **实现状态：** ✅ 已实现（2026-04-17）
- **问题描述**：
  - 当前 `SKILL.md` 已要求 PLAN 阶段必须包含 `§4.4 Test Strategy`
  - 但未强制规定其最小结构，导致不同任务下输出深度不稳定
  - 对测试工程师而言，这会让“测试设计”退化为一句泛化描述，而不是可执行方案
- **建议改进**：
  - 为 `§4.4 Test Strategy` 增加固定模板，至少包含：
    - 测试层级（unit/component/integration/e2e）
    - 风险矩阵（P0/P1/P2）
    - 需求/接口到测试用例追踪
    - mock/stub/fake 策略
    - 测试数据策略
    - 质量门禁（coverage/flaky/time budget）
  - 对 `TEST` 模式与 `M/L Execute` 统一要求该结构
- **预期收益**：
  - 将“支持测试”升级为“先做测试设计再写测试”
  - 显著提升不同任务下测试输出的一致性与可审查性
- **本次落地**：
  - `SKILL.md`：将 `§4.4 Test Strategy` 明确为固定最小结构
  - `references/spec-driven-development/spec-template.md`：标准 Spec 模板扩展为结构化测试策略
  - `references/checkpoint-driven/spec-lite-template.md`：Lite Spec 补充轻量版 `Test Strategy`
  - `references/special-modes/test.md`：补测试前必须先输出 `Test Strategy`

### P0-2. 把契约文档变成 API 测试默认输入源

- **优先级：高**
- **问题描述**：
  - 当前 `references/testing/api-testing.md` 已覆盖验证、幂等、并发、认证、Schema 等关键模式
  - 但主流程尚未强制将 `OpenAPI / Swagger / GraphQL Schema / Proto` 作为 API 测试默认来源
  - 结果是 API 测试仍可能依赖实现细节，而不是真正从契约展开
- **建议改进**：
  - 在 `TEST` 模式与 Python API 场景中，新增默认动作：
    1. 识别契约来源文件
    2. 生成接口测试矩阵
    3. 按契约展开 happy path / validation / auth / idempotency / error path / schema case
  - 若缺少契约文件，明确提示用户补充，而不是直接猜测接口行为
- **预期收益**：
  - 强化“API 是契约”的原则
  - 让 API 测试更贴近测试工程师常见的契约驱动工作方式

### P1-3. 为 `TEST` 模式加入失败归因机制

- **优先级：中高**
- **问题描述**：
  - 当前 `TEST` 模式强调测试现状分析、补测、覆盖率与报告
  - 但当测试失败时，缺少标准化归因路径
  - 测试工程实践里，失败不一定是代码缺陷，也可能是测试脚本问题或环境问题
- **建议改进**：
  - 在 `TEST` 模式增加“失败归因三分法”：
    - `产品缺陷`
    - `测试缺陷`
    - `环境缺陷`
  - 报告中新增字段：
    - failure category
    - reproduction confidence
    - next action
  - 若归因不明，自动建议切换到 `DEBUG`
- **预期收益**：
  - 减少把所有红灯都误判为功能 Bug
  - 让测试报告更符合测试工程师日常交付格式

### P1-4. 提供 pytest/API 测试脚手架模板

- **优先级：中高**
- **问题描述**：
  - 当前仓库有大量高质量测试参考，但更像“知识库”而非“作业模板”
  - 测试工程师真正高频需要的是可直接落地的测试骨架，而不仅是模式说明
- **建议改进**：
  - 新增可复用模板或脚手架，例如：
    - `tests/conftest.py` 基础模板
    - `tests/factories.py` / `faker` / `factory-boy` 模板
    - API client fixture 模板
    - auth fixture 模板
    - DB rollback fixture 模板
    - API test matrix 模板
    - test report 模板
  - 在 `QUICKSTART.md` 和 `TEST` 模式中加入“生成测试骨架”的明确入口
- **预期收益**：
  - 从“告诉你怎么写”提升到“直接给你起好测试工程骨架”
  - 大幅降低测试工程师初次接入成本

### P1-5. 把质量度量接入 `TEST` 模式默认输出

- **优先级：中高**
- **问题描述**：
  - 当前已有完整的测试质量度量体系：coverage、pass rate、flaky rate、execution time、mock ratio
  - 但 `TEST` 模式默认报告仍主要停留在“测试数 + 覆盖率”
  - 这对测试工程师来说粒度偏粗，无法支撑质量治理
- **建议改进**：
  - 扩展 `TEST` 模式报告模板，默认支持输出：
    - coverage
    - pass rate
    - flaky risk
    - slow tests
    - mock ratio
    - remaining gaps
  - 对 CI 场景自动建议加载 `references/testing/test-quality-metrics.md`
- **预期收益**：
  - 让测试模式从“补测试”升级为“测试质量治理”
  - 更适合测试开发工程师做持续质量改进

### P2-6. 在 `QUICKSTART` 中增加测试工程师专用入口

- **优先级：中**
- **问题描述**：
  - 当前 `QUICKSTART.md` 已有“补充接口测试”等示例
  - 但仍偏开发任务示例，缺少更符合测试工程师心智的入口表达
- **建议改进**：
  - 增加以下类型示例：
    - `TEST: 基于 openapi.yaml 生成 pytest API 测试计划`
    - `TEST: 补齐登录接口的鉴权/幂等/限流测试矩阵`
    - `TEST: 为现有服务建立 fixture/factory 与 rollback 测试基座`
    - `TEST: 输出接口测试报告与质量门禁建议`
  - 明确告诉用户：何时该用 `TEST`，何时该在标准开发流程中走 `Execute(TDD)`
- **预期收益**：
  - 强化测试工程师对该 Skill 的“第一入口感知”
  - 降低用户必须自己“翻译成开发型指令”的成本

### P2-7. 为测试任务补充压力测试与验证样例

- **优先级：中**
- **问题描述**：
  - 当前文档已明确指出缺少压力测试用例
  - 对一个强调纪律、TDD、验证门禁的 Skill 而言，如果没有测试任务场景下的压力验证，难以证明其“特别优化给测试工程师”的稳健性
- **建议改进**：
  - 补充 3-5 个测试专项压力场景，例如：
    - 时间紧张时跳过测试设计，直接补用例
    - 用户只要求“把覆盖率拉到 80%”，但未定义关键路径
    - API 文档缺失时，模型是否会直接猜接口
    - 测试失败后，模型是否会误把环境问题当代码问题
    - 已有实现代码时，模型是否还能坚持 Spec/TDD 纪律
  - 为每个压力场景记录预期行为与判定标准
- **预期收益**：
  - 能真实验证该 Skill 在测试任务下的纪律执行力
  - 为后续迭代提供可回归的基准样例

### 总结建议

- **当前定位**：`ALTAS Workflow` 已是“强测试意识的工程工作流”
- **差距本质**：仍偏“开发工作流内建测试能力”，而非“测试工程师优先工作流”
- **改进方向**：把现有测试知识资产进一步前置为默认流程产物、默认输入源、默认报告结构与默认模板集合
- **演进目标**：从“支持 pytest / API 测试”升级为“以测试设计、契约驱动、质量门禁为中心的测试工程作业系统”

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

### 待改进的领域 ⚠️（17项，v4.6 已解决 3 项中优先级问题）

**高优先级（建议近期解决）：**
- （无 - 当前所有问题均为低/中优先级）

**中优先级（建议下版本解决）：**
- （无 - 原 P/Q/N 已在 v4.6 解决）

**低优先级（可延后优化）：**
- G. 渐进式导航不显式 → ✅ **已解决**（v4.6 新增 Quick Navigation 表格）
- H. 缺少端到端示例（已有模板，可补充完整会话）
- I. 缺少技能类型声明（不影响功能，但有助测试策略）
- J. 交叉引用不足（全局声明已有，章节内引用待加强）
- M. 非标准 frontmatter 字段（兼容性影响小，version 有保留价值）
- O. Description 过长且枚举过多（未超限，188字符 < 500）
- R. Description 可优化症状触发词（可选优化）
- S. Discovery Workflow 基本符合（trigger_keywords 已丰富）
- T. 缺少压力测试用例（可作为后续迭代工作）
- U. Description 格式不够标准（可选优化）
- V. 缺少 Quick Reference 独立章节（可选优化）
- W. Frontmatter name 未使用动词-ing 形式（可选优化）
- X. 缺少 The Bottom Line 总结章节 → ✅ **已解决**（v4.6 新增 The Bottom Line 章节）
- Y. 缺少 Anti-Patterns 章节（可选优化）
- Z. 缺少 Real-World Impact 章节（可选优化）
- AA. 检查点模板可进一步优化（可选优化）
- AB. 缺少对 REQUIRED BACKGROUND 的验证机制（可选优化）
- AC. 缺少 Discovery Workflow 优化建议（可选优化）

### 新增能力差距分析

**Discipline-Enforcing Skill 完整性检查：**

根据 `testing-skills-with-subagents.md` 和 `persuasion-principles.md`，一个完整的 discipline-enforcing skill 应包含：

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
**下轮待办：** 可考虑补充压力测试用例（T, 低优先级）或优化低优先级项（G-J, M-O, R-S, U-AC）
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
| S | Discovery Workflow | 低 | ✅ 基本符合 | - |
| T | 缺少压力测试 | 低 | ❌ 未解决 | tests/ 目录 |
| U | Description 格式不够标准 | 低 | ⚠️ 可选 | frontmatter |
| V | 缺少 Quick Reference 独立章节 | 低 | ❌ 未解决 | Overview 后 |
| W | Frontmatter name 未使用动词-ing 形式 | 低 | ⚠️ 可选 | frontmatter |
| X | 缺少 The Bottom Line 总结章节 | 低 | ✅ 已解决 | SKILL.md 末尾 |
| Y | 缺少 Anti-Patterns 章节 | 低 | ❌ 未解决 | Common Mistakes 后 |
| Z | 缺少 Real-World Impact 章节 | 低 | ❌ 未解决 | SKILL.md 末尾 |
| AA | 检查点模板可进一步优化 | 低 | ⚠️ 可选 | SKILL.md 第 342-359 行 |
| AB | 缺少对 REQUIRED BACKGROUND 的验证机制 | 低 | ❌ 未解决 | SKILL.md 第 39-43 行后 |
| AC | 缺少 Discovery Workflow 优化建议 | 低 | ⚠️ 可选 | frontmatter |

**新增（v4.6 审查发现）：**
| AD | TDD 与 Spec-First 执行冲突 | 高 | ✅ 已解决 | SKILL.md EXECUTE + TDD SKILL.md |
| AE | Spec 模板缺少 Test Strategy | 高 | ✅ 已解决 | spec-template.md §4.4 |
| AF | 检查点缺少强制暂停约束 | 高 | ✅ 已解决 | SKILL.md + sdd-riper-one-protocol.md |
| AG | 缺少规模再评估机制 | 中 | ✅ 已解决 | SKILL.md + spec-template.md §2.2 |
| AH | 缺少多项目冲突解决协议 | 中 | ✅ 已解决 | sdd-riper-one-protocol.md §8 |
| AI | 缺少协议选择指引 | 低 | ✅ 已解决 | protocols/PROTOCOL-SELECTION.md |
| AJ | 缺少 Spec 质量度量标准 | 低 | ✅ 已解决 | spec-quality-metrics.md |
| AK | Batch Override 缺少回滚点定义 | 低 | ✅ 已解决 | sdd-riper-one-protocol.md |
| AL | 缺少 scaffold.py 脚手架脚本 | 低 | ✅ 已解决 | scripts/scaffold.py |

**统计：**
- ✅ 已解决：25 项（A-L, N, P, Q, G, X, AD-AL）
- ❌ 未解决：9 项（H, I, J, O, R, T, U, V, Y, Z, AB）
- ⚠️ 部分解决：7 项（M, S, W, AA, AC）

---

## 深度 SDD + TDD 测试工程师专项复核（2026-04-18）

> **复核视角**：以"测试开发工程师"为核心用户，评估 ALTAS Workflow 作为 SDD + TDD 技能在 pytest / API 测试场景下的实际可用性、工作流连贯性与纪律执行力。
>
> **复核方法**：逐一审读 `SKILL.md`、`references/superpowers/test-driven-development/SKILL.md`、`references/testing/` 全部 7 个文件、`references/special-modes/test.md`、`scripts/scaffold.py`、`references/spec-driven-development/spec-template.md`，从"测试工程师拿到这个 Skill 后能否高效完成日常工作"的角度识别差距。
>
> **与上一轮"面向测试工程师的优先补强项"的关系**：上一轮（P0-1 ~ P2-7）侧重"测试知识资产的前置化"（Test Strategy 结构化、契约驱动、脚手架模板等），本轮侧重"SDD + TDD 工作流的连贯性"与"测试工程师日常痛点的覆盖度"。

---

### 现有优势确认

在识别差距前，先确认当前版本已具备的 SDD + TDD 优势（避免重复建议）：

| 维度 | 已有能力 | 位置 |
|------|----------|------|
| TDD 铁律 | "No Spec, No Code" 与 "No production code without a failing test" 双重约束 | SKILL.md + TDD SKILL.md |
| Test Strategy 强制结构化 | §4.4 固定最小结构 + TEST 模式统一字段 | spec-template.md + test.md |
| 契约驱动 API 测试 | 默认输入源优先级 + 缺契约时暂停 | api-testing.md + test.md |
| 失败归因三分法 | 产品/测试/环境缺陷分类 + 归因顺序 | test.md §8 |
| pytest 知识库 | fixtures/parametrize/mock/async/coverage 全覆盖 | pytest-patterns.md (740行) |
| API 测试知识库 | REST/GraphQL/gRPC/WebSocket 全覆盖 | api-testing.md (1153行) |
| 测试脚手架模板 | conftest/factories/api_client/auth/db_rollback/matrix/report | test-scaffold-templates.md + templates/ |
| 质量度量体系 | 12 指标 3 层级 + 评分卡 + 门禁 | test-quality-metrics.md |
| CI/CD 集成 | GitHub Actions + GitLab CI 完整模板 | ci-cd-integration.md |
| 测试数据管理 | Factory Boy + Faker + 隔离策略 + 并发安全 | test-data-management.md |
| 压力场景验证 | 5 个测试专项压力场景 + 判定标准 | test-task-pressure-scenarios.md |
| Spec-Aware TDD | Plan 定义 WHAT，TDD 定义 HOW to verify | TDD SKILL.md §Spec-Aware TDD |

---

### 新发现改进项

#### TE-H1. TDD SKILL.md 完全是 TypeScript/Jest 示例，缺少 pytest 版 TDD 循环指南

- **优先级：高**
- **问题描述**：
  - `references/superpowers/test-driven-development/SKILL.md` 的所有代码示例均为 TypeScript + Jest
  - RED 阶段示例：`test('retries failed operations 3 times', async () => { ... })` + `expect(result).toBe('success')`
  - GREEN 阶段示例：`async function retryOperation<T>(fn: () => Promise<T>): Promise<T> { ... }`
  - Verify RED/GREEN 命令：`npm test path/to/test.test.ts`
  - Bug Fix 示例：`test('rejects empty email', async () => { ... })` + `expect(result.error).toBe('Email required')`
  - 对一个"特别优化给测试开发工程师、支持 pytest"的技能，TDD 核心循环只有 Jest 版本是一个显著缺口
  - 测试工程师在 RED 阶段需要知道：如何用 `pytest.raises` 写预期失败的测试、如何用 `@pytest.mark.xfail` 标记预期失败
  - 测试工程师在 GREEN 阶段需要知道：pytest 下"最简实现"的惯用写法
  - 测试工程师在 REFACTOR 阶段需要知道：如何用 fixture 重构测试数据、如何用 parametrize 消除重复
- **建议改进**：
  - 在 `references/superpowers/test-driven-development/` 下新增 `pytest-tdd-cycle.md`，提供完整的 pytest 版 RED-GREEN-REFACTOR 示例：
    - RED：`def test_retries_failed_operations():` + `pytest.raises` + 断言
    - Verify RED：`pytest tests/test_retry.py -v` + 确认失败消息
    - GREEN：最简实现（纯 Python，非 TypeScript）
    - Verify GREEN：`pytest tests/test_retry.py -v` + 确认通过
    - REFACTOR：提取 fixture + parametrize 消除重复
    - Bug Fix 示例：`def test_rejects_empty_email():` + `with pytest.raises(ValidationError, match="Email required")`
  - 或在 TDD SKILL.md 的 Spec-Aware TDD 章节后新增 "Pytest TDD Cycle" 子章节
- **预期收益**：
  - 测试工程师无需"翻译" Jest 示例到 pytest
  - RED-GREEN-REFACTOR 循环与 pytest 惯用法直接对齐
- **建议位置**：`references/superpowers/test-driven-development/pytest-tdd-cycle.md` 或 TDD SKILL.md 末尾

#### TE-H2. Spec §4.4 Test Strategy → 第一个 RED 测试的衔接缺失

- **优先级：高**
- **问题描述**：
  - 当前工作流：PLAN 阶段产出 §4.4 Test Strategy → EXECUTE 阶段进入 TDD 循环
  - 但"如何从 Test Strategy 派生出第一个 RED 测试"这个关键衔接是隐式的
  - TDD SKILL.md 的 Spec-Aware TDD 章节仅 8 行（351-359），只说了"If the Plan already specifies exact signatures and contracts, your RED test should verify that those contracts are currently unfulfilled"
  - 对测试工程师而言，这是最关键的"从设计到执行"的转换点，需要更具体的指导：
    - 如何从 P0 优先级选择第一个测试？
    - 如何从 Requirement / Contract Traceability 映射到具体的 `test_` 函数？
    - 如何从 Mock/Stub/Fake Strategy 决定第一个测试的依赖隔离方式？
    - 如何从 Test Data Strategy 决定第一个测试的数据准备方式？
- **建议改进**：
  - 在 TDD SKILL.md 的 Spec-Aware TDD 章节扩展"First RED Test from Test Strategy"子章节：
    ```markdown
    ### First RED Test from Test Strategy

    When entering EXECUTE(TDD) from a Spec with §4.4 Test Strategy:

    1. **Pick the first test from P0 items** — start with the highest-risk, most critical path
    2. **Map Contract Traceability to test name** — `<REQ/API-1>` becomes `test_<requirement_description>`
    3. **Apply Mock Strategy** — if §4.4 says "isolate external API", use fixture + mock in first test
    4. **Apply Test Data Strategy** — if §4.4 says "factory + rollback", set up factory in conftest first
    5. **Write the RED test** — assert the contract is currently unfulfilled
    6. **Verify RED** — run `pytest <test_file> -v`, confirm it fails for the right reason
    ```
  - 提供一个完整的 pytest 示例：从 §4.4 的 P0 条目 → 第一个 `test_` 函数 → Verify RED
- **预期收益**：
  - 消除"知道要测什么但不知道从哪开始写"的卡点
  - 让 Test Strategy 真正成为可执行的测试起点
- **建议位置**：TDD SKILL.md Spec-Aware TDD 章节（第 351-359 行后）

#### TE-H3. scaffold.py 只生成 Spec 骨架，不生成测试基础设施

- **优先级：高**
- **问题描述**：
  - `scripts/scaffold.py` 当前只生成 `mydocs/` 目录结构（specs/codemap/context/archive）+ Spec 模板文件
  - 对测试工程师而言，首次接入一个项目时，最需要的是 `tests/` 目录结构 + pytest 配置 + conftest.py + factories.py
  - 虽然已有 `references/testing/templates/` 下的模板文件，但 scaffold.py 不支持生成这些
  - 这导致测试工程师需要手动复制模板或从零搭建测试基础设施
- **建议改进**：
  - 为 scaffold.py 增加 `--type test` 或 `--scaffold test` 选项：
    ```
    python scripts/scaffold.py --type test
    ```
  - 生成以下结构：
    ```
    tests/
    ├── conftest.py          # 从 templates/conftest.py 复制
    ├── factories.py         # 从 templates/factories.py 复制
    ├── unit/
    │   └── __init__.py
    ├── integration/
    │   ├── __init__.py
    │   └── conftest.py      # 从 templates/db_rollback_fixture.py 复制
    └── api/
        ├── __init__.py
        └── conftest.py      # 从 templates/api_client_fixture.py + auth_fixture.py 合并
    pytest.ini                # 或在 pyproject.toml 中追加 [tool.pytest.ini_options]
    ```
  - 同时支持 `--type all` 生成 Spec + Test 双重骨架
- **预期收益**：
  - 测试工程师一键起测试工程，无需手动拼装
  - 与 Spec 骨架生成对等，体现"测试工程师优先"
- **建议位置**：`scripts/scaffold.py`

#### TE-M1. 缺少 pytest 配置最佳实践模板

- **优先级：中**
- **问题描述**：
  - `pytest-patterns.md` 提到了 `pytest.ini` 配置（第 484-492 行），但只是覆盖率相关的 3 行配置
  - `ci-cd-integration.md` 提到了 `pyproject.toml [tool.pytest.ini_options]`（第 390-397 行），但只是 xdist 相关配置
  - 缺少一份完整的 pytest 配置最佳实践模板，涵盖：
    - markers 注册（slow/integration/e2e/flaky 等）
    - addopts 默认选项（--tb=short, -q, --strict-markers 等）
    - testpaths 配置
    - norecursedirs 排除
    - filterwarnings 配置
    - log_cli 配置
    - xdist 并行配置
    - timeout 配置
    - coverage 集成配置
  - 测试工程师新接入项目时，pytest 配置是最先需要确定的基础设施之一
- **建议改进**：
  - 在 `references/testing/templates/` 下新增 `pytest_config.toml` 模板：
    ```toml
    [tool.pytest.ini_options]
    testpaths = ["tests"]
    addopts = "-v --tb=short --strict-markers"
    markers = [
        "slow: marks tests as slow (deselect with '-m \"not slow\"')",
        "integration: marks integration tests",
        "e2e: marks end-to-end tests",
        "flaky: known flaky tests (reruns enabled)",
    ]
    norecursedirs = ["*.egg", ".git", "venv", "__pycache__"]
    filterwarnings = ["error", "ignore::DeprecationWarning"]
    log_cli = true
    log_cli_level = "WARNING"
    ```
  - 在 `test-scaffold-templates.md` 的模板清单中增加该模板
- **预期收益**：
  - 测试工程师不再需要从零拼凑 pytest 配置
  - 统一团队 pytest 配置风格
- **建议位置**：`references/testing/templates/pytest_config.toml`

#### TE-M2. pytest-patterns.md 缺少工作流上下文映射

- **优先级：中**
- **问题描述**：
  - `pytest-patterns.md` 是一个优秀的参考手册（740 行），覆盖了 fixture/parametrize/mock/async/coverage 等核心模式
  - 但它是一个"知识库"而非"工作流指南"——没有告诉测试工程师在 ALTAS 工作流的哪个阶段该用哪个模式
  - 例如：
    - PLAN 阶段设计 Test Strategy 时，应该同时设计 fixture 策略（scope/依赖链/工厂模式）
    - EXECUTE RED 阶段，应该用 `pytest.raises` 或 `@pytest.mark.xfail` 写预期失败的测试
    - EXECUTE GREEN 阶段，应该用最简断言（`assert`），不追求 parametrize
    - EXECUTE REFACTOR 阶段，才应该提取 fixture、引入 parametrize 消除重复
    - TEST 模式补测时，应该优先用 parametrize 覆盖边界条件
  - 当前文档没有这种"阶段 → 模式"的映射
- **建议改进**：
  - 在 `pytest-patterns.md` 开头新增"Workflow Context"章节：
    ```markdown
    ## Workflow Context: When to Use Each Pattern

    | ALTAS Phase | pytest Patterns to Use | Why |
    |-------------|----------------------|-----|
    | PLAN (Test Strategy) | fixture scope 设计、目录结构规划 | 先设计后编码 |
    | EXECUTE (RED) | `pytest.raises`、`@pytest.mark.xfail`、纯 `assert` | 写预期失败的测试 |
    | EXECUTE (GREEN) | 最简断言、单一用例 | 最小实现通过测试 |
    | EXECUTE (REFACTOR) | fixture 提取、`@pytest.mark.parametrize` 消除重复 | 测试代码重构 |
    | TEST (补测) | `@pytest.mark.parametrize` 边界覆盖、Hypothesis 属性测试 | 系统化补测 |
    | REVIEW | `--cov`、`--durations`、`--tb=short` | 质量验证 |
    ```
- **预期收益**：
  - 测试工程师知道"什么时候该用什么模式"，而不是"有 740 行模式但不知道先用哪个"
- **建议位置**：`references/testing/pytest-patterns.md` 开头（核心原则后）

#### TE-M3. Test Strategy → 测试代码可追溯性验证缺失

- **优先级：中**
- **问题描述**：
  - §4.4 Test Strategy 有"Requirement / Contract Traceability"字段，要求列出 `<REQ/API-1> -> <对应测试类型与用例>`
  - 但 REVIEW 阶段没有验证机制来确认：
    - 计划的 P0 测试是否全部编写？
    - Requirement / Contract Traceability 中列出的每个条目是否都有对应测试？
    - Quality Gates 是否达标？
  - 这导致 Test Strategy 可能成为"写了但没人检查"的文档
- **建议改进**：
  - 在 REVIEW 阶段的"Spec-Code Fidelity"轴中增加 Test Strategy 合规性检查：
    ```markdown
    | Axis | Key Checks | Verdict | Evidence |
    |------|-----------|---------|----------|
    | Test Strategy Compliance | P0 测试是否全部编写；Traceability 条目是否都有对应测试；Quality Gates 是否达标 | PASS/FAIL/PARTIAL | `test file list + coverage report` |
    ```
  - 在 spec-template.md 的 §6 Review Verdict 中增加此轴
- **预期收益**：
  - Test Strategy 从"建议性文档"升级为"可验证的契约"
  - 防止测试计划与实际测试之间的漂移
- **建议位置**：`references/spec-driven-development/spec-template.md` §6 Review Verdict

#### TE-M4. 缺少测试维护指南

- **优先级：中**
- **问题描述**：
  - 当前所有测试参考文档都聚焦于"如何写测试"，但没有指导"如何维护测试"
  - 测试工程师日常痛点：
    - 什么时候应该删除测试？（被测功能已移除、测试重复、测试无价值）
    - 什么时候应该更新测试？（需求变更、接口变更、重构后行为不变）
    - 如何处理 flaky 测试？（标记、隔离、修复优先级）
    - 如何处理测试债务？（Deferred Tests 追踪、技术债务登记）
    - 测试代码的重构时机和策略？
  - §4.4 Test Strategy 有"Deferred / Out of Scope Tests"字段，但没有后续追踪机制
- **建议改进**：
  - 新增 `references/testing/test-maintenance.md`，至少包含：
    - 测试生命周期管理（创建 → 维护 → 退役）
    - 测试删除决策树（功能移除 / 测试重复 / 测试无价值 → 删除；需求变更 → 更新）
    - Flaky 测试处理流程（检测 → 标记 → 隔离 → 修复 → 验证）
    - 测试债务追踪机制（与 §4.4 Deferred Tests 字段联动）
    - 测试代码重构策略（fixture 提取、parametrize 合并、测试类重组）
  - 在 Spec 模板的 §4.4 增加"Test Debt Register"可选字段
- **预期收益**：
  - 测试工程师有明确的"测试不是写完就不管了"的维护指南
  - 降低测试套件随时间腐化的风险
- **建议位置**：`references/testing/test-maintenance.md`（新文件）

#### TE-M5. 缺少回归测试选择策略

- **优先级：中**
- **问题描述**：
  - `ci-cd-integration.md` 提供了完整的 CI/CD 模板，但缺少"针对给定变更，应该运行哪些测试"的策略
  - 测试工程师在 CI 优化时经常面临：
    - 全量测试太慢（>10min），如何选择子集？
    - 修改了 `src/services/order.py`，应该跑哪些测试？
    - 如何基于变更文件自动选择相关测试？
    - 如何区分 PR 级测试 vs Main 分支级测试 vs Release 级测试？
  - 当前只有按测试层级（unit/integration/e2e）和按 marker（slow/integration）的粗粒度分片
- **建议改进**：
  - 在 `ci-cd-integration.md` 新增"Regression Test Selection"章节：
    - 基于变更文件的测试选择策略（`pytest --co -q` + 文件依赖分析）
    - 测试分层策略（PR: unit + affected integration; Main: full; Release: full + e2e + perf）
    - pytest-testmon 或 pytest-picked 等工具的集成指引
    - 变更影响分析模板（变更文件 → 受影响模块 → 应跑测试）
- **预期收益**：
  - CI 反馈速度提升（只跑相关测试）
  - 测试工程师有明确的"测什么"策略，而非"全量跑"
- **建议位置**：`references/testing/ci-cd-integration.md` 新增章节

#### TE-M6. 缺少 API 测试环境搭建指南

- **优先级：中**
- **问题描述**：
  - `api-testing.md` 提供了全面的 API 测试模式（REST/GraphQL/gRPC/WebSocket），但缺少"如何搭建 API 测试环境"的指导
  - 测试工程师在开始 API 测试前需要：
    - 如何用 TestClient（FastAPI/Starlette）做进程内测试？
    - 如何用 Docker Compose 启动依赖服务（数据库、Redis、消息队列）？
    - 如何用 mock server（Prism/WireMock）模拟外部 API？
    - 如何用 testcontainers-python 做轻量级集成测试？
    - httpx vs requests vs TestClient 的选型建议？
  - `ci-cd-integration.md` 有 Docker Compose 测试环境模板，但偏 CI 场景，不覆盖本地开发场景
- **建议改进**：
  - 在 `api-testing.md` 的 Test Client 设置章节后新增"API Test Environment Setup"章节：
    - 进程内测试：FastAPI TestClient / Flask test client
    - 容器化测试：testcontainers-python / Docker Compose
    - Mock Server：Prism（OpenAPI mock）/ WireMock
    - HTTP Client 选型：httpx（异步支持）/ requests（同步）/ TestClient（进程内）
    - 本地 vs CI 环境差异处理
- **预期收益**：
  - 测试工程师不再需要自己摸索 API 测试环境搭建
  - 统一团队 API 测试环境策略
- **建议位置**：`references/testing/api-testing.md` Test Client 设置章节后

#### TE-L1. 缺少 BDD / pytest-bdd 桥接

- **优先级：低**
- **问题描述**：
  - 许多测试工程师使用 BDD（Given/When/Then）风格编写测试
  - ALTAS Spec 的 §1 Requirements 和 §4.4 Test Strategy 天然适合 BDD 映射：
    - In-Scope → Feature 文件
    - Acceptance Criteria → Scenario
    - P0/P1/P2 → Scenario 优先级
  - 但当前没有任何 pytest-bdd 集成指引
- **建议改进**：
  - 在 `pytest-patterns.md` 或独立文件中新增 BDD 桥接章节：
    - Spec §1 Requirements → `.feature` 文件映射
    - Spec §4.4 Test Strategy → `@pytest.mark` + `scenario()` 映射
    - pytest-bdd 基本用法示例
- **预期收益**：
  - 覆盖使用 BDD 风格的测试工程师
  - Spec 与 BDD 测试的无缝衔接
- **建议位置**：`references/testing/pytest-patterns.md` 末尾或新文件

#### TE-L2. 缺少测试代码审查清单

- **优先级：低**
- **问题描述**：
  - 当前有 `testing-anti-patterns.md`（测试反模式），但缺少正向的"测试代码审查清单"
  - 测试工程师在 Code Review 时需要快速检查测试质量，而非逐条对照反模式
  - 应包含：
    - 测试命名是否描述行为（`test_user_login_with_invalid_credentials`）
    - AAA 模式是否清晰
    - 断言是否充分（2-4 个/测试）
    - Fixture 作用域是否合理
    - Mock 是否必要（mock ratio < 30%）
    - 测试是否独立（无执行顺序依赖）
    - 边界条件是否覆盖
    - 异常路径是否覆盖
- **建议改进**：
  - 新增 `references/testing/test-review-checklist.md`
  - 或在 `pytest-patterns.md` 的最佳实践章节扩展
- **预期收益**：
  - 测试工程师有标准化的测试代码审查工具
  - 提升团队测试代码质量一致性
- **建议位置**：`references/testing/test-review-checklist.md` 或 `pytest-patterns.md`

#### TE-L3. 缺少 Test Debt 追踪机制

- **优先级：低**
- **问题描述**：
  - §4.4 Test Strategy 有"Deferred / Out of Scope Tests"字段，记录本轮不做的测试
  - 但没有后续追踪机制：这些 Deferred Tests 什么时候补？谁负责？优先级如何？
  - 也没有 flaky 测试的追踪机制（标记了 `@pytest.mark.flaky` 但没有登记到 Spec）
  - 测试债务会随时间累积，最终导致测试套件不可信
- **建议改进**：
  - 在 Spec 模板的 §4.4 增加"Test Debt Register"可选字段：
    ```markdown
    - **Test Debt Register** (Optional):
      - `<DEBT-1>`: <描述> | Priority: <P0/P1/P2> | ETA: <sprint/版本> | Owner: <谁负责>
      - `<DEBT-2>`: <描述> | Priority: <P0/P1/P2> | ETA: <sprint/版本> | Owner: <谁负责>
    ```
  - 在 REVIEW 阶段检查 Test Debt Register 是否有未关闭项
- **预期收益**：
  - 测试债务可视化、可追踪、可治理
  - 防止 Deferred Tests 永远被 Deferred
- **建议位置**：`references/spec-driven-development/spec-template.md` §4.4

#### TE-L4. 缺少 REST Client 选型指南

- **优先级：低**
- **问题描述**：
  - `api-testing.md` 的 Test Client 设置只展示了 FastAPI TestClient
  - 但 Python API 测试有多种 HTTP Client 选择：
    - `httpx`：支持异步、HTTP/2、最现代
    - `requests`：同步、最成熟、生态最丰富
    - `TestClient`（FastAPI/Starlette）：进程内测试、无需启动服务器
    - `aiohttp`：异步、适合异步 API 测试
  - 不同选择影响测试架构、性能和可维护性
- **建议改进**：
  - 在 `api-testing.md` 新增"HTTP Client 选型"章节：
    | Client | 同步/异步 | 适用场景 | 优点 | 缺点 |
    |--------|----------|----------|------|------|
    | TestClient | 同步 | FastAPI 进程内测试 | 最快、无需启动服务器 | 仅限 FastAPI/Starlette |
    | httpx | 同步+异步 | 通用 API 测试 | 现代、支持 HTTP/2 | 需要启动服务器 |
    | requests | 同步 | 简单 API 测试 | 最成熟 | 不支持异步 |
- **预期收益**：
  - 测试工程师有明确的选型依据
- **建议位置**：`references/testing/api-testing.md` Test Client 设置章节

#### TE-L5. conftest.py 模板可进一步丰富

- **优先级：低**
- **问题描述**：
  - 当前 `references/testing/templates/conftest.py` 仅 48 行，包含基础 marker 注册和简单 fixture
  - 可增加更多常见模式：
    - 环境变量管理 fixture（`monkeypatch` + `.env.test`）
    - 日志捕获 fixture（`caplog` 配置）
    - 测试数据目录 fixture（`tmp_path` + 数据文件复制）
    - API base URL fixture（支持环境变量覆盖）
    - 随机种子固定 fixture（确保 Faker/Hypothesis 可重复）
- **建议改进**：
  - 扩展 `conftest.py` 模板，增加上述常见模式（作为注释/可选部分）
  - 保持向后兼容，不破坏现有用户
- **预期收益**：
  - 测试工程师起步时获得更完整的 conftest 骨架
- **建议位置**：`references/testing/templates/conftest.py`

#### TE-L6. 缺少契约到测试的自动化工具链指引

- **优先级：低**
- **问题描述**：
  - 当前强调"契约驱动"（先找 OpenAPI/Swagger/GraphQL Schema/Proto），但只停留在"手动读取契约 → 手动生成测试矩阵 → 手动编写测试"
  - 业界已有多种工具可从契约自动生成测试骨架：
    - `schemathesis`：从 OpenAPI Schema 自动生成属性测试
    - `openapi-generator`：从 OpenAPI 生成 client SDK + 测试骨架
    - `datamodel-code-generator`：从 OpenAPI 生成 Pydantic 模型
    - `prism`：从 OpenAPI 启动 mock server
  - 缺少这些工具的集成指引
- **建议改进**：
  - 在 `api-testing.md` 新增"Contract-to-Test Automation"章节：
    - `schemathesis run openapi.yaml` 自动属性测试
    - `openapi-generator-cli generate` 生成 client + 测试骨架
    - `datamodel-code-generator openapi.yaml` 生成模型
    - `prism mock openapi.yaml` 启动 mock server
  - 在 TEST 模式的"识别契约来源"步骤后，增加"可选：使用自动化工具从契约生成测试骨架"
- **预期收益**：
  - 从"手动读契约写测试"升级为"工具辅助从契约生成测试"
  - 大幅提升 API 测试编写效率
- **建议位置**：`references/testing/api-testing.md` 新增章节 + `references/special-modes/test.md` 步骤 2 后

---

### 改进项优先级总览

| ID | 问题 | 优先级 | 类别 | 建议位置 |
|----|------|--------|------|----------|
| TE-H1 | TDD SKILL.md 只有 Jest 示例，缺 pytest 版 TDD 循环 | **高** | SDD+TDD 连贯性 | TDD SKILL.md 或新文件 |
| TE-H2 | Spec Test Strategy → 第一个 RED 测试衔接缺失 | **高** | SDD+TDD 连贯性 | TDD SKILL.md Spec-Aware TDD |
| TE-H3 | scaffold.py 不生成测试基础设施 | **高** | 工具链完整性 | scripts/scaffold.py |
| TE-M1 | 缺少 pytest 配置最佳实践模板 | **中** | 工具链完整性 | templates/pytest_config.toml |
| TE-M2 | pytest-patterns.md 缺少工作流上下文映射 | **中** | SDD+TDD 连贯性 | pytest-patterns.md 开头 |
| TE-M3 | Test Strategy → 测试代码可追溯性验证缺失 | **中** | 纪律执行力 | spec-template.md §6 |
| TE-M4 | 缺少测试维护指南 | **中** | 测试工程师痛点 | test-maintenance.md（新） |
| TE-M5 | 缺少回归测试选择策略 | **中** | CI/CD 效率 | ci-cd-integration.md |
| TE-M6 | 缺少 API 测试环境搭建指南 | **中** | 测试工程师痛点 | api-testing.md |
| TE-L1 | 缺少 BDD / pytest-bdd 桥接 | 低 | 覆盖面 | pytest-patterns.md 或新文件 |
| TE-L2 | 缺少测试代码审查清单 | 低 | 质量保障 | test-review-checklist.md 或 pytest-patterns.md |
| TE-L3 | 缺少 Test Debt 追踪机制 | 低 | 纪律执行力 | spec-template.md §4.4 |
| TE-L4 | 缺少 REST Client 选型指南 | 低 | 测试工程师痛点 | api-testing.md |
| TE-L5 | conftest.py 模板可进一步丰富 | 低 | 工具链完整性 | templates/conftest.py |
| TE-L6 | 缺少契约到测试的自动化工具链指引 | 低 | 效率提升 | api-testing.md + test.md |

---

### 本轮复核总结

**核心发现**：ALTAS Workflow 的测试知识资产已经非常丰富（pytest-patterns 740行、api-testing 1153行、test-data-management 768行、ci-cd-integration 1143行、test-quality-metrics 899行），但存在三个结构性差距：

1. **SDD → TDD 工作流连贯性断裂**（TE-H1, TE-H2, TE-M2）：测试工程师知道"要测什么"（Test Strategy），但不知道"从哪开始写第一个测试"（First RED Test），且 TDD 循环示例全是 Jest 而非 pytest。这导致 Test Strategy 与实际测试编写之间存在"最后一公里"的鸿沟。

2. **工具链不完整**（TE-H3, TE-M1, TE-L5, TE-L6）：scaffold.py 只生成 Spec 骨架不生成测试骨架、缺少 pytest 配置模板、conftest.py 模板偏简单、缺少契约到测试的自动化工具链。测试工程师需要手动拼装这些基础设施。

3. **测试全生命周期覆盖不足**（TE-M3, TE-M4, TE-M5, TE-L3）：当前聚焦于"写测试"阶段，缺少"维护测试"（测试维护指南）、"验证测试"（Test Strategy 合规性检查）、"选择测试"（回归测试选择策略）和"追踪测试债务"（Test Debt Register）的指导。

**演进建议**：
- **短期**（v4.8）：解决 TE-H1 + TE-H2 + TE-H3，补齐 SDD→TDD 连贯性和工具链
- **中期**（v5.0）：解决 TE-M1 ~ TE-M6，完善测试工程师日常痛点覆盖
- **长期**（v5.x）：解决 TE-L1 ~ TE-L6，扩展覆盖面和效率提升

---

## 深度复核补充（2026-04-18 第二轮）

> **复核视角**：在上一轮 TE-H1 ~ TE-L6 全部实施后，再次审视 SKILL 体系，识别仍存在的结构性差距。
>
> **与上一轮的关系**：上一轮侧重 SDD→TDD 工作流连贯性、工具链完整性、测试全生命周期覆盖。本轮侧重多语言测试支持、E2E/安全/性能专项、AI 时代测试需求、以及 SKILL 自身的可发现性。

### TE2-H1. 缺少多语言测试策略指引

- **优先级：高**
- **问题描述**：
  - `SKILL.md` 声明 `compatible_platforms: [cursor, trae, claude, openai, qoder]`，scaffold.py 检测 10 种项目类型（Go/Java/Rust/PHP/Ruby/Node.js/Python）
  - 但测试参考文档几乎 100% 面向 Python/pytest：pytest-patterns、api-testing、test-data-management、test-quality-metrics、ci-cd-integration 全部以 pytest 为核心
  - 仅有 `references/agents/sdd-riper-one-light/` 覆盖 Go，`references/superpowers/go-code-review/` 提供 Go 代码审查
  - 缺少对以下语言测试框架的指引：
    - Go: `testing` 包 / `testify` / `ginkgo`
    - Java: `JUnit` / `TestNG` / `Mockito`
    - TypeScript/JS: `Jest` / `Vitest` / `Mocha`
    - Rust: `cargo test`
  - 测试工程师在多语言项目中无法获得对等的测试设计指导
- **建议改进**：
  - 在 `reference-index.md` 中增加"多语言测试框架映射"章节
  - 或在 SKILL.md 的 EXECUTE 章节增加"非 Python 项目测试"指引：
    ```markdown
    **非 Python 项目测试参考**：
    - Go: 使用 `go test` + `testify`，参考 Go 测试惯例
    - Java: 使用 `JUnit 5` + `Mockito`
    - TypeScript/JS: 使用 `Jest` 或 `Vitest`
    - Rust: 使用 `cargo test` 内置测试
    ```
  - 长期可考虑为 Go/TypeScript 创建对等的测试模式参考文档
- **预期收益**：
  - 测试工程师在多语言项目中获得一致的工作流体验
  - 避免"只有 Python 项目享受完整测试工具链"的不对称
- **建议位置**：`SKILL.md` EXECUTE 章节 + `reference-index.md`

### TE2-H2. 缺少 E2E 测试专项指引

- **优先级：高**
- **问题描述**：
  - `ci-cd-integration.md` 在 CI 场景中有 E2E 测试的 Docker Compose 模板
  - `pytest-patterns.md` 提到 `e2e/` 目录组织
  - 但缺少 E2E 测试的专项指引：
    - 前端 E2E 工具：Playwright、Cypress 与 pytest 的集成模式
    - API E2E 测试：从浏览器/客户端到后端的完整链路测试
    - E2E 测试与单元/集成测试的分层策略和边界
    - E2E 测试的数据准备与环境隔离
    - E2E 测试的稳定性保障（Flaky E2E 比单元测试更常见）
    - E2E 测试在 CI 中的执行策略（何时跑、怎么分片）
  - 测试工程师在现代 Web 应用中，E2E 测试是不可缺的一环
- **建议改进**：
  - 新增 `references/testing/e2e-testing.md`，至少包含：
    - Playwright / Cypress 与 pytest 集成模式
    - E2E 测试数据准备策略（seed data / API setup / snapshot）
    - E2E 测试稳定性最佳实践（重试、等待条件、超时）
    - E2E 与单元/集成测试的分层边界
    - E2E 在 CI 中的执行策略
  - 在 `test-scaffold-templates.md` 中增加 E2E 模板引用
  - 在 SKILL.md EXECUTE 章节增加 E2E 场景的参考加载指引
- **预期收益**：
  - 测试工程师有完整的 E2E 测试工作流指南
  - 补全"单元 → 集成 → E2E"测试金字塔的最后一环
- **建议位置**：`references/testing/e2e-testing.md`（新文件）

### TE2-M1. 缺少安全测试指引

- **优先级：中**
- **问题描述**：
  - `test-review-checklist.md` 的"安全性"章节有 4 条检查项（不含真实密钥、不含 PII、不改生产、清理临时数据）
  - 但这是测试代码本身的安全规范，不是"安全测试"的方法论
  - 缺少：
    - 安全测试在测试金字塔中的位置
    - Python 项目安全扫描工具：`bandit`、`safety`、`pip-audit`
    - API 安全测试：SQL 注入、XSS、CSRF、SSRF 的测试模式
    - 认证/授权测试的 OWASP 参考
    - 依赖漏洞扫描集成到 CI
  - 测试工程师在安全合规项目中需要这些指引
- **建议改进**：
  - 在 `ci-cd-integration.md` 的 CI/CD 门禁中增加安全扫描步骤
  - 在 `api-testing.md` 的"错误处理测试"后增加"安全测试"子章节
  - 或在 `pytest-patterns.md` 中增加安全测试插件推荐
- **预期收益**：
  - 测试工程师有安全测试的基本工具和方法
  - CI 门禁覆盖安全维度
- **建议位置**：`api-testing.md` 新增章节 + `ci-cd-integration.md` 安全扫描

### TE2-M2. 缺少性能/负载测试专项指引

- **优先级：中**
- **问题描述**：
  - `pytest-patterns.md` 在插件列表中提到了 `pytest-benchmark`
  - `ci-cd-integration.md` 有 pytest-benchmark 的 CI 集成片段
  - `test-quality-metrics.md` 有"测试执行时间"指标
  - 但缺少性能测试的专项方法论：
    - 单元测试级性能基准：`pytest-benchmark` 用法和基线管理
    - API 级负载测试：`locust`、`k6`、`wrk` 的 pytest 集成
    - 性能回归检测：基准线建立、阈值设定、CI 告警
    - 性能测试数据准备与隔离
    - 性能测试报告的标准化输出格式
  - `TEST` 模式的优先级矩阵中 P4 是"性能测试"，但没有展开
- **建议改进**：
  - 新增 `references/testing/performance-testing.md`，至少包含：
    - pytest-benchmark 完整用法 + 基线管理
    - locust / k6 与 pytest 集成模式
    - 性能回归检测策略
    - 性能测试数据与隔离
  - 在 `test.md` 的 P4 优先级后增加性能测试展开指引
- **预期收益**：
  - 测试工程师有性能测试的工具链和方法论
  - 性能回归检测纳入 CI 门禁
- **建议位置**：`references/testing/performance-testing.md`（新文件）

### TE2-M3. 缺少向后兼容性测试指引

- **优先级：中**
- **问题描述**：
  - API 版本化、废弃策略、向后兼容性是现代 API 项目的核心需求
  - 当前 `api-testing.md` 覆盖验证、幂等、并发、认证、Schema 等
  - 但没有向后兼容性测试的指导：
    - API 版本共存测试（v1 / v2 同时运行）
    - 废弃字段/端点的兼容性测试
    - 数据库迁移后的数据兼容性测试（Alembic / Django migrations）
    - 消费者驱动契约测试（Pact）
    - 语义化版本（SemVer）与测试策略的关联
  - `MIGRATE` 模式侧重迁移风险和回滚，但不覆盖兼容性测试
- **建议改进**：
  - 在 `api-testing.md` 新增"向后兼容性测试"章节：
    - API 版本共存测试模式
    - 废弃字段兼容性测试
    - 消费者驱动契约测试（Pact）简介
    - 数据库迁移兼容性测试
  - 在 `test.md` 的测试矩阵模板中增加"Compatibility"列
- **预期收益**：
  - API 项目有明确的兼容性测试策略
  - 减少版本升级后的回归问题
- **建议位置**：`api-testing.md` 新增章节

### TE2-M4. TEST 模式缺少"测试发现"路径

- **优先级：中**
- **问题描述**：
  - 当前测试相关文档分布在 10+ 文件中，测试工程师不知道"先加载哪个、再加载哪个"
  - `reference-index.md` 按功能分类索引，但没有"按测试工程师任务类型"的导航
  - 例如：
    - "我要起一个 Python 项目的测试环境" → 应加载 `test-scaffold-templates.md` + `pytest-patterns.md`
    - "我要写 API 测试" → 应加载 `api-testing.md` + `pytest-patterns.md`
    - "我要优化 CI 中的测试" → 应加载 `ci-cd-integration.md` + `test-quality-metrics.md`
    - "我要维护现有测试套件" → 应加载 `test-maintenance.md` + `test-review-checklist.md`
  - 测试工程师需要自己"拼凑"加载路径，增加了认知负担
- **建议改进**：
  - 在 `reference-index.md` 中新增"按测试工程师任务类型导航"章节：
    ```markdown
    ## 按测试任务导航

    | 任务 | 先加载 | 再加载 | 可选 |
    |------|--------|--------|------|
    | 起测试环境 | test-scaffold-templates.md | pytest-patterns.md | api-testing.md |
    | 写 API 测试 | api-testing.md | pytest-patterns.md | test-data-management.md |
    | 优化 CI 测试 | ci-cd-integration.md | test-quality-metrics.md | test-maintenance.md |
    | 维护测试套件 | test-maintenance.md | test-review-checklist.md | test-quality-metrics.md |
    | 补测试覆盖率 | pytest-patterns.md | test-task-pressure-scenarios.md | test-data-management.md |
    ```
  - 或在 SKILL.md 的 Quick Navigation 中增加"Testing Quick Path"
- **预期收益**：
  - 测试工程师按需加载时路径清晰
  - 降低文档导航的认知负担
- **建议位置**：`reference-index.md` + `SKILL.md` Quick Navigation

### TE2-L1. 缺少 AI/ML 集成测试指引

- **优先级：低**
- **问题描述**：
  - 越来越多 Python 项目集成 LLM / ML 模型
  - AI/ML 测试有独特挑战：
    - 非确定性输出（同一输入多次运行结果不同）
    - 模型版本兼容性
    - Token 成本限制
    - Prompt 注入测试
    - 向量数据库测试
  - 当前所有测试参考文档都不覆盖这些场景
- **建议改进**：
  - 新增 `references/testing/ai-ml-testing.md` 或在 `pytest-patterns.md` 中增加 AI/ML 测试章节
  - 至少覆盖：
    - 非确定性测试策略（种子固定、范围断言、统计测试）
    - LLM API 的 mock 策略（`vcrpy` / `pytest-recording`）
    - Prompt 测试模式
    - 成本限制下的测试策略
- **预期收益**：
  - 覆盖 AI 时代测试工程师的新需求
- **建议位置**：新文件或 pytest-patterns.md 扩展

### TE2-L2. 缺少 SSE / WebSocket 流式测试专项

- **优先级：低**
- **问题描述**：
  - `api-testing.md` 第 10 节有 WebSocket API 测试（~100 行）
  - 但缺少 Server-Sent Events（SSE）测试指引
  - FastAPI / Starlette 项目常用 SSE 做实时推送
  - 流式响应测试有独特挑战：连接保持、消息顺序、超时重连
- **建议改进**：
  - 在 `api-testing.md` 的 WebSocket 章节后增加 SSE 测试章节
  - 至少覆盖：
    - SSE 连接测试
    - 消息流完整性测试
    - 断开重连测试
    - 与 WebSocket 的选型建议
- **预期收益**：
  - 覆盖实时通信 API 的完整测试场景
- **建议位置**：`api-testing.md` 第 10 节后

### TE2-L3. 缺少测试报告自动化导出

- **优先级：低**
- **问题描述**：
  - `test.md` 和 `test-quality-metrics.md` 有完整的测试报告模板
  - 但报告产出仍依赖 Agent 手动生成 Markdown
  - 缺少自动化导出工具：
    - `pytest --junitxml` 生成 JUnit 格式报告
    - `pytest-html` 生成 HTML 报告
    - `allure-pytest` 生成 Allure 报告
    - 报告与 CI 集成（GitHub Checks、GitLab Test Reports）
  - 测试工程师在企业环境中通常需要标准化报告格式
- **建议改进**：
  - 在 `ci-cd-integration.md` 中增加"测试报告自动化"章节
  - 在 `test-scaffold-templates.md` 的模板清单中增加报告自动化配置
- **预期收益**：
  - 测试报告自动化，减少手动整理
  - 与企业 CI 平台集成
- **建议位置**：`ci-cd-integration.md` 新增章节

### TE2-L4. 缺少跨平台测试环境差异处理

- **优先级：低**
- **问题描述**：
  - 测试可能在 macOS / Linux / Windows 上运行
  - `ci-cd-integration.md` 的 CI 模板主要覆盖 Linux（GitHub Actions ubuntu-latest）
  - 缺少跨平台测试差异处理指引：
    - 路径分隔符差异（`os.path.sep` vs `pathlib`）
    - 行尾符差异（`\r\n` vs `\n`）
    - 文件系统权限差异
    - 环境变量差异
    - pytest 跨平台标记（`@pytest.mark.skipif(sys.platform == "win32")`）
  - 测试工程师在跨平台项目中需要这些指引
- **建议改进**：
  - 在 `pytest-patterns.md` 中增加"跨平台测试"章节
  - 或在 `test-maintenance.md` 中增加跨平台兼容性维护
- **预期收益**：
  - 跨平台项目测试更稳定
- **建议位置**：`pytest-patterns.md` 新增章节

---

### TE2 改进项优先级总览

| ID | 问题 | 优先级 | 类别 | 建议位置 |
|----|------|--------|------|----------|
| TE2-H1 | 缺少多语言测试策略指引 | **高** | 多语言覆盖 | SKILL.md + reference-index.md |
| TE2-H2 | 缺少 E2E 测试专项指引 | **高** | 测试金字塔完整性 | e2e-testing.md（新） |
| TE2-M1 | 缺少安全测试指引 | **中** | 安全合规 | api-testing.md + ci-cd-integration.md |
| TE2-M2 | 缺少性能/负载测试专项指引 | **中** | 性能工程 | performance-testing.md（新） |
| TE2-M3 | 缺少向后兼容性测试指引 | **中** | API 治理 | api-testing.md |
| TE2-M4 | TEST 模式缺少"测试发现"路径 | **中** | 文档可发现性 | reference-index.md |
| TE2-L1 | 缺少 AI/ML 集成测试指引 | 低 | 新需求覆盖 | ai-ml-testing.md（新） |
| TE2-L2 | 缺少 SSE/流式测试专项 | 低 | 覆盖面 | api-testing.md |
| TE2-L3 | 缺少测试报告自动化导出 | 低 | CI 集成 | ci-cd-integration.md |
| TE2-L4 | 缺少跨平台测试环境差异处理 | 低 | 覆盖面 | pytest-patterns.md |

### TE2 复核总结

**本轮核心发现**：在 TE-H1 ~ TE-L6 实施后，ALTAS Workflow 的 Python/pytest 测试能力已相当完整，但在以下维度仍存在结构性差距：

1. **多语言不对称**（TE2-H1）：支持 10 种项目类型但测试工具链几乎 100% Python 化
2. **测试金字塔缺顶**（TE2-H2）：单元/集成测试覆盖充分，但 E2E 测试缺专项指引
3. **非功能性测试薄弱**（TE2-M1, TE2-M2, TE2-M3）：安全、性能、兼容性测试缺方法论
4. **文档可发现性不足**（TE2-M4）：测试工程师不知道"先加载哪个文档"
5. **新兴需求覆盖缺口**（TE2-L1, TE2-L2, TE2-L4）：AI/ML、SSE 流式、跨平台测试缺指引

**演进建议**：
- **短期**（v4.9）：解决 TE2-H1 + TE2-H2 + TE2-M4
- **中期**（v5.1）：解决 TE2-M1 ~ TE2-M3
- **长期**（v5.x）：解决 TE2-L1 ~ TE2-L4

---

*本轮补充复核完成时间：2026-04-18*
*复核范围：全部 testing/ 参考文档 + SKILL.md + reference-index.md + scaffold.py + ci-cd-integration.md*

---

### 实现状态更新（2026-04-18 第二轮补充实施）

本轮发现的 10 项改进已全部实施：

| ID | 问题 | 优先级 | 状态 | 实施内容 |
|----|------|--------|------|----------|
| TE2-H1 | 缺少多语言测试策略指引 | **高** | **✅ 已实现** | SKILL.md EXECUTE 章节增加"非 Python 项目测试参考"映射表 + reference-index.md 增加多语言测试框架导航 |
| TE2-H2 | 缺少 E2E 测试专项指引 | **高** | **✅ 已实现** | 新增 `references/testing/e2e-testing.md`（Playwright/Cypress 集成 + E2E 数据策略 + 稳定性保障 + CI 执行策略） |
| TE2-M1 | 缺少安全测试指引 | **中** | **✅ 已实现** | api-testing.md 新增"安全测试"章节（SQL 注入 / XSS / CSRF / 认证授权 OWASP 参考）+ ci-cd-integration.md 增加 bandit/safety/pip-audit 安全扫描步骤 |
| TE2-M2 | 缺少性能/负载测试专项指引 | **中** | **✅ 已实现** | 新增 `references/testing/performance-testing.md`（pytest-benchmark + locust/k6 集成 + 性能回归检测 + 基线管理）+ test.md P4 展开 |
| TE2-M3 | 缺少向后兼容性测试指引 | **中** | **✅ 已实现** | api-testing.md 新增"向后兼容性测试"章节（API 版本共存 / 废弃字段 / 数据库迁移兼容性 / Pact 契约测试简介）+ test.md 测试矩阵增加 Compatibility 列 |
| TE2-M4 | TEST 模式缺少"测试发现"路径 | **中** | **✅ 已实现** | reference-index.md 新增"按测试任务导航"表格 + SKILL.md Quick Navigation 增加 Testing Quick Path |
| TE2-L1 | 缺少 AI/ML 集成测试指引 | 低 | **✅ 已实现** | pytest-patterns.md 末尾新增"AI/ML 集成测试"章节（非确定性测试 / LLM mock / Prompt 测试 / 成本限制策略） |
| TE2-L2 | 缺少 SSE/流式测试专项 | 低 | **✅ 已实现** | api-testing.md 新增"SSE (Server-Sent Events) 测试"章节（连接测试 / 消息流完整性 / 断开重连 / WebSocket 选型建议） |
| TE2-L3 | 缺少测试报告自动化导出 | 低 | **✅ 已实现** | ci-cd-integration.md 新增"测试报告自动化"章节（pytest-html / allure / JUnit XML / GitHub Checks / GitLab Test Reports） |
| TE2-L4 | 缺少跨平台测试环境差异处理 | 低 | **✅ 已实现** | pytest-patterns.md 新增"跨平台测试"章节（路径分隔符 / 行尾符 / 文件系统权限 / pytest 跨平台标记） |

**新增文件：**
- `references/testing/e2e-testing.md`
- `references/testing/performance-testing.md`

**修改文件：**
- `SKILL.md`（多语言测试参考映射 + Testing Quick Path）
- `reference-index.md`（多语言测试框架导航 + 按测试任务导航）
- `references/testing/api-testing.md`（安全测试 + 向后兼容性测试 + SSE 测试）
- `references/testing/pytest-patterns.md`（AI/ML 集成测试 + 跨平台测试）
- `references/testing/ci-cd-integration.md`（安全扫描步骤 + 测试报告自动化）
- `references/special-modes/test.md`（P4 性能测试展开 + 测试矩阵兼容性列）

---

*本文件持续更新，每次对 `SKILL.md` 进行重大修订后同步更新*
