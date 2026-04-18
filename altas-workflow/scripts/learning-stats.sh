#!/bin/bash
# ALTAS Learning Statistics Script
# Generate statistics and insights from .learnings/ entries
# Usage: ./scripts/learning-stats.sh [--period <days>] [--area <area>] [--output <format>]

set -e

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

LEARNINGS_DIR=".learnings"

usage() {
    cat << EOF
Usage: $(basename "$0") [options]

生成 .learnings/ 目录的统计信息和洞察。

Options:
  --period <days>     仅统计最近 N 天的条目（默认：全部）
  --area <area>       按区域过滤 (workflow, routing, spec, execute, ...)
  --type <type>       按类型显示详情 (LRN, ERR, FEAT)
  --trends            显示趋势分析（需要足够数据）
  --promotions        显示可晋升条目列表
  --output <format>   输出格式: text (默认), json, markdown
  -h, --help          显示帮助信息

Examples:
  $(basename "$0") --period 30 --output markdown
  $(basename "$0") --area execute --promotions
  $(basename "$0") --trends --period 90
EOF
}

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Parse arguments
PERIOD=""
AREA=""
TYPE=""
TRENDS=false
PROMOTIONS=false
OUTPUT="text"

while [[ $# -gt 0 ]]; do
    case $1 in
        --period)
            PERIOD="$2"
            shift 2
            ;;
        --area)
            AREA="$2"
            shift 2
            ;;
        --type)
            TYPE="$2"
            shift 2
            ;;
        --trends)
            TRENDS=true
            shift
            ;;
        --promotions)
            PROMOTIONS=true
            shift
            ;;
        --output)
            OUTPUT="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            log_error "未知选项: $1"
            usage
            exit 1
            ;;
    esac
done

# Check if learnings directory exists
if [ ! -d "$LEARNINGS_DIR" ]; then
    echo "❌ 学习目录不存在: $LEARNINGS_DIR"
    exit 1
fi

# Initialize counters
declare -A status_count
declare -A area_count
declare -A category_count
declare -A priority_count
declare -A type_count

total=0
pending=0
in_progress=0
resolved=0
promoted=0
promoted_to_skill=0

# Calculate cutoff date if period specified
CUTOFF_DATE=""
if [ -n "$PERIOD" ]; then
    CUTOFF_DATE=$(date -v-"${PERIOD}"d +%Y%m%d 2>/dev/null || date -d "${PERIOD} days ago" +%Y%m%d 2>/dev/null || echo "")
fi

# Process each file
for file in "$LEARNINGS_DIR"/*.md; do
    [ -f "$file" ] || continue
    
    filename=$(basename "$file")
    
    # Determine entry type based on filename
    case "$filename" in
        LEARNINGS.md) current_type="LRN" ;;
        ERRORS.md) current_type="ERR" ;;
        FEATURE_REQUESTS.md) current_type="FEAT" ;;
        *) continue ;;
    esac
    
    # Skip if type filter doesn't match
    if [ -n "$TYPE" ] && [ "$current_type" != "$TYPE" ]; then
        continue
    fi
    
    # Find all entries in this file
    while IFS= read -r line; do
        if [[ $line =~ ^##\ \[(LRN|ERR|FEAT)-([0-9]{8})-[A-Za-z0-9]+\] ]]; then
            entry_date="${BASH_REMATCH[2]}"
            
            # Apply period filter
            if [ -n "$CUTOFF_DATE" ] && [ -n "$entry_date" ]; then
                if [[ "$entry_date" < "$CUTOFF_DATE" ]]; then
                    continue
                fi
            fi
            
            total=$((total + 1))
            
            # Get entry content
            entry_id="${BASH_REMATCH[0]}"
            entry_content=$(sed -n "/^${entry_id} /,/^---$/p" "$file")
            
            # Extract fields
            status=$(echo "$entry_content" | grep "^**Status**:" | sed 's/**Status**: *//' | head -n 1)
            area=$(echo "$entry_content" | grep "^**Area**:" | sed 's/**Area**: *//' | head -n 1)
            priority=$(echo "$entry_content" | grep "^**Priority**:" | sed 's/**Priority**: *//' | head -n 1)
            
            # Get category (second word of first line after ##)
            category=$(echo "$line" | awk '{print $2}')
            
            # Apply area filter
            if [ -n "$AREA" ] && [ "${area,,}" != "${AREA,,}" ]; then
                total=$((total - 1))
                continue
            fi
            
            # Count by status
            case "${status,,}" in
                pending) pending=$((pending + 1)) ;;
                in_progress) in_progress=$((in_progress + 1)) ;;
                resolved) resolved=$((resolved + 1)) ;;
                promoted) promoted=$((promoted + 1)) ;;
                promoted_to_skill) promoted_to_skill=$((promoted_to_skill + 1)) ;;
            esac
            
            # Count by area
            if [ -n "$area" ]; then
                area_count["$area"]=$((${area_count["$area"]:-0} + 1))
            fi
            
            # Count by category
            if [ -n "$category" ]; then
                category_count["$category"]=$((${category_count["$category"]:-0} + 1))
            fi
            
            # Count by priority
            if [ -n "$priority" ]; then
                priority_count["$priority"]=$((${priority_count["$priority"]:-0} + 1))
            fi
            
            # Count by type
            type_count["$current_type"]=$((${type_count["$current_type"]:-0} + 1))
        fi
    done < "$file"
done

# Output results
if [ "$OUTPUT" = "json" ]; then
    echo "{"
    echo "  \"total\": $total,"
    echo "  \"by_status\": {"
    echo "    \"pending\": $pending,"
    echo "    \"in_progress\": $in_progress,"
    echo "    \"resolved\": $resolved,"
    echo "    \"promoted\": $promoted,"
    echo "    \"promoted_to_skill\": $promoted_to_skill"
    echo "  },"
    
    echo "  \"by_area\": {"
    first=true
    for area in "${!area_count[@]}"; do
        if [ "$first" = true ]; then
            first=false
        else
            echo ","
        fi
        printf "    \"%s\": %s" "$area" "${area_count[$area]}"
    done
    echo ""
    echo "  },"
    
    echo "  \"by_priority\": {"
    first=true
    for prio in "${!priority_count[@]}"; do
        if [ "$first" = true ]; then
            first=false
        else
            echo ","
        fi
        printf "    \"%s\": %s" "$prio" "${priority_count[$prio]}"
    done
    echo ""
    echo "  },"
    
    echo "  \"by_type\": {"
    first=true
    for t in "${!type_count[@]}"; do
        if [ "$first" = true ]; then
            first=false
        else
            echo ","
        fi
        printf "    \"%s\": %s" "$t" "${type_count[$t]}"
    done
    echo ""
    echo "  }"
    echo "}"
elif [ "$OUTPUT" = "markdown" ]; then
    echo "# ALTAS 学习统计报告"
    echo ""
    echo "**生成时间**: $(date '+%Y-%m-%d %H:%M:%S')"
    if [ -n "$PERIOD" ]; then
        echo "**统计周期**: 最近 ${PERIOD} 天"
    fi
    if [ -n "$AREA" ]; then
        echo "**区域过滤**: $AREA"
    fi
    echo ""
    
    echo "## 总览"
    echo ""
    echo "| 指标 | 数量 | 占比 |"
    echo "|------|------|------|"
    echo "| **总计** | **$total** | **100%** |"
    echo "| 待处理 (Pending) | $pending | $(echo "scale=1; $pending * 100 / $total" | bc 2>/dev/null || echo 'N/A')% |"
    echo "| 进行中 (In Progress) | $in_progress | $(echo "scale=1; $in_progress * 100 / $total" | bc 2>/dev/null || echo 'N/A')% |"
    echo "| 已解决 (Resolved) | $resolved | $(echo "scale=1; $resolved * 100 / $total" | bc 2>/dev/null || echo 'N/A')% |"
    echo "| 已晋升 (Promoted) | $promoted | $(echo "scale=1; $promoted * 100 / $total" | bc 2>/dev/null || echo 'N/A')% |"
    echo "| 已提取为技能 | $promoted_to_skill | $(echo "scale=1; $promoted_to_skill * 100 / $total" | bc 2>/dev/null || echo 'N/A')% |"
    echo ""
    
    echo "## 按区域分布"
    echo ""
    echo "| 区域 | 数量 | 占比 |"
    echo "|------|------|------|"
    for area in "${!area_count[@]}"; do
        printf "| **%s** | %s | %s%% |\n" "$area" "${area_count[$area]}" "$(echo "scale=1; ${area_count[$area]} * 100 / $total" | bc 2>/dev/null || echo 'N/A')"
    done | sort -t'|' -k2 -rn
    echo ""
    
    echo "## 按优先级分布"
    echo ""
    echo "| 优先级 | 数量 | 占比 |"
    echo "|--------|------|------|"
    for prio in critical high medium low; do
        if [ -n "${priority_count[$prio]}" ]; then
            printf "| **%s** | %s | %s%%\n" "$prio" "${priority_count[$prio]}" "$(echo "scale=1; ${priority_count[$prio]} * 100 / $total" | bc 2>/dev/null || echo 'N/A')"
        fi
    done
    echo ""
    
    echo "## 按类型分布"
    echo ""
    echo "| 类型 | 文件 | 数量 | 占比 |"
    echo "|------|------|------|------|"
    for t in LRN ERR FEAT; do
        if [ -n "${type_count[$t]}" ]; then
            case "$t" in
                LRN) file="LEARNINGS.md" ;;
                ERR) file="ERRORS.md" ;;
                FEAT) file="FEATURE_REQUESTS.md" ;;
            esac
            printf "| **%s** | %s | %s | %s%%\n" "$t" "$file" "${type_count[$t]}" "$(echo "scale=1; ${type_count[$t]} * 100 / $total" | bc 2>/dev/null || echo 'N/A')"
        fi
    done
    echo ""
else
    # Text output (default)
    echo "╔══════════════════════════════════════════╗"
    echo "║     📊 ALTAS 学习统计报告               ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""
    echo "📅 生成时间: $(date '+%Y-%m-%d %H:%M:%S')"
    if [ -n "$PERIOD" ]; then
        echo "⏱️  统计周期: 最近 ${PERIOD} 天"
    fi
    if [ -n "$AREA" ]; then
        echo "🎯 区域过滤: $AREA"
    fi
    echo ""
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📈 总览"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    printf "%-25s %8s %8s\n" "状态" "数量" "占比"
    printf "%-25s %8s %8s\n" "─────────────────────────" "────────" "────────"
    printf "%-25s ${GREEN}%8s${NC} %8s\n" "✅ 总计" "$total" "100%"
    printf "%-25s ${YELLOW}%8s${NC} %8s\n" "⏳ 待处理 (Pending)" "$pending" "$(echo "scale=1; $pending * 100 / $total" | bc 2>/dev/null || echo '-')%"
    printf "%-25s ${BLUE}%8s${NC} %8s\n" "🔄 进行中 (In Progress)" "$in_progress" "$(echo "scale=1; $in_progress * 100 / $total" | bc 2>/dev/null || echo '-')%"
    printf "%-25s ${GREEN}%8s${NC} %8s\n" "✔️  已解决 (Resolved)" "$resolved" "$(echo "scale=1; $resolved * 100 / $total" | bc 2>/dev/null || echo '-')%"
    printf "%-25s ${MAGENTA}%8s${NC} %8s\n" "⬆️  已晋升 (Promoted)" "$promoted" "$(echo "scale=1; $promoted * 100 / $total" | bc 2>/dev/null || echo '-')%"
    printf "%-25s ${CYAN}%8s${NC} %8s\n" "🎯 已提取为技能" "$promoted_to_skill" "$(echo "scale=1; $promoted_to_skill * 100 / $total" | bc 2>/dev/null || echo '-')%"
    echo ""
    
    if [ ${#area_count[@]} -gt 0 ]; then
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "🗺️  按区域分布"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        printf "%-20s %8s %8s\n" "区域" "数量" "占比"
        printf "%-20s %8s %8s\n" "────────────────────" "────────" "────────"
        
        for area in "${!area_count[@]}"; do
            printf "%-20s %8d %7s%%\n" "$area" "${area_count[$area]}" "$(echo "scale=1; ${area_count[$area]} * 100 / $total" | bc 2>/dev/null || echo '-')"
        done | sort -k2 -rn
        echo ""
    fi
    
    if [ ${#priority_count[@]} -gt 0 ]; then
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "🎯 按优先级分布"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        printf "%-15s %8s %8s\n" "优先级" "数量" "占比"
        printf "%-15s %8s %8s\n" "───────────────" "────────" "────────"
        
        for prio in critical high medium low; do
            if [ -n "${priority_count[$prio]}" ]; then
                case "$prio" in
                    critical) color=$RED ;;
                    high) color=$RED ;;
                    medium) color=$YELLOW ;;
                    low) color=$GREEN ;;
                esac
                printf "${color}%-15s${NC} %8d %7s%%\n" "$prio" "${priority_count[$prio]}" "$(echo "scale=1; ${priority_count[$prio]} * 100 / $total" | bc 2>/dev/null || echo '-')"
            fi
        done
        echo ""
    fi
    
    if [ ${#type_count[@]} -gt 0 ]; then
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "📁 按类型分布"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        printf "%-10s %-20s %8s %8s\n" "类型" "文件" "数量" "占比"
        printf "%-10s %-20s %8s %8s\n" "──────────" "──────────────────" "────────" "────────"
        
        for t in LRN ERR FEAT; do
            if [ -n "${type_count[$t]}" ]; then
                case "$t" in
                    LRN) file="LEARNINGS.md"; desc="学习" ;;
                    ERR) file="ERRORS.md"; desc="错误" ;;
                    FEAT) file="FEATURE_REQUESTS.md"; desc="功能请求" ;;
                esac
                printf "%-10s %-20s %8d %7s%%\n" "$t" "$file" "${type_count[$t]}" "$(echo "scale=1; ${type_count[$t]} * 100 / $total" | bc 2>/dev/null || echo '-')"
            fi
        done
        echo ""
    fi
fi

# Show promotions candidates if requested
if [ "$PROMOTIONS" = true ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "⬆️  可晋升条目候选"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    candidates_found=false
    
    for file in "$LEARNINGS_DIR"/LEARNINGS.md; do
        [ -f "$file" ] || continue
        
        while IFS= read -r line; do
            if [[ $line =~ ^##\ \[LRN-[0-9]{8}-[A-Za-z0-9]+\] ]]; then
                entry_id="${BASH_REMATCH[0]}"
                
                entry_content=$(sed -n "/^${entry_id} /,/^---$/p" "$file")
                
                recurrence=$(echo "$entry_content" | grep "^- Recurrence-Count:" | sed 's/.*Recurrence-Count: *//')
                status=$(echo "$entry_content" | grep "^**Status**:" | sed 's/**Status**: *//')
                summary=$(echo "$entry_content" | grep "^### Summary" -A 1 | tail -n 1 | sed 's/^[[:space:]]*//')
                pattern_key=$(echo "$entry_content" | grep "^- Pattern-Key:" | sed 's/.*Pattern-Key: *//')
                
                # Show if recurrence >= 2 or high priority and not already promoted
                show_candidate=false
                
                if [ -n "$recurrence" ] && [ "$recurrence" -ge 2 ]; then
                    show_candidate=true
                fi
                
                if [ "$status" != "promoted" ] && [ "$status" != "promoted_to_skill" ]; then
                    priority=$(echo "$entry_content" | grep "^**Priority**:" | sed 's/**Priority**: *//')
                    if [ "$priority" = "high" ] || [ "$priority" = "critical" ]; then
                        show_candidate=true
                    fi
                fi
                
                if [ "$show_candidate" = true ]; then
                    candidates_found=true
                    echo "📌 $entry_id"
                    echo "   摘要: $summary"
                    if [ -n "$recurrence" ]; then
                        echo "   重复次数: $recurrence"
                    fi
                    if [ -n "$pattern_key" ]; then
                        echo "   模式键: $pattern_key"
                    fi
                    echo "   状态: $status"
                    echo ""
                fi
            fi
        done < "$file"
    done
    
    if [ "$candidates_found" = false ]; then
        echo "ℹ️  当前没有符合条件的晋升候选"
        echo "   提示: 当 Recurrence-Count >= 2 或高优先级时会在此显示"
    fi
fi

# Show trends if requested
if [ "$TRENDS" = true ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📉 趋势分析"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "⚠️  趋势分析需要足够的历史数据（建议至少 30 天）"
    echo "   当前功能: 基础时间分布统计"
    echo ""
    
    # Group entries by date
    declare -A date_count
    
    for file in "$LEARNINGS_DIR"/*.md; do
        [ -f "$file" ] || continue
        
        while IFS= read -r line; do
            if [[ $line =~ ^##\ \[(LRN|ERR|FEAT)-([0-9]{8})-[A-Za-z0-9]+\] ]]; then
                entry_date="${BASH_REMATCH[2]}"
                date_count["$entry_date"]=$((${date_count["$entry_date"]:-0} + 1))
            fi
        done < "$file"
    done
    
    if [ ${#date_count[@]} -gt 0 ]; then
        echo "最近活动日期:"
        echo ""
        printf "%-12s %6s\n" "日期" "条目数"
        printf "%-12s %6s\n" "────────────" "──────"
        
        for date in $(echo "${!date_count[@]}" | tr ' ' '\n' | sort -rn | head -n 10); do
            printf "%-12s %6d\n" "$date" "${date_count[$date]}"
        done
        
        echo ""
        total_dates=${#date_count[@]}
        avg_per_day=$(echo "scale=2; $total / $total_dates" | bc 2>/dev/null || echo "N/A")
        echo "活跃天数: $total_dates"
        echo "日均条目: $avg_per_day"
    else
        echo "暂无数据可用于趋势分析"
    fi
fi

echo ""
echo "💡 提示:"
echo "   使用 ./scripts/review-learnings.sh 进入交互式回顾"
echo "   使用 ./scripts/promote-learning.sh <ID> 晋升特定条目"
if [ "$OUTPUT" = "text" ]; then
    echo "   使用 --output markdown 导出为 Markdown 格式"
    echo "   使用 --output json 导出为 JSON 格式"
fi
