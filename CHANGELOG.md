# Changelog

All notable changes to the Claude Context System will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.4] - 2025-10-04

### Added
- Step 4 in /update-context-system to detect and update personal references
- Checks for "Rex" references in CLAUDE.md and CODE_STYLE.md
- Offers to update "Working with Rex" → "Working with You"
- Offers to update "What Rex Prefers" → "What You Prefer"
- Interactive confirmation before applying changes

### Fixed
- Personal references not being updated when system was made universal
- Migrated projects keeping old "Rex" references after update
- Gap where /migrate-context preserves content but /update-context-system doesn't modernize it

## [1.1.3] - 2025-10-04

### Added
- Multiple .claude directory detection in /init-context and /migrate-context
- Warning message when parent folders have .claude directories
- Step 0 verification in both commands to check working directory
- Documentation in VERSION_MANAGEMENT.md about .claude conflicts
- Troubleshooting section in README.md for .claude directory issues

### Fixed
- Critical issue where nested projects load commands from parent .claude folder
- Commands appearing out of sync or missing after updates
- Confusing behavior when test/example projects are nested

## [1.1.2] - 2025-10-04

### Fixed
- Added explicit ACTION instructions to /update-context-system
- Consolidated Steps 1-2 into single bash script to preserve variables
- Added "Use the Bash tool" instructions throughout command
- Simplified command execution with clear "STOP_NO_UPDATE" / "PROCEED_WITH_UPDATE" markers
- Now actually executes bash commands instead of just describing them

## [1.1.1] - 2025-10-04

### Fixed
- Improved version detection in /update-context-system
- Added explicit bash commands for version extraction using grep + sed
- Added clear exit logic when versions match (exit 0)
- Now properly detects version differences and only updates when needed

## [1.1.0] - 2025-10-04

### Added
- CHANGELOG.md to track version history
- .gitignore template for context system files
- Session number auto-increment in /save-context
- /quick-save-context command for lightweight checkpoints
- Project type presets in /init-context
- /export-context command to generate combined markdown
- /validate-context command for template validation
- Conflict detection in /update-context-system

### Changed
- Made system universal by removing personal name references
- "Working with Rex" → "Working with You" in all templates
- Added cleanup instructions after installation

## [1.0.0] - 2025-10-04

### Added
- Initial release of Claude Context System
- Core slash commands:
  - /init-context - Initialize context system in new projects
  - /migrate-context - Migrate existing projects with documentation
  - /save-context - Update documentation to reflect current state
  - /review-context - Verify documentation accuracy
  - /code-review - Comprehensive code quality audit
  - /update-context-system - Update to latest version from GitHub
- 9 documentation templates:
  - CLAUDE.md - Developer guide
  - PRD.md - Product requirements
  - ARCHITECTURE.md - Technical design
  - DECISIONS.md - Decision log
  - CODE_STYLE.md - Coding standards
  - KNOWN_ISSUES.md - Issue tracking
  - SESSIONS.md - Session history
  - next-steps.md - Action items
  - todo.md - Current session tasks
- Configuration system with .context-config.json
- Artifact organization (code-reviews, lighthouse, performance, etc.)
- Validation script (scripts/validate-context.sh)

### Features
- Perfect session continuity across Claude Code sessions
- Zero context loss with comprehensive documentation
- Automated context preservation
- Smart file organization (context/ and artifacts/ folders)
- Version tracking and update system
- Migration support for existing projects

### Documentation
- Complete setup guide (SETUP_GUIDE.md)
- System structure documentation (STRUCTURE.md)
- Product requirements document (PRD.md)
- README with quick start instructions

---

## Version History

- **1.0.0** (2025-10-04) - Initial release
- **Unreleased** - Current development version

## Upgrade Guide

### From 1.0.0 to Current

**In your project:**
```bash
/update-context-system
# or
/update-context-system --accept-all
```

**What's new:**
- See [Unreleased] section above for new features
- Templates updated with universal language
- New commands for validation and quick saves
- Enhanced project type detection

**Breaking changes:**
- None

**Migration notes:**
- Existing projects continue to work without changes
- New features are opt-in via new commands
- Templates use "[Your Name]" instead of "Rex Kirshner"
