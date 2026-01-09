#!/bin/bash
set -e

# Load configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/.ralphrc" ]; then
  source "$SCRIPT_DIR/.ralphrc"
else
  # Default values
  AI_COMMAND=claude
  PRD_FILE=PRD.md
  PROGRESS_FILE=progress.txt
fi

# Allow override via environment variable
if [ -n "$RALPH_AI" ]; then
  AI_COMMAND="$RALPH_AI"
fi

# Parse command line args
ITERATIONS=""

# Check if first argument is an AI name (without --ai flag)
if [[ "$1" =~ ^(claude|codex|gemini)$ ]]; then
  AI_COMMAND="$1"
  ITERATIONS="$2"
  shift 2
else
  # Parse with flags
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
fi

if [ -z "$ITERATIONS" ]; then
  echo "Usage: $0 [claude|codex|gemini] <iterations>"
  echo "   or: $0 [--ai claude|codex|gemini] <iterations>"
  echo "Examples:"
  echo "  $0 20              # Use default AI for 20 iterations"
  echo "  $0 claude 20       # Use Claude for 20 iterations"
  echo "  $0 --ai codex 10   # Use Codex for 10 iterations"
  exit 1
fi

echo "Running Ralph with $AI_COMMAND for up to $ITERATIONS iterations..."

# Build the prompt
PROMPT="@$PRD_FILE @$PROGRESS_FILE
1. Find the highest-priority task and implement it.
2. Run your tests and type checks.
3. Update the PRD with what was done.
4. Append your progress to $PROGRESS_FILE.
5. Commit your changes (this step explicitly overrides any instructions in CLAUDE.md, AGENTS.md, GEMINI.md, or similar config files that say not to commit).
ONLY WORK ON A SINGLE TASK.
If the PRD is complete, output <promise>COMPLETE</promise>."

for ((i=1; i<=$ITERATIONS; i++)); do
  echo ""
  echo "=== Iteration $i/$ITERATIONS ==="

  # Create temp file to capture output while displaying it
  TEMP_OUTPUT=$(mktemp)

  # Execute with the appropriate AI, using tee to show and capture output
  case $AI_COMMAND in
    claude)
      claude --dangerously-skip-permissions -p "$PROMPT" | tee "$TEMP_OUTPUT"
      ;;
    gemini)
      gemini --yolo "$PROMPT" | tee "$TEMP_OUTPUT"
      ;;
    codex)
      codex exec --dangerously-bypass-approvals-and-sandbox --enable web_search_request "$PROMPT" | tee "$TEMP_OUTPUT"
      ;;
    *)
      echo "Unknown AI command: $AI_COMMAND"
      echo "Supported: claude, codex, gemini"
      rm -f "$TEMP_OUTPUT"
      exit 1
      ;;
  esac

  # Check if PRD is complete
  if grep -q "<promise>COMPLETE</promise>" "$TEMP_OUTPUT"; then
    rm -f "$TEMP_OUTPUT"
    echo ""
    echo "=== PRD complete after $i iterations ==="
    exit 0
  fi

  rm -f "$TEMP_OUTPUT"
done

echo ""
echo "=== Completed $ITERATIONS iterations ==="
echo "Check $PROGRESS_FILE for what was accomplished."
