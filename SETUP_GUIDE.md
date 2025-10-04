# Claude Context System - Setup Guide

## Which Setup Command Do I Use?

### Use `/init-context` for:
- ✅ **New projects** with no documentation yet
- ✅ Fresh scaffolded projects (npx create-next-app, etc.)
- ✅ Projects where you want Claude to create docs from scratch

### Use `/migrate-context` for:
- ✅ **Existing projects** with documentation already
- ✅ Projects with CLAUDE.md, PRD.md, etc. in root directory
- ✅ Projects with scattered artifacts (lighthouse reports, code reviews)
- ✅ Want to preserve ALL existing content while adopting the system

---

## Quick Start (New Project)

### Step 1: Get the Toolkit
```bash
# Clone the repository
git clone https://github.com/rexkirshner/claude-context-system.git

# Or download just the .claude/commands folder from GitHub
```

### Step 2: Copy Files to Your Project
```bash
# From your new project root
mkdir -p .claude
cp -r claude-context-system/.claude/commands .claude/
cp claude-context-system/config/.context-config.template.json .context-config.json
```

### Step 3: Initialize Context
```
/init-context
```
This creates:
- `context/` folder with all meta-documentation
- `.context-config.json` with your preferences
- Initial project analysis and documentation

### Step 4: Clean Up
```bash
# After /init-context completes successfully, clean up the clone
rm -rf claude-context-system
```

The system is now installed and the clone is no longer needed. Future updates use `/update-context-system` which downloads fresh from GitHub.

### Step 5: Start Working
```
# At session start:
/review-context  # Verify context is loaded

# During work:
/quick-save-context  # Every 15-30 minutes during active coding
/save-context        # After completing major features

# At session end:
/save-context    # Capture final state
```

---

## Quick Start (Existing Project with Docs)

### Step 1: Get the Toolkit
```bash
# Clone the repository
git clone https://github.com/rexkirshner/claude-context-system.git

# Or download just the .claude/commands folder from GitHub
```

### Step 2: Copy Commands to Your Project
```bash
# From your existing project root
mkdir -p .claude
cp -r claude-context-system/.claude/commands .claude/
```

### Step 3: Migrate Existing Documentation
```
/migrate-context
```
This will:
- Scan existing docs (CLAUDE.md, PRD.md, etc.)
- Move them to `context/` folder
- Move artifacts (lighthouse reports, code reviews) to `artifacts/`
- Augment existing docs with new sections
- Create missing documentation
- Preserve ALL existing content

### Step 4: Clean Up
```bash
# After /migrate-context completes successfully, clean up the clone
rm -rf claude-context-system
```

The system is now installed and the clone is no longer needed. Future updates use `/update-context-system` which downloads fresh from GitHub.

### Step 5: Verify Migration
```
# Review the migration report
# Check context/ folder structure
# Run save-context to capture current state
/save-context
```

---

## Detailed Setup Instructions

### Prerequisites
1. Have your claude-admin folder accessible
2. Claude Code open in your project
3. Project initialized (package.json exists for JS projects)

### Installation Methods

#### Method 1: Clone and Copy (Recommended)
1. Clone the repository: `git clone https://github.com/rexkirshner/claude-context-system.git`
2. Copy the `.claude/commands/` folder to your project: `mkdir -p .claude && cp -r claude-context-system/.claude/commands .claude/`
3. Copy and rename config: `cp config/.context-config.template.json .context-config.json`
4. Run `/init-context` in Claude Code
5. Clean up: `rm -rf claude-context-system`
6. Review and customize `.context-config.json` if needed

#### Method 2: Download and Copy
1. Download the repository as ZIP from GitHub
2. Extract and copy `.claude/commands/` to your project
3. Copy and rename `.context-config.template.json`
4. Run `/init-context`
5. Clean up: Delete the extracted folder

#### Method 3: Direct Reference
If you have a local clone of the repo:
1. Tell Claude: "Load commands from /path/to/claude-context-system/"
2. Claude will read the command definitions
3. Run `/init-context`

---

## Command Reference

### `/init-context`
**When:** Once, for NEW projects with no documentation

**What it does:**
- Creates `context/` folder structure
- Generates all meta-documentation from scratch
- Analyzes project and fills in known information
- Creates `.context-config.json`

**Expected output:**
```
✅ Created context/ directory
✅ Generated 8 documentation files
✅ Analyzed project structure
✅ Created .context-config.json
```

### `/migrate-context`
**When:** Once, for EXISTING projects with documentation

**What it does:**
- Scans for existing docs and artifacts
- Moves docs to `context/` folder
- Moves artifacts to `artifacts/` folder
- Augments existing docs with new sections
- Creates missing documentation
- Preserves ALL existing content

**Expected output:**
```
✅ Migration Complete
📁 Moved 5 docs to context/
📁 Moved 4 lighthouse reports to artifacts/
📝 Augmented CLAUDE.md with Core Methodology
⭐ Created ARCHITECTURE.md, CODE_STYLE.md, SESSIONS.md
✅ All existing content preserved
```

### `/save-context`
**When:** Frequently - after major work, before breaks, at session end

**What it does:**
- Updates all existing documentation
- Captures current session state
- Records decisions made
- Updates task progress
- Creates session log entries

**Expected output:**
```
✅ Updated CLAUDE.md - Added critical path
✅ Updated SESSIONS.md - Session 12 logged
✅ Updated KNOWN_ISSUES.md - 2 issues resolved
✅ Updated next-steps.md - 3 tasks completed
```

### `/review-context`
**When:** At session start, before major decisions, when confused

**What it does:**
- Verifies documentation accuracy
- Checks for inconsistencies
- Confirms ability to resume work
- Reports any gaps

**Expected output:**
```
✅ All documentation current
✅ No inconsistencies found
✅ Ready to resume from: [specific task]
⚠️ Note: SESSIONS.md shows incomplete task X
```

### `/update-context-system`
**When:** Periodically to get latest improvements

**What it does:**
- Fetches latest version from GitHub
- Updates all slash commands automatically
- Detects context file template changes
- Optionally updates system sections in CLAUDE.md, CODE_STYLE.md
- Reports everything that changed

**Usage:**
```
# Interactive mode (shows diffs, asks for approval)
/update-context-system

# Auto-accept all updates
/update-context-system --accept-all
```

**Expected output:**
```
✅ Claude Context System Updated
📦 Version: 1.0.0 → 1.2.0
✅ Updated 5 commands
✅ Updated 2 context sections
```

### `/quick-save-context`
**When:** During active coding - every 15-30 minutes

**What it does:**
- Lightweight checkpoint (~5 seconds)
- Updates SESSIONS.md with brief entry
- Updates task files (next-steps.md, todo.md)
- Captures git state
- Skips full documentation regeneration

**Expected output:**
```
✅ Quick Save Complete - Session 23
📝 Session checkpoint in SESSIONS.md
✅ Task updates in next-steps.md
⏱️ Time since last save: 23 minutes
```

### `/code-review`
**When:** After feature completion, before deployment, when quality matters

**What it does:**
- Comprehensive code audit
- NO changes during review
- Generates findings report
- Suggests improvements

**Expected output:**
```
Code Review Report - Grade: B+
✅ No critical issues
⚠️ 3 minor improvements suggested
📋 See artifacts/code-reviews/session-12-review.md
```

### `/validate-context`
**When:** After setup, before export, periodically for health checks

**What it does:**
- Validates all required files exist
- Checks for required sections in each doc
- Flags unfilled placeholders
- Validates .context-config.json
- Calculates health score (0-100)
- Provides actionable recommendations

**Expected output:**
```
# Context Validation Report
Overall Health Score: 82/100 (Good)

⚠️ Found 5 unfilled placeholders
⚠️ ARCHITECTURE.md seems sparse (18 lines)
✅ All required sections present

Recommendations:
1. Fill in owner name in .context-config.json
2. Expand ARCHITECTURE.md with more detail
3. Address 5 TODO markers
```

### `/export-context`
**When:** Before sharing, for backups, for offline reference

**What it does:**
- Combines all context/*.md files into one document
- Generates table of contents
- Adds metadata (version, date, statistics)
- Outputs to `context-export-[DATE].md`

**Expected output:**
```
✅ Context Export Complete

Output File: context-export-20251004-143022.md
File size: 156 KB
Sections: 9 core + 2 additional
Session count: 23
```

---

## File Structure Created

```
your-project/
├── context/                      # All context docs
│   ├── .context-config.json     # Your preferences
│   ├── CLAUDE.md                # Dev guide + your rules
│   ├── PRD.md                   # Product requirements
│   ├── ARCHITECTURE.md          # Technical design
│   ├── DECISIONS.md             # Why we chose X over Y
│   ├── CODE_STYLE.md            # Your coding standards
│   ├── KNOWN_ISSUES.md          # Current problems
│   ├── SESSIONS.md              # Detailed work log
│   ├── tasks/
│   │   ├── next-steps.md        # What to do next
│   │   └── todo.md              # Current session tasks
│   └── reviews/
│       └── [session]-review.md  # Code review results
```

---

## Typical Workflow

### New Project Session
```
1. Create new project
2. Copy .claude/commands folder
3. Run: /init-context
4. Start coding
5. Run: /save-context (periodically)
6. End: /save-context
```

### Existing Project Migration
```
1. Open existing project with docs
2. Copy .claude/commands folder
3. Run: /migrate-context
4. Review migration report
5. Verify context/ and artifacts/ folders
6. Run: /save-context
7. Continue working
```

### Continuing Project Session
```
1. Open project
2. Run: /review-context
3. Read SESSIONS.md last entry
4. Continue from next-steps.md
5. Run: /quick-save-context (every 15-30 minutes)
6. Run: /save-context (after major features)
7. End: /save-context
```

### Pre-Deployment Session
```
1. Run: /save-context
2. Run: /validate-context (check docs health)
3. Run: /code-review (thorough audit)
4. Fix issues in separate session
5. Run: /save-context
6. Deploy
```

### Team Handoff Session
```
1. Run: /save-context
2. Run: /validate-context (ensure quality)
3. Run: /export-context (generate single file)
4. Share export file with team
```

---

## Troubleshooting

### "Unknown slash command: init-context" (or other commands)
**Cause:** Command files missing `name` field in frontmatter

**Fix:** Ensure each `.md` file in `.claude/commands/` has this format:
```yaml
---
name: command-name
description: Command description
---
```

**Example:**
```yaml
---
name: init-context
description: Initialize Claude Context System for this project
---
```

If you downloaded an older version, the files may only have `description`. Add the `name` field to fix.

### "Commands not recognized"
- Make sure to load commands at session start
- Check `.claude/commands/` folder exists with .md files
- Restart Claude Code conversation to reload commands

### "Context seems stale"
- Run `/save-context` immediately
- Check SESSIONS.md for last update
- Review git log for uncommitted changes

### "Can't resume work"
- Check context/SESSIONS.md for last state
- Review context/tasks/todo.md for WIP
- Look at git status for uncommitted work

### "Documentation drift"
- Run `/save-context` more frequently
- Set reminder to update every hour
- Check .context-config.json settings

---

## Best Practices

1. **Always init on new projects** - Don't skip initialization
2. **Save context before breaks** - Even 5-minute breaks
3. **Review at session start** - Ensure continuity
4. **Don't edit context manually** - Let commands handle it
5. **Include in .gitignore if needed** - `echo "context/" >> .gitignore`
6. **Update config per project** - Some projects need different settings

---

## Customization

### Per-Project Overrides
Edit `.context-config.json`:
- Change documentation location
- Adjust verbosity preferences
- Enable/disable specific docs
- Set custom templates path

### Global Preferences
Keep your master preferences in the cloned repo:
`claude-context-system/config/.context-config.template.json`

### Command Shortcuts
Add to `.context-config.json`:
```json
"aliases": {
  "/s": "/save-context",
  "/r": "/review-context"
}
```

---

## Questions?

If context seems lost or commands aren't working:
1. Verify `.context-config.json` exists
2. Check `context/` folder has all docs
3. Run `/review-context` for diagnostic
4. Manually tell Claude about your preferences if needed

Remember: The goal is perfect session continuity. When in doubt, `/save-context`!

---

## Advanced Usage

### Using with Git

**Option 1: Track Context (Recommended for solo projects)**
```bash
# Context helps you and future you
git add context/
git commit -m "Update context documentation"
```

**Option 2: Ignore Context (For team projects)**
```bash
# Add to .gitignore
echo "context/" >> .gitignore
echo ".context-config.json" >> .gitignore
```

### Multiple Projects

Keep a master command set:
```bash
# Clone once, then symlink to projects
git clone https://github.com/rexkirshner/claude-context-system.git ~/claude-context-system

# In each project, create symlink instead of copying
mkdir -p .claude
ln -s ~/claude-context-system/.claude/commands .claude/commands
```

### Backup Strategy

Important context should be backed up:
```bash
# Manual backup
cp -r context/ context.backup-$(date +%Y%m%d)/

# Or use git (if tracked)
git commit -m "Backup context before major changes"
```

---

## Success Checklist

After setup, verify:
- [ ] `.claude/commands/` folder exists with .md files in project
- [ ] `/init-context` or `/migrate-context` successfully created `context/` folder
- [ ] All 8 core documentation files present in `context/`
- [ ] `artifacts/` subdirectories created (if using /migrate-context)
- [ ] `context/.context-config.json` configured correctly
- [ ] `/review-context` reports "ready to work"
- [ ] Can run `/save-context` without errors

When all checked, you're ready to work with perfect context preservation!
