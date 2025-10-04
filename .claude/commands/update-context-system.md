---
name: update-context-system
description: Update Claude Context System to latest version from GitHub
---

# /update-context-system Command

Update your project's Claude Context System to the latest version from GitHub. Safely updates commands and optionally updates context file templates.

## When to Use This Command

- You want the latest slash commands and features
- System templates have been updated (CLAUDE.md, CODE_STYLE.md guidelines)
- New features or improvements released
- Bug fixes in command logic

**Run periodically** to stay up to date with improvements.

## What This Command Does

1. Fetches latest version from GitHub
2. Updates all slash commands (`.claude/commands/*.md`)
3. Detects changes to context file templates
4. Optionally updates context files with new sections
5. Reports everything that changed

## Command Options

### Default (Interactive Mode)
```
/update-context-system
```
- Updates commands automatically
- Shows diffs for context file changes
- Asks for approval before applying each change
- Safe, controlled updates

### Accept All Mode
```
/update-context-system --accept-all
```
- Updates commands automatically
- Applies all context file updates without review
- Fast, fully automated
- Use when you trust all updates

## Execution Steps

### Step 1: Check Current Version

Read current version from config:
```bash
grep -o '"version": "[^"]*"' context/.context-config.json
```

Display to user:
```
📦 Current version: 1.0.0
🔍 Checking for updates from GitHub...
```

### Step 2: Fetch Latest Version from GitHub

Download latest release info:
```bash
# Create temp directory
mkdir -p /tmp/claude-context-update
cd /tmp/claude-context-update

# Download latest from GitHub
curl -L https://github.com/rexkirshner/claude-context-system/archive/refs/heads/main.zip -o latest.zip

# Extract
unzip -q latest.zip
cd claude-context-system-main
```

Get latest version:
```bash
grep -o '"version": "[^"]*"' config/.context-config.template.json
```

**Compare versions:**
```
If current == latest:
  Report: "✅ Already up to date (v1.0.0)"
  Exit

If current < latest:
  Report: "📦 Update available: v1.0.0 → v1.2.0"
  Continue
```

### Step 3: Update Slash Commands

Commands are safe to overwrite (no project-specific content):

```bash
# Backup existing commands
cp -r .claude/commands .claude/commands.backup

# Update with latest
cp /tmp/claude-context-update/claude-context-system-main/.claude/commands/* .claude/commands/

# Report
echo "✅ Updated commands:"
ls .claude/commands/*.md | sed 's/.*\//  - /'
```

**Commands updated:**
- init-context.md
- migrate-context.md
- save-context.md
- review-context.md
- code-review.md
- update-context-system.md (this command!)

### Step 4: Detect Context File Template Changes

Check which templates have changed:

```bash
# For each template, check if different from current
cd /tmp/claude-context-update/claude-context-system-main

# Check CLAUDE template
if [ -f templates/CLAUDE.template.md ]; then
  # Extract just the "system" sections we might want to update
  # (Communication Style, Core Methodology, etc.)
fi
```

**Sections we can safely update in CLAUDE.md:**
- "Core Development Methodology" (system section)
- Communication preferences template (system section)
- Reference to .context-config.json (system section)

**Sections we should NOT touch:**
- Project Overview (project-specific)
- Commands (project-specific)
- Architecture (project-specific)
- Examples from Past Sessions (project-specific)

**Identify available updates:**
```
Available template updates:
- CLAUDE.md: Core Development Methodology section updated
- CODE_STYLE.md: New anti-patterns added
- templates/: 2 new templates available
```

### Step 5: Detect User Modifications (Conflict Check)

**Before applying updates, check if user has customized system sections:**

```bash
# For each section we want to update, check if it's been modified
cd /tmp/claude-context-update/claude-context-system-main

# Extract Core Development Methodology from template
TEMPLATE_HASH=$(sed -n '/^## Core Development Methodology/,/^## /p' templates/CLAUDE.template.md | md5sum | cut -d' ' -f1)

# Extract from current project (if exists)
if grep -q "^## Core Development Methodology" context/CLAUDE.md 2>/dev/null; then
  CURRENT_HASH=$(sed -n '/^## Core Development Methodology/,/^## /p' context/CLAUDE.md | md5sum | cut -d' ' -f1)

  # Compare with original v1.0.0 template hash
  ORIGINAL_HASH="[known hash for v1.0.0]"

  if [ "$CURRENT_HASH" != "$ORIGINAL_HASH" ] && [ "$CURRENT_HASH" != "$TEMPLATE_HASH" ]; then
    echo "⚠️  CUSTOMIZATION DETECTED"
    echo "You've modified Core Development Methodology section"
    echo "Template has also been updated"
    echo ""
    echo "Options:"
    echo "1. Keep your customizations (skip update)"
    echo "2. Apply template update (overwrite customizations)"
    echo "3. Merge manually (show both versions)"
  fi
fi
```

**Conflict scenarios:**

1. **No conflict:** Current matches original template → Safe to update
2. **User customized:** Current differs from original → Warn before updating
3. **Both changed:** User customized AND template updated → Require manual merge

**Handle conflicts:**

```
⚠️  Conflict Detected in context/CLAUDE.md

Section: Core Development Methodology
Status: You've customized this section, and template has updates

--- YOUR VERSION ---
**When Debugging:**
Trace code flows carefully. Use debugger breakpoints.
Always check database state.

--- TEMPLATE UPDATE ---
**When Debugging:**
Trace through the ENTIRE code flow step by step. No assumptions. No shortcuts. Follow the data from entry point to the issue.

--- RECOMMENDATION ---
Your version includes custom debugging steps (database state check).
Template update adds emphasis on thoroughness.

Choose action:
1. Keep yours (recommended if you've added project-specific guidance)
2. Use template (recommended if you want latest best practices)
3. Merge both (manually combine in next step)
4. Show full diff

Your choice [1/2/3/4]:
```

### Step 6: Apply Updates (Based on Mode)

#### If `--accept-all` flag:

**Check for conflicts first:**
- If conflicts detected: Show warning, require manual resolution
- If no conflicts: Proceed with auto-apply

```
⚠️  Cannot use --accept-all with conflicts

Conflicts detected in:
- context/CLAUDE.md (Core Development Methodology customized)
- context/CODE_STYLE.md (Git workflow customized)

Please run without --accept-all to resolve conflicts interactively.
Or resolve manually and re-run.
```

**If no conflicts, auto-apply all updates:**
1. Add/update Core Development Methodology in context/CLAUDE.md
2. Add/update system sections in context/CODE_STYLE.md
3. Update context/.context-config.json version
4. Report what was changed

```
🚀 Applying all updates automatically...

✅ Updated context/CLAUDE.md:
   - Core Development Methodology section updated
   - Communication preferences updated

✅ Updated context/CODE_STYLE.md:
   - Added new anti-patterns section

✅ Updated context/.context-config.json:
   - Version: 1.0.0 → 1.2.0
```

#### If interactive mode (default):

**Show each update and ask:**

```
📝 Update available for context/CLAUDE.md

Section: Core Development Methodology
Change: Updated debugging guidance

--- OLD ---
**When Debugging:**
Trace through code flows carefully.

--- NEW ---
**When Debugging:**
Trace through the ENTIRE code flow step by step. No assumptions. No shortcuts. Follow the data from entry point to the issue.

Apply this update? [Y/n/diff]
- Y: Apply update
- n: Skip this update
- diff: Show full diff

User response: Y

✅ Applied update to context/CLAUDE.md
```

**For each template update:**
1. Show section name and brief change summary
2. Show before/after snippet
3. Ask: Apply? [Y/n/diff]
4. If Y: Use Edit tool to apply change
5. If n: Skip, note in report
6. If diff: Show full diff, then ask again

### Step 6: Update Version in Config

After all updates applied:

```bash
# Update version number
# Use Edit tool to update context/.context-config.json
```

Example edit:
```
old_string: "version": "1.0.0"
new_string: "version": "1.2.0"
```

### Step 7: Cleanup

```bash
# Remove temp directory
rm -rf /tmp/claude-context-update

# Remove command backup if successful
rm -rf .claude/commands.backup
```

### Step 8: Generate Update Report

Provide clear summary:

```
✅ Claude Context System Updated

## Version
1.0.0 → 1.2.0

## Commands Updated (5)
- ✅ init-context.md
- ✅ migrate-context.md
- ✅ save-context.md
- ✅ review-context.md
- ✅ code-review.md

## Context Files Updated (2)
- ✅ context/CLAUDE.md
  - Core Development Methodology section updated
  - Communication preferences clarified
- ✅ context/CODE_STYLE.md
  - Added new anti-patterns section

## Context Files Skipped (1)
- ⏭️ context/ARCHITECTURE.md (no template updates)

## New Features
- Added /update-context-system command (this one!)
- Improved /migrate-context with augmentation verification
- Enhanced /code-review with SEO section

## Breaking Changes
None

## Next Steps
1. Review updated sections in context/CLAUDE.md
2. Run /save-context to capture the update
3. Continue working with latest system!

---

📚 Full changelog: https://github.com/rexkirshner/claude-context-system/releases
```

## Template Section Mapping

These are the "system" sections we can safely update:

### context/CLAUDE.md
**Safe to update (system sections):**
- Core Development Methodology
- Communication Style template
- Testing & Verification template
- Config reference block

**Never touch (project sections):**
- Project Overview
- Commands
- Architecture
- Critical Path
- Examples from Past Sessions

### context/CODE_STYLE.md
**Safe to update (system sections):**
- Core development principles
- Anti-patterns
- Git workflow rules

**Never touch (project sections):**
- Language-specific conventions
- Project-specific patterns
- Custom testing requirements

### context/.context-config.json
**Safe to update:**
- version number
- Add new preference fields (don't remove existing)

**Never touch:**
- project.name, project.type
- Any user-customized preferences

## Update Detection Strategy

**How to detect if a section needs updating:**

1. **Hash comparison:**
   ```bash
   # Get hash of current section
   sed -n '/^## Core Development Methodology/,/^## /p' context/CLAUDE.md | md5sum

   # Compare with template
   sed -n '/^## Core Development Methodology/,/^## /p' templates/CLAUDE.template.md | md5sum
   ```

2. **If hashes differ:**
   - Section has been updated
   - Show diff and offer to apply

3. **If section missing entirely:**
   - Auto-add (this is an improvement, not a change)

## Error Handling

**If GitHub is unreachable:**
```
❌ Cannot reach GitHub
- Check internet connection
- Try again later
- Manual update: download from https://github.com/rexkirshner/claude-context-system
```

**If commands backup fails:**
```
❌ Could not backup existing commands
- Ensure .claude/commands/ is writable
- Check disk space
- Update cancelled for safety
```

**If template extraction fails:**
```
⚠️ Could not extract template updates
- Commands updated successfully
- Context file updates skipped
- Manually check templates/ folder
```

**If Edit tool fails:**
```
❌ Could not apply update to context/CLAUDE.md
- Changes saved to context/CLAUDE.md.update
- Review and apply manually
- Or re-run /update-context-system
```

## Important Notes

### Version Numbers
- Version stored in `context/.context-config.json`
- Format: `major.minor.patch` (e.g., "1.2.3")
- Check GitHub releases for changelog

### Backup Safety
- Commands backed up to `.claude/commands.backup` during update
- Restore if needed: `mv .claude/commands.backup .claude/commands`
- Backup removed on successful completion

### What Gets Updated
- ✅ All slash commands (always)
- ✅ System sections in context files (if changed)
- ✅ Version number in config
- ❌ Never: project-specific content
- ❌ Never: custom user modifications

### Accept All Safety
- `--accept-all` only updates predefined system sections
- Never overwrites project-specific content
- Safe to use if you trust system updates
- Review changelog first: https://github.com/rexkirshner/claude-context-system/releases

## Usage Examples

### Check and update interactively
```
/update-context-system

> 📦 Update available: v1.0.0 → v1.2.0
>
> Commands to update: 5
> Context sections to update: 2
>
> Apply updates? [Y/n]
```

### Accept all updates
```
/update-context-system --accept-all

> 🚀 Applying all updates...
> ✅ Updated 5 commands
> ✅ Updated 2 context sections
> ✅ Version: 1.0.0 → 1.2.0
```

### Check version only
If already up to date:
```
/update-context-system

> ✅ Already up to date (v1.2.0)
> No updates available.
```

## Success Criteria

Update succeeds when:
- All commands updated successfully
- Version number incremented
- Update report generated
- No errors during process
- User informed of all changes

**Perfect update:**
- Commands auto-updated
- Context improvements applied
- Project-specific content untouched
- Clear report of what changed
- Ready to continue work immediately
