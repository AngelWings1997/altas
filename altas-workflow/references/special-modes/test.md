# TEST 模式 - 测试专项协议

**触发词**: `TEST` / `写测试` / `补测试`

---

## 何时使用

- 用户需要为现有代码补充测试（非 TDD 场景）
- 用户需要提高测试覆盖率
- 用户需要修复失败测试
- 用户需要生成测试报告

**注意**: 如果是新功能/新 Bug 修复的开发流程，使用标准工作流的 Execute(TDD) 阶段即可，不需要单独触发 TEST 模式。

---

## 首轮动作

1. **确认测试目标**:
   - 补测试覆盖（无测试的老代码）
   - 提高覆盖率（已有部分测试）
   - 修复失败测试
   - 生成测试报告
2. **确认测试范围**:
   - 单个文件/函数/模块？
   - 全项目扫描？
3. **若为 API 测试，先识别契约来源**:
   - 优先查找 `OpenAPI / Swagger / GraphQL Schema / Proto`
   - 记录契约文件路径、协议类型（REST / GraphQL / gRPC）和可用范围
   - 若没有契约文件且接口行为不清楚，暂停并提示用户补充；不要直接猜接口
4. **确认测试框架**:
   - 项目使用什么测试框架？（Jest/Mocha/Pytest/Go test/...）
   - 测试运行命令是什么？

**快速入口：生成测试骨架**

- 需要直接起 pytest / API 测试基座时，优先加载 `references/testing/test-scaffold-templates.md`
- 推荐骨架组合：
  - `conftest.py`
  - `factories.py`
  - API client fixture
  - auth fixture
  - DB rollback fixture
  - API test matrix
  - test report

---

## 测试流程

### 1) 测试现状分析

- 运行现有测试套件，确认通过率
- 生成测试覆盖率报告（若项目支持）
- 识别测试空白区域：
  - 未覆盖的核心逻辑
  - 未覆盖的边界条件
  - 未覆盖的异常路径

### 2) 识别 API 契约来源（API 项目必做）

- 默认优先读取契约文件，而不是从控制器、handler 或现有实现倒推接口行为
- 优先顺序：
  1. `OpenAPI / Swagger` (`openapi.yaml`, `swagger.yaml`, `*.openapi.json` 等)
  2. `GraphQL Schema` (`schema.graphql`, `schema.graphqls`, introspection 结果)
  3. `Proto` (`*.proto`)
  4. 已落盘的接口 Spec / requirements / 对外 API 文档
- 识别后先记录：
  - 契约文件路径
  - 协议类型（REST / GraphQL / gRPC）
  - endpoint / query / rpc 范围
  - 契约版本或来源说明
- 若缺少可用契约且行为无法从现有文档明确得出，**必须暂停**并提示用户补充契约，而不是猜测返回结构、状态码或字段语义
- **可选：使用自动化工具从契约生成测试骨架**（详见 `references/testing/api-testing.md` "契约到测试自动化工具链"章节）：
  - `schemathesis run openapi.yaml` — 从 OpenAPI 自动生成属性测试
  - `datamodel-code-generator openapi.yaml` — 生成 Pydantic 模型用于断言
  - `prism mock openapi.yaml` — 启动 mock server 用于依赖模拟

### 3) 确认测试框架

- **Python/pytest 项目**: 加载 `references/testing/pytest-patterns.md`
- **Python API 项目**: 额外加载 `references/testing/api-testing.md`
- **其他语言**: 按项目实际框架编写

### 4) 基于契约生成测试矩阵（API 项目默认动作）

- 从契约中提取接口清单、请求参数、响应 Schema、鉴权要求、错误码、幂等或并发约束
- 先输出接口测试矩阵，再进入测试编写
- 默认至少覆盖：
  - happy path
  - validation
  - auth
  - idempotency
  - error path
  - schema case

**接口测试矩阵模板**:

```markdown
| Contract Item | Source | Happy Path | Validation | Auth | Idempotency | Error Path | Schema | Compatibility |
|---------------|--------|------------|------------|------|-------------|------------|--------|---------------|
| `POST /orders` | `openapi.yaml#/paths/~1orders/post` | `201 create order` | `422 missing field` | `401/403` | `same Idempotency-Key` | `409/500` | `response schema matches` | `v1+v2 both work` |
| `GetUser` | `user.proto#rpc GetUser` | `OK returns user` | `INVALID_ARGUMENT` | `UNAUTHENTICATED` | `N/A` | `NOT_FOUND` | `protobuf fields match` | `old data accessible` |
```

### 5) 测试优先级排序

| 优先级 | 测试类型 | 说明 |
|--------|----------|------|
| **P0** | 核心逻辑测试 | 业务核心功能，必须覆盖 |
| **P1** | 边界条件测试 | 极值/空值/非法输入 |
| **P2** | 异常路径测试 | 错误处理/降级逻辑 |
| **P3** | 集成测试 | 跨模块/跨系统交互 |
| **P4** | 性能测试 | 响应时间/吞吐量/资源消耗；详见 `references/testing/performance-testing.md` |
| **P5** | 兼容性测试 | API 版本共存、废弃字段、数据库迁移后数据完整 |

### 6) 先输出测试策略产物（必填）

在开始补测试前，**必须**先产出一版结构化 `Test Strategy`，不得只写成“补充必要测试”。
`TEST` 模式下的 `Test Strategy` 必须与主流程 `§4.4 Test Strategy` 使用**同一套字段名与顺序**；不适用项显式写 `N/A`。

**最小结构**:

```markdown
## Test Strategy

- **Test Framework**: <Jest / Pytest / ...>
- **Run Command**: <npm test / pytest / ...>

### Test Levels
- Unit: <覆盖范围；不适用写 N/A>
- Component: <覆盖范围；不适用写 N/A>
- Integration: <覆盖范围；不适用写 N/A>
- E2E: <覆盖范围；不适用写 N/A>

### Risk & Priority Matrix
- P0: <核心主流程 / 高风险逻辑>
- P1: <边界条件 / 状态变化 / 权限差异>
- P2: <异常路径 / 超时 / 降级>

### Requirement / Contract Traceability
- Source: <需求、接口文档、Spec、缺陷单>
- Cases:
  - <REQ/API-1> -> <计划测试>
  - <REQ/API-2> -> <计划测试>

### Mock / Stub / Fake Strategy
- <哪些依赖用真实实现，哪些需要隔离>

### Test Data Strategy
- Data Source: <fixture / factory / seed / 手写样例>
- Isolation: <rollback / tmp dir / dedicated db / fake service>
- Cleanup: <自动清理方式>

### Quality Gates
- Pass Rate: <目标值>
- Coverage Target: <目标值>
- Flaky Tolerance: <允许的 flaky 风险>
- Time Budget: <时间预算>
```

**Python/pytest 项目**: 结合 `references/testing/pytest-patterns.md` 设计 fixture、parametrize、mock 方案

**Python API 项目**: 结合 `references/testing/api-testing.md`，优先从契约文件展开 validation/auth/idempotency/error/schema 等测试矩阵

### 6.5) 生成测试骨架（可选但推荐）

- 若项目缺少测试基座，优先从 `references/testing/test-scaffold-templates.md` 复制最小骨架，而不是从零散描述手写
- 常见组合：
  - `tests/conftest.py` <- `references/testing/templates/conftest.py`
  - `tests/factories.py` <- `references/testing/templates/factories.py`
  - `tests/api/conftest.py` <- `references/testing/templates/api_client_fixture.py`
  - `tests/auth/conftest.py` <- `references/testing/templates/auth_fixture.py`
  - `tests/db/conftest.py` <- `references/testing/templates/db_rollback_fixture.py`
  - `mydocs/test-plans/*.md` <- `references/testing/templates/api_test_matrix.md`
  - `mydocs/test-reports/*.md` <- `references/testing/templates/test_report.md`
- 若用户明确要求“先起测试工程骨架”，本步骤优先于批量写测试用例

### 7) 编写测试（按优先级）

对每个优先级：

1. 识别待测试的接口/契约项
2. 编写测试用例（含正常场景 + 边界场景 + 异常场景）
3. 运行测试，确认通过
4. 输出检查点，请求进入下一组测试

**测试用例模板（通用）**:

```
// 正常场景
describe('<函数名>', () => {
  it('应该 <预期行为> 当 <输入条件>', () => {
    // Arrange
    const input = ...;
    const expected = ...;
    
    // Act
    const result = targetFunction(input);
    
    // Assert
    expect(result).toEqual(expected);
  });
});
```

**Python/pytest 项目**: 使用 `references/testing/pytest-patterns.md` 中的 AAA 模式和 fixture 模板

**Python API 项目**: 额外使用 `references/testing/api-testing.md` 中的 API 测试模式

### 8) 测试失败归因（失败时必做）

测试失败后，**不要默认把所有红灯都判定为产品 Bug**。先执行“失败归因三分法”：

| 归因类别 | 定义 | 典型信号 | 默认下一步 |
|----------|------|----------|------------|
| **产品缺陷** | 产品代码或业务逻辑不满足预期契约/行为 | 可稳定复现；断言与契约一致；实现返回错误结果/状态码 | 记录缺陷、回到修复或开发流程 |
| **测试缺陷** | 测试脚本、断言、fixture、mock、测试数据本身有问题 | 断言与契约不一致；mock 伪造错误；fixture 污染；测试假设错误 | 修正测试并重新验证 |
| **环境缺陷** | 环境、依赖、网络、数据、配置导致失败 | 本地/CI 表现不一致；数据库/外部服务不可用；端口/权限/时钟问题 | 修复环境或隔离依赖后重跑 |

**失败归因最小输出**:

```markdown
### Failure Triage
- failure category: `产品缺陷 / 测试缺陷 / 环境缺陷 / 未确定`
- reproduction confidence: `high / medium / low`
- evidence: `<失败日志 / 契约条目 / 环境信号>`
- next action: `<修代码 / 修测试 / 修环境 / 切换 DEBUG>`
```

**归因顺序**:

1. 先确认失败能否稳定复现
2. 对照契约 / Spec / 测试策略，判断断言是否合理
3. 检查 fixture、mock、测试数据和依赖隔离是否污染结果
4. 检查环境差异（数据库、网络、配置、权限、时间、外部服务）
5. 仍无法明确归因时，标记 `未确定`，并**自动建议切换到 `DEBUG`**

### 9) 测试覆盖率验证

- 运行覆盖率报告
- 对比测试前后的覆盖率变化
- 识别仍未覆盖的区域（若用户要求继续，则回到步骤 6）

### 9.5) 汇总质量度量（默认输出）

- `TEST` 模式下，测试报告默认输出以下质量度量；不要只停留在“测试数 + 覆盖率”
- 最少包含：
  - `coverage`
  - `pass rate`
  - `flaky risk`
  - `slow tests`
  - `mock ratio`
  - `remaining gaps`
- 若项目暂时无法自动采集某项指标，显式写 `N/A` 并说明原因；不要静默省略
- 涉及 CI、质量门禁或持续治理时，默认加载 `references/testing/test-quality-metrics.md`
- 需要标准报告骨架时，优先使用 `references/testing/templates/test_report.md`

### 10) 输出测试报告

**标准格式**:

```markdown
## 测试报告

**测试范围**: <文件/模块列表>
**测试框架**: <Jest/Pytest/...>
**运行命令**: `<npm test / pytest / ...>`

### 测试策略摘要
- Test Levels: ...
- P0/P1/P2: ...
- Requirement / Contract Traceability: ...
- Mock / Data Strategy: ...
- Quality Gates: ...

### 测试结果
- 总测试数: X
- 通过: Y
- 失败: Z
- 跳过: W

### 质量度量
| 指标 | 当前值 | 目标值 | 结论 |
|------|--------|--------|------|
| Coverage | X% | Y% | `通过 / 未达标 / N/A` |
| Pass Rate | X% | 100% | `通过 / 未达标 / N/A` |
| Flaky Risk | `low / medium / high` | `<1%` 或团队阈值 | `通过 / 未达标 / N/A` |
| Slow Tests | `<最慢测试或耗时分布>` | `<时间预算>` | `通过 / 未达标 / N/A` |
| Mock Ratio | X% | `<30%` 或团队阈值 | `通过 / 未达标 / N/A` |

### 覆盖率
| 类型 | 覆盖率 | 变化 |
|------|--------|------|
| 语句覆盖率 | X% | +Y% |
| 分支覆盖率 | X% | +Y% |
| 函数覆盖率 | X% | +Y% |
| 行覆盖率 | X% | +Y% |

### 新增测试清单
1. <测试文件名>: <测试用例描述>
2. ...

### 失败测试 (若有)
1. <测试文件名>: <失败原因>
   - failure category: <产品缺陷 / 测试缺陷 / 环境缺陷 / 未确定>
   - reproduction confidence: <high / medium / low>
   - next action: <修代码 / 修测试 / 修环境 / 切换 DEBUG>
   - 修复建议: ...

### Remaining Gaps
- P0: <仍未覆盖的关键路径 / 契约项>
- P1: <仍未覆盖的边界或状态分支>
- P2: <仍未覆盖的异常或降级路径>

### 建议
- 质量门禁建议: <coverage / pass rate / flaky / time budget>
- CI / 持续治理建议: <是否接入 `test-quality-metrics.md`>
```

---

## 门禁逻辑

| 场景 | 处理方式 |
|------|----------|
| 新增测试失败 | 必须先完成失败归因；禁止未归因就直接认定为代码 Bug |
| 新增测试导致旧测试失败 | 检查是否破坏了现有行为，若是则调整测试或回到 Plan |
| 覆盖率未达标 | 若用户设定了目标覆盖率，继续补充测试直到达标或用户确认降低目标 |
| 质量度量缺失 | 报告中显式写 `N/A + 原因`，并标记后续补齐动作 |
| 测试运行超时 | 识别慢测试，建议用户优化或拆分 |
| 归因不明 | 标记 `failure category = 未确定`，并建议切换到 `DEBUG` |

---

## 与其他模式协作

- **TEST → DEBUG**: 测试失败且原因不明，进入 DEBUG 模式排查
- **TEST → REFACTOR**: 测试覆盖后发现有重构机会，进入 REFACTOR 模式
- **TEST → REVIEW**: 测试完成后，进入 REVIEW 模式审查测试质量

---

## 特殊场景处理

### 场景 1: 无测试框架的项目

- 建议用户先搭建测试框架（提供框架选型建议）
- 若用户暂不搭建，输出声明："由于项目缺少测试框架，以下测试为手动验证步骤，非自动化测试"

### 场景 2: 测试依赖复杂环境（数据库/外部 API）

- 建议使用 Mock/Stub 隔离依赖
- 若无法 Mock，建议用户先搭建测试基础设施（如测试数据库）

### 场景 3: 测试代码量 > 被测试代码

- 输出提示："测试代码量较大，建议拆分到多个测试文件，按功能分组"
- 提供测试组织建议（如按功能模块/按测试类型分组）

### 场景 4: API 缺少契约文件

- 输出提示："当前缺少 OpenAPI / GraphQL Schema / Proto / 已落盘接口文档，无法把 API 测试建立在稳定契约上"
- 优先建议用户补充契约文件或确认可作为契约的现有文档
- 若用户明确要求先基于现有实现补测试，必须在策略中标注：`Contract Source: Missing / inferred from implementation (higher risk)`

### 场景 5: 需要验证 TEST 模式在压力下是否仍守纪律

- 当任务存在时间压力、覆盖率数字导向、契约缺失、失败误判或“已有代码就跳过流程”等信号时，加载 `references/testing/test-task-pressure-scenarios.md`
- 至少对照以下维度检查是否绕过纪律：
  - 是否跳过 `Test Strategy`
  - 是否在缺契约时直接猜 API
  - 是否只追 coverage 数字而忽略关键路径
  - 是否在失败后未做归因就直接改代码
- 若压力场景自检不通过，暂停当前实现，回到测试策略或切换到 `DEBUG`

---

## 测试最佳实践

### 测试命名规范

```
it('应该 <预期行为> 当 <输入条件/场景>', () => {
  // ...
});
```

### AAA 模式

```
// Arrange - 准备测试数据
const input = ...;
const expected = ...;

// Act - 执行被测逻辑
const result = targetFunction(input);

// Assert - 验证结果
expect(result).toEqual(expected);
```

### 测试独立性

- 每个测试用例必须独立，不依赖其他测试的状态
- 测试前清理全局状态（若有）
- 测试后恢复环境（若有副作用）

---

## 参考文档

- pytest 核心模式：`references/testing/pytest-patterns.md`
- API 测试模式：`references/testing/api-testing.md`
- 测试脚手架模板：`references/testing/test-scaffold-templates.md`
- 测试质量度量：`references/testing/test-quality-metrics.md`
- 测试任务压力场景：`references/testing/test-task-pressure-scenarios.md`
- TDD 执行协议：`references/superpowers/test-driven-development/SKILL.md`
- 测试反模式：`references/superpowers/test-driven-development/testing-anti-patterns.md`
- 系统化 Debug：`references/superpowers/systematic-debugging/SKILL.md`
