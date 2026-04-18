# Test Strategy 模板

> 本文件统一 `TEST` 模式与 `M/L` 规模 `PLAN` 阶段使用的 `Test Strategy` 结构。
> 入口文件只保留“必须先产出结构化测试策略”这一要求；字段细节统一在这里维护。

## 何时加载

- `TEST` 模式开始补测试、修测试或做测试规划时
- `M/L` 规模任务进入 `PLAN`，需要设计验证方案时
- 需要把需求、契约和测试用例做结构化映射时
- 需要统一不同项目、语言或团队的测试策略写法时

## 使用原则

- `TEST` 模式与主流程 `PLAN` 阶段使用同一套字段名与顺序
- 不适用项显式写 `N/A`，不要省略整个小节
- 不允许只写成“补充必要测试”或“补齐回归”这种泛化描述
- API 项目优先从契约文件展开，而不是从实现细节倒推接口行为

## 固定最小结构

```markdown
## Test Strategy

- **Test Framework**: <Jest / Pytest / Go test / ...>
- **Run Command**: <npm test / pytest / go test ./... / ...>

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

## 填写说明

### Test Framework

- 明确项目主测试框架与辅助库
- 示例：
  - Python: `pytest + pytest-mock + httpx`
  - Go: `go test + testify + httptest`
  - Frontend: `vitest + testing-library + playwright`

### Run Command

- 给出本地执行命令；如 CI 命令不同，也应明确说明
- 如果需要多条命令，按层次区分：
  - 单元测试
  - 集成测试
  - 全量回归

### Test Levels

- `Unit`：纯逻辑、边界值、条件分支
- `Component`：单模块或单接口层级行为
- `Integration`：数据库、消息队列、第三方服务、跨模块交互
- `E2E`：从用户入口到核心链路完成的端到端流程

### Risk & Priority Matrix

- 至少覆盖 `P0 / P1 / P2`
- 任务涉及安全、性能、兼容性时，可扩展 `P3+`
- 建议把高风险场景直接映射到回归门禁

### Requirement / Contract Traceability

- 优先引用需求编号、缺陷编号、API 契约路径或 Spec 段落
- API 项目建议使用：
  - `openapi.yaml#/paths/~1orders/post`
  - `schema.graphql#Mutation.createOrder`
  - `user.proto#rpc GetUser`

### Mock / Stub / Fake Strategy

- 明确哪些依赖必须使用真实实现，哪些需要隔离
- 优先级建议：
  - 核心业务规则尽量少 mock
  - 不稳定外部依赖优先 fake / stub
  - 跨网络依赖需要说明是否使用 mock server

### Test Data Strategy

- 明确数据来源、隔离方式和清理策略
- 若需要大规模数据、并发数据或关联对象，额外加载 `references/testing/test-data-management.md`

### Quality Gates

- 至少定义通过率、覆盖率、flaky 容忍度和时间预算
- 如涉及 CI 或可观测性，额外加载：
  - `references/testing/ci-cd-integration.md`
  - `references/testing/test-quality-metrics.md`
  - `references/testing/test-observability.md`

## 常见组合

| 场景 | 先加载 | 再加载 |
|------|--------|--------|
| Python 单元/集成测试 | `references/testing/pytest-patterns.md` | `references/testing/test-data-management.md` |
| Python API 测试 | `references/testing/api-testing.md` | `references/testing/pytest-patterns.md` |
| Go 服务测试 | `references/testing/go-testing.md` | `references/testing/contract-testing.md` |
| E2E 测试 | `references/testing/e2e-testing.md` | `references/testing/test-environment.md` |
| 性能/容量测试 | `references/testing/performance-testing.md` | `references/testing/ci-cd-integration.md` |
