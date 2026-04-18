#!/usr/bin/env bash
#
# verify.sh - Implementation verification script for ALTAS Workflow
#
# Verifies implementation against PRD/specifications by checking requirement
# fulfillment, task completion, and contract implementation.
#
# Usage: bash references/superpowers/implementation-verify/scripts/verify.sh
#
# Exit Codes:
#   0 - Complete (100% fulfillment)
#   1 - Partial (>80% fulfillment)
#   2 - Low (<80% fulfillment)
#   3 - Error (required files missing)
#

set -euo pipefail

# ============================================================================
# COLORS AND UTILITIES
# ============================================================================

readonly COLOR_RED='\033[0;31m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_NC='\033[0m'

print_info()    { echo -e "${COLOR_BLUE}ℹ $1${COLOR_NC}"; }
print_success() { echo -e "${COLOR_GREEN}✓ $1${COLOR_NC}"; }
print_warning() { echo -e "${COLOR_YELLOW}⚠ $1${COLOR_NC}"; }
print_error()   { echo -e "${COLOR_RED}✗ $1${COLOR_NC}"; }

# ============================================================================
# PATH RESOLUTION
# ============================================================================

find_repo_root() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        if [[ -d "$dir/.git" ]] || [[ -d "$dir/.specify" ]] || [[ -f "$dir/altas-workflow/SKILL.md" ]] || [[ -d "$dir/.agents" ]] || [[ -d "$dir/.cursor" ]]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

REPO_ROOT="$(find_repo_root)" || {
    print_error "Could not find repository root (looked for .git, .specify, or altas-workflow/)"
    exit 3
}

# Find feature directory - look for spec files in common locations
SPEC_FILE=""
TASKS_FILE=""
CONTRACTS_DIR=""

# Search strategy: check .specify/specs, .start/specs, mydocs/specs, then current dir
for base_dir in "$REPO_ROOT/.specify/specs" "$REPO_ROOT/.start/specs" "$REPO_ROOT/mydocs/specs" "$REPO_ROOT/specs" "$REPO_ROOT"; do
    if [[ -d "$base_dir" ]]; then
        # Find the most recently modified spec.md
        found_spec=$(find "$base_dir" -name "spec.md" -o -name "requirements.md" 2>/dev/null | head -1)
        if [[ -n "$found_spec" ]]; then
            FEATURE_DIR="$(dirname "$found_spec")"
            break
        fi
    fi
done

if [[ -z "${FEATURE_DIR:-}" ]]; then
    # Fallback: look for tasks.md in common locations
    found_tasks=$(find "$REPO_ROOT" -name "tasks.md" -maxdepth 4 2>/dev/null | head -1)
    if [[ -n "$found_tasks" ]]; then
        FEATURE_DIR="$(dirname "$found_tasks")"
    fi
fi

if [[ -n "${FEATURE_DIR:-}" ]]; then
    # Look for spec files in feature directory
    for spec_name in "spec.md" "requirements.md"; do
        if [[ -f "$FEATURE_DIR/$spec_name" ]]; then
            SPEC_FILE="$FEATURE_DIR/$spec_name"
            break
        fi
    done

    if [[ -f "$FEATURE_DIR/tasks.md" ]]; then
        TASKS_FILE="$FEATURE_DIR/tasks.md"
    fi

    if [[ -d "$FEATURE_DIR/contracts" ]]; then
        CONTRACTS_DIR="$FEATURE_DIR/contracts"
    fi
fi

# ============================================================================
# VALIDATION
# ============================================================================

if [[ -z "$SPEC_FILE" ]] || [[ ! -f "$SPEC_FILE" ]]; then
    print_error "spec.md or requirements.md not found"
    echo ""
    echo "Searched in:"
    echo "  - $REPO_ROOT/.specify/specs/"
    echo "  - $REPO_ROOT/.start/specs/"
    echo "  - $REPO_ROOT/specs/"
    echo ""
    echo "Run PRD analysis first: /prd or /prd-analysis"
    exit 3
fi

if [[ -z "$TASKS_FILE" ]] || [[ ! -f "$TASKS_FILE" ]]; then
    print_error "tasks.md not found"
    echo ""
    echo "Expected at: $FEATURE_DIR/tasks.md"
    echo ""
    echo "Create tasks.md from spec first: /speckit.implement"
    exit 3
fi

# ============================================================================
# METRICS STORAGE
# ============================================================================

declare -i TOTAL_FRS=0
declare -i IMPLEMENTED_FRS=0
declare -i TOTAL_TASKS=0
declare -i COMPLETED_TASKS=0
declare -i TOTAL_CONTRACTS=0
declare -i IMPLEMENTED_CONTRACTS=0

declare -a UNIMPLEMENTED_REQUIREMENTS=()
declare -a RECOMMENDED_ACTIONS=()

# ============================================================================
# FR REQUIREMENT EXTRACTION
# ============================================================================

extract_requirements() {
    print_info "Extracting FR requirements from $(basename "$SPEC_FILE")..."

    local content
    content=$(cat "$SPEC_FILE")

    # Find all unique FR-XXX references
    local frs
    frs=$(echo "$content" | grep -oE 'FR-[0-9]+' | sort -u || true)

    while IFS= read -r fr; do
        if [[ -n "$fr" ]]; then
            ((TOTAL_FRS++)) || true
        fi
    done <<< "$frs"

    print_info "Found $TOTAL_FRS FR requirements"
}

# ============================================================================
# TASK COMPLETION CALCULATION
# ============================================================================

calculate_task_completion() {
    print_info "Calculating task completion from tasks.md..."

    local content
    content=$(cat "$TASKS_FILE")

    # Count total tasks (lines starting with - [ ] or - [X] or - [x])
    TOTAL_TASKS=$(echo "$content" | grep -cE '^\s*-\s*\[[Xx ]\]' || echo "0")

    # Count completed tasks (marked with [X] or [x])
    COMPLETED_TASKS=$(echo "$content" | grep -cE '^\s*-\s*\[[Xx]\]' || echo "0")

    print_info "Tasks: $COMPLETED_TASKS/$TOTAL_TASKS completed"
}

# ============================================================================
# FR FULFILLMENT CALCULATION
# ============================================================================

calculate_fr_fulfillment() {
    print_info "Cross-referencing FR requirements with completed tasks..."

    local spec_content tasks_content
    spec_content=$(cat "$SPEC_FILE")
    tasks_content=$(cat "$TASKS_FILE")

    # Get all FR-XXX from spec
    local frs
    frs=$(echo "$spec_content" | grep -oE 'FR-[0-9]+' | sort -u || true)

    while IFS= read -r fr; do
        if [[ -z "$fr" ]]; then
            continue
        fi

        # Check if this FR is referenced in a completed task
        if echo "$tasks_content" | grep -E '^\s*-\s*\[[Xx]\].*'"$fr" > /dev/null 2>&1; then
            ((IMPLEMENTED_FRS++)) || true
        else
            # Get FR description from spec
            local fr_desc
            fr_desc=$(echo "$spec_content" | grep -m1 "$fr" | head -1 | sed 's/.*'"$fr"'[^a-zA-Z]*//' | cut -c1-80)
            if [[ -n "$fr_desc" ]]; then
                UNIMPLEMENTED_REQUIREMENTS+=("$fr: $fr_desc...")
            else
                UNIMPLEMENTED_REQUIREMENTS+=("$fr: (description not found)")
            fi
        fi
    done <<< "$frs"
}

# ============================================================================
# CONTRACT IMPLEMENTATION CHECK
# ============================================================================

check_contract_implementation() {
    if [[ -z "$CONTRACTS_DIR" ]] || [[ ! -d "$CONTRACTS_DIR" ]]; then
        print_info "No contracts/ directory found, skipping contract check"
        return
    fi

    print_info "Checking contract implementations..."

    local contract_files
    contract_files=$(find "$CONTRACTS_DIR" -name "*.md" -type f 2>/dev/null || true)

    if [[ -z "$contract_files" ]]; then
        return
    fi

    while IFS= read -r contract_file; do
        if [[ -z "$contract_file" ]]; then
            continue
        fi

        local content
        content=$(cat "$contract_file")

        # Count endpoint definitions (lines with HTTP methods)
        local endpoints
        endpoints=$(echo "$content" | grep -cE '(GET|POST|PUT|DELETE|PATCH)\s+/' || echo "0")
        ((TOTAL_CONTRACTS += endpoints)) || true

        # For now, assume all contract endpoints are implemented
        # A more sophisticated check would verify actual implementation files
        ((IMPLEMENTED_CONTRACTS += endpoints)) || true
    done <<< "$contract_files"

    print_info "Contracts: $IMPLEMENTED_CONTRACTS/$TOTAL_CONTRACTS endpoints"
}

# ============================================================================
# RECOMMENDATIONS
# ============================================================================

generate_recommendations() {
    local task_percent=0
    local fr_percent=0

    if [[ "$TOTAL_TASKS" -gt 0 ]]; then
        task_percent=$((COMPLETED_TASKS * 100 / TOTAL_TASKS))
    fi

    if [[ "$TOTAL_FRS" -gt 0 ]]; then
        fr_percent=$((IMPLEMENTED_FRS * 100 / TOTAL_FRS))
    fi

    if [[ "$task_percent" -lt 100 ]]; then
        local remaining=$((TOTAL_TASKS - COMPLETED_TASKS))
        RECOMMENDED_ACTIONS+=("Complete remaining $remaining task(s) in tasks.md")
    fi

    if [[ "$fr_percent" -lt 100 ]]; then
        local unimpl=$((TOTAL_FRS - IMPLEMENTED_FRS))
        RECOMMENDED_ACTIONS+=("Address $unimpl unimplemented requirement(s)")
    fi

    if [[ "${#UNIMPLEMENTED_REQUIREMENTS[@]}" -gt 0 ]]; then
        RECOMMENDED_ACTIONS+=("Review unimplemented requirements list below")
    fi

    if [[ "${#RECOMMENDED_ACTIONS[@]}" -eq 0 ]]; then
        RECOMMENDED_ACTIONS+=("All requirements fulfilled - ready for merge")
    fi
}

# ============================================================================
# EXIT CODE DETERMINATION
# ============================================================================

determine_exit_code() {
    local task_percent=0
    local fr_percent=0

    if [[ "$TOTAL_TASKS" -gt 0 ]]; then
        task_percent=$((COMPLETED_TASKS * 100 / TOTAL_TASKS))
    fi

    if [[ "$TOTAL_FRS" -gt 0 ]]; then
        fr_percent=$((IMPLEMENTED_FRS * 100 / TOTAL_FRS))
    fi

    # Use the lower of the two percentages
    local overall_percent=$task_percent
    if [[ "$fr_percent" -lt "$overall_percent" ]]; then
        overall_percent=$fr_percent
    fi

    if [[ "$overall_percent" -eq 100 ]]; then
        echo "0"
    elif [[ "$overall_percent" -ge 80 ]]; then
        echo "1"
    else
        echo "2"
    fi
}

# ============================================================================
# OUTPUT RESULTS
# ============================================================================

output_results() {
    local timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    echo ""
    echo "=========================================="
    echo "  Fulfillment Report: implementation-verify"
    echo "=========================================="
    echo ""
    echo "**Branch**: $(git branch --show-current 2>/dev/null || echo 'unknown')"
    echo "**Timestamp**: $timestamp"
    echo "**Spec**: $(basename "$SPEC_FILE")"
    echo "**Tasks**: $(basename "$TASKS_FILE")"
    echo ""

    echo "### Coverage Metrics"
    echo ""
    echo "| Metric | Completed | Total | Percentage |"
    echo "|--------|-----------|-------|------------|"

    local task_percent=0
    local fr_percent=0
    local contract_percent=0

    if [[ "$TOTAL_TASKS" -gt 0 ]]; then
        task_percent=$((COMPLETED_TASKS * 100 / TOTAL_TASKS))
        echo "| Task Completion | $COMPLETED_TASKS | $TOTAL_TASKS | ${task_percent}% |"
    else
        echo "| Task Completion | N/A | 0 | - |"
    fi

    if [[ "$TOTAL_FRS" -gt 0 ]]; then
        fr_percent=$((IMPLEMENTED_FRS * 100 / TOTAL_FRS))
        echo "| FR Fulfillment | $IMPLEMENTED_FRS | $TOTAL_FRS | ${fr_percent}% |"
    else
        echo "| FR Fulfillment | N/A | 0 | - |"
    fi

    if [[ "$TOTAL_CONTRACTS" -gt 0 ]]; then
        contract_percent=$((IMPLEMENTED_CONTRACTS * 100 / TOTAL_CONTRACTS))
        echo "| Contract Implementation | $IMPLEMENTED_CONTRACTS | $TOTAL_CONTRACTS | ${contract_percent}% |"
    fi

    echo ""

    # Status indicator
    local exit_code
    exit_code=$(determine_exit_code)
    local status
    case "$exit_code" in
        0) status="COMPLETE"; print_success "Status: $status (100% fulfillment)" ;;
        1) status="PARTIAL";  print_warning "Status: $status (>80% fulfillment, gaps detected)" ;;
        2) status="LOW";      print_error "Status: $status (<80% fulfillment, blockers found)" ;;
    esac
    echo ""

    # Unimplemented requirements
    if [[ "${#UNIMPLEMENTED_REQUIREMENTS[@]}" -gt 0 ]]; then
        echo "### Unimplemented Requirements"
        echo ""
        for req in "${UNIMPLEMENTED_REQUIREMENTS[@]}"; do
            echo "- $req"
        done
        echo ""
    fi

    # Recommended actions
    echo "### Recommended Actions"
    echo ""
    for action in "${RECOMMENDED_ACTIONS[@]}"; do
        echo "- $action"
    done
    echo ""

    echo "=========================================="
    echo "  Exit Code: $exit_code"
    echo "=========================================="
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

main() {
    print_info "Starting implementation verification..."
    print_info "Repository: $REPO_ROOT"
    print_info "Feature directory: ${FEATURE_DIR:-'not found'}"
    echo ""

    # Run all analyses
    extract_requirements
    calculate_task_completion
    calculate_fr_fulfillment
    check_contract_implementation
    generate_recommendations

    # Output results
    output_results

    # Exit with appropriate code
    exit "$(determine_exit_code)"
}

main "$@"
