# Claude Context System

**Version 2.0.0**

> Perfect session continuity for Claude Code projects
>
> **Two-tier workflow: 2-3 minutes daily, comprehensive when needed.**

## What is This?

The Claude Context System is a complete toolkit for maintaining perfect context across Claude Code sessions AND enabling AI agents to review, improve, and take over your work.

**Dual Purpose:**
1. **Session Continuity** - Never lose your place, never repeat explanations, never lose work again
2. **AI Agent Review & Takeover** - Rich documentation that enables AI agents to understand your thinking, review your work, and seamlessly take over development

## The Problem

**For Session Continuity:**
- Context is lost between sessions
- You repeat the same explanations every time
- Work in progress disappears when sessions end
- Technical decisions get forgotten or contradicted
- Session handoffs feel like starting over

**For AI Agent Review & Takeover:**
- AI agents can't understand WHY you made certain decisions
- Code reviews lack context about constraints and tradeoffs
- New AI agents starting on your project have to reverse-engineer your thinking
- Architecture reviews miss the rationale behind design choices
- Handoffs to other developers/AIs lose critical mental models

## The Solution

**Two-tier workflow** - Minimal overhead for continuous work, comprehensive documentation when needed:

**Philosophy:**
- **Within sessions:** TodoWrite for active productivity (zero overhead)
- **Quick saves (daily):** `/save` updates current state (2-3 minutes)
- **Comprehensive saves (occasional):** `/save-full` before breaks/handoffs (10-15 minutes)
- **Single source of truth:** No duplication, but comprehensive depth

**Setup (run once):**
- **`/init-context`** - Create core files (CONTEXT.md, STATUS.md, DECISIONS.md)
- **`/migrate-context`** - Migrate existing project with documentation

**Daily Workflow:**
- **`/save`** - Quick save (2-3 min): Updates STATUS.md, auto-generates QUICK_REF.md
- **`/save-full`** - Comprehensive (10-15 min): Everything /save does + SESSIONS.md entry + mental models
- **Frequency:** Use `/save` most sessions, `/save-full` 3-5× per 20 sessions
- **`/review-context`** - Verify continuity and completeness

**Quality & Sharing:**
- **`/code-review`** - AI agent conducts quality audit
- **`/validate-context`** - Check documentation completeness
- **`/export-context`** - Generate AI-optimized export for review/takeover

**Updates:**
- **`/update-context-system`** - Update to latest version from GitHub

## Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/rexkirshner/claude-context-system.git

# 2. Copy toolkit to your project
cp -r claude-context-system/.claude /path/to/your/project/
cp -r claude-context-system/scripts /path/to/your/project/

# 3. In Claude Code, initialize
/init-context

# 4. Clean up (after init completes)
rm -rf claude-context-system

# 5. Daily workflow
/save          # Quick update (2-3 min) - most sessions
/save-full     # Comprehensive (10-15 min) - before breaks/handoffs
```

See [SETUP_GUIDE.md](./SETUP_GUIDE.md) for complete instructions.

## What Gets Created

**Core documentation** (`/init-context`):
```
your-project/
├── .claude/                        # Toolkit (you copy this)
│   ├── commands/                   # Slash commands
│   ├── docs/                       # Comprehensive guides
│   └── checklists/                 # Review criteria
├── scripts/
│   └── validate-context.sh         # Validation script
├── context/                        # Core documentation files
│   ├── .context-config.json        # Project configuration
│   ├── CONTEXT.md                  # Orientation (who/what/how/why)
│   ├── STATUS.md                   # Current state (tasks/blockers/next)
│   ├── DECISIONS.md                # Decision log (WHY choices were made)
│   ├── SESSIONS.md                 # History (structured, comprehensive)
│   └── QUICK_REF.md                # Auto-generated dashboard
└── artifacts/                      # Generated outputs
    ├── code-reviews/               # AI agent code reviews
    ├── lighthouse/                 # Performance reports
    ├── performance/                # Perf analysis
    ├── security/                   # Security audits
    ├── bundle-analysis/            # Bundle reports
    └── coverage/                   # Test coverage
```

**Additional files created on-demand**:
- `PRD.md` → Product vision gets complex
- `ARCHITECTURE.md` → System design needs comprehensive documentation

**Key Principle:** Structured but comprehensive. AI agents need depth to understand your thinking, constraints, and rationale - not just what you did, but WHY.

## Key Features

### Dual Purpose: Developer Productivity + AI Agent Review (New in v1.8.0!)
- **Within sessions** - TodoWrite for active productivity (minimal overhead)
- **At save points** - Rich documentation for AI review and takeover
- **Mental models captured** - AI agents understand your thinking, not just code
- **Decision rationale preserved** - DECISIONS.md explains WHY, not just WHAT
- **Comprehensive but structured** - Depth without verbosity

### AI Agent Review & Takeover
- **`/code-review`** - AI agent reviews your code with full context
- **`/export-context`** - Generates AI-optimized export for agent takeover
- **DECISIONS.md** - AI understands constraints and tradeoffs
- **SESSIONS.md** - AI learns from your problem-solving approach
- **Mental model capture** - AI knows your current thinking and next steps

### Single Source of Truth
- **Each piece of information lives in ONE place**
- No duplication between CONTEXT.md, STATUS.md, SESSIONS.md
- STATUS.md is canonical for current state
- DECISIONS.md is canonical for WHY
- CONTEXT.md references other files instead of duplicating

### Structured, Comprehensive Documentation
- **SESSIONS.md is structured AND comprehensive**
- Easy to scan: What changed, decisions, files, mental models, next steps
- Enough depth for AI agents to understand context and thinking
- Auto-generated QUICK_REF.md dashboard

### Smart Save Command
- **Captures TodoWrite state automatically**
- **Extracts mental models and decision rationale**
- Updates only what changed
- Suggests optional files when complexity demands
- `/save-context --full` for comprehensive AI review preparation

### Zero Context Loss
- Session logs preserve exact state + thinking
- Work-in-progress with mental models
- Can resume from anywhere
- AI agents can take over seamlessly

## Core Commands

### Setup Commands (Run Once)

#### `/init-context`
**For ALL projects**

Creates 2 core files: CONTEXT.md (orientation), STATUS.md (current state). Auto-generates QUICK_REF.md dashboard. Optional files (PRD, ARCHITECTURE) suggested when complexity demands. **Minimal overhead. Maximum value.**

#### `/migrate-context`
**For EXISTING projects with docs**

Migrates existing documentation to Claude Context System structure. Preserves ALL existing content while organizing into context/ and artifacts/ folders. Consolidates to single source of truth.

### Maintenance Commands (Run Frequently)

#### `/save-context`
**Smart update - run often**

**Captures TodoWrite state. Updates what changed. Suggests growth when needed.**

- Default mode: Updates STATUS.md, appends to SESSIONS.md, captures WIP
- Auto-generates QUICK_REF.md dashboard
- Suggests optional files (PRD, ARCHITECTURE) when complexity demands
- Use `--full` flag for comprehensive update (rare)

**Fast and lightweight.** Your safety net.

#### `/review-context`
**Run at session start**

Verifies documentation is current and accurate. Shows QUICK_REF.md dashboard. Reports any gaps or issues. Confirms you can resume exactly where you left off.

### Quality & Sharing Commands

#### `/code-review`
**Run when quality matters**

Comprehensive code audit with NO changes during review. Identifies issues and suggests improvements in a separate session. Takes its time to be thorough.

#### `/validate-context`
**Run to check documentation health**

Validates all context files follow expected structure. Flags missing sections, unfilled placeholders, and configuration issues. Reports health score and actionable recommendations.

#### `/export-context`
**Run to share or backup**

Combines all context documentation into single markdown file with table of contents. Perfect for team handoffs, backups, or offline reference.

### Update Commands

#### `/update-context-system`
**Run periodically to get latest improvements**

Updates slash commands and optionally updates context file templates from GitHub. Interactive mode shows diffs, or use `--accept-all` for automatic updates.

## Choosing Your Setup Command

### Use `/init-context` when:
- ✅ Starting a brand new project
- ✅ Project has basic setup (package.json) but no docs yet
- ✅ No existing CLAUDE.md or context documentation
- ✅ You want Claude to create everything from scratch

### Use `/migrate-context` when:
- ✅ Project already has documentation (CLAUDE.md, PRD.md, etc.)
- ✅ Docs are scattered in root directory or old structure
- ✅ You have artifacts (lighthouse reports, code reviews) to organize
- ✅ Want to preserve ALL existing content while adopting the system

**Examples:**
- `npx create-next-app` → Use `/init-context`
- Mature project with CLAUDE.md in root → Use `/migrate-context`
- Fresh clone with no docs → Use `/init-context`
- Project with tasks/ folder and multiple docs → Use `/migrate-context`

## Documentation Files

### CONTEXT.md - Orientation (Rarely Changes)
**Who, what, how, why.** Includes:
- Tech stack and architecture
- Communication preferences
- Anti-patterns to avoid
- Commands and setup
- References other files (no duplication)

**For AI agents:** Project overview, constraints, preferences

### STATUS.md - Current State (Frequently Updated)
**Single source of truth for "what's happening now."** Includes:
- Current phase/focus
- Active tasks (checkboxes)
- Blockers and recent decisions
- Next session start point
- Updated by every `/save-context`

**For AI agents:** Current work state, immediate priorities, blockers

### DECISIONS.md - Decision Log (Critical for AI Review)
**WHY choices were made.** Includes:
- Technical decisions and rationale
- Alternatives considered
- Constraints and tradeoffs
- When to reconsider
- Append-only decision history

**For AI agents:** Understand WHY, not just WHAT. Critical for reviews and takeover.

### SESSIONS.md - History (Structured, Comprehensive)
**What happened when.** Includes:
- Structured entries (scannable but comprehensive)
- What changed, decisions, files, mental models
- Problem-solving approaches
- Enough depth for AI understanding
- Append-only

**For AI agents:** Learn from problem-solving patterns, understand evolution, see thinking process

### QUICK_REF.md - Dashboard (Auto-Generated)
**At-a-glance project status.** Includes:
- Current phase and progress
- Tech stack and URLs
- Quick navigation links
- Generated automatically by `/save-context`

**For AI agents:** Fast orientation and entry point

### Optional Files (Created On-Demand)

**PRD.md** - Product vision and roadmap (when scope is complex)

**ARCHITECTURE.md** - System design details (when architecture is complex)

## Workflow Integration

This system is built around solid workflow principles:

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
├── .claude/
│   ├── commands/               # Custom slash commands (9 total)
│   │   ├── init-context.md
│   │   ├── migrate-context.md
│   │   ├── save-context.md
│   │   ├── quick-save-context.md
│   │   ├── review-context.md
│   │   ├── code-review.md
│   │   ├── validate-context.md
│   │   ├── export-context.md
│   │   └── update-context-system.md
│   ├── docs/                   # Comprehensive command guides
│   │   ├── README.md
│   │   ├── command-philosophy.md
│   │   ├── code-review-guide.md
│   │   ├── save-context-guide.md
│   │   ├── review-context-guide.md
│   │   ├── update-guide.md
│   │   └── usage-examples.md
│   └── checklists/             # Specialized review criteria
│       ├── accessibility.md
│       ├── security.md
│       ├── seo-review.md
│       └── performance.md
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

### Existing Project Migration
```
1. Copy .claude/commands to project
2. /migrate-context
3. Review migration report
4. /save-context
5. Continue working
```

### Daily Work
```
1. Open project
2. /review-context
3. Start coding
4. /quick-save-context (every 15-30 minutes)
5. /save-context (after major features)
6. /save-context (at end of session)
```

### Quality Check
```
1. /save-context
2. /validate-context (check docs health)
3. /code-review (thorough audit)
4. Review reports
5. Fix in new session
```

### Team Handoff
```
1. /save-context
2. /validate-context
3. /export-context
4. Share export file with team
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

**Commands not working or loading wrong versions?**
- ⚠️ **CRITICAL:** Check for multiple `.claude` directories
- Claude Code may be loading commands from a parent folder
- Run: `find .. -maxdepth 2 -name ".claude"`
- **Solution:** Only keep `.claude` in the actual project root
- Remove `.claude` from parent folders that aren't projects

**Context feels stale?**
- Run `/save-context` immediately
- Check SESSIONS.md for last update

**Can't resume work?**
- Check context/tasks/todo.md
- Review SESSIONS.md last entry
- Check git status

**Commands missing after update?**
- Check if there's a parent `.claude` directory
- The update may have updated the wrong folder
- Verify: `ls .claude/commands` shows all 9 commands

See [SETUP_GUIDE.md](./SETUP_GUIDE.md) for detailed troubleshooting.

## Version

**Current Version:** 2.0.0
**Status:** Active Development
**Last Updated:** 2025-10-06

### What's New in v2.0.0

**Core Improvements: Promise → Delivery** - Real-world feedback from v1.9.0 revealed critical gaps between what we promised and what we delivered.

**The Issues Fixed:**
- **Promised files now created**: STATUS.md, QUICK_REF.md, CONTEXT.md, DECISIONS.md, SESSIONS.md all generated by `/init-context`
- **Status duplication eliminated**: STATUS.md is now the single source of truth - other files reference it instead of duplicating
- **SESSIONS.md made scannable**: Structured format (Changed/Decisions/Files/Next) instead of prose - find info in seconds instead of scrolling 800 lines
- **Decision log added**: DECISIONS.md captures WHY with proper structure - critical for AI agent review
- **Commands handle missing files**: Graceful degradation instead of failures when optional docs don't exist
- **Migration safety**: Dry-run mode, content preservation, rollback mechanism protect custom content

**Key Changes:**
- **v2.0 file structure**: CONTEXT.md (orientation), STATUS.md (current), DECISIONS.md (why), SESSIONS.md (history), QUICK_REF.md (auto-gen)
- **Auto-calculation in QUICK_REF**: Progress % computed from STATUS.md checkboxes - never manual
- **Decision ID auto-increment**: Stored in .context-config.json, auto-assigned during `/save-full`
- **Migration safeguards**: Preserve custom sections in "Legacy Notes", optional todo.md handling, automatic backups
- **Metrics tracking**: `/save` duration logged for continuous improvement
- **Acceptance tests**: Each command has defined criteria to prevent regressions

**Philosophy:**
```
v1.9.0: Minimal overhead daily, rich docs occasionally
v2.0.0: Same philosophy, but actually DELIVERS on it
```

**Bottom line:** Same great two-tier workflow, but now the files we promise actually get created, status stays consistent, and nothing gets lost in migration.

### What's New in v1.8.0 (Previously)

**Dual Purpose: Developer Productivity + AI Agent Review** - Real-world feedback revealed a critical insight: this system isn't just for session continuity, it's for AI agents to review, improve, and take over your work.

**The Realization:**
- **During work:** TodoWrite >> Context docs for productivity
- **At save points:** Rich documentation for AI review and takeover
- **The value:** AI agents can understand WHY, review with full context, take over seamlessly

**Key Changes:**
- **Restored DECISIONS.md** - Critical for AI agents to understand rationale
- **Enhanced SESSIONS.md** - Structured BUT comprehensive (mental models + thinking)
- **3 core files** - CONTEXT.md (orientation), STATUS.md (current), DECISIONS.md (why)
- **Single source of truth** - No duplication, but comprehensive depth
- **Auto-generated dashboard** - QUICK_REF.md for fast orientation
- **Smart `/save-context`** - Captures TodoWrite + mental models for AI review
- **AI-optimized exports** - `/export-context` generates takeover-ready documentation

**Philosophy:**
```
v1.7.0: Start minimal → Grow naturally
v1.8.0: Minimal overhead during work → Rich documentation for AI review/takeover
```

**The sweet spot:** Low friction for you, rich context for AI agents.

## Contributing

This is a workflow system you can adapt to your needs. You're welcome to:
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
