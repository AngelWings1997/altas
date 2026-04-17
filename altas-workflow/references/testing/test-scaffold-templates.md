# pytest / API 测试脚手架模板

> **调用时机**: 需要快速起 pytest / API 测试骨架、补齐 fixture / factory / report 模板时加载
> **配合使用**: `references/testing/pytest-patterns.md`、`references/testing/api-testing.md`、`references/testing/test-data-management.md`

---

## 目标

这些模板的定位不是解释“测试应该怎么写”，而是帮助你**直接起一个可运行、可扩展、可审查的测试骨架**。

推荐优先级：

1. `conftest.py` 基础模板
2. API client fixture 模板
3. auth fixture 模板
4. DB rollback fixture 模板
5. `factories.py` 模板
6. API test matrix 模板
7. test report 模板

---

## 模板清单

| 模板 | 文件 | 适用场景 |
|------|------|----------|
| 基础共享 fixture | `references/testing/templates/conftest.py` | pytest 项目起步，统一 marker、基础配置、共享 fixture |
| 测试数据工厂 | `references/testing/templates/factories.py` | 需要 `faker` / `factory-boy` 管理测试数据 |
| API client fixture | `references/testing/templates/api_client_fixture.py` | HTTP API 测试，需要统一请求入口 |
| auth fixture | `references/testing/templates/auth_fixture.py` | 鉴权、角色、用户上下文相关测试 |
| DB rollback fixture | `references/testing/templates/db_rollback_fixture.py` | 数据库集成测试，需要每个测试自动回滚 |
| API 测试矩阵 | `references/testing/templates/api_test_matrix.md` | 从 OpenAPI / GraphQL Schema / Proto 展开测试计划 |
| 测试报告模板 | `references/testing/templates/test_report.md` | 输出测试结果、质量门禁、失败归因 |

---

## 推荐组合

### 1. 纯 pytest 单元测试基座

- 使用 `conftest.py`
- 视数据复杂度追加 `factories.py`

### 2. Python API 测试基座

- 使用 `conftest.py`
- 使用 `api_client_fixture.py`
- 使用 `auth_fixture.py`
- 若涉及数据库，追加 `db_rollback_fixture.py`
- 在执行前先填写 `api_test_matrix.md`

### 3. 测试工程师补测工作流

- 先根据契约填写 `api_test_matrix.md`
- 再复制所需 fixture / factory 模板到目标项目
- 最后用 `test_report.md` 输出结果与质量门禁建议

---

## 复制落地建议

| 目标项目路径 | 推荐复制源 |
|--------------|------------|
| `tests/conftest.py` | `references/testing/templates/conftest.py` |
| `tests/factories.py` | `references/testing/templates/factories.py` |
| `tests/api/client.py` 或 `tests/api/conftest.py` | `references/testing/templates/api_client_fixture.py` |
| `tests/auth/conftest.py` 或 `tests/conftest.py` | `references/testing/templates/auth_fixture.py` |
| `tests/db/conftest.py` 或 `tests/conftest.py` | `references/testing/templates/db_rollback_fixture.py` |
| `mydocs/test-plans/*.md` | `references/testing/templates/api_test_matrix.md` |
| `mydocs/test-reports/*.md` | `references/testing/templates/test_report.md` |

---

## 使用提醒

- 模板是起点，不是最终成品；复制后应替换占位符、路径和业务字段
- API 测试优先从契约文件展开，不要先从实现细节猜接口
- 若项目已有成熟测试基建，优先复用现有风格，不要强行覆盖
- CI / 质量门禁场景建议同时加载 `references/testing/test-quality-metrics.md`
