# Claude Context System - File Structure

**Version 2.0.0** - Complete file organization

## Root Files

### Core Documentation
- **README.md** - Overview of the Claude Context System
- **PRD.md** - Product requirements document
- **SETUP_GUIDE.md** - Installation and usage guide
- **MIGRATION_GUIDE.md** - v1.x → v2.0 migration steps
- **CHANGELOG.md** - Version history and changes

## .claude/commands/

Slash command definitions for project workflows.

**Setup Commands (run once):**
- **init-context.md** - Initialize v2.0 structure for new projects (creates 5 core files)
- **migrate-context.md** - Migrate existing v1.x projects to v2.0

**Maintenance Commands (run frequently):**
- **save.md** - Quick save (2-3 min): Updates STATUS.md, QUICK_REF.md
- **save-full.md** - Comprehensive save (10-15 min): Everything save does + detailed SESSIONS.md
- **review-context.md** - Verify documentation accuracy and load context at session start

**Quality & Sharing Commands:**
- **code-review.md** - Comprehensive code quality audit (no changes made)
- **validate-context.md** - Validate documentation structure and health
- **export-context.md** - Export all context docs to single file

**Update Commands:**
- **update-context-system.md** - Update commands and templates from GitHub

**Legacy Commands (v1.x):**
- **save-context.md** - Legacy (replaced by save.md + save-full.md in v2.0)

## .claude/docs/

Comprehensive guides explaining command philosophy and methodology.

**Core Guides:**
- **README.md** - Documentation folder structure and reading order
- **command-philosophy.md** - Core principles (Prime Directive, anti-patterns)
- **code-review-guide.md** - Review methodology, grading rubric, examples
- **save-context-guide.md** - WIP preservation, file-by-file update strategies
- **review-context-guide.md** - Trust but verify, confidence scoring, verification
- **update-guide.md** - System updates, version management, troubleshooting
- **usage-examples.md** - Real-world workflows and scenarios

## .claude/checklists/

Domain-specific review criteria for `/code-review`.

- **accessibility.md** - WCAG compliance, keyboard nav, screen readers
- **security.md** - OWASP Top 10, SQL injection, XSS protection
- **seo-review.md** - Meta tags, Core Web Vitals, structured data
- **performance.md** - Bundle optimization, caching strategies

## templates/

Documentation templates used by `/init-context`.

**v2.0 Templates (Active):**
- **CONTEXT.template.md** - Project orientation (replaces CLAUDE.template.md)
- **STATUS.template.md** - Current state (single source of truth)
- **DECISIONS.template.md** - Decision log with guidelines for AI agents
- **SESSIONS.template.md** - Structured session history format
- **QUICK_REF.template.md** - Auto-generated dashboard

**Optional Templates:**
- **PRD.template.md** - Product requirements document
- **ARCHITECTURE.template.md** - Technical architecture documentation
- **CODE_STYLE.template.md** - Coding standards and principles
- **KNOWN_ISSUES.template.md** - Issue tracking template

**Legacy Templates (v1.x - for migration reference):**
- **CLAUDE.template.md** - Replaced by CONTEXT.template.md
- **next-steps.template.md** - Replaced by STATUS.md
- **todo.template.md** - Merged into STATUS.md

## config/

Configuration files for the context system.

- **.context-config.template.json** - v2.0 configuration template
  - Includes: version, counters (nextDecisionId, sessionCount), metrics tracking
- **context-config-schema.json** - JSON Schema for validation

## scripts/

Automation scripts used by commands.

- **validate-context.sh** - Used by `/validate-context`
- **export-sessions-json.sh** - Used by `/export-context`
- **save-context-helper.sh** - Used by `/save` and `/save-full`
- **migrate-to-1-9-0.sh** - Legacy migration (v1.7/v1.8 → v1.9)

## reference/

Reference materials (not enforced by commands).

- **preference-catalog.yaml** - Catalog of workflow preferences

## Typical Project Structure (After /init-context)

```
your-project/
├── .claude/
│   ├── commands/           # Slash commands
│   ├── docs/               # Comprehensive guides
│   └── checklists/         # Review criteria
├── context/
│   ├── CONTEXT.md          # Project orientation ✨ v2.0
│   ├── STATUS.md           # Current state (single source of truth) ✨ v2.0
│   ├── DECISIONS.md        # Decision log ✨ v2.0
│   ├── SESSIONS.md         # Structured history ✨ v2.0
│   ├── QUICK_REF.md        # Auto-generated dashboard ✨ v2.0
│   ├── PRD.md              # (optional - suggested when needed)
│   ├── ARCHITECTURE.md     # (optional - suggested when needed)
│   └── .context-config.json
├── artifacts/
│   ├── code-reviews/
│   ├── lighthouse/
│   ├── performance/
│   └── security/
└── [your project files]
```

## v2.0 File Purpose Summary

| File | Purpose | Update Frequency |
|------|---------|------------------|
| **CONTEXT.md** | Project orientation (who/what/how/why) | Rarely (architecture changes) |
| **STATUS.md** | Current state - **single source of truth** | Every `/save` |
| **DECISIONS.md** | WHY choices were made | When decisions made |
| **SESSIONS.md** | Structured history (Changed/Decisions/Files) | Every `/save` (brief), `/save-full` (detailed) |
| **QUICK_REF.md** | Auto-generated dashboard | Auto (every `/save`) |
| PRD.md | Product vision | As needed (optional) |
| ARCHITECTURE.md | System design | As needed (optional) |

## Key Differences from v1.x

**Eliminated:**
- `tasks/next-steps.md` → Merged into STATUS.md
- `tasks/todo.md` → Merged into STATUS.md
- `CLAUDE.md` → Renamed to CONTEXT.md

**Added:**
- STATUS.md - Single source of truth for current state
- QUICK_REF.md - Auto-generated dashboard
- DECISIONS.md - Always created (was optional before)

**Improved:**
- SESSIONS.md - Structured format instead of prose

**Philosophy:**
- No status duplication - update once in STATUS.md
- Single file per purpose
- Auto-generation where possible (QUICK_REF.md)
