# SIGMA Workflow 快速启动指南

## 决策树：选择正确的工作流深度

```
你有一个任务要完成
        │
        ▼
   改动有多复杂？
        │
   ┌─────┼─────┬───────────┐
   │     │     │           │
  单点   2-3   多文件      架构/
  修改   文件   改动       跨模块
   │     │     │           │
   ▼     ▼     ▼           ▼
 zero   fast  standard    deep
```

## 场景化快速命令

### 场景 1: 修复一个 typo

```text
>> 修复 UserService.java 第 42 行的 typo: "Useer" → "User"
```

**流程**: 执行 → 1 行 summary

---

### 场景 2: 修改配置文件

```text
>> 把 DEBUG mode 改成 false
```

**流程**: 确认理解 → 执行 → summary

---

### 场景 3: 小功能: 添加日志

```text
>> 给 UserService 添加访问日志
```

**流程**: micro-spec (1-3句) → 批准 → 执行 → summary

---

### 场景 4: 中等功能: 用户登录

```text
请使用 SIGMA standard:
- task: 用户 Email/Password 登录
- goal: 支持 JWT Token
- scope: src/auth/*
```

**流程**:
```
sdd_bootstrap → create_codemap → build_context_bundle → Spec → Plan → Execute → Review → Verify
```

---

### 场景 5: 复杂重构

```text
请使用 SIGMA deep:
- task: 重构订单模块
- goal: 拆分为独立服务
- scope: src/order/*, src/payment/*
```

**流程**:
```
Research → Innovate(方案比较) → Plan(详细) → Subagent Execute → Review → Verify
```

---

### 场景 6: Bug 排查

```text
DEBUG: 用户反馈订单支付成功后页面显示"支付失败"
log_path: ./logs/app.log
```

**流程**:
```
Phase 1: Root Cause (读日志+追踪)
Phase 2: Pattern (找相似)
Phase 3: Hypothesis (形成假设)
Phase 4: Fix + Test
```

---

### 场景 7: 多项目协作

```text
请使用 SIGMA 多项目模式：
- mode=multi_project
- task=前后端联动发布
- goal=web-console 和 api-service 联合发布功能
```

**流程**:
```
自动发现项目 → 确认 Registry → 生成 Codemap → Plan(按项目分组) → Execute(Provider优先) → Review
```

---

### 场景 8: 测试开发任务

```text
我要为登录功能设计测试方案
```

**触发**: 自动识别测试需求，加载 `references/test-dev-workflow/test-dev-workflow.md`

**流程**:
```
需求理解 ──→ Code Map ──→ Spec(测试策略) ──→ Plan(任务分解) ──→ TDD循环 ──→ Review ──→ Archive
```

**测试开发铁律**:
| 铁律 | 含义 |
|------|------|
| **No Spec, No Test** | 未设计测试策略不写测试代码 |
| **No Production Code Without Failing Test First** | 先写失败测试，再写实现 |
| **Done Contract** | 明确定义"完成"的证据和边界 |

---

## 6 个原生命令详解

详见: `references/spec-driven-development/commands.md`

| 命令 | 完整说明 |
|------|----------|
| **create_codemap** | 生成代码索引地图，支持 feature/project 模式 |
| **build_context_bundle** | 整理需求上下文，支持 Lite/Standard 两种粒度 |
| **sdd_bootstrap** | RIPER 启动命令，进入 Research 第一步 |
| **review_spec** | 执行前规格评审，输出 GO/NO-GO 建议 |
| **review_execute** | 执行后三轴评审，Spec质量/代码一致性/代码质量 |
| **archive** | 知识沉淀，输出 Human + LLM 双视角文档 |

---

## 常用命令速查表

| 你想说 | 使用命令 | 示例 |
|--------|----------|------|
| 快速小改动 | `>>` 或 `FAST` | `>> 修复按钮颜色` |
| 生成代码地图 | `CODE MAP` | `CODE MAP: scope=feature path=src/auth` |
| 整理需求上下文 | `CONTEXT` | `CONTEXT: dir=requirements/` |
| 启动标准任务 | `SIGMA standard` | `SIGMA standard: task=登录功能...` |
| 启动复杂任务 | `SIGMA deep` | `SIGMA deep: task=架构重构...` |
| 测试开发任务 | `测试` / `test` | `我要设计登录测试方案` |
| 批准计划执行 | `PLAN APPROVED` | `Plan Approved` |
| 执行前评审 | `REVIEW SPEC` | `Review Spec` |
| 执行后评审 | `REVIEW EXECUTE` | `Review Execute` |
| 归档沉淀 | `ARCHIVE` | `ARCHIVE: targets=...` |
| 启用测试驱动 | `TDD` | `使用 TDD 实现 XX` |
| 启动调试流程 | `DEBUG` | `DEBUG: log_path=...` |
| 验证工作完成 | `VERIFY` | `VERIFY: 运行测试套件` |
| 多项目模式 | `MULTI` | `MULTI: task=...` |
| 退出协议 | `EXIT SIGMA` | `EXIT SIGMA` |

---

## Checkpoint 响应指南

### 收到 Checkpoint 时，你应该:

```
[Checkpoint]
理解: 实现 Email/Password 登录
核心目标: 登录 API + JWT Token 生成
下一步:
  1. 创建 auth/spec.md
  2. 设计 API 路由
  3. 实现登录逻辑
风险: 密码加密方案待确认
验证: POST /api/auth/login 测试
```

**回复选项**:
- `Approved` → 继续执行
- `修改第 X 点` → 提出修改意见
- `先做 X` → 调整优先级

---

## 验证通过标志

任务完成前，必须确认:

```
✅ 测试: N/N pass (本轮运行结果)
✅ Lint: 0 errors
✅ 构建: success
✅ 回归: 无新问题
✅ Bug 修复: 原操作已验证
```

**禁止使用的词汇**:
- "应该可以"
- "看起来没问题"
- "大概好了"
- "应该没问题"

---

## 完整内容索引

| 类别 | 文件位置 |
|------|----------|
| **Spec驱动核心协议** | `references/spec-driven-development/sdd-riper-one-protocol.md` |
| **6 个原生命令** | `references/spec-driven-development/commands.md` |
| **Spec 模板 (Standard)** | `references/spec-driven-development/spec-template.md` |
| **Spec 模板 (Lite)** | `references/checkpoint-driven/spec-lite-template.md` |
| **多项目协作** | `references/spec-driven-development/multi-project.md` |
| **归档模板** | `references/spec-driven-development/archive-template.md` |
| **Checkpoint驱动** | `references/checkpoint-driven/` |
| **TDD 完整内容** | `references/superpowers/test-driven-development/` |
| **Debug 四阶段** | `references/superpowers/systematic-debugging/` |
| **Subagent 派遣** | `references/superpowers/subagent-driven-development/` |
| **验证铁律** | `references/superpowers/verification-before-completion/` |
| **测试开发专用** | `references/test-dev-workflow/test-dev-workflow.md` |

---

## 常见问题

**Q: 什么时候用 zero vs fast?**
A: typo/纯配置 → zero; 有简单逻辑 → fast

**Q: 什么时候升级到 deep?**
A: 跨模块、架构变更、需求模糊、3+ 修复失败

**Q: Subagent 什么时候用?**
A: 独立任务 + 需要隔离上下文 + 需要两阶段 Review

**Q: TDD 什么时候用?**
A: 新功能、Bug Fix、Refactoring、行为变更

**Q: 测试开发模式怎么触发?**
A: 当用户提到"测试"、"test"、"测试开发"、"自动化测试"时，自动加载测试开发专用模式

**Q: archive 什么时候用?**
A: 任务收尾时推荐执行，产出 Human 汇报 + LLM 后续参考文档
