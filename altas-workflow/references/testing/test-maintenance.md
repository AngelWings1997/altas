# 测试维护指南

> **调用时机**: 测试套件需要维护、清理或重构时加载
> **配合使用**: `references/testing/pytest-patterns.md`（pytest 模式参考）、`references/testing/test-quality-metrics.md`（质量度量）

---

## 核心原则

1. **测试是资产，不是负债** — 维护良好的测试套件是安全网，腐化的测试套件是负担
2. **测试代码 = 生产代码** — 同样的质量标准、同样的重构纪律
3. **删除测试比保留无用测试更好** — 误报比漏报更危险

---

## 测试生命周期

```
创建 → 维护 → 退役
  │       │       │
  │       ├─ 更新（需求/接口变更）
  │       ├─ 重构（消除重复/改善可读性）
  │       └─ 修复（flaky/环境问题）
  │               │
  └───────────────┴─ 删除（功能移除/测试无价值/测试重复）
```

---

## 测试删除决策树

```
测试失败
├─ 被测功能已移除？ → 删除测试
├─ 测试与另一个测试完全重复？ → 删除其中一个
├─ 测试验证的行为不再需要？ → 删除测试
├─ 需求已变更？ → 更新测试
├─ 接口已变更但行为不变？ → 更新测试
└─ 不确定？ → 保留并标记待审查
```

### 应该删除测试的情况

| 情况 | 操作 | 示例 |
|------|------|------|
| 被测功能已移除 | 删除测试文件/函数 | `test_legacy_export` → 功能已下线 |
| 测试完全重复 | 保留更清晰的那个 | 两个测试验证同一行为的同一方面 |
| 测试验证实现细节 | 重写为验证行为 | 测试私有方法 → 改为测试公开接口 |
| 测试永远通过（空断言） | 删除或重写 | `assert True` 或无断言的测试 |

### 不应该删除测试的情况

| 情况 | 操作 |
|------|------|
| 测试偶尔失败（flaky） | 修复，不删除 |
| 测试太慢 | 优化或标记 `@pytest.mark.slow`，不删除 |
| 测试难以理解 | 重构改善可读性，不删除 |
| 测试覆盖边界条件 | 保留，即使看起来"多余" |

---

## Flaky 测试处理流程

### 检测

```bash
# 多次运行检测 flaky
pytest tests/ --reruns 5 --reruns-delay 1 -q
# 或使用 pytest-flakefinder
pytest tests/ --flake-finder --flake-runs=10
```

### 处理流程

```
1. 检测到 flaky
   ↓
2. 标记: @pytest.mark.flaky(reason="描述")
   ↓
3. 隔离: 移到单独文件或用 marker 排除
   ↓
4. 修复（优先级 P1）
   ├─ 竞态条件 → 加锁/串行化/超时增加
   ├─ 外部依赖 → mock/stub/容器化
   ├─ 数据依赖 → 固定数据/factory/隔离
   ├─ 时间依赖 → freezegun/time-machine
   └─ 顺序依赖 → 确保测试独立
   ↓
5. 验证: 连续运行 20 次无失败
   ↓
6. 移除 @pytest.mark.flaky 标记
```

### 常见 Flaky 原因与修复

| 原因 | 修复方式 | pytest 工具 |
|------|----------|-------------|
| 竞态条件 | 加锁/串行化 | `@pytest.mark.serial` |
| 外部 API 不稳定 | mock/容器化 | `responses`/`pytest-httpx` |
| 数据库状态泄漏 | 事务回滚 | `db_session` fixture |
| 时间依赖 | 冻结时间 | `freezegun`/`time-machine` |
| 浮点精度 | 使用近似比较 | `pytest.approx` |
| 文件系统竞争 | `tmp_path` fixture | `tmp_path`/`tmp_path_factory` |
| 随机数据 | 固定随机种子 | `Faker(seed=42)` |

---

## 测试重构策略

### 何时重构测试

- RED-GREEN-REFACTOR 的 REFACTOR 阶段
- 测试文件超过 300 行
- 同一 fixture 在 3+ 文件中重复
- 测试函数名无法描述行为
- `conftest.py` 超过 100 行

### 重构手法

#### 1. 提取 Fixture

```python
# Before: 重复数据准备
def test_create_user():
    user = {"name": "Alice", "email": "alice@example.com"}
    result = create_user(user)
    assert result.id is not None

def test_update_user():
    user = {"name": "Alice", "email": "alice@example.com"}
    created = create_user(user)
    result = update_user(created.id, {"name": "Bob"})
    assert result.name == "Bob"

# After: 提取 fixture
@pytest.fixture
def user_data():
    return {"name": "Alice", "email": "alice@example.com"}

@pytest.fixture
def created_user(user_data):
    return create_user(user_data)

def test_create_user(user_data):
    result = create_user(user_data)
    assert result.id is not None

def test_update_user(created_user):
    result = update_user(created_user.id, {"name": "Bob"})
    assert result.name == "Bob"
```

#### 2. Parametrize 消除重复

```python
# Before: 3 个相似测试
def test_validate_email_valid():
    assert validate_email("a@b.com") is True

def test_validate_email_invalid_no_at():
    assert validate_email("ab.com") is False

def test_validate_email_invalid_empty():
    assert validate_email("") is False

# After: 1 个 parametrize
@pytest.mark.parametrize("email,expected", [
    ("a@b.com", True),
    ("ab.com", False),
    ("", False),
])
def test_validate_email(email, expected):
    assert validate_email(email) is expected
```

#### 3. 拆分大 conftest.py

```
tests/
├── conftest.py          # 全局 fixture（api_client, anyio_backend）
├── unit/
│   └── conftest.py      # 单元测试 fixture（mock 对象）
├── integration/
│   └── conftest.py      # 集成测试 fixture（db_session, redis）
└── api/
    └── conftest.py      # API 测试 fixture（auth, api_client）
```

---

## 测试债务管理

### 与 Spec §4.4 联动

当 §4.4 Test Strategy 中有 "Deferred / Out of Scope Tests" 时，应同步记录到 Test Debt Register：

```markdown
- **Test Debt Register** (Optional):
  - `<DEBT-1>`: 缺少并发创建订单的竞态条件测试 | Priority: P1 | ETA: v2.1 | Owner: @backend-team
  - `<DEBT-2>`: WebSocket 重连测试未覆盖 | Priority: P2 | ETA: v2.2 | Owner: @qa-team
```

### 债务治理原则

1. **P0 债务必须在下一个迭代清偿** — 不允许 P0 测试债务跨迭代
2. **P1 债务必须在 2 个迭代内清偿**
3. **P2 债务每季度审查一次** — 决定清偿或降级
4. **新增功能时先检查债务** — 避免债务累积

### 债务可视化

```bash
# 统计标记为 flaky 的测试
pytest --collect-only -q -m flaky

# 统计跳过的测试
pytest --collect-only -q -m "skip or skipif"

# 统计 xfail 测试
pytest --collect-only -q -m xfail
```

---

## 测试更新指南

### 需求变更时

1. 找到对应的测试（通过 §4.4 Traceability 映射）
2. 更新测试的 Arrange 部分（新输入数据）
3. 更新测试的 Assert 部分（新期望输出）
4. 运行测试确认失败（RED）
5. 更新实现代码
6. 运行测试确认通过（GREEN）
7. 更新 §4.4 Traceability（如果映射关系变化）

### 接口变更时

1. 如果是签名变更：更新 fixture + 测试函数参数
2. 如果是返回值变更：更新断言
3. 如果是端点变更：更新 API 测试的 URL
4. 如果是数据模型变更：更新 factory + fixture

### 重构后行为不变时

- 测试不应改变
- 如果测试因重构而失败，说明重构改变了行为 → 撤回重构

---

**版本**: 1.0.0
**兼容**: pytest 7.0+, Python 3.8+
