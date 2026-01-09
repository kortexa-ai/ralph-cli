#!/bin/bash

# Ralph CLI Setup Script
# Creates symlinks in ~/bin for easy access

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/bin"

echo "Ralph CLI Setup"
echo "==============="
echo ""

# Create ~/bin if it doesn't exist
if [ ! -d "$BIN_DIR" ]; then
  echo "Creating $BIN_DIR..."
  mkdir -p "$BIN_DIR"
fi

# List of scripts to symlink
SCRIPTS=(
  "ralph-once.sh"
  "ralph.sh"
  "ralph-init.sh"
)

echo "Creating symlinks in $BIN_DIR..."
echo ""

for script in "${SCRIPTS[@]}"; do
  SOURCE="$SCRIPT_DIR/$script"
  TARGET="$BIN_DIR/$script"

  # Remove .sh extension for cleaner command names
  if [[ "$script" == *.sh ]]; then
    CLEAN_NAME="${script%.sh}"
    TARGET="$BIN_DIR/$CLEAN_NAME"
  fi

  # Remove existing symlink or file
  if [ -L "$TARGET" ]; then
    echo "  Removing existing symlink: $TARGET"
    rm "$TARGET"
  elif [ -f "$TARGET" ]; then
    echo "  Warning: $TARGET exists and is not a symlink"
    read -p "    Overwrite? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "    Skipping $script"
      continue
    fi
    rm "$TARGET"
  fi

  # Create symlink
  ln -s "$SOURCE" "$TARGET"
  echo "  ✓ $TARGET -> $SOURCE"
done

echo ""
echo "Setup complete!"
echo ""

# Check if ~/bin is in PATH
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
  echo "⚠️  $HOME/bin is not in your PATH"
  echo ""
  echo "Add it by running:"
  echo "  echo 'export PATH=\"\$HOME/bin:\$PATH\"' >> ~/.bashrc"
  echo "  source ~/.bashrc"
  echo ""
  echo "Or for zsh:"
  echo "  echo 'export PATH=\"\$HOME/bin:\$PATH\"' >> ~/.zshrc"
  echo "  source ~/.zshrc"
else
  echo "✓ $HOME/bin is already in your PATH"
fi

echo ""
echo "Available commands:"
echo "  ralph-init       - Initialize new Ralph project"
echo "  ralph-once       - Run single iteration"
echo "  ralph            - Run multiple iterations"
echo ""
echo "Try: ralph-init to get started"
