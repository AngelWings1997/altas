# 检查点与批量执行约束

> 本文件承接 `SKILL.md` 中的检查点模板、暂停规则与 Batch Override 约束。
> 入口文件只保留“什么时候必须输出检查点”和“到哪里查细则”。

## 何时加载

- 任务进入 `M/L` 规模，需要完整检查点推进时
- 需要输出标准化 checkpoint 模板时
- 用户要求查看进度时
- 考虑使用 Batch Override 或批量执行时
- 上下文将满，需要留下 Resume Ready 恢复锚点时

## 触发时机

| 场景 | 是否必须输出 |
|------|--------------|
| 阶段转换时（Research -> Plan -> Execute -> Review） | 必须 |
| `M/L` 规模每完成一个 Plan 中的任务项 | 必须 |
| 遇到异常、不确定性或解决不了的问题 | 立即输出 |
| 用户要求查看进度 | 必须 |
| 上下文将满需要 Resume Ready | 必须 |

## 输出要求

| 规模 | 输出要求 |
|------|----------|
| **XS** | 1 行 summary：做了什么 + 如何验证 |
| **S** | 短 checkpoint：当前理解 / 核心目标 / 下一步 |
| **M/L** | 完整检查点，逐步推进 |

## 完整检查点模板（M/L）

```markdown
### 进度 [Phase ▸ Step]
[已完成] ▸ **[当前]** ▸ [下一步] ▸ [后续...]

### 当前成果
- 刚完成了什么

### 预期产出
- 下一步将产出什么

### 下一步操作
- **[继续/Approved/直接执行]**: 同意，进入下一步
- **[修改]** + 意见: 调整当前成果
- **[升级为X]** / **[降级为X]**: 调整规模
- **[加载参考: XXX]**: 查看某参考文档
```

## 检查点强制暂停规则

- `M/L` 规模执行中，每个 Checklist 项完成后必须输出检查点 + `[WAITING FOR COMMAND]`
- 用户已明确触发 Batch Override（如 `全部` / `all` / `execute all` / `继续完成所有` / `一次性完成`）时，才允许连续推进
- 即使在 Batch Override 中，遇到以下情况也必须立即暂停：
  - 测试失败且原因不明
  - 发现 Spec 中未覆盖的场景
  - 文件冲突或编辑失败
  - 不确定下一步的正确实现方式

## Batch Override Git 约束

> **CORE PRINCIPLE:** Batch Override without Git checkpoint = flying without a parachute.

进入 Batch Override 前，必须完成以下检查点创建：

| 步骤 | 操作 | 验证标准 |
|------|------|----------|
| **1. Git 状态检查** | `git status` 确认工作区干净或已有改动已提交 | 工作区 clean 或用户确认保留未提交改动 |
| **2. 创建检查点分支** | `git checkout -b checkpoint/batch-YYYYMMDD-HHmmss` | 分支创建成功，当前 HEAD 指向新分支 |
| **3. 记录回滚元数据** | 在 Spec §5 Execute Log 写入 `Batch Execution Record` | 包含 checkpoint branch 名、回滚命令、batch_start_item |
| **4. 运行基线测试** | 执行 Spec §4.4 定义的测试命令，确认基线通过 | 所有测试 PASS，或用户确认已知失败后可继续 |

缺少任一步骤就禁止进入 Batch Override。若项目不是 Git 仓库，必须明确说明自动回滚不可用，并获得显式确认后才能继续。

## Batch Override 失败时的回滚选项

```text
┌──────────────────────────────────────────────────────────────────┐
│  ⚠️  Batch Override 失败 (Item M)                                 │
│                                                                  │
│  检查点分支: checkpoint/batch-YYYYMMDD-HHmmss                    │
│  已完成项: N → M-1                                               │
│                                                                  │
│  请选择回滚策略：                                                 │
│  (a) 修复当前失败，从 M+1 继续                                    │
│  (b) 回滚到检查点: git reset --hard <checkpoint_branch>          │
│  (c) 部分回滚到 Item K: 回滚后重新执行 N+1 → K                    │
│  (d) 完全放弃，回到 PLAN 重新规划                                  │
│                                                                  │
│  等待用户指令...                                                  │
└──────────────────────────────────────────────────────────────────┘
```

回滚命令执行后必须：

1. 删除检查点分支（`git branch -D <checkpoint_branch>`）
2. 切回原始分支（如适用）
3. 更新 Spec §5 Execute Log 中的 `batch_status` 为 `rolled_back` 或 `completed`
