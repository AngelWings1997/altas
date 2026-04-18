# 测试代码审查清单

> **调用时机**: Code Review 测试代码时逐项检查
> **配合使用**: `references/superpowers/test-driven-development/testing-anti-patterns.md`（测试反模式）

---

## 审查清单

### 命名与可读性

- [ ] 测试函数名描述行为，非实现：`test_user_login_with_invalid_credentials` 而非 `test_login_2`
- [ ] 测试文件名与被测模块对应：`test_order.py` → `order.py`
- [ ] Fixture 名称描述其角色：`authenticated_client` 而非 `fixture1`
- [ ] 测试内无魔法数字：用命名常量或 fixture 提供语义

### 结构与组织

- [ ] AAA 模式清晰：Arrange / Act / Assert 三段分明
- [ ] 一个测试只验证一个行为
- [ ] 测试相互独立，无执行顺序依赖
- [ ] 测试文件组织合理：unit/integration/api/e2e 分层

### 断言质量

- [ ] 断言充分：每个测试 2-4 个断言（非硬性规则，但过少/过多都需审查）
- [ ] 断言具体：`assert response.status_code == 201` 而非 `assert response.ok`
- [ ] 断言有意义：不写 `assert True` 或永远通过的断言
- [ ] 异常断言精确：`pytest.raises(ValidationError, match="Email required")` 而非裸 `pytest.raises(Exception)`

### Fixture 使用

- [ ] Fixture 作用域合理：function（默认）/ class / module / session 按需选择
- [ ] Fixture 无隐式状态泄漏：每个测试获得干净状态
- [ ] Fixture 依赖链清晰：不过深嵌套（≤3 层）
- [ ] conftest.py 不超过 100 行：超出则拆分到子目录

### Mock 使用

- [ ] Mock 仅在必要时使用：外部 API、不可控依赖
- [ ] Mock ratio < 30%：过多 mock 说明测试过于脆弱
- [ ] Mock 范围精确：只 mock 需要隔离的部分，不 mock 被测系统本身
- [ ] Mock 清理：使用 `mock.patch` 上下文管理器或 fixture 确保清理

### 覆盖度

- [ ] Happy path 已覆盖
- [ ] 边界条件已覆盖（空值、零、最大值、最小值）
- [ ] 异常路径已覆盖（无效输入、权限不足、服务不可用）
- [ ] 并发/竞态条件已覆盖（如适用）

### 可维护性

- [ ] 无硬编码 URL/端口/路径：使用 fixture 或环境变量
- [ ] 无硬编码时间/日期：使用 `freezegun` 或 fixture
- [ ] 无测试间数据依赖：每个测试自包含
- [ ] `@pytest.mark.parametrize` 用于消除重复，而非掩盖复杂度

### 安全性

- [ ] 测试中不包含真实密钥/密码/Token
- [ ] 测试数据不包含 PII（个人身份信息）
- [ ] 测试不修改生产环境
- [ ] 测试清理敏感临时数据

---

## 快速判定规则

| 信号 | 判定 | 建议 |
|------|------|------|
| 测试名含数字 | 可疑 | 改为描述行为 |
| 单个测试 > 50 行 | 过长 | 拆分或提取 fixture |
| conftest.py > 100 行 | 过大 | 拆分到子目录 conftest |
| Mock ratio > 50% | 过多 | 减少不必要的 mock |
| 测试无断言 | 无效 | 添加断言或删除 |
| `time.sleep()` 在测试中 | 危险 | 改用轮询/事件/超时 |
| `@pytest.mark.skip` 无 reason | 不规范 | 添加原因和 issue 链接 |

---

**版本**: 1.0.0
