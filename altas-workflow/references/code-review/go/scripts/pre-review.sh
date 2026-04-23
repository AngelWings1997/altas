#!/bin/bash
# Pre-review checks for Go code
# Usage: bash scripts/pre-review.sh ./...
#        bash scripts/pre-review.sh --json ./...

set -e

JSON=false
if [ "$1" = "--json" ]; then
    JSON=true
    shift
fi

TARGET="${1:-./...}"

echo "Running Go pre-review checks..."

# Check gofmt
echo ""
echo "=== gofmt ==="
if [ -n "$(gofmt -l .)" ]; then
    echo "FAIL: Files not formatted with gofmt:"
    gofmt -l .
    exit 1
else
    echo "PASS: All files formatted"
fi

# Check go vet
echo ""
echo "=== go vet ==="
if go vet "$TARGET" 2>&1; then
    echo "PASS: go vet clean"
else
    echo "FAIL: go vet found issues"
    exit 1
fi

# Check golangci-lint if available
if command -v golangci-lint &> /dev/null; then
    echo ""
    echo "=== golangci-lint ==="
    if golangci-lint run "$TARGET" 2>&1; then
        echo "PASS: golangci-lint clean"
    else
        echo "FAIL: golangci-lint found issues"
        exit 1
    fi
else
    echo ""
    echo "=== golangci-lint (skipped) ==="
    echo "SKIP: golangci-lint not installed"
fi

echo ""
echo "All checks passed!"
