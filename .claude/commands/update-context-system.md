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

**ACTION:** Use the Bash tool to execute this entire script as ONE command:

```bash
# Step 1: Get current version
CURRENT_VERSION=$(grep -m 1 '"version":' context/.context-config.json | sed 's/.*"version": "\([^"]*\)".*/\1/')
echo "📦 Current version: $CURRENT_VERSION"
echo "🔍 Checking for updates from GitHub..."

# Step 2: Download and extract latest
mkdir -p /tmp/claude-context-update
cd /tmp/claude-context-update
curl -L https://github.com/rexkirshner/claude-context-system/archive/refs/heads/main.zip -o latest.zip
unzip -q latest.zip

# Step 3: Get latest version
LATEST_VERSION=$(grep -m 1 '"version":' claude-context-system-main/config/.context-config.template.json | sed 's/.*"version": "\([^"]*\)".*/\1/')
echo "🔍 Latest version from GitHub: $LATEST_VERSION"

# Step 4: Compare versions
echo ""
if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
  echo "✅ Already Up to Date"
  echo ""
  echo "Current version: $CURRENT_VERSION"
  echo "Latest version: $LATEST_VERSION"
  echo ""
  echo "Your Claude Context System is already running the latest version."
  echo "No updates were performed. All commands are current."

  # Clean up and exit
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

### Step 4: Detect Template Content Changes

**IMPORTANT:** Compare template sections with current project files to find content updates.

This step detects changes to the **content** of system sections (not just new sections).

**System sections we can update (CLAUDE.md):**
- "Working with You" / "Communication Style"
- "Core Development Methodology"
- Config reference block

**System sections we can update (CODE_STYLE.md):**
- "Core Principles" / "Core Development Principles"
- "Git Workflow" section

**Never update (project-specific):**
- Project Overview
- Commands list
- Architecture details
- Examples from Past Sessions
- Specific code examples

**ACTION:** Compare template sections to current sections:

1. **Extract system sections from template:**
```bash
cd /tmp/claude-context-update/claude-context-system-main

# Extract "Working with You" section from template
sed -n '/^## Working with You/,/^## /p' templates/CLAUDE.template.md > /tmp/template-working.txt

# Extract "Core Development Methodology" section
sed -n '/^## Core Development Methodology/,/^## /p' templates/CLAUDE.template.md > /tmp/template-methodology.txt
```

2. **Extract same sections from current project:**
```bash
cd - > /dev/null

# Extract from current CLAUDE.md (may have "Working with Rex" or "Working with You")
sed -n '/^## Working with [YR]/,/^## /p' context/CLAUDE.md > /tmp/current-working.txt 2>/dev/null || echo "" > /tmp/current-working.txt

# Extract methodology section
sed -n '/^## Core Development Methodology/,/^## /p' context/CLAUDE.md > /tmp/current-methodology.txt 2>/dev/null || echo "" > /tmp/current-methodology.txt
```

3. **Compare sections and show differences:**
```bash
# Check if "Working with You" section differs
if ! diff -q /tmp/template-working.txt /tmp/current-working.txt > /dev/null 2>&1; then
  echo ""
  echo "📝 Template Update Available: 'Working with You' section"
  echo ""
  echo "The template has updated content for this section."
  echo ""

  # Show brief diff
  diff --unified=3 /tmp/current-working.txt /tmp/template-working.txt | head -20

  echo ""
  read -p "Apply this update to CLAUDE.md? [Y/n] " -n 1 -r
  echo

  if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    # Use Read tool to get current CLAUDE.md
    # Use Edit tool to replace the section
    echo "UPDATE_WORKING_SECTION"
  fi
fi

# Repeat for Core Development Methodology
if ! diff -q /tmp/template-methodology.txt /tmp/current-methodology.txt > /dev/null 2>&1; then
  echo ""
  echo "📝 Template Update Available: 'Core Development Methodology' section"
  # Same process...
  echo "UPDATE_METHODOLOGY_SECTION"
fi
```

4. **Apply updates if approved:**

If user approved, use the Edit tool to replace the entire section:
- Read the current CLAUDE.md
- Find the old section (e.g., `## Working with Rex` or `## Working with You`)
- Replace with the template version
- Preserve all project-specific content around it

**Important:** This approach detects ANY content changes to system sections, not just specific text like "Rex". It will catch:
- Wording improvements
- Added/removed guidelines
- Restructured content
- New best practices

**If no differences found:**
```
✅ All system sections up to date
No template content changes detected
```

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

### Step 9: Cleanup

**ACTION:** Use the Bash tool to clean up:

```bash
# Remove temp directory
rm -rf /tmp/claude-context-update

# Remove command backup if successful
rm -rf .claude/commands.backup

echo "✅ Cleanup complete"
```

### Step 10: Generate Update Report

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
