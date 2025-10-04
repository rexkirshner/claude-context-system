---
name: migrate-context
description: Migrate existing project to Claude Context System while preserving all content
---

# /migrate-context Command

Migrate an existing project with documentation to the Claude Context System. This command preserves ALL existing content while organizing it into the standard structure and augmenting with new sections.

## When to Use This Command

- Mature projects with existing documentation
- Projects with docs scattered across root directory
- Projects with artifacts (code reviews, lighthouse reports) in wrong locations
- Converting from other documentation systems
- Want to adopt Claude Context System without losing existing work

**Do NOT use if:**
- Project has no documentation (use `/init-context` instead)
- Already using Claude Context System

## What This Command Does

1. Scans existing project structure
2. Identifies documentation and artifacts
3. Creates context/ and artifacts/ folder structure
4. Moves existing files to correct locations
5. Augments existing docs with new sections
6. Creates missing documentation
7. Generates .context-config.json
8. Preserves ALL existing content

## Execution Steps

### Step 1: Scan Existing Project

**Identify existing documentation:**
```bash
ls -la
```

Look for:
- **Context docs (root):** CLAUDE.md, PRD.md, DECISIONS.md, KNOWN_ISSUES.md, ARCHITECTURE.md, CODE_STYLE.md, SESSIONS.md, README.md, DEPLOYMENT.md
- **Task files:** tasks/, todo.md, next-steps.md
- **Code reviews:** *code-review*.md, *review*.md
- **Lighthouse reports:** lighthouse-*.json
- **Other artifacts:** bundle-analysis/, coverage/, performance reports

**Analyze what exists:**
```
Create inventory:
- ✅ Found: CLAUDE.md (25KB)
- ✅ Found: PRD.md (57KB)
- ✅ Found: DECISIONS.md (16KB)
- ✅ Found: KNOWN_ISSUES.md (11KB)
- ❌ Missing: ARCHITECTURE.md
- ❌ Missing: CODE_STYLE.md
- ❌ Missing: SESSIONS.md
- ✅ Found: tasks/ directory
- ✅ Found: 4 lighthouse reports
- ✅ Found: 3 code review files in tasks/
```

### Step 2: Create Folder Structure

Create the complete Claude Context System structure:

```bash
mkdir -p context/tasks
mkdir -p artifacts/code-reviews
mkdir -p artifacts/lighthouse
mkdir -p artifacts/performance
mkdir -p artifacts/security
mkdir -p artifacts/bundle-analysis
mkdir -p artifacts/coverage
```

### Step 3: Move Existing Files

**Move documentation to context/:**

```bash
# Core docs
mv CLAUDE.md context/ 2>/dev/null || true
mv PRD.md context/ 2>/dev/null || true
mv DECISIONS.md context/ 2>/dev/null || true
mv KNOWN_ISSUES.md context/ 2>/dev/null || true
mv ARCHITECTURE.md context/ 2>/dev/null || true
mv CODE_STYLE.md context/ 2>/dev/null || true
mv SESSIONS.md context/ 2>/dev/null || true
mv DEPLOYMENT.md context/ 2>/dev/null || true
mv TROUBLESHOOTING.md context/ 2>/dev/null || true

# Task files
mv tasks/next-steps.md context/tasks/ 2>/dev/null || true
mv tasks/todo.md context/tasks/ 2>/dev/null || true
```

**Move artifacts to artifacts/:**

```bash
# Code reviews
mv tasks/*code-review*.md artifacts/code-reviews/ 2>/dev/null || true
mv tasks/*review*.md artifacts/code-reviews/ 2>/dev/null || true
mv *code-review*.md artifacts/code-reviews/ 2>/dev/null || true
mv CODE_REVIEW*.md artifacts/code-reviews/ 2>/dev/null || true

# Lighthouse reports
mv lighthouse-*.json artifacts/lighthouse/ 2>/dev/null || true

# Other artifacts
mv bundle-analysis/ artifacts/ 2>/dev/null || true
mv coverage/ artifacts/ 2>/dev/null || true
```

**Clean up empty directories:**
```bash
rmdir tasks 2>/dev/null || true
```

### Step 4: Augment Existing Documentation

For each existing doc, add missing sections from templates while preserving all content.

#### Augment context/CLAUDE.md

**Check for missing sections:**
- [ ] "Core Development Methodology" section
- [ ] Reference to .context-config.json
- [ ] Proper frontmatter/intro
- [ ] Commands section up to date

**If missing Core Development Methodology, add after "Working with Rex" section:**

```markdown
## Core Development Methodology

**The Golden Rule: Simplicity First**
Make every task and code change as simple as possible. Avoid massive or complex changes. Every change should impact as little code as possible.

**When Debugging:**
Trace through the ENTIRE code flow step by step. No assumptions. No shortcuts. Follow the data from entry point to the issue.

**Code Quality Standards:**
- DO NOT BE LAZY. NEVER BE LAZY.
- Find root causes, not symptoms
- NO TEMPORARY FIXES
- Think like a senior developer
- Impact only necessary code relevant to the task

**Impact Minimization:**
Make all fixes and code changes as simple as humanly possible. They should only impact necessary code relevant to the task and nothing else. Goal: not introduce any bugs.
```

**Add reference to config at top of "Working with Rex":**

```markdown
> **📋 Preferences:** All communication, workflow, and quality preferences are defined in `context/.context-config.json`.
> The settings below are derived from that source of truth.
```

**Update task file references:**
- Change `tasks/todo.md` → `context/tasks/todo.md`
- Change `tasks/next-steps.md` → `context/tasks/next-steps.md`

#### Augment context/PRD.md

**Add if missing:**
- Progress Log section (at end)
- Session tracking references

**Update structure to match template:**
- Ensure has Executive Summary
- Ensure has Current Status section
- Ensure has Implementation Plan

#### Augment context/DECISIONS.md

**Ensure has:**
- Last Updated date at top
- Table of Contents (if long)
- Proper categorization

**If missing structure, add template header:**

```markdown
# Technical Decisions & Architecture Choices

**Purpose:** Document why we made specific technical choices to inform future decisions and enable perfect session continuity.

**Last Updated:** [DATE]

---
```

#### Augment context/KNOWN_ISSUES.md

**Ensure has proper categorization:**

```markdown
# Known Issues

**Last Updated:** [DATE]

## 🔴 Blocking Issues

[Issues that prevent deployment or critical functionality]

## 🟡 Non-Critical Issues

[Issues that should be fixed but don't block progress]

## 🔵 Limitations & Future Work

[Known limitations and planned improvements]

---
```

**Migrate from old format to new if needed.**

### Step 5: Create Missing Documentation

Create any docs that don't exist from templates:

#### Create context/ARCHITECTURE.md (if missing)

Analyze project structure and generate:

```bash
# Analyze project
ls -la
find src app lib components -type d -maxdepth 2 2>/dev/null
```

Use ARCHITECTURE.template.md to create comprehensive overview.

#### Create context/CODE_STYLE.md (if missing)

Use CODE_STYLE.template.md and fill in:
- Language (from package.json)
- Framework patterns
- Rex's principles (from config)

#### Create context/SESSIONS.md (if missing)

Use SESSIONS.template.md and create first entry:

```markdown
# Session History

## Session 1 - Migration to Claude Context System
**Date:** [DATE]
**Focus:** Project migration

**Work Completed:**
- Migrated existing documentation to context/ folder
- Moved artifacts to proper locations
- Created missing documentation files
- Established Claude Context System structure

**Files Modified:**
- Moved: CLAUDE.md, PRD.md, DECISIONS.md, KNOWN_ISSUES.md → context/
- Moved: lighthouse-*.json → artifacts/lighthouse/
- Moved: code reviews → artifacts/code-reviews/
- Created: ARCHITECTURE.md, CODE_STYLE.md, SESSIONS.md
- Created: .context-config.json

**State at End:**
- Claude Context System fully migrated
- All existing content preserved
- Ready to use /save-context for future sessions

---
```

#### Create context/tasks/next-steps.md (if missing)

Analyze git status and recent work to create actionable next steps.

#### Create context/tasks/todo.md (if missing)

Use todo.template.md to create empty template ready for next session.

### Step 6: Create Configuration

Create `context/.context-config.json`:

```json
{
  "version": "1.0.0",
  "owner": "Rex Kirshner",
  "project": {
    "name": "[PROJECT_NAME]",
    "type": "[PROJECT_TYPE]",
    "initialized": "[ORIGINAL_DATE if known]",
    "migrated": "[TODAY]"
  },
  "preferences": {
    "documentation": {
      "location": "context/",
      "autoCreate": true,
      "updateFrequency": "every-session",
      "includeTimestamps": true,
      "gitTracking": true,
      "pruneInterval": "monthly"
    },
    "workflow": {
      "requirePlanApproval": true,
      "requirePushApproval": true,
      "preferSimpleChanges": true,
      "noTemporaryFixes": true,
      "fullCodeFlowTracing": true,
      "testBeforeCommit": true,
      "useTodoList": true
    },
    "communication": {
      "summaryStyle": "high-level",
      "verbosity": "concise",
      "includeLineNumbers": true,
      "skipPreamble": true,
      "useEmojis": false,
      "explainComplex": false
    },
    "codeReview": {
      "thoroughnessLevel": "comprehensive",
      "makeNoChanges": true,
      "timeConstraintWarning": true,
      "separateFixSession": true,
      "focusAreas": [
        "simplicity",
        "root-causes",
        "security",
        "performance",
        "testing",
        "accessibility",
        "seo",
        "architecture"
      ]
    },
    "sessionManagement": {
      "autoSaveInterval": null,
      "captureCommandHistory": true,
      "trackFileChanges": true,
      "preserveWIPState": true
    },
    "artifacts": {
      "location": "artifacts/",
      "subdirectories": {
        "lighthouse": "lighthouse/",
        "code_reviews": "code-reviews/",
        "performance": "performance/",
        "security": "security/",
        "bundle_analysis": "bundle-analysis/",
        "coverage": "coverage/"
      },
      "naming": {
        "include_timestamp": true,
        "include_session_number": true,
        "format": "YYYY-MM-DD"
      },
      "git_ignore": false,
      "organization": {
        "keep_root_clean": true,
        "auto_create_dirs": true,
        "archive_old": false
      }
    }
  },
  "migration": {
    "migrated_from": "root directory structure",
    "migration_date": "[TODAY]",
    "preserved_files": [
      "List of files that were moved"
    ]
  }
}
```

### Step 7: Generate Migration Report

Create comprehensive report of what was done:

```markdown
✅ Migration to Claude Context System Complete

## Files Moved

### Documentation → context/
- CLAUDE.md (augmented with Core Methodology)
- PRD.md (augmented with Progress Log)
- DECISIONS.md (reformatted)
- KNOWN_ISSUES.md (categorized)

### Tasks → context/tasks/
- tasks/next-steps.md → context/tasks/next-steps.md
- tasks/todo.md → context/tasks/todo.md

### Artifacts → artifacts/
- lighthouse-homepage.json → artifacts/lighthouse/
- lighthouse-article.json → artifacts/lighthouse/
- lighthouse-category.json → artifacts/lighthouse/
- lighthouse-article-optimized.json → artifacts/lighthouse/
- tasks/session-7-code-review.md → artifacts/code-reviews/
- tasks/session-8-code-review.md → artifacts/code-reviews/
- tasks/session-11-code-review.md → artifacts/code-reviews/

## Files Created

- context/ARCHITECTURE.md (new)
- context/CODE_STYLE.md (new)
- context/SESSIONS.md (new, Session 1 entry)
- context/.context-config.json (new)

## Files Augmented

- context/CLAUDE.md: Added Core Development Methodology, config reference
- context/PRD.md: Added Progress Log structure
- context/DECISIONS.md: Added proper formatting
- context/KNOWN_ISSUES.md: Added categorization

## Structure After Migration

context/
├── .context-config.json
├── CLAUDE.md ✏️ augmented
├── PRD.md ✏️ augmented
├── ARCHITECTURE.md ⭐ new
├── DECISIONS.md ✏️ augmented
├── CODE_STYLE.md ⭐ new
├── KNOWN_ISSUES.md ✏️ augmented
├── SESSIONS.md ⭐ new
└── tasks/
    ├── next-steps.md ➡️ moved
    └── todo.md ➡️ moved

artifacts/
├── code-reviews/
│   ├── session-7-code-review.md ➡️ moved
│   ├── session-8-code-review.md ➡️ moved
│   └── session-11-code-review.md ➡️ moved
└── lighthouse/
    ├── lighthouse-homepage.json ➡️ moved
    ├── lighthouse-article.json ➡️ moved
    ├── lighthouse-category.json ➡️ moved
    └── lighthouse-article-optimized.json ➡️ moved

## Preserved Content

✅ All 25KB of CLAUDE.md content preserved + augmented
✅ All 57KB of PRD.md content preserved
✅ All 16KB of DECISIONS.md content preserved
✅ All 11KB of KNOWN_ISSUES.md content preserved
✅ All task files preserved
✅ All artifacts preserved

## Next Steps

1. Review context/CLAUDE.md for accuracy
2. Verify context/.context-config.json settings
3. Check new ARCHITECTURE.md and CODE_STYLE.md
4. Run /save-context to capture current state
5. Use Claude Context System going forward!

---

**Ready!** Your project is now fully migrated to Claude Context System.
All existing content preserved, enhanced with new structure.
```

## Important Guidelines

### Preservation First

**NEVER delete or lose content:**
- Always move, never delete original files
- Augment existing docs, don't replace
- Preserve all sections, add new ones
- Keep exact wording in existing sections

### Smart Augmentation

**When adding sections to existing docs:**
- Read entire file first
- Identify what's missing vs template
- Add missing sections without disrupting existing flow
- Preserve author's voice and style
- Update references (tasks/ → context/tasks/)

**What to augment:**
- Add standardized headers/structure
- Add missing categories
- Add cross-references
- Add "Core Development Methodology" if missing
- Add config references

**What NOT to change:**
- Project-specific content
- User's examples and workflows
- Technical decisions already documented
- Existing section names (unless standardizing)

### File Movement Strategy

**Documentation (goes to context/):**
- CLAUDE.md, PRD.md, ARCHITECTURE.md, DECISIONS.md
- CODE_STYLE.md, KNOWN_ISSUES.md, SESSIONS.md
- DEPLOYMENT.md, TROUBLESHOOTING.md
- tasks/next-steps.md, tasks/todo.md

**Artifacts (goes to artifacts/):**
- lighthouse-*.json → artifacts/lighthouse/
- *code-review*.md → artifacts/code-reviews/
- bundle-analysis/ → artifacts/bundle-analysis/
- coverage/ → artifacts/coverage/
- performance reports → artifacts/performance/
- security scans → artifacts/security/

**Leave in root:**
- README.md (stays in root for GitHub)
- package.json, tsconfig.json (project config)
- .gitignore, .env* (project files)

### Config Generation

**Fill in from analysis:**
- project.name: From README or package.json
- project.type: Inferred from structure
- project.initialized: From git log (first commit date)
- migration.preserved_files: Actual list of moved files

### Migration Report

**Be specific:**
- List every file moved with → arrows
- Show before/after structure
- Note augmentations with ✏️
- Note new files with ⭐
- Note moved files with ➡️

## Error Handling

**If file conflicts:**
- Report which files would conflict
- Ask user how to proceed
- Suggest: rename existing, merge content, skip

**If can't determine structure:**
- Show what was found
- Ask user to clarify
- Provide safe default

**If unsure about file:**
- List in "Unprocessed Files" section
- Ask user where it should go
- Don't move unless confident

## Success Criteria

Migration succeeds when:
- All documentation in context/
- All artifacts in artifacts/
- Existing content 100% preserved
- New sections added to existing docs
- Missing docs created
- .context-config.json exists
- Migration report generated
- Ready to use /save-context

**Perfect migration:**
- Zero content lost
- All files in right place
- Documentation enhanced not replaced
- Clear audit trail of changes
- User can continue work immediately
