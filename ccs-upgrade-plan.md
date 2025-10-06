# Claude Context System v2.0 Upgrade Plan

**Date:** 2025-10-06
**Current Version:** 1.9.0
**Target Version:** 2.0.0
**Feedback Sources:**
- Real-world usage (Claude Sonnet 4.5 on Podcast Website, 5+ days)
- External evaluation (Codex AI agent assessment)
- Codex review of v2.0 upgrade plan (refinements incorporated)

---

## Executive Summary

The Claude Context System is **fundamentally sound** but suffering from **promise vs. delivery gaps** and **status duplication overhead**. The core philosophy (minimal during work, rich at checkpoints) is validated, but implementation has three critical flaws:

1. **Promised files not auto-generated** - STATUS.md, QUICK_REF.md, CONTEXT.md mentioned in config but never created
2. **Status duplication causes drift** - Same info in 3-4 places, creates maintenance burden and sync issues
3. **SESSIONS.md not scannable** - 800+ lines of prose when structured format would be 10x more useful

**Good news:** The `/code-review` command is "exceptional" (10/10), TodoWrite integration works perfectly, and the two-tier workflow philosophy is validated. We're fixing implementation gaps, not redesigning the system.

---

## What's Working Well (Preserve These)

### ✅ Core Strengths
1. **TodoWrite for active work** - Provides 80% of value during coding, zero overhead
2. **`/code-review` command** - "No changes" rule is liberating, structured output is perfect
3. **Two-tier philosophy** - Quick saves frequently, comprehensive rarely (validated by real usage)
4. **Artifacts output** - Permanent records in `artifacts/code-reviews/` work perfectly
5. **Communication preferences in CLAUDE.md** - Immediately useful for setting tone
6. **Git + Context system complementarity** - Git tracks code, Context tracks reasoning
7. **PRD + Implementation Plan combo** - High-level goals paired with execution roadmap

### ✅ Philosophy Insights (Validated)
- Context system = **backup/insurance mechanism**, not productivity tool
- During work: TodoWrite dominates
- At checkpoints: Rich documentation enables AI review/takeover
- Value proposition: "Session start" tool, not "during work" tool
- Cost-benefit sweet spot: 2-3 min saves frequently, 10-15 min saves rarely

**Quote from feedback:**
> "The system might be optimized for the wrong problem: How often do I lose context? Rarely. How often do I update docs? Frequently. v1.9.0's two-tier answer is smarter."

---

## Critical Issues (Must Fix in v2.0)

### 🔴 Issue 1: Promised Files Not Generated
**Problem:** `.context-config.json` lists `CONTEXT.md`, `STATUS.md`, `QUICK_REF.md`, `DECISIONS.md` as required, but `/init-context` doesn't create them.

**Impact:**
- User confusion ("Where's STATUS.md?")
- Onboarding friction (no quick-orientation doc)
- External agents (like Codex) notice the gap immediately

**Fix:**
- `/init-context` MUST create all files listed in config
- `/save` MUST auto-generate QUICK_REF.md from existing data
- Update templates to match v1.9.0 promises

---

### 🔴 Issue 2: Status Duplication Causes Drift
**Problem:** "Current status" appears in multiple files:
- `CLAUDE.md` (Current Status section)
- `context/tasks/next-steps.md` (Current Focus)
- `context/tasks/todo.md` (active tasks)
- `context/SESSIONS.md` (latest entry)

**Impact:**
- Triple maintenance burden
- Files drift out of sync (e.g., CLAUDE.md says "complete" while todo.md says "in progress")
- External agents can't trust any single source
- User wastes 5-10 min reconciling conflicts

**Real quote:**
> "Same information, three locations = triple maintenance. Feels like overhead rather than value-add."

**Fix:**
- **Single source of truth: STATUS.md**
- Other files **reference** STATUS.md instead of duplicating
- `/save` updates STATUS.md first, then generates references elsewhere
- Automated validation checks for drift and warns user

---

### 🔴 Issue 3: SESSIONS.md Not Scannable
**Problem:** Chronological prose format requires scrolling 800+ lines to find latest session. Hard to extract decisions or scan history.

**Real quote:**
> "Day 4 session entry: 190+ lines of prose. Good for recovery, exhausting to write, hard to scan."

**Impact:**
- High cognitive load during `/save-full`
- External agents struggle to extract "why" behind decisions
- Can't quickly answer "what changed in last 3 sessions?"

**Proposed format:**
```markdown
## Session 2025-10-05D
**Duration:** 2.5h | **Phase:** 1b | **Tasks:** 4.1-4.12 | **Status:** Complete

### Changed
- ✅ Sanity CMS fully integrated
- ✅ Dynamic routing with [slug].astro

### Decisions
- Centralized config per user feedback
- isActive toggle for multi-podcast support

### Files
- NEW: src/lib/sanity.ts, src/config/site.ts
- MODIFIED: all pages fetch from Sanity

### Next Session
Start Task 5.1 (data migration)
```

**Fix:**
- Template with structured sections (Changed/Decisions/Files/Next)
- Scannable bullets, not prose paragraphs
- `/save-full` guides user through structure
- Latest session at TOP (reverse chronological)

---

### 🔴 Issue 4: No Aggregated Decision Log
**Problem:** Architectural decisions and rationale buried in SESSIONS.md prose. No dedicated `DECISIONS.md` despite being promised in v1.9.0.

**Impact:**
- External agents (like Codex) cite this as major gap
- Can't quickly answer "Why did we choose X over Y?"
- AI review/takeover lacks critical context

**Real quote from Codex:**
> "Missing aggregated decision log; architectural and rationale notes exist but are buried inside long session narratives."

**Fix:**
- Create `DECISIONS.md` with structure:
  ```markdown
  ## D-001: Use Sanity CMS (2025-10-04)
  **Decision:** Centralized CMS instead of local markdown
  **Context:** Multi-podcast support, non-technical editing
  **Alternatives:** Local markdown, Contentful, Strapi
  **Tradeoffs:** Hosting cost vs editing UX
  **Status:** Active | **Reconsider if:** <5 podcasts total
  ```
- `/save-full` prompts: "Any decisions to log?"
- Append-only, numbered for referencing

---

### 🔴 Issue 5: Commands Assume Files Exist
**Problem:** `/code-review` says "Read CODE_STYLE.md, ARCHITECTURE.md" but doesn't handle gracefully when missing.

**Real quote:**
> "Command says 'Read CODE_STYLE.md' but these files don't exist (which I documented as issue H3). Should gracefully handle missing context docs."

**Impact:**
- Commands fail or produce incomplete results
- User wastes time troubleshooting
- Confusing error messages

**Fix:**
- All commands check if files exist BEFORE reading
- If missing: Note as finding OR create template
- Example: "CODE_STYLE.md not found. Generated template from codebase patterns observed."

---

### 🟡 Issue 6: No Takeover/Onboarding Guide
**Problem:** New AI agents struggle to understand environment setup, build commands, deployment steps.

**Codex quote:**
> "No checklist confirming environment variables, credentials, or deployment steps for a new operator; relies on reverse engineering."

**Impact:**
- Takeover takes 30-60 min instead of 5-10 min
- High risk of missing critical setup steps

**Fix:**
- New command: `/export-takeover`
- Generates `TAKEOVER.md` with:
  - Environment setup checklist
  - Build/test/deploy commands
  - Current blockers and WIP
  - "Start here" guidance
  - Links to all critical docs

---

### 🟡 Issue 7: Missing Standard Docs
**Problem:** System references ARCHITECTURE.md, CODE_STYLE.md, KNOWN_ISSUES.md but doesn't create them.

**Impact:**
- Commands fail or produce incomplete output
- External reviewers must infer conventions

**Fix:**
- Make these truly optional (not referenced unless they exist)
- OR: `/init-context` creates minimal templates
- Preferred: Optional, created on-demand when complexity demands

---

## Recommendations by Category

### A. File Structure Changes

#### Current (v1.9.0):
```
context/
├── CLAUDE.md           # Everything mixed together
├── PRD.md              # Product vision
├── IMPLEMENTATION_PLAN.md
├── SESSIONS.md         # Prose format
└── tasks/
    ├── next-steps.md   # Status duplicate
    └── todo.md         # Status duplicate
```

#### Proposed (v2.0.0):
```
context/
├── CONTEXT.md          # Orientation (rarely changes) - REPLACES CLAUDE.md
├── STATUS.md           # Current state (single source of truth) - NEW
├── DECISIONS.md        # Decision log (append-only) - NEW
├── SESSIONS.md         # History (structured format) - REFORMATTED
├── QUICK_REF.md        # Auto-generated dashboard - AUTO-GENERATED
├── PRD.md              # Product vision (optional, on-demand)
├── ARCHITECTURE.md     # System design (optional, on-demand)
├── CODE_STYLE.md       # Conventions (optional, on-demand)
└── KNOWN_ISSUES.md     # Bug/tech debt tracking (optional, on-demand)
```

**Migration path:**
- CLAUDE.md → CONTEXT.md (preserve custom sections)
- Extract current status → STATUS.md
- Extract decisions → DECISIONS.md
- Reformat SESSIONS.md → structured format
- Merge next-steps.md → STATUS.md (preserve user notes)
- Optional: Keep todo.md OR migrate to STATUS.md (user choice)

---

### B. Command Changes

#### `/init-context` (Modified)
**Current behavior:** Creates CLAUDE.md, tasks/ folder
**New behavior:**
1. Create 3 core files: CONTEXT.md, STATUS.md, DECISIONS.md
2. Create SESSIONS.md with structured template
3. Auto-generate QUICK_REF.md
4. Create .context-config.json
5. Create artifacts/ folders
6. Suggest optional files (PRD, ARCHITECTURE) if complexity detected

#### `/save` (Enhanced)
**Current behavior:** Updates what changed
**New behavior:**
1. Update STATUS.md (single source of truth)
2. Append to SESSIONS.md (structured format, prompts for Changed/Decisions/Files)
3. Auto-generate QUICK_REF.md from STATUS.md data
4. Validate no drift (check consistency)
5. Time budget: 2-3 minutes

#### `/save-full` (Enhanced)
**Current behavior:** Comprehensive update
**New behavior:**
1. Everything `/save` does
2. Prompt for DECISIONS.md entries
3. Update CONTEXT.md if architecture changed
4. Capture mental models and reasoning
5. Suggest creating optional docs if complexity increased
6. Time budget: 10-15 minutes

#### `/code-review` (Fixed)
**Current behavior:** Assumes context docs exist
**New behavior:**
1. Check if context docs exist before reading
2. If missing: Create templates from observed patterns
3. Report missing docs as finding
4. Graceful degradation (review completes even if docs missing)

#### `/review-context` (Enhanced)
**Current behavior:** Verify documentation current
**New behavior:**
1. Show QUICK_REF.md dashboard
2. Check for status drift (STATUS.md vs SESSIONS.md vs git)
3. Validate all required files exist
4. Report health score and gaps
5. Suggest running `/save` if stale

#### `/export-takeover` (NEW)
**Purpose:** Generate handoff guide for new agents/developers
**Behavior:**
1. Create TAKEOVER.md with:
   - Environment setup checklist
   - Build/test/deploy commands
   - Current work-in-progress
   - Known blockers
   - "Start here" guidance
   - Links to key docs
2. Package for sharing (single markdown file)
3. Time budget: 3-5 minutes

#### `/validate-context` (Enhanced)
**Current behavior:** Check structure
**New behavior:**
1. Check all required files exist
2. Validate STATUS.md is source of truth (no drift)
3. Check SESSIONS.md uses structured format
4. Confirm QUICK_REF.md is current
5. Report health score (0-100)
6. Provide actionable fix suggestions

---

### C. Template Changes

#### CONTEXT.md Template (replaces CLAUDE.md)
```markdown
# Context: [Project Name]

> **Quick Links:** See [QUICK_REF.md](./QUICK_REF.md) for current status

## Identity
- **What:** [One-line description]
- **Who:** [Target users/audience]
- **Why:** [Core problem solved]

## Tech Stack
[List technologies]

## Architecture
[High-level system design, OR link to ARCHITECTURE.md]

## Communication Preferences
- Tone: [Concise/verbose/etc]
- Code style: [Link to CODE_STYLE.md or inline]
- Approval checkpoints: [When to ask vs. proceed]

## Workflow
- Planning: [Process]
- Testing: [Requirements]
- Deployment: [Process]

## Anti-Patterns
[Things to avoid]

## Commands
[Common commands for this project]

---
**Current Status:** See [STATUS.md](./STATUS.md)
**History:** See [SESSIONS.md](./SESSIONS.md)
**Decisions:** See [DECISIONS.md](./DECISIONS.md)
```

#### STATUS.md Template (NEW)
```markdown
# Status: [Project Name]

> **Last Updated:** 2025-10-06 14:30 (Session 2025-10-06F)
> **Auto-generated dashboard:** [QUICK_REF.md](./QUICK_REF.md)

## Current Phase
**Phase 1b: Polish & QA** (Day 5-10)

## Active Tasks
- [ ] 5.1 Data migration scripts
- [ ] 5.2 Guest bio scraping
- [x] 4.12 Code review fixes

## Blockers
- None currently

## Recent Decisions
- D-003: Centralized config (2025-10-05) - See [DECISIONS.md](./DECISIONS.md#d-003)
- D-002: Multi-podcast support (2025-10-04)

## Next Session
- Start Task 5.3 (automated episode linking)
- Test data migration end-to-end

## Work In Progress
- None currently

---
**Health:** ✅ On track
**Last Session:** [SESSIONS.md](./SESSIONS.md) (2025-10-06F)
```

#### DECISIONS.md Template (NEW)
```markdown
# Decisions: [Project Name]

> Append-only log of architectural decisions and rationale

## D-003: Centralized Site Config (2025-10-05)
**Decision:** Create `src/config/site.ts` for all site-wide settings
**Context:** Settings scattered across 5+ files, hard to maintain
**Alternatives Considered:**
- Leave scattered (rejected: maintenance burden)
- Environment variables (rejected: not all settings are secrets)
**Tradeoffs:**
- PRO: Single source of truth, easy to find/update
- CON: Extra abstraction layer
**Status:** ✅ Active
**Reconsider if:** Settings become environment-specific (dev vs prod)

## D-002: Multi-Podcast Sanity Schema (2025-10-04)
**Decision:** Use `isActive` flag + slug-based filtering for multi-podcast support
**Context:** Framework will support multiple podcasts, need CMS flexibility
**Alternatives Considered:**
- Separate Sanity projects per podcast (rejected: cost)
- Hardcode single podcast (rejected: defeats framework purpose)
**Tradeoffs:**
- PRO: Flexible, cost-effective, simple filtering
- CON: All podcasts share same Sanity project (permissions)
**Status:** ✅ Active
**Reconsider if:** Need strict podcast isolation or >10 podcasts

## D-001: Choose Sanity CMS (2025-10-03)
**Decision:** Sanity CMS for content management
**Context:** Need non-technical editing, structured content
**Alternatives Considered:**
- Local markdown files (rejected: no GUI)
- Contentful (rejected: cost at scale)
- Strapi (rejected: self-hosting complexity)
**Tradeoffs:**
- PRO: Excellent DX, real-time preview, free tier generous
- CON: Vendor lock-in, costs at scale
**Status:** ✅ Active
**Reconsider if:** <5 podcasts total OR need offline editing
```

#### SESSIONS.md Template (REFORMATTED)
```markdown
# Sessions: [Project Name]

> Structured session history (reverse chronological)

---

## Session 2025-10-06F
**Duration:** 1.5h | **Phase:** 1b | **Tasks:** Code review fixes | **Status:** Complete

### Changed
- ✅ Fixed hardcoded Sanity project ID (now uses env var)
- ✅ Added error boundaries to episode pages
- ✅ Implemented responsive images with optimization

### Decisions
- D-004: Use Astro Image component for automatic optimization

### Files
- MODIFIED: src/lib/sanity.ts (env var for project ID)
- NEW: src/components/ErrorBoundary.astro
- MODIFIED: src/pages/episodes/[slug].astro (responsive images)

### Metrics
- Lighthouse score: 95 → 98
- Build time: 12s (unchanged)
- 3 critical issues resolved

### Next Session
- Start Task 5.1 (data migration scripts)
- Test Sanity content import workflow

---

## Session 2025-10-05D
**Duration:** 2.5h | **Phase:** 1b | **Tasks:** 4.1-4.12 | **Status:** Complete

### Changed
- ✅ Sanity CMS fully integrated
- ✅ Dynamic routing with [slug].astro
- ✅ Episode detail pages with rich media
- ✅ Guest profiles auto-populated

### Decisions
- D-003: Centralized site config (maintenance burden reduction)
- D-002: isActive toggle for multi-podcast support

### Files
- NEW: src/lib/sanity.ts, src/config/site.ts
- MODIFIED: src/pages/episodes/[slug].astro, src/pages/index.astro
- MODIFIED: All pages now fetch from Sanity

### Metrics
- 127 episodes imported
- 45 guest profiles created
- Lighthouse: 95/100

### Next Session
- Run comprehensive code review
- Address any critical issues found

---

[Earlier sessions continue in reverse chronological order...]
```

#### QUICK_REF.md Template (AUTO-GENERATED)
```markdown
# Quick Reference: [Project Name]

> **Auto-generated** by `/save` from [STATUS.md](./STATUS.md)
> Last updated: 2025-10-06 14:30

## Current Status
📍 **Phase:** 1b - Polish & QA (Day 5-10)
⏱️ **Progress:** 45% complete (27/60 days)
   - Calculation: completed_tasks / total_tasks from STATUS.md
   - Source: IMPLEMENTATION_PLAN.md task count (if exists) OR STATUS.md checkboxes
✅ **Health:** On track

## Active Work
- [ ] Task 5.1: Data migration scripts
- [ ] Task 5.2: Guest bio scraping

## Tech Stack
- **Framework:** Astro 4.0
- **CMS:** Sanity.io
- **Styling:** Tailwind CSS
- **Deployment:** Netlify

## Environment
- **Local:** http://localhost:4321
- **Sanity Studio:** http://localhost:3333
- **Staging:** https://staging.strangewater.xyz
- **Production:** (not deployed)

## Quick Links
- [Full Context](./CONTEXT.md) - Project orientation
- [Current Status](./STATUS.md) - Detailed state
- [Session History](./SESSIONS.md) - What happened when
- [Decisions](./DECISIONS.md) - Why we made choices
- [Latest Code Review](../artifacts/code-reviews/session-6-review.md)

## Blockers
None currently

## Next Steps
Start Task 5.3 (automated episode linking) in next session
```

---

### D. Automated Consistency Checks

Add validation to `/save` that checks:

1. **Status Consistency**
   - STATUS.md marks task complete → SESSIONS.md latest entry references it
   - No conflicting status across different files

2. **Required Files Exist**
   - CONTEXT.md, STATUS.md, DECISIONS.md, SESSIONS.md present
   - Warn if missing

3. **QUICK_REF.md Current**
   - Regenerated on every `/save`
   - Timestamp matches STATUS.md timestamp

4. **Timestamps Aligned**
   - Latest SESSIONS.md entry ≤ STATUS.md last updated
   - If drift detected, warn user

5. **Decision References Valid**
   - STATUS.md references to DECISIONS.md (e.g., "D-003") exist
   - No broken links

**Output format:**
```
✅ Status consistency check passed
✅ All required files present
✅ QUICK_REF.md regenerated
⚠️  Warning: SESSIONS.md latest entry is 2 hours older than STATUS.md
   Recommendation: Run /save-full to sync session history
```

---

### E. Migration Path for Existing Projects

When user runs `/update-context-system` with v2.0.0:

1. **Detect current structure**
   - Find CLAUDE.md, next-steps.md, todo.md, SESSIONS.md
   - Analyze format (prose vs structured)
   - Identify custom sections in CLAUDE.md

2. **Dry-run analysis**
   ```
   Migration Preview (Dry Run):

   Will preserve:
   - Custom section "Team Contacts" in CLAUDE.md
   - User notes in next-steps.md (5 inline comments)
   - Active tasks in todo.md (3 items)

   Will transform:
   - CLAUDE.md → CONTEXT.md (custom sections → "Legacy Notes")
   - Current Status → STATUS.md
   - 12 decisions extracted → DECISIONS.md
   - SESSIONS.md → structured format (8 sessions)

   Will create:
   - QUICK_REF.md (auto-generated)

   Proceed with migration? [Y/n/dry-run]
   ```

3. **User choices**
   ```
   Migration Options:

   1. Keep tasks/todo.md alongside STATUS.md? [Y/n]
      - Y: todo.md preserved, STATUS.md references it
      - N: todo.md merged into STATUS.md, then deleted

   2. Handle custom CLAUDE.md sections?
      - Preserve as "Legacy Notes" in CONTEXT.md [default]
      - Manual review required [M]
   ```

4. **Perform migration with safeguards**
   - **Backup first:** Create `context/.backup-pre-v2-[timestamp]/` with ALL old files
   - **Content preservation:**
     - Scan CLAUDE.md for sections not in template
     - Append unmatched sections under "## Legacy Notes" in CONTEXT.md
     - Flag for user review: "⚠️ Custom sections preserved in CONTEXT.md - review recommended"
   - **Extract and transform:**
     - "Current Status" section → STATUS.md
     - Parse SESSIONS.md for decisions (look for keywords: "decided", "chose", "selected") → DECISIONS.md
     - User notes in next-steps.md → STATUS.md "## Notes" section
   - **Optional todo.md handling:**
     - If keep: Leave todo.md, add note in STATUS.md: "See tasks/todo.md for detailed checklist"
     - If migrate: Parse checkboxes → STATUS.md "## Active Tasks", preserve inline notes
   - **Reformat SESSIONS.md:** Convert prose → structured template, preserve all content
   - **Generate QUICK_REF.md** from STATUS.md data

5. **Validation with reporting**
   - Run `/validate-context` automatically
   - Report:
     ```
     Migration Complete ✅

     Created:
     - context/CONTEXT.md (with 2 legacy sections preserved)
     - context/STATUS.md (12 active tasks migrated)
     - context/DECISIONS.md (8 decisions extracted)
     - context/QUICK_REF.md (auto-generated)

     Preserved:
     - tasks/todo.md (per your choice)
     - All custom CLAUDE.md sections → CONTEXT.md

     Backup:
     - context/.backup-pre-v2-20251006143022/

     ⚠️ Action Required:
     - Review "Legacy Notes" in CONTEXT.md
     - Verify decisions in DECISIONS.md are accurate

     Run /review-context to verify migration
     ```
   - Provide manual fix guidance if issues detected

6. **Rollback mechanism**
   - Command: `/rollback-migration`
   - Restores from `context/.backup-pre-v2-[timestamp]/`
   - Deletes new v2.0 files
   - User confirms before rollback executes

---

### F. Command Acceptance Tests

To prevent regressions during implementation, each updated command must pass acceptance tests:

#### `/init-context` Acceptance Tests
```
✅ Creates CONTEXT.md with all required sections
✅ Creates STATUS.md with task checkboxes
✅ Creates DECISIONS.md with example decision entry
✅ Creates SESSIONS.md with structured template
✅ Auto-generates QUICK_REF.md from STATUS.md
✅ Creates .context-config.json with correct schema
✅ Creates artifacts/ folder structure
✅ Suggests optional files (PRD, ARCHITECTURE) if project has >1000 LOC
```

#### `/save` Acceptance Tests
```
✅ Updates STATUS.md timestamp and task status
✅ Appends structured entry to SESSIONS.md (not prose)
✅ Regenerates QUICK_REF.md with current data
✅ Progress % calculated correctly (completed_tasks / total_tasks)
✅ Consistency validation runs and reports drift if detected
✅ Completes in <3 minutes (user-timed)
✅ Captures TodoWrite state if active
✅ No duplicate information across files
```

#### `/save-full` Acceptance Tests
```
✅ Everything /save does
✅ Prompts for DECISIONS.md entries if architectural changes detected
✅ Auto-increments decision counter in .context-config.json
✅ Updates CONTEXT.md if architecture section changed
✅ Captures mental models in SESSIONS.md "Metrics" or "Notes" section
✅ Suggests creating PRD.md if product scope expanded
✅ Suggests creating ARCHITECTURE.md if system complexity increased
✅ Completes in <15 minutes (user-timed)
```

#### `/code-review` Acceptance Tests
```
✅ Checks if CONTEXT.md, CODE_STYLE.md, ARCHITECTURE.md exist before reading
✅ If missing: Notes as finding, generates template from codebase patterns
✅ Completes review even if context docs missing (graceful degradation)
✅ Outputs to artifacts/code-reviews/session-N-review.md
✅ Review includes severity levels (Critical/High/Medium/Low)
✅ Review includes effort estimates
✅ NEVER makes code changes during review
✅ Provides actionable suggestions with code examples
```

#### `/review-context` Acceptance Tests
```
✅ Displays QUICK_REF.md dashboard first
✅ Checks STATUS.md vs SESSIONS.md timestamp alignment (warns if >24h drift)
✅ Validates all required files exist (CONTEXT.md, STATUS.md, DECISIONS.md, SESSIONS.md)
✅ Reports health score (0-100)
✅ Lists any gaps (missing sections, empty placeholders)
✅ Suggests running /save if STATUS.md >2 days stale
✅ Checks git status for uncommitted changes
```

#### `/validate-context` Acceptance Tests
```
✅ Checks all required files exist
✅ Validates STATUS.md is single source of truth (no contradictions in other files)
✅ Checks SESSIONS.md uses structured format (not prose)
✅ Confirms QUICK_REF.md timestamp matches STATUS.md
✅ Validates decision references (D-001, D-002) exist in DECISIONS.md
✅ Reports health score with breakdown (files: 100%, consistency: 95%, structure: 90% = 95% overall)
✅ Provides actionable fix suggestions (specific line/file to edit)
```

#### `/export-takeover` Acceptance Tests
```
✅ Creates TAKEOVER.md with environment setup checklist
✅ Includes build/test/deploy commands from CONTEXT.md
✅ Lists current WIP from STATUS.md
✅ Lists known blockers from STATUS.md
✅ Provides "Start here" guidance (read QUICK_REF.md → STATUS.md → SESSIONS.md latest)
✅ Links to all critical docs
✅ Outputs to artifacts/TAKEOVER-[timestamp].md
✅ Completes in <5 minutes
```

#### `/update-context-system` Migration Acceptance Tests
```
✅ Dry-run mode shows preview without making changes
✅ Identifies custom sections in CLAUDE.md
✅ User choice: Keep todo.md or migrate to STATUS.md
✅ Backup created at context/.backup-pre-v2-[timestamp]/
✅ Custom CLAUDE.md sections preserved in CONTEXT.md "Legacy Notes"
✅ User notes in next-steps.md preserved in STATUS.md
✅ SESSIONS.md decisions extracted to DECISIONS.md (keyword search)
✅ SESSIONS.md reformatted to structured template
✅ QUICK_REF.md generated from new STATUS.md
✅ Migration report shows what was preserved/transformed/created
✅ /validate-context runs automatically post-migration
✅ Rollback available via /rollback-migration command
✅ ZERO data loss (all original content in backup or migrated files)
```

---

## Implementation Plan

### Phase 1: Core File Structure (Week 1)
**Priority:** 🔴 Critical

- [ ] Create CONTEXT.md template (replace CLAUDE.md)
- [ ] Create STATUS.md template
- [ ] Create DECISIONS.md template
- [ ] Create structured SESSIONS.md template
- [ ] Create auto-generated QUICK_REF.md template
- [ ] Update .context-config.json schema
- [ ] Update all command prompts to reference new file names

**Validation:**
- `/init-context` creates all 5 core files
- Templates match feedback recommendations

### Phase 2: Command Updates (Week 2)
**Priority:** 🔴 Critical

- [ ] Update `/init-context` to create new structure
- [ ] Update `/save` to:
  - Update STATUS.md as source of truth
  - Append structured entry to SESSIONS.md
  - Auto-generate QUICK_REF.md
  - Validate consistency
- [ ] Update `/save-full` to:
  - Everything `/save` does
  - Prompt for DECISIONS.md entries
  - Capture mental models
- [ ] Update `/code-review` to handle missing files gracefully
- [ ] Update `/review-context` to show QUICK_REF.md and check drift
- [ ] Update `/validate-context` with new consistency checks

**Validation:**
- All commands work with new file structure
- Missing files handled gracefully
- Consistency checks catch drift

### Phase 3: New Commands (Week 3)
**Priority:** 🟡 High

- [ ] Create `/export-takeover` command
- [ ] Create TAKEOVER.md template
- [ ] Test takeover workflow with external AI agent

**Validation:**
- New agent can onboard in <10 minutes using TAKEOVER.md

### Phase 4: Migration System (Week 4)
**Priority:** 🟡 High

- [ ] Add v1.9 → v2.0 migration to `/update-context-system`
- [ ] Create migration script
- [ ] Test on 3+ real projects
- [ ] Document migration process
- [ ] Create backup/rollback mechanism

**Validation:**
- Existing projects migrate cleanly
- No data loss
- User can rollback if needed

### Phase 5: Documentation (Week 5)
**Priority:** 🟡 Medium

- [ ] Update README.md for v2.0
- [ ] Update SETUP_GUIDE.md
- [ ] Create MIGRATION_GUIDE.md
- [ ] Update all .claude/docs/ guides
- [ ] Update PRD.md with v2.0 philosophy
- [ ] Create CHANGELOG.md entry

**Validation:**
- Documentation matches implementation
- Users can understand changes

### Phase 6: Polish & Testing (Week 6)
**Priority:** 🟢 Low

- [ ] Real-world testing on 5+ projects
- [ ] Collect feedback
- [ ] Fix bugs
- [ ] Performance optimization
- [ ] Add command acceptance tests (see Acceptance Tests section)
- [ ] Add analytics (how often commands used, success rate)

**Validation:**
- No critical bugs
- All acceptance tests pass
- User feedback positive
- Success metrics met

### Phase 7: Post-Launch Monitoring (Months 1-3)
**Priority:** 🟡 High

- [ ] Collect usage metrics (command frequency, `/save` duration, error rates)
- [ ] Monitor success metrics (onboarding speed, status accuracy, maintenance time)
- [ ] Bi-weekly feedback review (GitHub issues, user reports)
- [ ] Iterate on pain points (prioritize by frequency)
- [ ] Release v2.1 with refinements based on real-world usage

**Metrics to track:**
- `/save` average duration (target: 2-3 min)
- `/save-full` average duration (target: 10-15 min)
- Consistency check pass rate (target: 95%+)
- Migration success rate (target: 100% with no data loss)
- User retention (target: 80%+ continue using after 1 month)

**Feedback loop:**
- Weekly: Review automated metrics dashboard
- Bi-weekly: Prioritize top 3 pain points for fixes
- Monthly: Release patch with improvements
- Quarterly: Major version update (v2.1, v2.2, etc.)

---

## Success Metrics

### Primary Metrics
1. **Onboarding speed:** New agent can orient in <5 minutes (vs. 30+ currently)
   - Measured: Time from opening project to first code contribution (external AI agent test)
2. **Status accuracy:** Zero drift between STATUS.md and other files (validated by checks)
   - Measured: `/validate-context` drift detection rate (target: <5% warnings)
3. **Maintenance time:** `/save` averages 2-3 minutes (vs. 5-10 currently)
   - Measured: Instrumentation in `/save` command (start time to completion)
   - Logged to `.context-config.json` → `{ "saveMetrics": { "avgDuration": 165 } }`
4. **Scan time:** Find latest session info in <30 seconds (vs. scrolling 800 lines)
   - Measured: User testing (5 users, timed task: "What was the last thing done?")

### Validation Metrics
1. **External AI evaluation:** Codex or similar re-evaluates project, reports 8/10+ for takeover readiness
2. **User feedback:** "Status duplication" pain point resolved
3. **File count:** No missing files warnings in `/validate-context`
4. **Consistency:** 95%+ of `/save` runs pass all consistency checks

### User Satisfaction
- Quote target: "v2.0 cut my documentation time in half while improving quality"
- Adoption: 80%+ of existing users migrate to v2.0 within 3 months
- Retention: Users continue using `/save` regularly (2+ times per week)

---

## Risks & Mitigations

### Risk 1: Breaking Changes
**Risk:** v2.0 breaks existing projects
**Mitigation:**
- Automatic migration with backup
- Rollback mechanism
- Gradual rollout (beta testers first)

### Risk 2: Increased Complexity
**Risk:** Adding more files/checks makes system harder to use
**Mitigation:**
- Auto-generation reduces manual work (QUICK_REF.md)
- Consistency checks catch issues automatically
- Each file has clear, singular purpose

### Risk 3: Migration Pain
**Risk:** Users resist migrating due to effort
**Mitigation:**
- One-command migration (`/update-context-system --migrate`)
- Clear value proposition (status consistency, faster saves)
- Migration takes 5-10 min, saves hours over project lifetime

### Risk 4: Status Validation False Positives
**Risk:** Consistency checks flag issues that aren't real problems
**Mitigation:**
- Conservative validation (only flag clear drift)
- User can override with `--skip-validation` flag
- Iterate based on feedback

### Risk 5: Data Loss During Migration
**Risk:** Custom content in CLAUDE.md, next-steps.md, todo.md lost during migration
**Mitigation:**
- Dry-run mode shows exactly what will be preserved/transformed
- Automatic backup to `.backup-pre-v2-[timestamp]/`
- Legacy notes section preserves unmatched content
- Rollback command available
- Migration tested on 10+ real projects before release

### Risk 6: TodoWrite Dependency
**Risk:** Removing todo.md forces users to adopt TodoWrite workflow
**Mitigation:**
- Make todo.md optional during migration (user choice)
- If kept: STATUS.md references it, no forced workflow change
- Document both workflows (TodoWrite vs markdown checklist)

### Risk 7: Git Diff Noise
**Risk:** Reverse-chronological SESSIONS.md causes every new session to edit top of file, making git diffs noisy
**Mitigation:**
- Accept this tradeoff (single file simpler than session-per-file)
- Git handles it fine (only shows changed lines)
- Benefits (scannability, single file) outweigh diff noise
- Optional: Consider session-per-file in future if users report pain

---

## Open Questions

1. **CONTEXT.md vs CLAUDE.md naming:**
   - Migrate all projects to CONTEXT.md, or support both?
   - **Recommendation:** Migrate to CONTEXT.md (clearer purpose)

2. **STATUS.md update frequency:**
   - Every `/save` or only `/save-full`?
   - **Recommendation:** Every `/save` (it's the source of truth)

3. **DECISIONS.md numbering:**
   - Manual (user assigns D-001) or auto (system increments)?
   - **Recommendation:** Auto-increment (less friction)
   - **Algorithm:** Counter stored in `.context-config.json` → `{ "nextDecisionId": 5 }`
   - On each `/save-full` that adds decision: read counter, use it, increment, save back
   - Conflict resolution (rare, collaborative repos): Use timestamp if counter collision detected

4. **QUICK_REF.md location:**
   - `context/QUICK_REF.md` or root `QUICK_REF.md`?
   - **Recommendation:** `context/QUICK_REF.md` (keeps context/ self-contained)

5. **Optional docs creation:**
   - Offer to create PRD.md, ARCHITECTURE.md during `/save-full` if complexity detected?
   - **Recommendation:** Yes, but only when genuinely needed (check LOC, file count, etc.)

6. **TodoWrite integration:**
   - Should `/save` capture TodoWrite state automatically?
   - **Recommendation:** Yes, append to STATUS.md as "Work in Progress" section

---

## Timeline

**REVISED:** Based on real-world constraints and feedback:

- **✅ Week 1 (DONE):** Core file structure (templates, config, command docs)
- **📋 Week 2-4:** v2.0.0 Release (manual migration)
  - Templates ready ✓
  - Command documentation updated ✓
  - Migration guide written ✓
  - Release v2.0.0 with manual migration path
- **Week 5-8:** v2.1.0 Development (automated migration)
  - Implement migration script with dry-run
  - Add backup/rollback mechanisms
  - Test on 10+ real projects
  - Release v2.1.0 with automated migration
- **Months 2-3:** v2.2+ iterations based on feedback

**Actual Release Plan:**
- **v2.0.0 (Now):** New structure, templates, manual migration
- **v2.1.0 (3-4 weeks):** Automated migration with safety features
- **v2.2+ (Ongoing):** Refinements based on user feedback

**Why Split the Release:**
1. Get new structure into users' hands faster
2. Manual migration forces understanding of changes
3. Time to test automation thoroughly (10+ projects)
4. Gather feedback on v2.0 structure before automating migration

---

## Implementation Status

### ✅ Completed (v2.0.0)

1. **File Structure & Templates**
   - CONTEXT.md, STATUS.md, DECISIONS.md, SESSIONS.md, QUICK_REF.md templates exist and aligned
   - Config schema updated to v2.0.0 (counters, metrics, required files list)
   - All templates follow structured format from upgrade plan

2. **Command Documentation**
   - `/init-context` - Updated to create 5 core files
   - `/review-context` - Updated for v2.0 file structure
   - `/validate-context` - Updated for v2.0 validation
   - `/export-context` - Updated with backward compatibility
   - `/save` and `/save-full` - Already correct for STATUS.md
   - `/update-context-system` - Updated to guide manual migration

3. **Documentation**
   - README.md - v2.0.0 features and migration status
   - CHANGELOG.md - Complete v2.0.0 entry
   - MIGRATION_GUIDE.md - Manual migration steps
   - ccs-upgrade-plan.md - Full rationale

4. **Consistency Fixes**
   - All file references updated (CLAUDE.md → CONTEXT.md)
   - File count descriptions accurate (5 core files)
   - Version numbers consistent across all docs

### 📋 Deferred to v2.1.0 (3-4 weeks)

1. **Automated Migration**
   - Create `migrate-to-2-0-0.sh` script
   - Implement dry-run mode
   - Add backup/rollback mechanisms
   - Test on 10+ real projects

2. **New Commands**
   - `/export-takeover` - Onboarding guide generation
   - `/rollback-migration` - Safety mechanism

3. **Acceptance Tests**
   - Per-command validation criteria
   - Regression prevention

### 🔄 Ongoing (v2.2+)

- Post-launch monitoring
- User feedback integration
- Iterative improvements

---

## Next Steps for v2.0.0 Release

1. ✅ Templates and config ready
2. ✅ Command documentation updated
3. ✅ Consistency fixes applied
4. **→ Push to GitHub (ready)**
5. **→ Test on new project with `/init-context`**
6. **→ Document known limitations (manual migration)**
7. **→ Gather user feedback for v2.1**

---

## Conclusion

v2.0.0 is **evolutionary, not revolutionary**. We're fixing implementation gaps that real-world usage exposed:

1. ✅ Deliver the files we promised (STATUS.md, QUICK_REF.md, CONTEXT.md, DECISIONS.md)
2. ✅ Eliminate status duplication (single source of truth: STATUS.md)
3. ✅ Make SESSIONS.md scannable (structured format)
4. ✅ Handle missing files gracefully (all commands)
5. 📋 Enable fast takeover (deferred to v2.1: `/export-takeover` command)

The core philosophy (TodoWrite for work, rich docs for checkpoints) is validated and preserved. We're making the system deliver on its promises without adding complexity.

**v2.0.0 Scope:**
- New file structure defined and templates ready
- Command documentation updated
- Manual migration path documented
- Foundation for automated migration in v2.1

**v2.1.0 Scope (Next):**
- Automated migration with dry-run/backup/rollback
- New commands (/export-takeover, /rollback-migration)
- Extensive testing on real projects
- Acceptance test suite

**Bottom line:** Same great philosophy, better execution. Releasing v2.0.0 now to get structure feedback, automating migration in v2.1.
