#!/bin/bash
# ALTAS Learning Statistics Script
# Generate statistics and insights from .learnings/ entries
# Usage: ./scripts/learning-stats.sh [--period <days>] [--area <area>] [--output <format>]

set -e

# 获取脚本目录并设置模块路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LEARNING_STATS_LIB_DIR="${SCRIPT_DIR}/lib"
LEARNING_STATS_OUTPUT_DIR="${SCRIPT_DIR}/lib/output"

# 加载模块
source "${LEARNING_STATS_LIB_DIR}/utils.sh"
source "${LEARNING_STATS_LIB_DIR}/stats.sh"
source "${LEARNING_STATS_OUTPUT_DIR}/text.sh"
source "${LEARNING_STATS_OUTPUT_DIR}/markdown.sh"
source "${LEARNING_STATS_OUTPUT_DIR}/json.sh"
source "${LEARNING_STATS_LIB_DIR}/promotions.sh"
source "${LEARNING_STATS_LIB_DIR}/trends.sh"

# 加载颜色配置
load_colors

# 清理临时目录 (退出时)
trap cleanup_stats EXIT

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

# 解析参数
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

# 检查学习目录是否存在
if [ ! -d "$LEARNINGS_DIR" ]; then
    echo "$ICON_ERROR 学习目录不存在: $LEARNINGS_DIR"
    exit 1
fi

# 初始化统计
init_stats
set_stats_filters "$PERIOD" "$AREA"

# 遍历条目并计算统计
iterate_entries "process_entry_for_stats" "$LEARNINGS_DIR" "$TYPE"

# 根据输出格式生成报告
case "$OUTPUT" in
    json)
        output_json
        ;;
    markdown)
        output_markdown_report "" "$PERIOD" "$AREA"
        ;;
    text|*)
        output_text_report "" "$PERIOD" "$AREA"
        ;;
esac

# 显示晋升候选（如果请求）
if [ "$PROMOTIONS" = true ]; then
    show_promotion_candidates "$LEARNINGS_DIR"
fi

# 显示趋势分析（如果请求）
if [ "$TRENDS" = true ]; then
    show_trends "$LEARNINGS_DIR" "$PERIOD"
fi

echo ""
echo "$ICON_INFO 提示:"
echo "   使用 ./scripts/review-learnings.sh 进入交互式回顾"
echo "   使用 ./scripts/promote-learning.sh <ID> 晋升特定条目"
if [ "$OUTPUT" = "text" ]; then
    echo "   使用 --output markdown 导出为 Markdown 格式"
    echo "   使用 --output json 导出为 JSON 格式"
fi
