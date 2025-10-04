---
name: init-context
description: Initialize Claude Context System for this project
---

# /init-context Command

Initialize the complete context management system for this project. Run this once when starting a new project to set up comprehensive documentation and session continuity.

## What This Command Does

1. Creates `context/` folder structure
2. Analyzes current project state
3. Generates all meta-documentation from templates
4. Creates configuration file
5. Sets up task tracking system

## Execution Steps

### Step 1: Check Existing Context

```
Check if context/ folder already exists:
- If exists: Warn user and ask if they want to reinitialize
- If not: Proceed to Step 2
```

### Step 2: Analyze Project

Gather information about the project:

**File System Analysis:**
- Run `ls -la` to see root structure
- Check for package.json, Cargo.toml, go.mod, requirements.txt, etc.
- Identify project type (web app, CLI, library, API, etc.)
- Find README.md if exists

**Git Analysis (if git repo):**
- Run `git log --oneline -10` for recent history
- Run `git remote -v` to find repo URL
- Check current branch with `git branch --show-current`

**Technology Stack:**
- Read package.json for Node.js projects
- Read Cargo.toml for Rust projects
- Read go.mod for Go projects
- Read requirements.txt for Python projects
- Identify framework (Next.js, React, Express, etc.)

**Project Structure:**
- Identify src/ or app/ or lib/ directories
- Look for test/ or tests/ directories
- Check for build/dist/out directories
- Find documentation directories

### Step 3: Create Folder Structure

Create the complete context directory structure:

```bash
mkdir -p context/tasks
mkdir -p artifacts/code-reviews
mkdir -p artifacts/lighthouse
mkdir -p artifacts/performance
mkdir -p artifacts/security
mkdir -p artifacts/bundle-analysis
mkdir -p artifacts/coverage
```

### Step 4: Generate Documentation Files

Create all documentation files from templates. Fill in as much as possible from project analysis:

**context/CLAUDE.md** - Developer guide
- Project overview (from README or git description)
- Tech stack (from package analysis)
- Commands (from package.json scripts or Makefile)
- Architecture (inferred from folder structure)
- Include Rex's communication preferences and workflow rules
- Include "Core Development Methodology" section

**context/PRD.md** - Product requirements
- Executive summary (from README or create placeholder)
- Current status (Phase 1 - Initial Setup)
- Tech stack (from analysis)
- Implementation plan (create initial phases)
- Progress log (first entry: "Project initialized")

**context/ARCHITECTURE.md** - Technical design
- High-level overview (inferred from structure)
- Key directories and purposes
- Technology choices (from analysis)
- Design patterns (identify from code if possible)

**context/DECISIONS.md** - Technical decisions
- Framework choice (why this framework)
- Initial architectural decisions
- Dependencies chosen (from package files)

**context/CODE_STYLE.md** - Coding standards
- Rex's principles (simplicity, root causes, no lazy coding)
- Language-specific conventions (from project type)
- Testing requirements
- Git workflow rules

**context/KNOWN_ISSUES.md** - Current issues
- Start empty or with placeholders
- Categories: Blocking, Non-Critical, Limitations, Future Work

**context/SESSIONS.md** - Session history
- First entry documenting initialization
- Template for future entries

**context/tasks/next-steps.md** - Action items
- Initial next steps based on project state
- If new project: setup tasks
- If existing: current state analysis

**context/tasks/todo.md** - Current session
- Empty template ready for use

### Step 5: Create Configuration

Create `.context-config.json` in the context/ folder with Rex's preferences:

```json
{
  "version": "1.0.0",
  "owner": "Rex Kirshner",
  "preferences": {
    "documentation": {
      "location": "context/",
      "autoCreate": true,
      "updateFrequency": "every-session",
      "includeTimestamps": true,
      "gitTracking": true
    },
    "workflow": {
      "requirePlanApproval": true,
      "requirePushApproval": true,
      "preferSimpleChanges": true,
      "noTemporaryFixes": true,
      "fullCodeFlowTracing": true,
      "testBeforeCommit": true
    },
    "communication": {
      "summaryStyle": "high-level",
      "verbosity": "concise",
      "includeLineNumbers": true,
      "skipPreamble": true,
      "useEmojis": false
    },
    "codeReview": {
      "thoroughnessLevel": "comprehensive",
      "makeNoChanges": true,
      "timeConstraintWarning": true,
      "separateFixSession": true
    },
    "sessionManagement": {
      "autoSaveInterval": null,
      "captureCommandHistory": true,
      "trackFileChanges": true,
      "preserveWIPState": true
    }
  }
}
```

### Step 6: Report Completion

Provide clear summary:

```
✅ Context System Initialized

Created:
- context/ folder structure
- 8 documentation files
- Configuration file

Files created:
- context/CLAUDE.md - Developer guide
- context/PRD.md - Product requirements
- context/ARCHITECTURE.md - Technical design
- context/DECISIONS.md - Decision log
- context/CODE_STYLE.md - Coding standards
- context/KNOWN_ISSUES.md - Issue tracking
- context/SESSIONS.md - Session history
- context/tasks/next-steps.md - Action items
- context/tasks/todo.md - Current tasks
- context/.context-config.json - Configuration

Project Type: [Detected type]
Tech Stack: [Detected stack]

Next Steps:
1. Review context/CLAUDE.md for accuracy
2. Update context/PRD.md with project goals
3. Run /save-context after making changes
4. Start coding!
```

## Template Content Guidelines

When filling templates, use this priority:

1. **From project files**: Use actual data from package.json, README, git
2. **Inferred from structure**: Make educated guesses from folder layout
3. **Generic placeholders**: Use `[TODO: Add ...]` for unknown info
4. **Rex's defaults**: Always include his preferences and workflow rules

## Important Notes

- Always include Rex's workflow preferences in CLAUDE.md
- CODE_STYLE.md must include his "no lazy coding" and "simplicity first" rules
- Configuration must enforce "no push without approval"
- Documentation should be scannable in 5 minutes per file
- Use bullet points and clear headings
- Link between related documents

## Error Handling

If errors occur:
- Report what failed clearly
- Show what was successfully created
- Provide manual recovery steps
- Never leave partial initialization

## Success Criteria

Command succeeds when:
- All 9 files created
- Configuration valid
- Templates filled with available data
- User can immediately run /save-context
- Clear next steps provided
