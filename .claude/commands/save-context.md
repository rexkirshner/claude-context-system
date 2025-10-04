---
name: save-context
description: Update all meta-documentation to reflect current code state
---

# /save-context Command

Update all context documentation to accurately reflect the current state of the project. This is your safety net - run it frequently to preserve session state and enable perfect continuity.

## When to Use This Command

- After completing any significant work
- Before taking breaks (even 5-minute breaks)
- At session end (always!)
- After making technical decisions
- When switching tasks
- Before running /code-review

**Rule of thumb:** If you're unsure, run it. Better to save too often than lose context.

## What This Command Does

1. Verifies context/ folder exists (creates if missing)
2. Analyzes current state vs documented state
3. Updates all documentation files
4. Captures session activity
5. Preserves work-in-progress state
6. Reports what changed

## Execution Steps

### Step 1: Verify Context Exists

```
If context/ folder missing:
- Automatically run /init-context first
- Then proceed with save

If context/ exists:
- Proceed to Step 2
```

### Step 2: Analyze Current State

Gather comprehensive information about what changed:

**Git Analysis:**
```bash
# Recent commits (last 5-10)
git log --oneline -10

# Current changes
git status
git diff HEAD

# Staged changes
git diff --cached

# Current branch
git branch --show-current
```

**File System Changes:**
```bash
# Modified files since last update
ls -lt | head -20

# New directories
find . -type d -maxdepth 2 -newer context/SESSIONS.md 2>/dev/null
```

**Project State:**
- Read package.json for new dependencies
- Check for new npm scripts
- Look for new files in src/app/lib directories
- Identify any architectural changes

**Session Activity:**
- What commands were run (if trackable)
- What files were modified
- What decisions were made
- What issues were discovered

### Step 3: Update Each Documentation File

Update files based on changes detected:

#### context/CLAUDE.md Updates

**Development Status:**
- Update current phase/milestone
- Mark completed work with ✅
- Update "in progress" items

**Commands:**
- Add any new npm scripts/commands
- Update command descriptions if changed

**Architecture:**
- Add new architectural patterns
- Update directory structure if changed
- Document new integrations

**Critical Path:**
- Add "Completed in Session [N]" section
- List key accomplishments with ✅
- Update "Key Files Modified/Created"
- Set current status

**Example update:**
```markdown
**Current Status:** Phase 2 - Feature Implementation

**Completed in Session 12:**
- ✅ Implemented user authentication system
- ✅ Added JWT token management
- ✅ Created login/logout flows

**Key Files Modified/Created:**
- `lib/auth.ts` - Authentication utilities
- `app/api/auth/route.ts` - Auth API endpoints
- `middleware.ts` - Auth middleware
```

#### context/PRD.md Updates

**Current Status:**
- Update version number if needed
- Update phase status

**Progress Log:**
Add new session entry:
```markdown
### YYYY-MM-DD - Session [N]
**[Phase Name] [Status]:**
- ✅ [Accomplishment 1]
- ✅ [Accomplishment 2]
- ✅ [Key decision made]
- 🎯 **[Phase Status]**
```

**Implementation Plan:**
- Mark completed phases with ✅
- Update current phase progress
- Adjust timeline if needed

**Future Roadmap:**
- Move completed items from future to done
- Add new items discovered

#### context/ARCHITECTURE.md Updates

**If architectural changes:**
- Document new patterns introduced
- Update system design
- Add new dependencies/integrations
- Update data flow if changed

**If no changes:**
- Skip or add note: "No architectural changes this session"

#### context/DECISIONS.md Updates

**For each decision made:**
```markdown
## [Decision Title] - YYYY-MM-DD

**Decision:** What was decided

**Context:** Why this decision was needed

**Alternatives Considered:**
- Option A - Why not chosen
- Option B - Why not chosen

**Trade-offs:**
- Pros: [List]
- Cons: [List]

**When to Reconsider:**
- [Conditions that would make this decision obsolete]
```

**If no decisions:**
- Skip updates

#### context/CODE_STYLE.md Updates

**Rarely needs updates unless:**
- New patterns adopted
- Style rules changed
- Language-specific conventions added

**Most sessions:** Skip this file

#### context/KNOWN_ISSUES.md Updates

**Remove fixed issues:**
- Check git history for fixes
- Remove from appropriate sections
- Note in SESSIONS.md what was fixed

**Add new issues discovered:**
```markdown
## [Issue Title]

**Severity:** Blocking | Non-Critical | Minor

**Description:** What's wrong

**Impact:** What this affects

**Workaround:** Temporary solution (if any)

**Discovered:** YYYY-MM-DD Session [N]
```

**Update priorities:**
- Move blocking → non-critical if partially fixed
- Add to technical debt if deferred

#### context/SESSIONS.md Updates

**Auto-detect session number:**
```bash
# Count existing sessions to determine next number
LAST_SESSION=$(grep -c "^## Session" context/SESSIONS.md)
NEXT_SESSION=$((LAST_SESSION + 1))
echo "Creating Session $NEXT_SESSION entry"
```

**Always add detailed entry:**
```markdown
## Session [N] - YYYY-MM-DD HH:MM

**Duration:** [X] hours

**Focus:** [Main work area]

**Accomplishments:**
- [Detailed list of what was done]
- [Include file paths and line numbers]
- [Note any decisions made]

**Files Modified:**
- `path/to/file.ts:123-145` - [What changed]
- `path/to/file.tsx:67` - [What changed]

**Files Created:**
- `path/to/new-file.ts` - [Purpose]

**Decisions Made:**
- [Link to DECISIONS.md entries]

**Issues Discovered:**
- [Link to KNOWN_ISSUES.md entries]

**Issues Resolved:**
- [What was fixed]

**Work In Progress:**
- [What's incomplete]
- [What to resume next session]

**Next Steps:**
- [Immediate next actions]

**Commands Run:**
- [Key commands executed]

**Notes:**
- [Any other relevant context]
```

#### context/tasks/next-steps.md Updates

**Mark completed actions:**
- Change [ ] to [✅]
- Move to "Completed" section if appropriate

**Add new immediate actions:**
- Based on current state
- Based on issues discovered
- Based on WIP

**Update blockers:**
- Add new blockers
- Remove resolved blockers
- Update status

**Refresh priorities:**
- Reorder based on current goals
- Add urgency markers if needed

#### context/tasks/todo.md Updates

**Current session todos:**
- Mark completed items with ✅
- Add any new items discovered
- Preserve incomplete items for next session

### Step 4: Cross-Check Consistency

Verify documentation tells coherent story:

**Consistency checks:**
- [ ] CLAUDE.md status matches PRD.md status
- [ ] DECISIONS.md choices reflected in ARCHITECTURE.md
- [ ] KNOWN_ISSUES.md blockers mentioned in next-steps.md
- [ ] SESSIONS.md entry matches actual work done
- [ ] All docs tell same story

**If inconsistencies found:**
- Fix them immediately
- Document why inconsistency existed

### Step 5: Capture Work-In-Progress

**Critical for session continuity:**

In SESSIONS.md, explicitly note:
- Exact task in progress when stopped
- Files open and being edited
- Line numbers of current work
- Mental model / approach being used
- Next specific action to take

**Example WIP capture:**
```markdown
**Work In Progress:**
- Implementing JWT refresh logic in `lib/auth.ts`
- Currently at line 145, need to add refresh token validation
- Approach: Using jose library for JWT verification
- Next: Add refresh endpoint at `app/api/auth/refresh/route.ts`
- Mental model: Refresh tokens stored in httpOnly cookie, access tokens in memory
```

### Step 5.5: Write Machine-Readable Artifacts

**Purpose:** Create JSON files for fast agent loading and cross-session memory.

**Write context/state.json:**

Aggregate current project state for fast loading. Use schema at `config/state-schema.json`.

```json
{
  "version": "1.0.0",
  "lastUpdated": "2024-03-15T14:30:00Z",
  "sessionNumber": 12,
  "project": {
    "name": "Project Name",
    "phase": "Phase 2 - Feature Implementation",
    "status": "One-sentence current status"
  },
  "currentFocus": {
    "task": "Implementing JWT refresh logic",
    "description": "Adding refresh token validation and rotation",
    "approach": "Using jose library for JWT verification",
    "nextAction": "Add refresh endpoint at app/api/auth/refresh/route.ts"
  },
  "workInProgress": {
    "active": true,
    "files": [
      {
        "path": "lib/auth.ts",
        "lineNumber": 145,
        "description": "Adding refresh token validation"
      }
    ],
    "context": "Refresh tokens stored in httpOnly cookie, access tokens in memory"
  },
  "blockers": [],
  "recentAccomplishments": [
    {
      "description": "Implemented user authentication system",
      "sessionNumber": 12,
      "files": ["lib/auth.ts", "app/api/auth/route.ts"]
    }
  ],
  "nextSteps": [
    {
      "action": "Complete refresh token implementation",
      "priority": "high",
      "context": "Resume at lib/auth.ts:145"
    }
  ],
  "keyFiles": [
    {
      "path": "lib/auth.ts",
      "purpose": "Authentication utilities",
      "lastModified": "2024-03-15T14:30:00Z"
    }
  ],
  "recentDecisions": [
    {
      "decision": "Use jose library for JWT handling",
      "date": "2024-03-15",
      "rationale": "Better TypeScript support and Web Crypto API integration"
    }
  ],
  "knownIssues": {
    "blocking": 0,
    "nonCritical": 1,
    "minor": 2,
    "topIssues": []
  },
  "technicalDebt": [],
  "metadata": {
    "createdAt": "2024-03-10T10:00:00Z",
    "totalSessions": 12,
    "projectAge": "5 days"
  }
}
```

**Write context/sessions/session-[N].json:**

Create detailed session log. Use schema at `config/session-schema.json`.

```json
{
  "version": "1.0.0",
  "sessionNumber": 12,
  "startTime": "2024-03-15T12:00:00Z",
  "endTime": "2024-03-15T14:30:00Z",
  "duration": {
    "hours": 2.5,
    "minutes": 150,
    "humanReadable": "2.5 hours"
  },
  "focus": "Implementing authentication system",
  "accomplishments": [
    {
      "description": "Created JWT token management utilities",
      "files": ["lib/auth.ts"],
      "lineReferences": [
        {
          "file": "lib/auth.ts",
          "lines": "1-145",
          "change": "Added token generation and validation"
        }
      ]
    }
  ],
  "filesModified": [
    {
      "path": "lib/auth.ts",
      "change": "Added JWT utilities",
      "lineNumbers": "1-145",
      "linesAdded": 145,
      "linesRemoved": 0
    }
  ],
  "filesCreated": [
    {
      "path": "app/api/auth/route.ts",
      "purpose": "Authentication API endpoints",
      "lines": 67
    }
  ],
  "decisionsMade": [
    {
      "decision": "Use jose library instead of jsonwebtoken",
      "rationale": "Better TypeScript support, Web Crypto API",
      "alternatives": ["jsonwebtoken", "auth0/jwt"],
      "documentedIn": "context/DECISIONS.md line 45"
    }
  ],
  "issuesDiscovered": [],
  "issuesResolved": [
    {
      "title": "CORS errors on auth endpoints",
      "solution": "Added CORS headers to middleware",
      "files": ["middleware.ts"]
    }
  ],
  "commandsRun": [
    {
      "command": "npm install jose",
      "purpose": "Add JWT library",
      "result": "Success"
    }
  ],
  "gitActivity": {
    "commits": [
      {
        "hash": "abc123",
        "message": "Add authentication system",
        "filesChanged": 3
      }
    ],
    "branch": "main",
    "pushed": false
  },
  "workInProgress": {
    "active": true,
    "task": "Implementing JWT refresh logic in lib/auth.ts",
    "files": [
      {
        "path": "lib/auth.ts",
        "lineNumber": 145,
        "description": "Adding refresh token validation"
      }
    ],
    "approach": "Using jose library for JWT verification",
    "nextAction": "Add refresh endpoint at app/api/auth/refresh/route.ts"
  },
  "nextSteps": [
    {
      "action": "Complete refresh token implementation",
      "priority": "high"
    }
  ],
  "notes": [
    "Decided on httpOnly cookies for refresh tokens after security review"
  ],
  "metadata": {
    "generatedBy": "/save-context",
    "generatedAt": "2024-03-15T14:30:00Z"
  }
}
```

**Important:**
- Create `context/sessions/` directory if it doesn't exist
- Keep markdown files as primary human-readable source
- JSON provides fast-loading cache for agents
- Validate against schemas in `config/` directory
- Use actual git data where available

### Step 6: Report Updates

Provide clear summary:

```
✅ Context Updated

**Files Updated:**
- CLAUDE.md - Updated critical path, added Session 12 accomplishments
- PRD.md - Session 12 logged, Phase 2 at 60% complete
- DECISIONS.md - Documented JWT library choice
- KNOWN_ISSUES.md - Fixed 2 bugs, added 1 new limitation
- SESSIONS.md - Complete session 12 log with WIP state
- next-steps.md - 3 items completed, 2 new actions added

**Key Changes Captured:**
- Implemented authentication system (auth.ts, API routes)
- Decided to use 'jose' library over 'jsonwebtoken'
- Fixed CORS issue, added new rate limiting concern
- WIP: Refresh token logic at lib/auth.ts:145

**Current Status:** Phase 2 - Authentication (60% complete)

**Next Session:** Resume refresh token implementation
```

## Important Guidelines

### Update Philosophy

**Be thorough but efficient:**
- Update what changed, not everything
- Use git history to catch missed changes
- Focus on material changes, not cosmetic
- Preserve historical information

**Think about the reader:**
- Future Claude instances need full context
- Future you (in weeks) needs to remember why
- New contributors need to understand decisions
- Make it scannable and clear

**Keep it honest:**
- Don't hide issues or technical debt
- Document the "why" behind weird decisions
- Admit when something is hacky or temporary
- Note when you're uncertain

**Maintain narrative:**
- Docs should tell coherent story
- Show progression over time
- Connect decisions to outcomes
- Link related information

### What to Capture

**Always capture:**
- Files modified (with line numbers when significant)
- Decisions made (with reasoning)
- Issues found (with severity)
- Work in progress (with exact state)
- Next immediate actions

**Never skip:**
- SESSIONS.md entry (most important!)
- WIP state (critical for continuity)
- Consistency checks

**Can skip if unchanged:**
- ARCHITECTURE.md (if no design changes)
- CODE_STYLE.md (rarely changes)
- DECISIONS.md (if no decisions made)

## Error Handling

**If files missing:**
- Report which files missing
- Offer to recreate from templates
- Never fail silently

**If can't determine changes:**
- Document uncertainty
- Add TODO markers
- Request user clarification in next session

**If git unavailable:**
- Use file system timestamps
- Analyze file content directly
- Note git history not available

## Success Criteria

Command succeeds when:
- All relevant files updated
- SESSIONS.md has complete entry
- WIP state preserved
- Consistency maintained
- Next session can resume seamlessly
- User knows exactly what was captured

## Time Investment

This command should take:
- 30-60 seconds for routine updates
- 2-3 minutes for major session ends
- 5 minutes for complex multi-feature sessions

**Worth every second** - saves hours of re-explanation later.
