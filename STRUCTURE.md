# Claude Admin - File Structure

Complete file organization for the Claude Context System.

## Root Files

### Core Documentation
- **README.md** - Overview of the Claude Context System
- **PRD.md** - Complete product requirements document
- **SETUP_GUIDE.md** - How to install and use the system

## .claude/commands/

Slash command definitions that can be loaded into any project.

**Setup Commands (run once):**
- **init-context.md** - Initialize context system for new projects
- **migrate-context.md** - Migrate existing projects with documentation

**Maintenance Commands (run frequently):**
- **save-context.md** - Save current state and update all documentation
- **quick-save-context.md** - Lightweight checkpoint for active work
- **review-context.md** - Verify documentation accuracy and continuity

**Quality & Sharing Commands:**
- **code-review.md** - Comprehensive code quality audit (no changes)
- **validate-context.md** - Validate documentation structure and health
- **export-context.md** - Export all context docs to single file

**Update Commands:**
- **update-context-system.md** - Update commands and templates from GitHub

## templates/

Documentation templates used by /init-context command.

- **CLAUDE.template.md** - Developer guide with Rex's preferences
- **PRD.template.md** - Product requirements document template
- **ARCHITECTURE.template.md** - Technical architecture documentation
- **DECISIONS.template.md** - Technical decision log format
- **CODE_STYLE.template.md** - Coding standards (includes Rex's principles)
- **KNOWN_ISSUES.template.md** - Issue tracking template
- **SESSIONS.template.md** - Session history log format
- **next-steps.template.md** - Action items template
- **todo.template.md** - Current session tasks template

## config/

Configuration files for the context system.

- **.context-config.template.json** - Master configuration template with workflow preferences
- **context-config-schema.json** - JSON Schema for configuration validation

## reference/

Reference materials and catalogs (not enforced by commands):

- **preference-catalog.yaml** - Comprehensive catalog of available workflow preferences (reference only)

## Usage

### New Project Setup

1. **Get the toolkit:**
   ```bash
   # Clone the repo
   git clone https://github.com/rexkirshner/claude-context-system.git

   # Or download just the .claude/commands folder
   ```

2. **Copy commands to your project:**
   ```bash
   mkdir -p .claude && cp -r claude-context-system/.claude/commands .claude/
   ```

3. **Initialize context:**
   ```
   /init-context
   ```

4. **Start working:**
   ```
   /save-context  # Run frequently
   /review-context  # Run at session start
   /code-review  # Run when quality matters
   ```

### What Gets Created in Projects

When you run `/init-context` in a project, it creates:

```
project-root/
└── context/
    ├── .context-config.json     # From config/ template
    ├── CLAUDE.md                # From templates/
    ├── PRD.md                   # From templates/
    ├── ARCHITECTURE.md          # From templates/
    ├── DECISIONS.md             # From templates/
    ├── CODE_STYLE.md            # From templates/
    ├── KNOWN_ISSUES.md          # From templates/
    ├── SESSIONS.md              # From templates/
    ├── tasks/
    │   ├── next-steps.md        # From templates/
    │   └── todo.md              # From templates/
    └── reviews/
        └── [generated during /code-review]
```

## File Relationships

### Command → Template Relationships

**`/init-context`** uses:
- All 9 templates from `templates/`
- Config template from `config/.context-config.template.json`

**`/save-context`** updates:
- All context/ docs in the project
- Adds to SESSIONS.md
- Updates next-steps.md and todo.md

**`/review-context`** reads:
- All context/ docs
- Validates against schema

**`/code-review`** creates:
- New review file in artifacts/code-reviews/
- Based on CODE_STYLE.md standards

### How Templates Work

**CLAUDE.template.md** includes:
- Core Development Methodology (workflow rules)
- Communication Style preferences
- Project-specific patterns

**CODE_STYLE.template.md** includes:
- Core coding principles (simplicity, root causes)
- Testing requirements
- Git workflow rules

**.context-config.template.json** enforces:
- All workflow preferences
- Communication style
- Code review behavior
- Session management

## Version Control

### What to Track in Git (Recommended)

**This toolkit folder:**
- All files (this is your master toolkit)

**In projects:**
- Option 1: Track `context/` (recommended for solo projects)
- Option 2: Add to `.gitignore` (for team projects with different workflows)

### .gitignore Example

If you don't want to track context in a project:
```
context/
.context-config.json
```

## Maintenance

### Regular Updates
- Review and update templates as patterns evolve
- Update config template when preferences change
- Keep documentation current

### Extending the System
- Add new command .md files to `.claude/commands/`
- Add new templates to `templates/`
- Update schema when adding config options
- Document new patterns directly in templates

## Verification Checklist

✅ All 4 commands created
✅ All 9 templates created
✅ Config and schema created
✅ Templates contain all workflow rules and preferences
✅ Root documentation complete
✅ Structure is clean and logical
✅ Ready for use in projects

## Quick Reference

**Most Important Files:**
1. `README.md` - Start here
2. `SETUP_GUIDE.md` - How to use
3. `.claude/commands/` - The actual commands
4. `templates/CLAUDE.template.md` - Core workflow and communication
5. `templates/CODE_STYLE.template.md` - Coding principles

**For New Users:**
1. Read README.md
2. Clone from GitHub or download .claude/commands/
3. Copy .claude/commands/ to your project (.claude/ directory)
4. Run /init-context
5. Read SETUP_GUIDE.md for details

**For Maintenance:**
1. Update templates/ as needs evolve
2. Version config template when changing preferences
3. Document new patterns directly in templates
4. Keep all preferences embedded in templates and config
