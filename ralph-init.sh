#!/bin/bash

# Ralph project initializer
echo "Ralph Project Initializer"
echo "========================="
echo ""

# Check if PRD.md already exists
if [ -f "PRD.md" ]; then
  echo "❌ PRD.md already exists in this directory."
  echo "   Delete it first or run this in a different directory."
  exit 1
fi

# Ask user for project name
read -p "Project name (optional): " PROJECT_NAME

# Create PRD.md
if [ -n "$PROJECT_NAME" ]; then
  cat > PRD.md << EOF
# $PROJECT_NAME

## Goals

[Describe what you want to build]

## Requirements

- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

## Technical Specs

[Any specific technologies, patterns, or constraints]

## Success Criteria

[How do you know when this is done?]
EOF
else
  cat > PRD.md << EOF
# Project Requirements

## Goals

[Describe what you want to build]

## Requirements

- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

## Technical Specs

[Any specific technologies, patterns, or constraints]

## Success Criteria

[How do you know when this is done?]
EOF
fi

# Create progress.txt
touch progress.txt

echo ""
echo "✅ Created PRD.md (edit this with your requirements)"
echo "✅ Created progress.txt (auto-updated by Ralph)"
echo ""
echo "Next steps:"
echo "1. Edit PRD.md with your project requirements"
echo "2. Run: ./ralph-once.sh (to test one iteration)"
echo "3. Run: ./afk-ralph.sh 20 (to go AFK)"
echo ""
echo "Or use Claude's plan mode to generate a PRD:"
echo "  claude"
echo "  Press Shift+Tab to enter plan mode"
