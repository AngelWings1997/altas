# Discipline-Enforcing 防绕过机制

> **加载时机**：当 Agent 即将违反铁律、使用借口绕过规则、或出现常见使用错误时，按需加载此文件。
> **与 SKILL.md 的关系**：SKILL.md 第 82-93 行包含精简版 Red Flags 自检清单；本文件是完整版。

---

## 完整 Red Flags - STOP and Re-evaluate

> **ANTI-RATIONALIZATION:** When you notice yourself doing any of these below, STOP immediately. These are warning signs you're about to violate an Iron Rule.

| Red Flag | → **STOP** | 违反铁律 |
|----------|------------|----------|
| 正要写代码但 Spec 还未形成？ | 回到 Research/Plan，先形成最小 Spec | #3 |
| 准备执行但未获得明确许可？ | 等待用户确认或确认是否为 XS/FAST（视为已授权） | #4 |
| 发现根因不明就要改代码？ | 继续调试直到根因清晰，禁止盲改 | #7 |
| 任务复杂想跳过 TodoWrite？ | 使用任务跟踪分解和状态管理 | #8 |
| 不确定但不问用户直接假设？ | 暂停并澄清，禁止带着不确定性继续 | #10 |
| "这次情况特殊可以例外"？ | 无例外。若确实特殊，提议修改规则而非违反规则 | #1-#10 |
| "时间紧可以简化流程"？ | 流程简化 = 质量降级 = 后期返工。Every time. | #3, #6 |
| "我已经手动测试过了" | 手动测试 ≠ 自动化回归保护。Write the test. | #6 |

**All of these mean:** Pause, identify which rule applies, comply before proceeding. No rationalization. No exceptions.

---

## Common Rationalizations vs Reality

> **RATIONALIZATION COUNTER:** Agents under pressure use these excuses. Here's why each one fails.

### 类别 1：跳过流程的借口

| 借口 (Excuse) | 现实 (Reality) |
|---------------|-----------------|
| "XS 任务不需要任何流程" | XS 需要 1 行 summary + 验证，不是零流程 |
| "我之后会补写测试" | 测试后补 = "这代码做什么？" 测试先行 = "这代码应该做什么？" |
| "用户说要快速，所以跳过 spec" | FAST = XS/S 带 micro-spec，不是零规划 |

### 类别 2：手动验证的借口

| 借口 (Excuse) | 现实 (Reality) |
|---------------|-----------------|
| "我已经手动测试过了" | 手动测试 ≠ 自动化回归保护。Write the test. |
| "它在我的机器上能跑" | 你的机器 ≠ 生产环境。Write the test. |

### 类别 3："特殊情况"借口

| 借口 (Excuse) | 现实 (Reality) |
|---------------|-----------------|
| "这个情况特殊/不同" | 无例外。如果真的独特，提议修改规则而不是违反它。 |
| "这是务实不是教条" | 务实 = 遵循经过验证的工作流，不是跳过步骤 |
| "我在遵循精神而不是字面意思" | 违反字面意思 **就是** 违反精神（铁律#1） |

### 类别 4：时间/压力借口

| 借口 (Excuse) | 现实 (Reality) |
|---------------|-----------------|
| "没时间走完整流程" | 跳过步骤的返工比正确做更耗时。Every time. |
| "截止日期压力可以成为捷径的理由" | 压力下的捷径 = 生产环境的 bug。可预测的失败。 |
| "过度工程比少做好" | 过度工程是问题，但正确的流程不是过度工程。XS/S/M/L 规模系统已优化。 |

**The pattern:** Every excuse has been heard before. Every excuse leads to the same outcome: rework, bugs, or failures. Follow the rules.

---

## Common Mistakes

> **USAGE ERRORS:** These are common mistakes when using this workflow. Contrast with "异常与恢复" in SKILL.md which covers runtime exceptions.

### 触发词 / 模式选择错误

| Mistake | Correction |
|---------|------------|
| 用 `DEEP` 触发简单修改（< 3 文件） | 使用 `>>` 或 `FAST`，避免过度工程和 unnecessary overhead |
| 用户给 `DEBUG` 但实际只需简单修复 | 先执行 DEBUG 流程的前 2 步（症状+预期），如果明显是 simple fix，提议降级为 Coding |

### 规模评估错误

| Mistake | Correction |
|---------|------------|
| 在 XS 任务上要求完整 Spec | XS 可直接执行，事后 1 行 summary 即可。不要对小任务施加大流程 |
| 低估复杂度按 S 处理实际是 M/L 的任务 | 不确定时向上取整（规模评估判定优先级）。发现超预期立即暂停并提议升级 |

### 流程跳过错误

| Mistake | Correction |
|---------|------------|
| 跳过首轮响应直接进入编码 | 必须先完成路由 + 规模评估（铁律#1, #2）。首轮响应是门禁，不是可选的 |
| 忽略只读纪律直接修改代码 | `MAP` / `REVIEW` 默认只读模式。需要明确许可或用户请求才可切换到写模式 |

### 沟通错误

| Mistake | Correction |
|---------|------------|
| 遇到不确定不暂停而假设 | 遵守铁律#10：必须澄清后再继续。假设 = bug 的根源 |
| 多意图请求未澄清主次（如"排查并顺手补文档"） | 必须输出候选路由并请用户确认主目标和本轮优先级（路由冲突优先级规则） |

### 工具使用错误

| Mistake | Correction |
|---------|------------|
| 使用 Shell 命令（`sed`/`awk`/`echo`）绕过原生工具写文件 | 必须使用 `Write` / `Edit` / `SearchReplace` 等原生编辑工具（Entry Contract - 工具映射规则） |
| 并发写入同一文件 | 遵守铁律#9：写文件必须串行。并发写入 = 数据竞争 = 文件损坏 |

**Pattern:** Most mistakes come from skipping gates or assuming context. When in doubt, follow the process. The process exists for a reason.

---

## 使用建议

**何时加载此文件：**
1. Agent 在自检时发现 Red Flag 匹配，需要查看完整列表
2. Agent 开始 rationalize（找借口），需要 Reality 反驳
3. 出现使用错误，需要查看 Common Mistakes 及纠正方法
4. 压力测试或 code review 时，作为检查清单

**如何使用：**
- **Red Flags**：每次行动前快速扫描，发现匹配项立即 STOP
- **Rationalization Table**：当内心出现借口时，查找对应 Reality 反驳
- **Common Mistakes**：任务完成后回顾，检查是否犯了已知错误

**与 SKILL.md 的协作关系：**
- SKILL.md 提供精简版 Red Flags（6 个核心项）用于即时自检
- 本文件提供完整版（8+10+10 项）用于深度防绕过
- 两者配合形成"快速扫描 + 详细核查"的双层防御体系
