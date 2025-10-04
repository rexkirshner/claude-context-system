# Next Steps

Action hub for the project. Keep this current - it should always reflect what needs to be done next.

**Last Updated:** [YYYY-MM-DD]

---

## Ready to Do Now

These actions are unblocked and ready to work on immediately.

### High Priority

1. **[Action 1]**
   - **Why:** [Importance/impact]
   - **Effort:** [Time estimate]
   - **Files:** `path/to/file.ts`
   - **Depends on:** Nothing (ready!)

2. **[Action 2]**
   - **Why:** [Importance]
   - **Effort:** [Estimate]
   - **Files:** [Affected files]
   - **Depends on:** Nothing

### Medium Priority

1. **[Action]**
   - Details

### Low Priority

1. **[Action]**
   - Details

---

## Pending / Blocked

Actions that are waiting on something else.

### Blocked on External Dependencies

1. **[Action]**
   - **Blocked by:** [External dependency]
   - **Waiting for:** [What's needed]
   - **Can start when:** [Condition]
   - **Importance:** [High/Medium/Low]

### Blocked on Internal Work

1. **[Action]**
   - **Blocked by:** [Internal task]
   - **Needs first:** [What must be done]
   - **Then can:** [What this enables]

### Blocked on Decisions

1. **[Action]**
   - **Decision needed:** [What needs to be decided]
   - **Options:** [A, B, C]
   - **Who decides:** [User/Team/etc.]
   - **Impact:** [Why this decision matters]

---

## Work In Progress

Currently active work (should align with SESSIONS.md WIP).

### [Task Name]
- **Started:** [Date/Session]
- **Progress:** [% or description]
- **Current location:** `file.ts:line`
- **Next action:** [Exact next step]
- **Blockers:** [Any issues]

---

## Completed ✅

Recently completed items (prune periodically).

### [Week/Month]

1. ✅ **[Completed action]**
   - Finished: [Date/Session]
   - Outcome: [Result]

2. ✅ **[Completed action]**
   - Finished: [Date]
   - Outcome: [Result]

---

## Future Work

Items for later consideration - beyond immediate roadmap.

### Features

1. **[Feature name]**
   - **Description:** [What it is]
   - **Value:** [Why it matters]
   - **Complexity:** [High/Medium/Low]
   - **Priority:** [When to consider]

### Improvements

1. **[Improvement]**
   - **Current state:** [How it works now]
   - **Desired state:** [How it should work]
   - **Benefit:** [Why improve]
   - **Effort:** [Estimate]

### Technical Debt

1. **[Debt item]**
   - **What:** [Description]
   - **Cost:** [What it costs us]
   - **Repay by:** [When to address]
   - **See:** KNOWN_ISSUES.md [TD-ID]

---

## Maintenance Tasks

Regular upkeep and recurring tasks.

### Weekly
- [ ] Review and update KNOWN_ISSUES.md
- [ ] Check dependency updates
- [ ] Review performance metrics
- [ ] [Project-specific task]

### Monthly
- [ ] Review all context documentation
- [ ] Assess technical debt
- [ ] Update roadmap
- [ ] [Project-specific task]

### As Needed
- [ ] Update dependencies when security patches available
- [ ] Refactor when adding features to messy code
- [ ] Add tests when bugs found
- [ ] [Project-specific task]

---

## Success Metrics

Track progress toward goals.

### Current Sprint/Phase Goals
- **Goal 1:** [Metric/target]
  - Current: [Status]
  - Target: [Goal]
  - Progress: [%]

- **Goal 2:** [Metric/target]
  - Current: [Status]
  - Target: [Goal]
  - Progress: [%]

### Overall Project Health
- **Code Quality:** [Metric]
- **Test Coverage:** [%]
- **Performance:** [Metric]
- **User Satisfaction:** [Metric if tracked]

### Velocity
- **This week:** [Items completed]
- **Last week:** [Items completed]
- **Trend:** [Improving/Stable/Declining]

---

## Decision Points

Upcoming decisions that will affect next steps.

### [Decision Name]
- **Deadline:** [When decision needed]
- **Options:** [Choices available]
- **Impact:** [What this affects]
- **Recommendation:** [Suggested choice]
- **Who decides:** [Decision maker]

---

## Quick Reference

### Top 3 Priorities
1. [Action 1] - [Why it's top priority]
2. [Action 2] - [Why it's important]
3. [Action 3] - [Why it matters]

### Quick Wins (Low effort, High value)
1. [Action] - [Estimate: X hours]
2. [Action] - [Estimate: X hours]

### Must Do Before Launch
- [ ] [Critical item 1]
- [ ] [Critical item 2]
- [ ] [Critical item 3]

---

## Context Links

**Related Documentation:**
- PRD.md - See current phase and roadmap
- SESSIONS.md - See what was worked on last
- KNOWN_ISSUES.md - See blockers and problems
- DECISIONS.md - See technical choices made

**Current Status:**
- Phase: [Current phase from PRD]
- Last session: [Date/number]
- WIP: [Current work from SESSIONS.md]

---

## How to Use This Document

### At Session Start
1. Review "Ready to Do Now" section
2. Check "Work In Progress" for continuity
3. Look at "Blocked" to see if anything unblocked
4. Pick highest priority ready item

### During Work
1. Mark items in progress
2. Note new blockers discovered
3. Add new items as they come up
4. Update status of active items

### At Session End
1. Move completed items to "Completed"
2. Update WIP status
3. Add any new items discovered
4. Reprioritize based on learnings

### Weekly Review
1. Prune completed items
2. Check if blocked items unblocked
3. Reassess priorities
4. Move future items to ready if appropriate
5. Update metrics

---

## Item Template

When adding new items:

```markdown
**[Action/Task Name]**
- **Why:** [Importance/impact]
- **Effort:** [Time estimate]
- **Files:** `path/to/affected-files`
- **Depends on:** [Prerequisites or "Nothing (ready!)"]
- **Outcome:** [What success looks like]
```

For blocked items, add:
```markdown
- **Blocked by:** [What's blocking]
- **Can start when:** [Unblock condition]
```

---

## Notes

- Keep this document current - stale todos are useless
- Be specific about actions - "Fix auth" → "Add JWT refresh token endpoint"
- Update after every session
- Mark completions immediately
- Don't let completed items pile up - prune weekly
- Cross-reference other context docs
- When in doubt, prioritize based on:
  1. User impact
  2. Blocker status
  3. Effort/value ratio
