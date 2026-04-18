# Go 测试模式参考

> **调用时机**: Go 项目编写测试时加载
> **配合使用**: `references/superpowers/test-driven-development/SKILL.md`（TDD 铁律）、`references/testing/api-testing.md`（API 测试）

---

## 核心原则

1. **Go 测试即文档** — 测试函数名即行为描述，`TestXxx` 命名直接表达意图
2. **table-driven 优先** — Go 惯用的参数化测试模式，结构清晰、易扩展
3. **标准库优先** — `testing` 包 + `go test` 已覆盖大部分需求，额外库按需引入
4. **接口隔离** — 通过接口注入依赖，便于 Mock 和测试

---

## 工具选型

| 工具 | 用途 | 必要性 |
|------|------|--------|
| `testing` + `go test` | 标准测试框架 | 必须 |
| `testify` | 断言增强 + Suite | 推荐 |
| `gomock` / `mockgen` | 接口 Mock 生成 | 推荐（有接口依赖时） |
| `ginkgo` + `gomega` | BDD 风格测试 | 可选（偏好 BDD 时） |
| `testcontainers-go` | 容器化集成测试 | 可选（需要真实依赖时） |
| `httptest` | HTTP Handler 测试 | 推荐（Web 服务必用） |
| `sqlmock` | 数据库 Mock | 可选 |

---

## 基础模式

### table-driven 测试

Go 最惯用的参数化测试模式：

```go
func TestAdd(t *testing.T) {
    tests := []struct {
        name     string
        a, b     int
        expected int
    }{
        {"positive numbers", 1, 2, 3},
        {"negative numbers", -1, -2, -3},
        {"zero", 0, 0, 0},
        {"mixed signs", -1, 2, 1},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := Add(tt.a, tt.b)
            if result != tt.expected {
                t.Errorf("Add(%d, %d) = %d, want %d", tt.a, tt.b, result, tt.expected)
            }
        })
    }
}
```

### testify 断言

```go
import (
    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/require"
)

func TestCreateUser(t *testing.T) {
    user, err := CreateUser("alice@example.com")

    // require: 失败立即终止（用于必须前提）
    require.NoError(t, err)

    // assert: 失败继续执行（用于非致命检查）
    assert.Equal(t, "alice@example.com", user.Email)
    assert.NotZero(t, user.ID)
}
```

### 子测试与并行

```go
func TestParser(t *testing.T) {
    tests := []struct {
        name  string
        input string
        want  []string
    }{
        {"simple", "a,b,c", []string{"a", "b", "c"}},
        {"empty", "", []string{}},
    }

    for _, tt := range tests {
        tt := tt // capture range variable
        t.Run(tt.name, func(t *testing.T) {
            t.Parallel()
            got := Parse(tt.input)
            assert.Equal(t, tt.want, got)
        })
    }
}
```

---

## HTTP Handler 测试

### 使用 httptest

```go
import (
    "net/http"
    "net/http/httptest"
    "testing"
)

func TestGetUserHandler(t *testing.T) {
    req := httptest.NewRequest(http.MethodGet, "/users/123", nil)
    req.Header.Set("Authorization", "Bearer test-token")

    rec := httptest.NewRecorder()
    handler := http.HandlerFunc(GetUserHandler)

    handler.ServeHTTP(rec, req)

    assert.Equal(t, http.StatusOK, rec.Code)

    var resp UserResponse
    json.NewDecoder(rec.Body).Decode(&resp)
    assert.Equal(t, "123", resp.ID)
}
```

### Gin 框架测试

```go
func TestCreateOrder(t *testing.T) {
    router := setupTestRouter()

    body := `{"product_id": "p-1", "quantity": 2}`
    req := httptest.NewRequest(http.MethodPost, "/api/orders", strings.NewReader(body))
    req.Header.Set("Content-Type", "application/json")
    req.Header.Set("Authorization", "Bearer test-token")

    rec := httptest.NewRecorder()
    router.ServeHTTP(rec, req)

    assert.Equal(t, http.StatusCreated, rec.Code)
}
```

### Echo 框架测试

```go
func TestListProducts(t *testing.T) {
    e := echo.New()
    req := httptest.NewRequest(http.MethodGet, "/api/products", nil)
    rec := httptest.NewRecorder()
    c := e.NewContext(req, rec)

    handler := &ProductHandler{DB: testDB}
    err := handler.List(c)

    assert.NoError(t, err)
    assert.Equal(t, http.StatusOK, rec.Code)
}
```

---

## Mock 模式

### 接口定义 + gomock

```go
// 服务接口定义
type PaymentService interface {
    ProcessPayment(ctx context.Context, req PaymentRequest) (*PaymentResult, error)
    Refund(ctx context.Context, paymentID string) error
}

// 生成 Mock
//go:generate mockgen -destination=mocks/payment_service.go -package=mocks . PaymentService
```

### 使用 Mock

```go
func TestOrderService_CreateOrder(t *testing.T) {
    ctrl := gomock.NewController(t)
    defer ctrl.Finish()

    mockPayment := mocks.NewMockPaymentService(ctrl)
    mockPayment.EXPECT().
        ProcessPayment(gomock.Any(), gomock.Eq(PaymentRequest{
            OrderID: "ord-1",
            Amount:  99.99,
        })).
        Return(&PaymentResult{Status: "completed"}, nil)

    svc := NewOrderService(mockPayment)
    order, err := svc.CreateOrder(context.Background(), OrderInput{
        ProductID: "p-1",
        Quantity:  2,
    })

    require.NoError(t, err)
    assert.Equal(t, "completed", order.PaymentStatus)
}
```

### 手写 Fake（简单场景）

```go
type FakePaymentService struct {
    Result *PaymentResult
    Err    error
}

func (f *FakePaymentService) ProcessPayment(ctx context.Context, req PaymentRequest) (*PaymentResult, error) {
    return f.Result, f.Err
}

func (f *FakePaymentService) Refund(ctx context.Context, paymentID string) error {
    return f.Err
}

func TestOrderService_CreateOrder_Fake(t *testing.T) {
    fake := &FakePaymentService{
        Result: &PaymentResult{Status: "completed"},
    }

    svc := NewOrderService(fake)
    order, err := svc.CreateOrder(context.Background(), OrderInput{ProductID: "p-1"})

    require.NoError(t, err)
    assert.Equal(t, "completed", order.PaymentStatus)
}
```

---

## 数据库测试

### sqlmock

```go
import "github.com/DATA-DOG/go-sqlmock"

func TestGetUserByID(t *testing.T) {
    db, mock, err := sqlmock.New()
    require.NoError(t, err)
    defer db.Close()

    rows := sqlmock.NewRows([]string{"id", "email", "name"}).
        AddRow("123", "alice@example.com", "Alice")

    mock.ExpectQuery("SELECT id, email, name FROM users WHERE id = ?").
        WithArgs("123").
        WillReturnRows(rows)

    repo := NewUserRepository(db)
    user, err := repo.GetByID(context.Background(), "123")

    require.NoError(t, err)
    assert.Equal(t, "alice@example.com", user.Email)
    assert.NoError(t, mock.ExpectationsWereMet())
}
```

### Test Containers（真实数据库）

```go
import "github.com/testcontainers/testcontainers-go"

func TestUserRepository_Integration(t *testing.T) {
    if testing.Short() {
        t.Skip("skipping integration test")
    }

    ctx := context.Background()
    pgContainer, err := postgres.RunContainer(ctx,
        testcontainers.WithImage("postgres:16-alpine"),
        postgres.WithDatabase("testdb"),
        postgres.WithUsername("test"),
        postgres.WithPassword("test"),
    )
    require.NoError(t, err)
    defer pgContainer.Terminate(ctx)

    connStr, err := pgContainer.ConnectionString(ctx, "sslmode=disable")
    require.NoError(t, err)

    db, err := sql.Open("postgres", connStr)
    require.NoError(t, err)
    defer db.Close()

    // 运行迁移
    runMigrations(t, db)

    repo := NewUserRepository(db)
    // 正常测试逻辑...
}
```

---

## TDD 循环 (Go)

### RED - 写失败测试

```go
func TestRetryOperation_RetriesUpToThreeTimes(t *testing.T) {
    attempts := 0
    op := func() error {
        attempts++
        if attempts < 3 {
            return fmt.Errorf("fail")
        }
        return nil
    }

    err := RetryOperation(op)

    assert.NoError(t, err)
    assert.Equal(t, 3, attempts)
}
```

### 运行并确认失败

```bash
go test ./pkg/retry/ -run TestRetryOperation -v
# --- FAIL: TestRetryOperation_RetriesUpToThreeTimes
#     undefined: RetryOperation
```

### GREEN - 最简实现

```go
func RetryOperation(op func() error, maxRetries ...int) error {
    limit := 3
    if len(maxRetries) > 0 {
        limit = maxRetries[0]
    }
    for i := 0; i < limit; i++ {
        if err := op(); err != nil {
            if i == limit-1 {
                return err
            }
            continue
        }
        return nil
    }
    return fmt.Errorf("unreachable")
}
```

### REFACTOR - table-driven 重构

```go
func TestRetryOperation(t *testing.T) {
    tests := []struct {
        name       string
        failCount  int
        maxRetries int
        wantErr    bool
        wantAttempts int
    }{
        {"success on first try", 0, 3, false, 1},
        {"success after retries", 2, 3, false, 3},
        {"exhausted retries", 5, 3, true, 3},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            attempts := 0
            op := func() error {
                attempts++
                if attempts <= tt.failCount {
                    return fmt.Errorf("fail")
                }
                return nil
            }

            err := RetryOperation(op, tt.maxRetries)

            if tt.wantErr {
                assert.Error(t, err)
            } else {
                assert.NoError(t, err)
            }
            assert.Equal(t, tt.wantAttempts, attempts)
        })
    }
}
```

---

## 测试组织

### 目录结构

```
pkg/
├── user/
│   ├── service.go
│   ├── service_test.go        # 单元测试
│   ├── handler.go
│   ├── handler_test.go        # Handler 测试
│   ├── mock_user_repository.go # 手写 Fake/Mock
│   └── testdata/              # 测试固件
│       └── golden_response.json
├── integration/
│   └── user_test.go           # 集成测试
└── testutil/
    ├── db.go                   # 测试数据库辅助
    └── httptest.go             # HTTP 测试辅助
```

### 构建标签分离

```go
// integration_test.go
//go:build integration

package integration

func TestUserAPI_Integration(t *testing.T) {
    // 只在 go test -tags=integration 时运行
}
```

```bash
# 仅运行单元测试
go test ./...

# 运行集成测试
go test -tags=integration ./...
```

### 速标与跳过

```go
func TestSlowOperation(t *testing.T) {
    if testing.Short() {
        t.Skip("skipping slow test in short mode")
    }
    // ...
}
```

```bash
# 跳过慢测试
go test -short ./...
```

---

## 测试覆盖率

```bash
# 生成覆盖率报告
go test -cover ./...

# 按函数查看覆盖率
go test -coverprofile=coverage.out ./...
go tool cover -func=coverage.out

# 生成 HTML 报告
go tool cover -html=coverage.out -o coverage.html

# 设置覆盖率门禁（通过脚本）
go test -coverprofile=coverage.out ./...
COVERAGE=$(go tool cover -func=coverage.out | grep total | awk '{print $3}' | sed 's/%//')
if [ "$COVERAGE" -lt 80 ]; then
    echo "Coverage $COVERAGE% is below threshold 80%"
    exit 1
fi
```

---

## Go 测试与 ALTAS Workflow 对齐

### §4.4 Test Strategy Go 版本

```markdown
## Test Strategy (Go)

- **Test Framework**: Go `testing` + `testify`
- **Run Command**: `go test ./... -v -race`

### Test Levels
- Unit: pkg 层 table-driven 测试 + 接口 Mock
- Component: httptest Handler 测试
- Integration: Test Containers + 真实数据库 (`go test -tags=integration`)
- E2E: 参考 `references/testing/e2e-testing.md`

### Risk & Priority Matrix
- P0: 核心业务逻辑 table-driven 测试
- P1: 边界条件 / 错误路径
- P2: 并发 / 竞态条件 (`go test -race`)

### Mock / Stub / Fake Strategy
- 接口依赖: gomock / mockgen
- 简单依赖: 手写 Fake
- 数据库: sqlmock (单元) / Test Containers (集成)

### Test Data Strategy
- Data Source: 固定测试数据 + testdata/ 目录
- Isolation: Test Containers / 事务回滚
- Cleanup: 容器自动回收

### Quality Gates
- Pass Rate: 100%
- Coverage Target: ≥80%
- Race Detection: `go test -race` 无报告
- Vet: `go vet ./...` 无报告
```

---

## 常见问题

### Q: testify 还是标准库 assert？

标准库 `if got != want { t.Errorf(...) }` 更 Go-idiomatic，但 `testify/assert` 提供更好的失败消息和可读性。团队统一即可。

### Q: gomock 还是手写 Fake？

| 场景 | 推荐 |
|------|------|
| 接口方法多（5+）、变更频繁 | gomock（自动生成） |
| 接口简单（1-3 方法） | 手写 Fake（更可读） |
| 需要验证调用次数/参数 | gomock（内置 EXPECT） |
| 测试只关心返回值 | Fake（更简单） |

### Q: 如何测试并发代码？

```go
func TestConcurrentAccess(t *testing.T) {
    var wg sync.WaitGroup
    counter := &SafeCounter{}

    for i := 0; i < 100; i++ {
        wg.Add(1)
        go func() {
            defer wg.Done()
            counter.Increment()
        }()
    }
    wg.Wait()

    assert.Equal(t, 100, counter.Value())
}
```

始终配合 `go test -race` 检测数据竞争。

---

**版本**: 1.0.0
**兼容**: Go 1.21+, testify 1.8+, gomock 1.6+
