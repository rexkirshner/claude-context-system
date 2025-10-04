# Changelog

All notable changes to the Claude Context System will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.9] - 2025-10-04

### Fixed
- **CRITICAL: Section structure mismatch** - Step 4 now detects updates even when projects have restructured sections
- Debugging guidance updates weren't detected when "Core Development Methodology" was promoted to top-level section
- Changed from section-based comparison to content-block comparison

### Changed
- Step 4 completely rewritten to use content-block detection instead of full section extraction
- Now extracts specific blocks like "**When Debugging:**" regardless of section hierarchy
- Handles migrated projects that promoted `### Core Development Methodology` to `## Core Development Methodology`

### Technical Details
- **Root Cause:** Projects migrated with /migrate-context sometimes restructure sections
  - Template has: `## Working with You` > `### Core Development Methodology` > `**When Debugging:**`
  - Migrated project had: `## Working with You` AND separate `## Core Development Methodology`
  - Section extraction stopped at next `##`, missing the debugging content entirely
- **Solution:** Extract specific content blocks (e.g., debugging guidance) directly
  - Uses awk pattern matching on `**When Debugging:**` marker
  - Compares actual content, not section structure
  - Works regardless of section hierarchy differences

### Impact
- **Debugging updates will finally be detected** in migrated projects ✅
- Step 4 now robust to section restructuring
- Updates preserve project's chosen structure while updating content

### User Report
User found Step 4 reported "No template updates needed" even though debugging guidance differed:
- Template had 6-bullet debugging steps
- Project had single-line version
- Caused by section structure mismatch preventing content comparison

## [1.2.8] - 2025-10-04

### Fixed
- **CRITICAL: awk syntax error** - Fixed boolean comparisons that caused "illegal statement" errors
- **CRITICAL: Section extraction** - Now stops at next `##` header correctly (was grabbing too many sections)
- Changed from `!found` to `found == 0` (awk syntax requirement)
- Changed from `found` to `found == 1` for consistency

### Changed
- Made "ask user" instruction absolutely mandatory with explicit warnings
- Added "CRITICAL: You MUST ask the user for approval. Do NOT make the decision yourself"
- Added working directory rules to prevent path escaping errors
- Explicit instruction: "Do NOT try to cd into the project directory yourself"

### Impact
- **No more awk syntax errors during execution** ✅
- **Extracts only the target section** (e.g., just "Working with You", not everything until "Commands")
- **Claude will always ask user** instead of deciding "it's too different" and skipping
- **Cleaner execution** with fewer parse errors

### User Feedback
User reported:
1. "awk syntax errors" during execution
2. "(eval):1: parse error near `)'" errors at start
3. Claude made decision not to apply update without asking
4. Section extraction grabbed too much content (102 lines vs 48 lines expected)

All issues addressed in this release.

## [1.2.7] - 2025-10-04

### Changed
- **COMPLETE REDESIGN: Step 4 is now general-purpose** - No longer hard-coded to specific blocks
- Step 4 now compares entire system sections (like "Working with You")
- Detects ANY change to template guidance, not just "When Debugging:" or config reference
- Uses awk-based section extraction that handles both `##` and `###` headers flexibly

### Added
- Unified diff output showing all changes in context
- Section-level comparison instead of block-level
- Support for "Working with Rex" or "Working with You" variations

### Fixed
- Hard-coded block detection that missed other template improvements
- Limited to only 2 specific markers (DEBUGGING_BLOCK_UPDATED, CONFIG_REF_UPDATED)
- Template changes outside those blocks were never detected

### How It Works Now
1. Extract entire "Working with You" section from template (all subsections included)
2. Extract same from project's CLAUDE.md
3. Run diff to detect ANY differences
4. Show unified diff with full context
5. Ask user to review and approve
6. Replace entire section if approved

### Impact
- **Any** future improvement to CLAUDE.template.md will be detected
- No need to update Step 4 command when adding new guidance
- True general-purpose template update system
- User sees full context of what's changing

### User Request
User identified the fundamental flaw: "Right now it seems like updating the debug information is hard coded into step 4, but the goal isn't just to update the debugging code, update should be general purpose. whenever we make a change to claude.template.md (or any of the other template files) the /update-context-system command should try to integrate those changes"

This release addresses that request completely.

## [1.2.6] - 2025-10-04

### Fixed
- **CRITICAL: Cleanup step order** - Moved cleanup from Step 9 to Step 10 (final step)
- Cleanup was deleting /tmp/claude-context-update BEFORE Step 4 could access templates
- This is why template updates were never detected or applied in v1.2.5 and earlier
- Step 4 explicitly instructs Claude to EXECUTE Edit tool, not just describe it

### Changed
- Step 9: Generate Update Report (moved from Step 10)
- Step 10: Cleanup (moved from Step 9, now runs LAST)
- Step 4: Added explicit ACTION instructions to read CLAUDE.md and use Edit tool when updates detected
- Step 4: Changed from passive "should do" to active "MUST take these actions immediately"

### Root Cause Analysis
**Why template updates never worked:**
1. Step 3: Downloaded templates to /tmp/claude-context-update ✅
2. Step 9: Deleted /tmp/claude-context-update ❌ (TOO EARLY)
3. Step 4: Tried to cd /tmp/claude-context-update → directory not found
4. Bash script couldn't run, no updates detected
5. CLAUDE.md never updated with template improvements

**Fixed in v1.2.6:**
- Cleanup runs LAST (Step 10)
- Step 4 can access /tmp/claude-context-update successfully
- Template detection works correctly
- Edit tool explicitly executed when updates found

### Impact
- Template improvements (like v1.2.2 debugging guidance) will now be detected and applied
- Users will actually receive system updates via /update-context-system
- Self-updating command now fully functional

## [1.2.5] - 2025-10-04

### Fixed
- **Step 1 shell parsing error** - Split complex single-command script into 3 separate steps
- Removed `cd` command in middle of script that caused eval parse errors
- Now uses absolute paths (`/tmp/claude-context-update/latest.zip`) instead of relative paths

### Changed
- Step 1 split into Step 1a (get current version), Step 1b (download), Step 1c (compare)
- Each step is a separate bash command - more reliable execution
- Clearer output showing which step is executing

### Technical Details
- Old: Single bash script with embedded `cd` caused: `(eval):1: parse error near )`
- New: Three separate commands, no directory changes, absolute paths throughout
- Variables still preserved across steps (CURRENT_VERSION, LATEST_VERSION)

## [1.2.4] - 2025-10-04

### Added
- **Step 3.5: Self-Reload** - Command now reloads itself mid-execution after downloading updates
- Instructs Claude to read the newly updated command file before continuing to Step 4
- Ensures latest Step 4 logic is used immediately (no need for second run)

### Fixed
- Bootstrapping problem where /update-context-system would execute old Step 4 logic even after downloading new version
- Previously required two runs: first to download, second to execute new logic
- Now works correctly in single run

### Changed
- After Step 3 (copy commands), explicitly read .claude/commands/update-context-system.md
- Compare newly read Step 4 with original instructions
- Switch to new instructions if different

### Impact
- v1.2.3 Step 4 fix now works on first run (previously needed two runs)
- Any future Step 4 improvements take effect immediately
- True self-updating command behavior

## [1.2.3] - 2025-10-04

### Fixed
- **CRITICAL FIX:** Step 4 template detection now works correctly
- Rewrote Step 4 to use content-based detection instead of section-based
- Now searches for specific markers like `**When Debugging:**` regardless of section structure
- Works for both new projects and migrated projects with different section organization
- Detects template improvements that were previously missed

### Changed
- Step 4 now uses grep to extract specific content blocks (e.g., "When Debugging" guidance)
- Compares blocks directly, not entire sections
- More surgical updates that preserve project-specific customizations

### Technical Details
- Old approach: `sed -n '/^## Section/,/^## /p'` - failed when section was `###` instead of `##`
- New approach: `grep -A N '^**Marker:**'` - works regardless of section level
- Handles migrated projects that restructured sections (e.g., "## Core Development Methodology" vs "### Core Development Methodology")

## [1.2.2] - 2025-10-04

### Changed
- Fixed config reference in CLAUDE.template.md (config/preferences.yaml → context/.context-config.json)
- Enhanced debugging guidance with detailed bullet points instead of single line
- Improved "No Lazy Coding" principle wording for clarity

### Improved
- **Working with You section:**
  - Now references correct config location
  - Expanded debugging section with 6 specific steps
  - Changed "Find root causes" to "Always look for root causes" for emphasis

## [1.2.1] - 2025-10-04

### Added
- Step 0 working directory verification in /update-context-system
- Checks for context/.context-config.json before proceeding
- Detects if running from parent folder and suggests cd command
- Clear error messages with pwd output

### Fixed
- Error when running /update-context-system from parent folder instead of project folder
- Claude saying "file access issues" when really in wrong directory
- Confusing error messages that didn't explain the root cause

## [1.2.0] - 2025-10-04

### Changed
- **BREAKING IMPROVEMENT:** Rewrote Step 4 of /update-context-system to be general-purpose
- Now uses diff-based approach to detect ANY content changes in system sections
- Compares template sections to current sections using sed + diff
- Shows unified diff of changes before applying
- Works for all future template updates, not just "Rex" references

### Added
- Extract and compare mechanism for system sections
- Interactive diff review with unified output
- Support for detecting renamed sections (e.g., "Working with Rex" → "Working with You")
- Clear distinction between system sections (updatable) and project sections (never touch)

### Improved
- Step 4 now catches wording improvements, restructured content, new best practices
- More maintainable - no hard-coded text replacements
- Better user experience - see exactly what will change

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
