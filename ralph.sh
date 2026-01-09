#!/bin/bash
set -e

# Load configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/.ralphrc" ]; then
  source "$SCRIPT_DIR/.ralphrc"
else
  # Default values
  AI_COMMAND=cld
  PRD_FILE=PRD.md
  PROGRESS_FILE=progress.txt
fi

# Allow override via environment variable
if [ -n "$RALPH_AI" ]; then
  AI_COMMAND="$RALPH_AI"
fi

# Parse command line args
ITERATIONS=""
while [[ $# -gt 0 ]]; do
  case $1 in
    --ai)
      AI_COMMAND="$2"
      shift 2
      ;;
    *)
      ITERATIONS="$1"
      shift
      ;;
  esac
done

if [ -z "$ITERATIONS" ]; then
  echo "Usage: $0 [--ai cld|cdx|gmn] <iterations>"
  echo "Example: $0 20"
  echo "Example: $0 --ai cdx 10"
  exit 1
fi

echo "Running Ralph with $AI_COMMAND for up to $ITERATIONS iterations..."

for ((i=1; i<=$ITERATIONS; i++)); do
  echo ""
  echo "=== Iteration $i/$ITERATIONS ==="

  # Your aliases already have the proper permissions configured
  result=$($AI_COMMAND "@$PRD_FILE @$PROGRESS_FILE \\
  1. Find the highest-priority task and implement it. \\
  2. Run your tests and type checks. \\
  3. Update the PRD with what was done. \\
  4. Append your progress to $PROGRESS_FILE. \\
  5. Commit your changes. \\
  ONLY WORK ON A SINGLE TASK. \\
  If the PRD is complete, output <promise>COMPLETE</promise>.")

  echo "$result"

  if [[ "$result" == *"<promise>COMPLETE</promise>"* ]]; then
    echo ""
    echo "=== PRD complete after $i iterations ==="
    exit 0
  fi
done

echo ""
echo "=== Completed $ITERATIONS iterations ==="
echo "Check $PROGRESS_FILE for what was accomplished."
