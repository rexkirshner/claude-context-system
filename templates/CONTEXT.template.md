# CONTEXT.md

This file provides orientation for working with this project. **For current status, see STATUS.md** - this file rarely changes.

## Project Overview

**[Project Name]** is [brief description of what this project does].

**Key References:**
- Production URL: [URL if deployed]
- Staging URL: [URL if exists]
- Repository: [GitHub URL]
- Documentation: [Docs URL if exists]

## Working with You

> **📋 Preferences:** All communication, workflow, and quality preferences are defined in `context/.context-config.json`.
> The settings below are derived from that source of truth.

### Communication Style

**What You Prefer:**
- Direct, concise responses without preamble
- High-level summaries of changes made (e.g., "Changed X to Y in file.ts:123")
- Clear indication when waiting for approval vs. when work is complete
- Honest assessment of confidence levels
- Simple solutions over complex ones

**What to Avoid:**
- Verbose explanations unless specifically requested
- Pushing to GitHub without explicit approval
- Making assumptions about user intent
- Complex changes when simple ones work
- Temporary fixes instead of root cause solutions
- Emojis unless explicitly requested

**Git Workflow:**
- **NEVER push without explicit "push" approval**
- Test everything in dev before committing
- When user says "let's make sure it works first" = make change, verify, WAIT for approval
- Make incremental commits with clear messages

### Core Development Methodology

1. **Plan First:** Read codebase, think through problem, use TodoWrite to plan
2. **Track Progress:** Create todo items that can be checked off during work
3. **Verify Plan:** Check in with user before starting implementation
4. **Work Incrementally:** Complete todos one by one, marking complete as you go
5. **Communicate Clearly:** Provide high-level explanation of changes at each step
6. **Simplicity Above All:** Every change should impact minimal code
7. **Document Results:** Run `/save-context` to capture session state
8. **No Lazy Coding:** Always look for root causes, never apply band-aids
9. **Minimal Impact:** Changes affect only necessary code, nothing else
10. **Full Tracing:** Debug by tracing ENTIRE code flow - no assumptions

**When Debugging:**
- Trace through the ENTIRE code flow step by step
- No assumptions - verify what you think you know
- No shortcuts - follow the data from entry to issue
- Use breakpoints or logging at each step
- Check inputs, outputs, and state at every layer
- Document the flow as you trace it

## Commands

```bash
# Development
[TODO: Add dev command]          # [Description]

# Production
[TODO: Add build command]        # [Description]
[TODO: Add start command]        # [Description]

# Testing
[TODO: Add test command]         # [Description]

# Other
[TODO: Add other commands]       # [Description]
```

## Architecture

### [Project Type - Web App / API / CLI / Library]

**Technology Stack:**
- Framework: [e.g., Next.js 15]
- Language: [e.g., TypeScript]
- Database: [e.g., PostgreSQL]
- Hosting: [e.g., Vercel]

**Directory Structure:**
```
[project-root]/
├── [key-directory]/     # [Purpose]
├── [key-directory]/     # [Purpose]
└── [key-directory]/     # [Purpose]
```

**Key Patterns:**
- [TODO: Describe main architectural pattern]
- [TODO: Describe state management approach]
- [TODO: Describe data flow pattern]

**File Organization:**
- [TODO: Explain file naming conventions]
- [TODO: Explain where different types of code go]

## Important Notes

**Environment Variables:**
- Template: `.env.example`
- Local config: `.env.local` (gitignored)
- Never commit credentials

**Dependencies:**
- [Note any critical dependencies]
- [External services required]

**Special Considerations:**
- [Any quirks or gotchas]
- [Important context for developers]

## Project-Specific Overrides

[Use this section to override or extend general preferences for this specific project]

**Custom Workflow:**
- [Any project-specific workflow requirements]

**Communication Adjustments:**
- [Any project-specific communication preferences]

**Technical Constraints:**
- [Any project-specific technical requirements or limitations]

---

**For current status:** See `STATUS.md` (single source of truth for what's happening now)
**For session history:** See `SESSIONS.md` (structured, scannable history)
**For quick reference:** See `QUICK_REF.md` (auto-generated dashboard)
