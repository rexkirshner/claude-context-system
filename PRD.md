# PRD: Claude Context System

## Executive Summary

**Product Name:** Claude Context System
**Version:** 1.7.0
**Owner:** Rex Kirshner
**Status:** Active Development
**Last Updated:** 2025-10-05

### What Changed in v1.7.0

**Real-world feedback** revealed the comprehensive 8-file approach felt overengineered:
- ✅ SESSIONS.md + CLAUDE.md provided 80% of value
- ❌ Other files felt like "documentation for documentation's sake"
- ❌ 50-step save process felt bureaucratic

**v1.7.0 Response: Progressive Enhancement**
- Start minimal (3 core files)
- Grow naturally when complexity demands
- Intelligent updates (not checklists)
- Reference guides (not rigid processes)

### Problem Statement

When working with Claude Code across multiple sessions, critical context is lost including:
- Current work state and progress
- Technical decisions and rationale
- User-specific preferences and workflows
- Project architecture understanding
- Known issues and limitations
- Work history and session logs

This leads to:
- Repeated explanations of project state
- Lost work when sessions end unexpectedly
- Inconsistent approaches between sessions
- Time wasted re-establishing context
- Risk of contradicting previous decisions

### Solution

A systematic context management system that:
- Preserves complete project state between sessions
- Maintains comprehensive documentation automatically
- Enables seamless session continuity
- Enforces consistent workflows and preferences
- Tracks all work history and decisions

---

## User Personas

### Primary User: Rex (Power Developer)
- Works on multiple complex projects simultaneously
- Has specific workflow preferences (no lazy coding, simplicity first)
- Needs perfect session continuity
- Values efficiency and hates repetition
- Requires high trust in AI maintaining context

### Secondary Users: Other Claude Code Users
- May adapt system for their own preferences
- Need customizable workflows
- Want session continuity but with different styles

---

## Core Requirements

### Functional Requirements

#### 1. Command System

The system provides **ten slash commands** available in every project:

**Setup Commands (run once):**

**`/init-context`** (Minimal Mode - v1.7.0+)
- Creates context/ folder structure with **3 core files**
- Analyzes existing project
- Creates configuration file
- Explains progressive enhancement
- Recommended for most projects

**`/init-context-full`** (Comprehensive Mode - v1.7.0+)
- Creates all 8 documentation files upfront
- Same as old /init-context behavior
- Use when complexity is known from day one
- Most projects should start with /init-context instead

**`/migrate-context`**
- Migrates existing projects with documentation
- Preserves all existing content
- Organizes into context/ and artifacts/ folders
- Augments existing docs with new sections

**Maintenance Commands (run frequently):**

**`/save-context`** (Intelligent Updates - v1.7.0+)
- **Writes good session summary** (SESSIONS.md - always)
- **Updates only what changed** (not everything)
- **Suggests new files** when complexity demands it
- Preserves work-in-progress
- No bureaucratic process - smart documentation
- Run after major work

**`/quick-save-context`**
- Lightweight checkpoint for active work
- Updates SESSIONS.md and tasks/ only
- Fast (~5 seconds)
- Run every 15-30 minutes during coding

**`/review-context`**
- Verifies documentation accuracy
- Checks for inconsistencies
- Confirms session continuity
- Reports gaps or issues
- Run at session start

**Quality & Sharing Commands:**

**`/code-review`**
- Comprehensive code quality audit
- NO changes during review
- Generates detailed report
- Suggests improvements separately
- Run when quality matters

**`/validate-context`**
- Validates documentation structure
- Flags missing sections and placeholders
- Reports health score
- Run to check documentation health

**`/export-context`**
- Combines all context docs into single file
- Generates table of contents
- Perfect for team handoffs or backups

**Update Commands:**

**`/update-context-system`**
- Updates slash commands from GitHub
- Optionally updates context file templates
- Interactive or automatic mode
- Run periodically for latest improvements

#### 2. Documentation System

**Required Files (in context/ folder):**

| File | Purpose | Updated |
|------|---------|---------|
| CLAUDE.md | Developer guide + user preferences | Every session |
| PRD.md | Product requirements & roadmap | Major milestones |
| ARCHITECTURE.md | Technical design & system structure | Design changes |
| DECISIONS.md | Technical decisions & rationale | When decisions made |
| CODE_STYLE.md | Coding standards & principles | Rarely |
| KNOWN_ISSUES.md | Current problems & limitations | As issues found/fixed |
| SESSIONS.md | Detailed session-by-session log | Every session |
| tasks/next-steps.md | Action items & priorities | Every session |
| tasks/todo.md | Current session work items | During session |

#### 3. Configuration System

**.context-config.json** stores:
- User preferences (workflow, communication style)
- Documentation settings (location, frequency)
- Command configuration (enabled commands, aliases)
- Template preferences

#### 4. Workflow Enforcement

System enforces Rex's core principles:
- Never push to GitHub without explicit approval
- Always find root causes, no temporary fixes
- Make simplest possible changes
- Test before committing
- Provide high-level summaries only
- Trace entire code flow when debugging

### Non-Functional Requirements

#### Performance
- Commands execute in <5 seconds
- Documentation updates are incremental
- No noticeable IDE slowdown

#### Reliability
- Never lose context data
- Handle interrupted sessions gracefully
- Recover from partial updates

#### Usability
- Zero learning curve for basic use
- Clear command outputs
- Intuitive folder structure
- Self-documenting system

#### Compatibility
- Works with any project type
- Language/framework agnostic
- Git-friendly (can be tracked or ignored)
- Works across all Claude Code sessions

---

## Technical Specifications

### File Structure

```
project-root/
├── context/                      # All context docs
│   ├── .context-config.json     # Configuration
│   ├── CLAUDE.md                # Developer guide
│   ├── PRD.md                   # Product specs
│   ├── ARCHITECTURE.md          # Technical design
│   ├── DECISIONS.md             # Decision log
│   ├── CODE_STYLE.md            # Coding standards
│   ├── KNOWN_ISSUES.md          # Issue tracking
│   ├── SESSIONS.md              # Session history
│   ├── tasks/
│   │   ├── next-steps.md        # Action items
│   │   └── todo.md              # Current tasks
│   └── reviews/
│       └── [session]-review.md  # Review results
```

### Command Behavior

**Init Sequence:**
1. Check if context/ exists
2. Create folder structure
3. Generate all template files
4. Analyze project (package.json, file structure)
5. Fill in known information
6. Create configuration file
7. Report completion status

**Save Sequence:**
1. Verify context/ exists (create if not)
2. Analyze current state vs documented state
3. Update each documentation file
4. Add session log entry
5. Capture work-in-progress
6. Report what was updated

**Review Sequence:**
1. Load all documentation
2. Check internal consistency
3. Verify against current code
4. Assess completeness
5. Report confidence level for continuity

**Code Review Sequence:**
1. Analyze code without making changes
2. Check against CODE_STYLE.md
3. Identify issues and improvements
4. Generate detailed report
5. Save report to reviews/ folder

---

## Success Metrics

### Quantitative Metrics
- **Session Continuity Rate:** >95% successful context reload
- **Context Capture Time:** <30 seconds per save
- **Documentation Coverage:** 100% of required files maintained
- **Command Success Rate:** >99% successful execution

### Qualitative Metrics
- User never needs to re-explain project state
- New sessions feel like continuations, not restarts
- Confidence in context preservation
- Zero lost work due to session ends

### Success Criteria
- [ ] All 4 commands work reliably
- [ ] Documentation stays synchronized with code
- [ ] Session handoff is seamless
- [ ] User preferences are consistently applied
- [ ] No manual context management needed

---

## Implementation Phases

### Phase 1: Core Infrastructure ⏳
- Create command definitions
- Build template system
- Implement /init-context
- Basic documentation generation

### Phase 2: Context Preservation
- Implement /save-context
- Session tracking
- Change detection
- State capture

### Phase 3: Validation & Review
- Implement /review-context
- Consistency checking
- Gap detection
- Confidence scoring

### Phase 4: Code Review System
- Implement /code-review
- Report generation
- Standards checking
- Improvement tracking

### Phase 5: Polish & Optimization
- Performance tuning
- Error handling
- Edge cases
- User feedback incorporation

---

## User Workflows

### New Project Start

```
1. Create/open project
2. Run /init-context
3. Review generated docs
4. Begin work
5. Run /save-context periodically
```

### Daily Development

```
1. Open project
2. Run /review-context
3. Continue from last state
4. Run /save-context during work
5. Run /save-context before ending
```

### Quality Check

```
1. Complete feature
2. Run /save-context
3. Run /code-review
4. Review report
5. Address issues in new session
```

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Context file corruption | High | Backup previous version before updates |
| Inconsistent updates | Medium | Validation checks in /review-context |
| Command failures | Medium | Graceful degradation, clear error messages |
| Documentation drift | Low | Frequent /save-context reminders |

---

## Future Enhancements

### V1.1
- Auto-save on timer
- Git hooks for context updates
- Context diff visualization

### V2.0
- Multi-user context sharing
- Context branching for experiments
- AI-powered context insights

### V3.0
- Cross-project context linking
- Context templates by project type
- Automated context pruning

---

## Success Statement

The Claude Context System is successful when:

> **"I can end any session abruptly, start a new session days later, run /review-context, and continue exactly where I left off without any re-explanation or context loss."**

---

## Appendix: Design Philosophy

### Core Principles

1. **Context is Sacred** - Never lose user context, ever
2. **Simplicity First** - Simple implementations over complex ones
3. **Progressive Enhancement** (v1.7.0+) - Start minimal, grow when needed
4. **No Surprises** - System behavior should be predictable
5. **Self-Documenting** - System explains itself
6. **Fail Safe** - Errors should never destroy context

### v1.7.0 Philosophy Shift

**What We Learned:**
Real-world usage showed we over-engineered the initial approach:
- Created 8 files when 2-3 provided most value
- Imposed bureaucratic process when natural documentation worked better
- Built for scale before it was needed

**New Approach - Progressive Enhancement:**
- **80/20 Rule:** 80% of value from 20% of files (SESSIONS.md + CLAUDE.md)
- **On-Demand Complexity:** Additional files created when needed, not upfront
- **Intelligent Updates:** Update what changed, not everything
- **Reference Guides:** Not checklists to follow rigidly

**The Shift:**
```
OLD: "Create comprehensive system → Force all projects to use it"
NEW: "Start minimal → Grow naturally when complexity demands it"
```

**Validated By:**
User feedback showing the concept worked perfectly, but execution was overengineered. v1.7.0 keeps what worked (session continuity, WIP capture, preferences) while removing overhead.

### User Preferences Integration

The system is built around Rex's specific workflow needs:
- Root cause analysis over quick fixes
- Surgical code changes over broad refactors
- High-level communication over verbose explanations
- Explicit approval for risky operations
- Complete code flow tracing for debugging

These preferences are embedded into CODE_STYLE.md and enforced throughout the system.
