# Claude Context System

> Perfect session continuity for Claude Code projects

## What is This?

The Claude Context System is a complete toolkit for maintaining perfect context across Claude Code sessions. Never lose your place, never repeat explanations, never lose work again.

## The Problem

When working with Claude Code:
- Context is lost between sessions
- You repeat the same explanations every time
- Work in progress disappears when sessions end
- Technical decisions get forgotten or contradicted
- Session handoffs feel like starting over

## The Solution

Four simple commands that preserve everything:
- **`/init-context`** - Set up context system in new project (once)
- **`/save-context`** - Capture current state (frequently)
- **`/review-context`** - Verify continuity (at session start)
- **`/code-review`** - Quality audit without breaking things (when needed)

## Quick Start

```bash
# 1. Clone the repo (or download .claude-commands folder)
git clone https://github.com/rexkirshner/claude-context-system.git

# 2. Copy commands to your project
cp -r claude-context-system/.claude-commands /path/to/your/project/

# 3. In Claude Code, initialize
/init-context

# 4. Start working
/save-context  # Run this often!
```

See [SETUP_GUIDE.md](./SETUP_GUIDE.md) for complete instructions.

## What Gets Created

```
your-project/
└── context/
    ├── CLAUDE.md           # How to work with this project
    ├── PRD.md              # What we're building and why
    ├── ARCHITECTURE.md     # How it's designed
    ├── DECISIONS.md        # Why we chose X over Y
    ├── CODE_STYLE.md       # How we write code
    ├── KNOWN_ISSUES.md     # What's broken or limited
    ├── SESSIONS.md         # Detailed work history
    └── tasks/
        ├── next-steps.md   # What to do next
        └── todo.md         # Current session tasks
```

## Key Features

### Automatic Context Preservation
- Captures everything: code changes, decisions, progress
- Works across session boundaries
- Handles interrupted sessions gracefully

### User Preference Enforcement
- Your workflow rules built in
- Consistent behavior every session
- No more reminding Claude of your preferences

### Zero Context Loss
- Session logs preserve exact state
- Work-in-progress is saved
- Can resume from anywhere

### Quality Without Risk
- Code reviews don't break things
- Identifies issues separately from fixes
- Thorough analysis without time pressure

## Core Commands

### `/init-context`
**Run once per project**

Creates complete documentation structure and configuration. Analyzes your project and fills in what it can.

### `/save-context`
**Run frequently**

Updates all documentation to match current state. Captures session activity, decisions, and progress. This is your safety net.

### `/review-context`
**Run at session start**

Verifies documentation is current and accurate. Reports any gaps or issues. Confirms you can resume exactly where you left off.

### `/code-review`
**Run when quality matters**

Comprehensive code audit with NO changes during review. Identifies issues and suggests improvements in a separate session. Takes its time to be thorough.

## Documentation Files

### CLAUDE.md - Developer Guide
How to work with this project. Includes:
- Commands and architecture
- Your specific preferences
- Current status and critical path

### PRD.md - Product Requirements
What and why. Includes:
- Vision and goals
- Tech stack and implementation plan
- Progress log and roadmap

### ARCHITECTURE.md - Technical Design
How it's built. Includes:
- System design and structure
- Data flow and dependencies
- Integration points

### DECISIONS.md - Decision Log
Why we chose this. Includes:
- Technical decisions and rationale
- Alternatives considered
- When to reconsider

### CODE_STYLE.md - Coding Standards
How we write code. Includes:
- Simplicity principles
- No lazy coding rule
- Testing requirements

### KNOWN_ISSUES.md - Issue Tracking
What's broken. Includes:
- Current bugs and limitations
- Technical debt
- Future improvements

### SESSIONS.md - Work History
What happened when. Includes:
- Detailed session logs
- Files modified
- Decisions made

## Rex's Workflow Integration

This system is built around specific workflow principles:

### Core Methodology
1. Plan first, execute second
2. Track all progress
3. Make simplest possible changes
4. Never use temporary fixes
5. Find and fix root causes
6. Trace entire code flows
7. Test before committing
8. Never push without approval

### Communication Style
- High-level summaries only
- Direct, concise responses
- Clear approval checkpoints
- No verbose explanations

These are embedded in CODE_STYLE.md and enforced automatically.

## File Organization

```
claude-context-system/
├── README.md                   # This file
├── PRD.md                      # System requirements
├── SETUP_GUIDE.md              # How to install and use
├── STRUCTURE.md                # Complete file organization guide
├── .claude-commands/           # Command definitions
│   ├── init-context.md
│   ├── save-context.md
│   ├── review-context.md
│   └── code-review.md
├── templates/                  # Doc templates
│   ├── CLAUDE.template.md
│   ├── PRD.template.md
│   ├── ARCHITECTURE.template.md
│   ├── DECISIONS.template.md
│   ├── CODE_STYLE.template.md
│   ├── KNOWN_ISSUES.template.md
│   ├── SESSIONS.template.md
│   ├── next-steps.template.md
│   └── todo.template.md
└── config/
    ├── .context-config.template.json
    └── context-config-schema.json
```

## Typical Workflows

### New Project
```
1. Init project
2. /init-context
3. Start coding
4. /save-context (often)
```

### Daily Work
```
1. Open project
2. /review-context
3. Continue working
4. /save-context (often)
5. /save-context (at end)
```

### Quality Check
```
1. /save-context
2. /code-review
3. Review report
4. Fix in new session
```

## Success Metrics

This system is successful when:
> "I can end any session abruptly, start a new session days later, run /review-context, and continue exactly where I left off without any re-explanation or context loss."

## Configuration

Each project gets a `.context-config.json` with:
- Workflow preferences
- Documentation settings
- Command configuration
- Communication style

Customize per project or use global defaults.

## Requirements

- Claude Code
- Any project (language/framework agnostic)
- File system access for context/ folder

## Best Practices

1. **Save often** - Run `/save-context` frequently
2. **Review at start** - Always `/review-context` when opening project
3. **Init immediately** - Run `/init-context` on all new projects
4. **Don't edit manually** - Let commands manage documentation
5. **Trust the system** - It captures more than you think

## Troubleshooting

**Context feels stale?**
- Run `/save-context` immediately
- Check SESSIONS.md for last update

**Can't resume work?**
- Check context/tasks/todo.md
- Review SESSIONS.md last entry
- Check git status

**Commands not working?**
- Verify `.claude-commands/` folder exists
- Check command files have `.md` extension
- Try loading commands manually

See [SETUP_GUIDE.md](./SETUP_GUIDE.md) for detailed troubleshooting.

## Version

**Current Version:** 1.0.0
**Status:** Implementation Phase
**Last Updated:** 2025-10-03

## Contributing

This is a personal workflow system built for Rex's specific needs. You're welcome to:
- Fork and adapt for your preferences
- Suggest improvements
- Share your adaptations

## License

Use freely for personal or commercial projects.

## Questions?

See:
- [SETUP_GUIDE.md](./SETUP_GUIDE.md) - Complete setup and usage
- [PRD.md](./PRD.md) - Full product requirements
- context/CLAUDE.md in any project - Project-specific guide

---

**Remember:** When in doubt, `/save-context`!
