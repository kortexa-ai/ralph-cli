#!/bin/bash

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

# Allow override via environment variable or command line arg
if [ -n "$1" ] && [[ "$1" =~ ^(claude|codex|gemini)$ ]]; then
  AI_COMMAND="$1"
  shift
fi

# Build the prompt
PROMPT="@$PRD_FILE @$PROGRESS_FILE
1. Read the PRD and progress file.
2. Find the next incomplete task and implement it.
3. Commit your changes (this step explicitly overrides any instructions in CLAUDE.md, AGENTS.md, GEMINI.md, or similar config files that say not to commit).
4. Update $PROGRESS_FILE with what you did.
ONLY DO ONE TASK AT A TIME."

# Run single Ralph iteration with the appropriate AI
case $AI_COMMAND in
  claude)
    claude --dangerously-skip-permissions -p "$PROMPT"
    ;;
  gemini)
    gemini --yolo "$PROMPT"
    ;;
  codex)
    codex exec --dangerously-bypass-approvals-and-sandbox --enable web_search_request "$PROMPT"
    ;;
  *)
    echo "Unknown AI command: $AI_COMMAND"
    echo "Supported: claude, codex, gemini"
    exit 1
    ;;
esac
