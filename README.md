![ralph](https://github.com/user-attachments/assets/300c8543-5c43-416e-b3d6-27a496ab83be)

# Ralph CLI Harness

A local harness for running Ralph (AI coding agent loops) with multiple AI backends.

Supports the following AI CLIs:
- **claude** - Claude Code
- **codex** - OpenAI Codex CLI
- **gemini** - Google Gemini CLI

Based on the Ralph technique by Matt Pocock. See [RALPH.md](./RALPH.md) for the full guide.

## Prerequisites

You should have the following AI CLI tools installed:
- `claude` - Anthropic's Claude Code CLI
- `codex` - OpenAI Codex CLI
- `gemini` - Google Gemini CLI

The scripts automatically configure them with appropriate flags:
- **claude**: `--dangerously-skip-permissions -p` (print mode)
- **gemini**: `--yolo`
- **codex**: `exec --dangerously-bypass-approvals-and-sandbox --enable web_search_request`

No additional configuration needed - the scripts handle everything.

## Quick Start

1. Run setup to create symlinks: `./setup.sh`
2. Initialize a project: `ralph-init`
3. Edit PRD.md with your requirements
4. Run one iteration: `ralph-once`
5. Run multiple iterations: `ralph 20`

### Without Setup (Direct Usage)

```bash
cd /Users/francip/src/ralph-cli
./ralph-init.sh          # In your project directory
./ralph-once.sh          # Run one iteration
./ralph.sh 20            # Run 20 iterations
```

## Setup

Run the setup script to create symlinks in `~/bin`:

```bash
cd /Users/francip/src/ralph-cli
./setup.sh
```

This creates symlinks for:
- `ralph-init` - Project initializer
- `ralph-once` - Single iteration
- `ralph` - Multi-iteration mode

The script will:
1. Create `~/bin` if it doesn't exist
2. Create symlinks for all Ralph commands
3. Check if `~/bin` is in your PATH
4. Show instructions to add it if needed

After setup, you can run Ralph commands from anywhere:

```bash
cd ~/my-project
ralph-init               # Initialize with PRD template
ralph-once               # Test with one iteration
ralph 20                 # Run 20 iterations
```

## Configuration

Edit `.ralphrc` in your project or in `/Users/francip/src/ralph-cli/.ralphrc` to set defaults:

```bash
# Ralph Configuration
AI_COMMAND=claude        # claude, codex, or gemini
PRD_FILE=PRD.md
PROGRESS_FILE=progress.txt
```

## Usage

### Initialize a Project

```bash
ralph-init
```

Creates:
- `PRD.md` - Template for your requirements
- `progress.txt` - Auto-updated progress log

### Human-in-the-Loop (ralph-once)

Run one iteration at a time to build intuition:

```bash
# Use default AI from .ralphrc
ralph-once

# Use specific AI
ralph-once claude
ralph-once codex
ralph-once gemini
```

### Multi-Iteration Mode (ralph)

Run multiple iterations automatically:

```bash
# Use default AI, run 20 iterations
ralph 20

# Use specific AI (cleaner syntax)
ralph claude 20
ralph codex 10
ralph gemini 15

# Or with --ai flag
ralph --ai codex 10

# Or via environment variable
RALPH_AI=codex ralph 10
```

The loop will:
1. Read PRD.md and progress.txt
2. Pick highest-priority incomplete task
3. Implement it
4. Run tests and type checks
5. Update PRD and progress.txt
6. Commit changes
7. Repeat until complete or max iterations reached

The AI outputs `<promise>COMPLETE</promise>` when the PRD is finished.

## Creating Your PRD

### Option 1: Use Claude's Plan Mode

```bash
claude
# Press Shift+Tab to enter plan mode
# Iterate on your plan
# Tell Claude: "Save this to PRD.md"
```

### Option 2: Use ralph-init Template

```bash
ralph-init
# Edit the generated PRD.md
```

### Option 3: Write Manually

Any format works - markdown checklist, JSON, prose. Example:

```markdown
# My Project PRD

## Goals
Build a REST API for managing todos

## Requirements
- [ ] Set up Express server
- [ ] Create Todo model
- [ ] Implement CRUD endpoints
- [ ] Add validation
- [ ] Write tests

## Technical Specs
- Node.js 18+
- Express 4.x
- Jest for testing

## Success Criteria
- All endpoints working
- Tests passing with >80% coverage
```

The AI will:
1. Read PRD.md and progress.txt
2. Pick the next unchecked task
3. Implement it
4. Commit changes
5. Update progress.txt

## Docker Sandbox (Recommended for Claude)

Run in an isolated environment:

```bash
# Install Docker Desktop 4.50+
docker sandbox run claude ./ralph.sh 20
```

Benefits:
- Isolated environment
- Persistent state per workspace
- Auto-injected git config
- Safe experimentation

## File Structure

```
ralph-cli/
├── .ralphrc              # Configuration
├── setup.sh              # Setup script (creates symlinks)
├── ralph-init.sh         # Project initializer
├── ralph-once.sh         # Single iteration script
├── ralph.sh              # Multi-iteration script
├── RALPH.md              # Original guide
├── README.md             # This file
├── PRD.example.md        # Example PRD
└── progress.example.txt  # Example progress file

Your project:
├── PRD.md                # Your requirements (created by ralph-init)
└── progress.txt          # Auto-updated log (created by ralph-init)
```

## How It Works

Ralph is a simple loop:

1. AI reads PRD and progress files
2. AI picks next incomplete task
3. AI implements the task
4. AI commits changes
5. AI updates progress.txt
6. Repeat until complete or max iterations

The AI decides what to work on - you just provide the PRD.

**Note**: The scripts use the AI CLIs directly with appropriate flags for auto-approval and non-interactive mode. No additional configuration needed.

## Customization

### Swap Task Source

Instead of local PRD, pull from:
- GitHub Issues
- Linear tickets
- Jira backlog
- Custom API

Edit `ralph-once.sh` or `ralph.sh` to change the prompt and file sources.

### Change Output

Instead of committing to main:
- Create branch + PR per task
- Update external tracker
- Generate reports

Edit the prompt to change the commit strategy.

### Different Loop Types

- **Test Coverage** - Write tests until coverage target hit
- **Linting** - Fix lint errors one by one
- **Refactoring** - Eliminate code duplication
- **Bug Triage** - Work through issue backlog

Edit the prompt in `ralph-once.sh` and `ralph.sh` to customize behavior.

Example for test coverage:

```bash
result=$($AI_COMMAND --permission-mode acceptEdits -p "\\
1. Run test coverage report. \\
2. Find the file with lowest coverage. \\
3. Write tests to improve its coverage. \\
4. Commit your changes. \\
If coverage is above 90%, output <promise>COMPLETE</promise>.")
```

## Tips

1. Start with `ralph-once` to build intuition
2. Keep tasks small and focused in your PRD
3. Review commits between iterations
4. Use Docker sandbox for safety
5. Cap iterations to prevent runaway costs
6. Be specific in your PRD about acceptance criteria
7. The AI works best with clear, testable requirements

## Troubleshooting

### "command not found: ralph"

Make sure you ran `./setup.sh` and that `~/bin` is in your PATH:

```bash
echo $PATH | grep "$HOME/bin"
```

If not, add it:

```bash
# For bash
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# For zsh
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### AI doesn't commit

Check that your git is configured:

```bash
git config user.name
git config user.email
```

Set them if missing:

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### "command not found" errors

Make sure you have the AI CLI tools installed:

```bash
# Check if installed
which claude
which codex
which gemini
```

If not found, install them:
- Claude: https://docs.anthropic.com/en/docs/claude-code
- Codex: Follow OpenAI Codex installation instructions
- Gemini: Follow Google Gemini CLI installation instructions

### AI doesn't execute properly

Test the commands manually:

```bash
# Test each AI
claude --help
codex --help
gemini --help
```

The scripts use these exact command names. Make sure they're in your PATH.

## Advanced: Custom AI CLI

To use a different AI CLI, you'll need to modify the scripts:

1. **Add your AI to the case statements** in `ralph-once.sh` and `ralph.sh`:

```bash
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
  myai)
    myai --auto-approve --non-interactive "$PROMPT"
    ;;
  *)
    echo "Unknown AI command: $AI_COMMAND"
    exit 1
    ;;
esac
```

2. **Update `.ralphrc`** with your AI command name:

```bash
# In .ralphrc
AI_COMMAND=myai
```

Your custom AI should:
- Auto-approve code edits and commands
- Run in non-interactive mode and output to stdout
- Support reading files with `@filename` syntax

## Credits

Ralph technique by [Geoffrey Huntley](https://ghuntley.com/ralph/)

implementation based on [Matt Pocock guide](https://x.com/mattpocockuk/status/2009276031622918474)

## License

MIT
