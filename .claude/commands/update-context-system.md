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

## Important: How to Execute This Command

**CRITICAL:** You MUST use the Bash tool to execute all commands in this file. Do NOT describe the commands to the user - EXECUTE them.

Each bash code block in this file should be run using the Bash tool. This is an automated update process.

## Important: Version Check First

**CRITICAL:** This command compares version numbers. If local version matches GitHub version, the command MUST exit immediately without making ANY changes. Only proceed with updates if GitHub version is newer.

## Execution Steps

### Step 0: Verify Working Directory

**CRITICAL:** Ensure we're in the correct project directory before proceeding.

```bash
# Check if context/.context-config.json exists
if [ ! -f "context/.context-config.json" ]; then
  echo ""
  echo "❌ ERROR: Not in correct project directory"
  echo ""
  echo "Current directory: $(pwd)"
  echo ""
  echo "This command must be run from the project root directory that contains:"
  echo "  - context/.context-config.json"
  echo "  - .claude/commands/"
  echo ""
  echo "Common issues:"
  echo "  1. Running from parent folder instead of project folder"
  echo "  2. Running from nested subdirectory"
  echo ""

  # Try to detect if we're in a parent folder
  if [ -d "inevitable-eth/context" ] || [ -d "*/context" ]; then
    echo "💡 Detected project in subdirectory!"
    echo ""
    echo "Try:"
    echo "  cd inevitable-eth  (or whatever your project folder is)"
    echo "  /update-context-system"
  fi

  echo ""
  echo "Cancelled. Please cd to the project directory and try again."
  exit 1
fi

echo "✅ Working directory verified"
echo "Project: $(pwd)"
echo ""
```

### Step 1: Check Current Version and Download Latest

**ACTION:** Use the Bash tool to execute these steps:

**Step 1a: Get current version**
```bash
CURRENT_VERSION=$(grep -m 1 '"version":' context/.context-config.json | sed 's/.*"version": "\([^"]*\)".*/\1/')
echo "📦 Current version: $CURRENT_VERSION"
echo "🔍 Checking for updates from GitHub..."
```

**Step 1b: Download and extract latest**
```bash
rm -rf /tmp/claude-context-update
mkdir -p /tmp/claude-context-update
curl -L https://github.com/rexkirshner/claude-context-system/archive/refs/heads/main.zip -o /tmp/claude-context-update/latest.zip
unzip -q /tmp/claude-context-update/latest.zip -d /tmp/claude-context-update
```

**Step 1c: Get latest version and compare**
```bash
LATEST_VERSION=$(grep -m 1 '"version":' /tmp/claude-context-update/claude-context-system-main/config/.context-config.template.json | sed 's/.*"version": "\([^"]*\)".*/\1/')
CURRENT_VERSION=$(grep -m 1 '"version":' context/.context-config.json | sed 's/.*"version": "\([^"]*\)".*/\1/')

echo "🔍 Latest version from GitHub: $LATEST_VERSION"
echo ""

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
  echo "✅ Already Up to Date"
  echo ""
  echo "Current version: $CURRENT_VERSION"
  echo "Latest version: $LATEST_VERSION"
  echo ""
  echo "Your Claude Context System is already running the latest version."
  echo "No updates were performed. All commands are current."

  rm -rf /tmp/claude-context-update
  echo "STOP_NO_UPDATE"
else
  echo "📦 Update Available"
  echo "  Current: $CURRENT_VERSION"
  echo "  Latest:  $LATEST_VERSION"
  echo ""
  echo "Proceeding with update..."
  echo "PROCEED_WITH_UPDATE"
fi
```

**After running the above:**
- If output contains "STOP_NO_UPDATE": Exit immediately, do not proceed to Step 3
- If output contains "PROCEED_WITH_UPDATE": Continue to Step 3

**CRITICAL:** If versions match, exit BEFORE updating commands. Do not download, do not copy files, do not modify anything. Only proceed if latest > current.

The version check MUST use string comparison (`[ "$CURRENT_VERSION" = "$LATEST_VERSION" ]`) and exit immediately if they match.

### Step 3: Update Slash Commands

**ACTION:** Use the Bash tool to update the commands:

```bash
# Navigate back to project root
cd - > /dev/null

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

### Step 3.5: Reload This Command (Self-Update)

**CRITICAL:** The update-context-system.md command file was just updated in Step 3. The newly downloaded version may have improved logic for detecting and applying template updates.

To ensure we use the **LATEST** command logic for remaining steps, we must reload this command now.

**ACTION:** Use the Read tool to read the newly updated command file:

```
Read file: .claude/commands/update-context-system.md
```

**After reading the new file:**

1. **Check if Step 4 logic has changed** - Compare what you just read with the Step 4 instructions you were originally following
2. **If Step 4 is different:** Continue execution using the **NEWLY READ** Step 4 instructions from the updated file
3. **If Step 4 is the same:** Continue with current instructions (no functional change)

**Example scenarios:**

- **Scenario A:** Old Step 4 used section-based detection (`sed -n '/^## Section/'`), new Step 4 uses content-based detection (`grep -A N '^**Marker:**'`)
  - **Action:** Use the new content-based approach for remaining execution

- **Scenario B:** Step 4 logic is identical in both versions
  - **Action:** Continue normally (no change needed)

**Why this matters:**

Without this reload step, you'd be executing outdated Step 4 logic even though the new file was downloaded. This reload ensures:
- Bug fixes in Step 4 take effect immediately (don't need two runs)
- New template detection features work on first run
- Self-updating command actually updates its own behavior

**After reload, proceed to Step 4 below** (using the version from the newly read file if different).

### Step 4: Detect Template Content Changes

**IMPORTANT:** Compare specific content blocks from template with current project files.

This step uses **content-based detection** instead of section-based. It searches for specific markers (like `**When Debugging:**`) and compares just those blocks, regardless of which section they're in.

**Why content-based?**
- Works for both new projects and migrated projects
- Handles different section structures (## vs ### headers)
- Detects actual content changes, not section reorganization
- More surgical and precise

**System content blocks we track (CLAUDE.md):**
- `**When Debugging:**` block (debugging methodology)
- Config reference block (`> **📋 Preferences:**`)
- Core quality principles blocks

**Never update (project-specific):**
- Project Overview
- Commands list
- Architecture details
- Examples from Past Sessions
- Specific code examples

**ACTION:** Use the Bash tool to run this entire script as ONE command:

```bash
cd /tmp/claude-context-update/claude-context-system-main

echo "🔍 Checking for template content updates..."
echo ""

# Function to extract content block (marker + N lines after)
extract_block() {
  local file=$1
  local marker=$2
  local lines_after=$3

  grep -A "$lines_after" "^${marker}" "$file" 2>/dev/null || echo ""
}

# Check 1: "When Debugging:" block
echo "Checking: **When Debugging:** guidance..."
extract_block "templates/CLAUDE.template.md" '\*\*When Debugging:\*\*' 7 > /tmp/template-debugging.txt

cd - > /dev/null
extract_block "context/CLAUDE.md" '\*\*When Debugging:\*\*' 7 > /tmp/current-debugging.txt

if [ -s /tmp/template-debugging.txt ]; then
  if ! diff -q /tmp/template-debugging.txt /tmp/current-debugging.txt > /dev/null 2>&1; then
    echo "  ✨ UPDATE AVAILABLE"
    echo ""
    echo "--- Current Version ---"
    cat /tmp/current-debugging.txt
    echo ""
    echo "--- Template Version ---"
    cat /tmp/template-debugging.txt
    echo ""
    echo "DEBUGGING_BLOCK_UPDATED"
  else
    echo "  ✅ Up to date"
  fi
else
  echo "  ⏭️  Not in template"
fi

echo ""

# Check 2: Config reference block
echo "Checking: Config reference block..."
cd /tmp/claude-context-update/claude-context-system-main
extract_block "templates/CLAUDE.template.md" '> \*\*📋 Preferences:\*\*' 2 > /tmp/template-config-ref.txt

cd - > /dev/null
extract_block "context/CLAUDE.md" '> \*\*📋 Preferences:\*\*' 2 > /tmp/current-config-ref.txt

if [ -s /tmp/template-config-ref.txt ]; then
  if ! diff -q /tmp/template-config-ref.txt /tmp/current-config-ref.txt > /dev/null 2>&1; then
    echo "  ✨ UPDATE AVAILABLE"
    echo ""
    echo "--- Current Version ---"
    cat /tmp/current-config-ref.txt
    echo ""
    echo "--- Template Version ---"
    cat /tmp/template-config-ref.txt
    echo ""
    echo "CONFIG_REF_UPDATED"
  else
    echo "  ✅ Up to date"
  fi
else
  echo "  ⏭️  Not in template"
fi

echo ""

# Summary
if grep -q "_UPDATED$" /tmp/template-*.txt 2>/dev/null; then
  echo "📝 Template updates detected - see above for details"
else
  echo "✅ No template content updates available"
  echo "   Your CLAUDE.md contains the latest system guidance"
fi
```

**After the script completes, you MUST take these actions immediately:**

**If you see `DEBUGGING_BLOCK_UPDATED` marker:**

1. **ACTION:** Use Read tool to read context/CLAUDE.md
2. The diff was already shown by the bash script above
3. **ACTION:** Ask user: "Apply debugging guidance update to context/CLAUDE.md? [Y/n]"
4. **If user approves (Y or yes):**
   - **ACTION:** Use Edit tool:
     ```
     file_path: context/CLAUDE.md
     old_string: [the current single-line "When Debugging:" block shown in diff]
     new_string: [the new 6-bullet "When Debugging:" block from template]
     ```
   - Report: "✅ Updated 'When Debugging' guidance in context/CLAUDE.md"
5. **If user declines:** Report: "⏭️ Skipped debugging guidance update"

**If you see `CONFIG_REF_UPDATED` marker:**

1. **ACTION:** Use Read tool to read context/CLAUDE.md
2. The diff was already shown by the bash script above
3. **ACTION:** Ask user: "Apply config reference update to context/CLAUDE.md? [Y/n]"
4. **If user approves:**
   - **ACTION:** Use Edit tool to replace the config reference block
   - Report: "✅ Updated config reference in context/CLAUDE.md"
5. **If user declines:** Report: "⏭️ Skipped config reference update"

**If NO markers appear (script output shows "No template content updates available"):**

Report:
```
✅ No template content updates available
   Your CLAUDE.md contains the latest system guidance
```

**CRITICAL:** Do not just describe what should be done - EXECUTE the Read and Edit tools when updates are detected.

### Step 5: Detect Context File Template Changes

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

### Step 6: Detect User Modifications (Conflict Check)

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

### Step 7: Apply Updates (Based on Mode)

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

### Step 8: Update Version in Config

**ACTION:** Use the Edit tool to update the version in context/.context-config.json

After determining LATEST_VERSION from Step 1, use the Edit tool:
```
file_path: context/.context-config.json
old_string: "version": "1.0.0"  (or whatever CURRENT_VERSION was)
new_string: "version": "1.1.1"  (or whatever LATEST_VERSION is)
```

Then report:
```
✅ Updated version: 1.0.0 → 1.1.1
```

### Step 9: Generate Update Report

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

### Step 10: Cleanup

**CRITICAL:** This MUST be the final step. Do not run cleanup before template detection steps.

**ACTION:** Use the Bash tool to clean up:

```bash
# Remove temp directory (contains downloaded templates)
rm -rf /tmp/claude-context-update

# Remove command backup if successful
rm -rf .claude/commands.backup

echo "✅ Cleanup complete"
```

**Why cleanup is last:**
- Steps 4-7 need /tmp/claude-context-update to access template files
- Running cleanup earlier causes template detection to fail (directory not found)
- This was a critical bug in v1.2.5 and earlier

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

> ✅ Already Up to Date
>
> Current version: 1.2.0
> Latest version: 1.2.0
>
> Your Claude Context System is already running the latest version.
> No updates were performed. All commands are current.
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
