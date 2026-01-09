#!/bin/bash

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

# Allow override via environment variable or command line arg
if [ -n "$1" ] && [[ "$1" =~ ^(cld|cdx|gmn)$ ]]; then
  AI_COMMAND="$1"
  shift
fi

# Run single Ralph iteration
# Your aliases already have the proper permissions configured
$AI_COMMAND "@$PRD_FILE @$PROGRESS_FILE \\
1. Read the PRD and progress file. \\
2. Find the next incomplete task and implement it. \\
3. Commit your changes. \\
4. Update $PROGRESS_FILE with what you did. \\
ONLY DO ONE TASK AT A TIME."
