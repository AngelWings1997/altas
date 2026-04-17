# API Test Matrix

## Context

- Contract Source:
- Contract File:
- Protocol Type: `REST / GraphQL / gRPC`
- Scope:
- Test Framework:
- Run Command:

## Matrix

| Contract Item | Source Ref | Priority | Happy Path | Validation | Auth | Idempotency | Error Path | Schema | Data / Fixture | Status | Notes |
|---------------|------------|----------|------------|------------|------|-------------|------------|--------|----------------|--------|-------|
| `POST /orders` | `openapi.yaml#/paths/~1orders/post` | `P0` | `201 create order` | `422 invalid payload` | `401/403` | `same Idempotency-Key returns same result` | `409 inventory conflict` | `response schema matches contract` | `order factory + auth fixture` | `planned` | |
| `GET /orders/{id}` | `openapi.yaml#/paths/~1orders~1{id}/get` | `P0` | `200 returns order` | `404 nonexistent id` | `401/403` | `N/A` | `500 masked internal error` | `response fields match contract` | `seeded order` | `planned` | |

## Remaining Gaps

- `P0`:
- `P1`:
- `P2`:

## Deferred Items

- Item:
- Reason:
