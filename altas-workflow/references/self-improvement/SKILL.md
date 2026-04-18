# Self-Improvement 参考文档

> ALTAS Workflow 自我进化机制：在使用中发现问题、纠正、新思路时自动记录，定期总结并晋升到工作流规则。
>
> **核心原则**：记录 → 总结 → 晋升 → 进化。每次任务完成后自动评估是否有可捕获的知识，而非等用户提醒。

## 触发场景

### 主动触发（Agent 自检）

| 时机 | 自检问题 | 触发方式 |
|------|----------|----------|
| 任务完成（Review/Archive 阶段） | 是否有非显而易见的解决方案？是否学到了项目特定模式？ | 检查点契约强制 |
| 错误发生时 | 错误是否非预期、需要调查、可能重复？ | Hook 自动检测 / Agent 识别 |
| 用户纠正时 | 用户说了"不对"、"应该是"、"搞错了"？ | Agent 检测纠正信号 |
| 新任务开始前 | 过往学习是否有相关条目？ | Agent 主动回顾 |

### 被动触发（信号检测）

| 场景 | 记录到 | ID 格式 | 检测关键词 |
|------|--------|---------|------------|
| 用户纠正 AI | LEARNINGS.md (correction) | LRN-YYYYMMDD-XXX | "不对"、"应该是..."、"你搞错了"、"这个不对"、"Actually..." |
| 命令执行失败/异常行为 | ERRORS.md | ERR-YYYYMMDD-XXX | 非零退出码、Exception、Traceback |
| 用户请求当前不支持的能力 | FEATURE_REQUESTS.md | FEAT-YYYYMMDD-XXX | "能不能..."、"为什么不能..."、"I wish..." |
| 发现文档过时/知识缺口 | LEARNINGS.md (knowledge_gap) | LRN-YYYYMMDD-XXX | 文档与实际行为不符 |
| 发现更优方案/最佳实践 | LEARNINGS.md (best_practice) | LRN-YYYYMMDD-XXX | 更简洁/更可靠的替代方案 |
| 用户说"记住这个"、"以后都这样" | LEARNINGS.md (user_explicit) | LRN-YYYYMMDD-XXX | "记住"、"以后都这样"、"保存下来" |

## 记录格式

### Learning 条目

```markdown
## [LRN-YYYYMMDD-XXX] category

**Logged**: ISO-8601 timestamp
**Priority**: low | medium | high | critical
**Status**: pending
**Area**: workflow | routing | spec | execute | review | archive | testing | prd | config

### Summary
一句话描述学到了什么

### Details
完整上下文：发生了什么、哪里错了、正确的应该是什么

### Suggested Action
具体的改进动作

### Metadata
- Source: conversation | error | user_feedback | discovery
- Related Files: path/to/file.ext
- Tags: tag1, tag2
- See Also: LRN-20250110-001 (如有相关条目)
- Pattern-Key: stable pattern key (可选，用于重复模式追踪)
- Recurrence-Count: 1 (可选)
- First-Seen: 2025-01-15 (可选)
- Last-Seen: 2025-01-15 (可选)

---
```

### Error 条目

```markdown
## [ERR-YYYYMMDD-XXX] skill_or_command

**Logged**: ISO-8601 timestamp
**Priority**: high
**Status**: pending
**Area**: workflow | routing | spec | execute | review | archive | testing | prd | config

### Summary
简短描述什么失败了

### Error
```
实际错误信息或输出
```

### Context
- 尝试的命令/操作
- 使用的参数
- 环境信息

### Suggested Fix
如果可识别，可能的解决方案

### Metadata
- Reproducible: yes | no | unknown
- Related Files: path/to/file.ext
- See Also: ERR-20250110-001 (如重复出现)

---
```

### Feature Request 条目

```markdown
## [FEAT-YYYYMMDD-XXX] capability_name

**Logged**: ISO-8601 timestamp
**Priority**: medium
**Status**: pending
**Area**: workflow | routing | spec | execute | review | archive | testing | prd | config

### Requested Capability
用户想要做什么

### User Context
为什么需要，解决什么问题

### Complexity Estimate
simple | medium | complex

### Suggested Implementation
如何实现，可能扩展到哪些地方

### Metadata
- Frequency: first_time | recurring
- Related Features: existing_feature_name

---
```

## 晋升规则

当学习条目满足以下**全部**条件时，晋升到工作流规则：

1. **Recurrence-Count >= 3**（出现至少 3 次）
2. **跨至少 2 个不同任务**
3. **在 30 天窗口期内**

### 晋升目标

| 学习类型 | 晋升到 | 示例 |
|----------|--------|------|
| 路由规则修正 | SKILL.md 路由表 | "含'只看代码'的请求优先 MAP 模式" |
| 规模评估修正 | SKILL.md 规模表 | "涉及公共接口的变更至少 M 级" |
| 铁律补充 | SKILL.md Hard Rules | "修改测试前必须先跑现有测试" |
| 阶段门禁强化 | SKILL.md 阶段门禁 | "PLAN 阶段必须包含回滚策略" |
| 工具映射更新 | SKILL.md 工具映射 | "新平台 X 的编辑工具名为 Y" |
| 别名补充 | references/entry/aliases.md | "新增 '搞一下' 作为 FAST 别名" |
| 测试策略 | references/testing/test-strategy-template.md | "API 测试必须包含 4xx/5xx 场景" |
| 审查规则 | references/special-modes/review.md | "Go 代码必须检查 defer 资源释放" |
| 调试策略 | references/superpowers/systematic-debugging/ | "先查日志再猜原因" |
| 工作流最佳实践 | 对应 references/ 目录 | 通用模式/模板/脚本 |

### 晋升格式

在目标文件中添加简洁的预防规则（不是冗长的事故报告）：

```markdown
## 来自 LRN-YYYYMMDD-XXX 的规则

**规则**: 一句话规则
**原因**: 简短理由
**来源**: LRN-YYYYMMDD-XXX
```

### 晋升后更新

在原学习条目中添加：

```markdown
### Resolution
- **Resolved**: 2025-01-16T09:00:00Z
- **Promoted To**: SKILL.md#Hard-Rules
- **Notes**: 已晋升为铁律 #11
```

并将 Status 改为 `promoted`。

## 技能提取

当学习足够通用、可跨项目复用时，提取为独立 Skill：

### 提取条件（满足任一即可）

| 条件 | 描述 |
|------|------|
| **Recurring** | 有 2+ 个 See Also 链接到相似问题 |
| **Verified** | Status 为 resolved 且有工作方案 |
| **Non-obvious** | 需要实际调试/调查才能发现 |
| **Broadly applicable** | 不限于特定项目，跨代码库有用 |
| **User-flagged** | 用户说"保存为技能"或类似表达 |

### 提取流程

1. 在 `references/superpowers/` 下创建新目录 `skill-name/`
2. 使用 `assets/SKILL-TEMPLATE.md` 格式创建 SKILL.md
3. 填写内容，确保自包含
4. 更新原学习条目的 Status 为 `promoted_to_skill`，添加 `Skill-Path`
5. 在 reference-index.md 中添加索引

## 定期回顾

在以下时机回顾 `.learnings/`：

- 开始新的大任务前
- 完成一个功能后
- 在有过往学习的区域工作时
- 用户要求查看学习记录时

### 快速状态检查

```bash
# 统计待处理条目
grep -h "Status\*\*: pending" .learnings/*.md | wc -l

# 列出高优先级待处理条目
grep -B5 "Priority\*\*: high" .learnings/*.md | grep "^## \["

# 查找特定区域的条目
grep -l "Area\*\*: workflow" .learnings/*.md
```

## 优先级指南

| 优先级 | 使用场景 |
|--------|----------|
| `critical` | 阻塞核心功能、数据丢失风险、安全问题 |
| `high` | 重大影响、影响常见工作流、重复出现的问题 |
| `medium` | 中等影响、有变通方案 |
| `low` | 小不便、边缘情况、锦上添花 |

## 区域标签

| 区域 | 范围 |
|------|------|
| `workflow` | 工作流路由、阶段、门禁 |
| `routing` | 触发词识别、模式选择 |
| `spec` | Spec 模板、格式、内容 |
| `execute` | 代码实现、工具使用 |
| `review` | 审查规则、质量标准 |
| `archive` | 知识沉淀、归档 |
| `testing` | 测试策略、框架、用例 |
| `prd` | PRD 分析、需求理解 |
| `config` | 配置、环境、设置 |

## 最佳实践

1. **立即记录** — 上下文最新鲜时记录
2. **具体明确** — 未来 Agent 需要快速理解
3. **包含复现步骤** — 特别是错误
4. **链接相关文件** — 使修复更容易
5. **建议具体修复** — 不只是"调查"
6. **使用一致分类** — 支持过滤
7. **积极晋升** — 有疑问就添加到对应规则文件
8. **定期回顾** — 过时的学习失去价值
