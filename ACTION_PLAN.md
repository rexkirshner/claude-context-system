# Claude Context System - Action Plan
**Based on v1.8.0 Introspection v3**
**Date:** 2025-10-05

---

## Executive Summary

**Problem:** Frequency mismatch - Update docs 20×, recover context 3× = unfavorable overhead/benefit ratio

**Solution:** Two-tier model - Minimal continuous + Comprehensive on-demand

**Expected Impact:** 50-60% reduction in overhead (100-200 min → 50-85 min for 20 sessions)

**Timeline:** 4 weeks total (Measure → Implement → Test → Refine)

---

## Phase 1: Measure Current Reality (Week 1)

**Goal:** Validate the frequency mismatch hypothesis with real data

### Tasks

**1.1 Add Telemetry to Commands**
- [ ] Instrument /save-context with time tracking
- [ ] Track: Start time, end time, which sections were updated
- [ ] Store in: context/.metrics.json (local, opt-in)

**1.2 Track Context Recovery Events**
- [ ] Add "recovery mode" flag to /init-context and /save-context
- [ ] Prompt: "Recovering from break? [y/n]" (tracks recovery events)
- [ ] Record: Recovery date, time since last session, what docs were read

**1.3 Run on Real Projects**
- [ ] Use system on 3 real projects (existing or new)
- [ ] Track for 10-20 sessions each
- [ ] Record: Sessions count, recovery count, time per save, what was referenced

**1.4 Analyze Data**
- [ ] Calculate: Overhead/benefit ratio (sessions vs. recoveries)
- [ ] Identify: What documentation was actually used during recovery?
- [ ] Determine: Is SESSIONS.md valuable or rarely referenced?

### Success Criteria
- Data from 3 projects showing sessions:recoveries ratio
- Evidence of what documentation is actually valuable
- Validation of hypothesis: SESSIONS.md rarely referenced after initial orientation

### Expected Finding
- Overhead/benefit ratio: 5:1 or worse
- Most value: CONTEXT.md + STATUS.md
- Low value: SESSIONS.md (updated often, referenced rarely)

---

## Phase 2: Implement Two-Tier Model (Week 2)

**Goal:** Create minimal continuous + comprehensive on-demand commands

### Tasks

**2.1 Create /save Command (Minimal)**

Update `.claude/commands/save.md`:
```markdown
# /save Command

Quick session save - updates current state only.

## What This Does (2-3 minutes)
1. Auto-extract git changes (status, diff, staged)
2. Update STATUS.md:
   - Current tasks (checkboxes)
   - Blockers (if any)
   - Next steps
3. Auto-generate QUICK_REF.md
4. Report what changed

## When to Use
- Every session
- Quick updates
- Continuous work

Target time: 2-3 minutes
```

**Implementation:**
- [ ] Create new /save command file
- [ ] Auto-extract git data (inline, no separate helper script)
- [ ] Update STATUS.md (structured bullets)
- [ ] Auto-generate QUICK_REF.md
- [ ] Report (1-2 lines)

**2.2 Rename /save-context to /save-full (Comprehensive)**

Update `.claude/commands/save-full.md`:
```markdown
# /save-full Command

Comprehensive session documentation.

## What This Does (10-15 minutes)
1. Everything /save does
2. PLUS: Create SESSIONS.md entry (40-60 lines)
3. PLUS: Update DECISIONS.md if important decision made
4. PLUS: Optional JSON export

## When to Use
- Before breaks >1 week
- Before handoffs to other agents
- Major milestones
- ~3-5 times per 20 sessions

Target time: 10-15 minutes
```

**Implementation:**
- [ ] Rename save-context.md → save-full.md
- [ ] Update command to emphasize "use sparingly"
- [ ] Make JSON export optional (--with-json flag)
- [ ] Keep comprehensive format (40-60 lines)

**2.3 Update /init-context**

Update `.claude/commands/init-context.md`:
```markdown
## Daily Workflow

Every session (2-3 min):
/save

Before breaks/handoffs (10-15 min):
/save-full
```

**Implementation:**
- [ ] Update workflow documentation
- [ ] Explain when to use /save vs. /save-full
- [ ] Set expectations: Most sessions use /save

**2.4 Update Documentation**

Update `README.md`:
```markdown
## Two-Tier Model

**Tier 1: Minimal Continuous (Default)**
- /save every session (2-3 min)
- Updates STATUS.md + QUICK_REF.md
- Low overhead, high frequency

**Tier 2: Comprehensive On-Demand**
- /save-full before breaks (10-15 min)
- Creates SESSIONS.md entries
- High overhead, low frequency (~3-5× per 20 sessions)
```

**Implementation:**
- [ ] Update README.md
- [ ] Update PRD.md
- [ ] Update command philosophy docs
- [ ] Update CHANGELOG.md

### Success Criteria
- /save command exists and works
- /save-full command exists (renamed from /save-context)
- Documentation clearly explains when to use which
- User can complete /save in 2-3 minutes

---

## Phase 3: Test and Validate (Weeks 3-4)

**Goal:** Confirm improved ROI with real usage

### Tasks

**3.1 A/B Test Setup**

**Test Group A: v1.8.0 (Current)**
- Use /save-context every session (5-10 min)
- Full SESSIONS.md updates every time
- Measure: Time invested, recovery success

**Test Group B: Two-Tier (New)**
- Use /save every session (2-3 min)
- Use /save-full only before breaks (3× per 20 sessions)
- Measure: Time invested, recovery success

**Implementation:**
- [ ] Recruit 6 test users (3 per group)
- [ ] Each uses system for 20 sessions
- [ ] Track metrics via telemetry

**3.2 Measure Outcomes**

**Metrics to Track:**
- Time invested in documentation
- Context recovery success rate
- What documentation was referenced during recovery
- User satisfaction (survey)

**Implementation:**
- [ ] Automated metric collection
- [ ] Post-project survey
- [ ] Exit interviews

**3.3 Compare Results**

**Expected Results:**
- Group A: 100-200 min invested, X% recovery success
- Group B: 50-85 min invested, X% recovery success (same)
- **Hypothesis:** Group B has better ROI (same success, less time)

**Implementation:**
- [ ] Analyze data
- [ ] Calculate ROI for each group
- [ ] Identify which documentation was actually valuable

**3.4 Iterate Based on Findings**

**If hypothesis validated:**
- [ ] Make two-tier model the default
- [ ] Update documentation
- [ ] Announce v1.9.0

**If hypothesis invalidated:**
- [ ] Analyze what went wrong
- [ ] Adjust approach
- [ ] Re-test

### Success Criteria
- Data from 6 users (120 sessions total)
- Clear evidence of improved ROI for two-tier model
- User satisfaction higher in Group B
- Ready to release v1.9.0

---

## Phase 4: Additional Improvements (Future)

**Lower priority enhancements for future iterations**

### 4.1 Git-Based Session History

**Concept:** Generate SESSIONS.md from git commits on-demand

**Benefits:**
- Zero per-session overhead for history
- Comprehensive summary when actually needed
- Git already provides chronological record

**Implementation:**
- [ ] Create /generate-session-summary command
- [ ] Reads git log since last session
- [ ] Generates structured SESSIONS.md entry
- [ ] User reviews and adds mental models

**Status:** Experimental, test after two-tier model is validated

### 4.2 Make QUICK_REF.md Optional

**Concept:** Generate only when user requests it

**Benefits:**
- Removes auto-generation overhead
- User controls when they want dashboard view

**Implementation:**
- [ ] Remove auto-generation from /save
- [ ] Create /generate-quick-ref command
- [ ] OR: Add config option: auto_generate_quick_ref: true/false

**Status:** Consider if QUICK_REF proves low-value in testing

### 4.3 Reduce Template Count

**Concept:** Only 3 core templates included by default

**Implementation:**
- [ ] Core templates: CONTEXT, STATUS, SESSIONS (included)
- [ ] Optional templates: DECISIONS, PRD, ARCHITECTURE (download on-demand)
- [ ] Create /add-template command

**Status:** Nice-to-have, low priority

---

## Timeline Summary

| Week | Phase | Deliverable |
|------|-------|------------|
| 1 | Measure | Telemetry + data from 3 projects |
| 2 | Implement | /save and /save-full commands |
| 3-4 | Test | A/B test with 6 users, 120 sessions |
| 5+ | Refine | v1.9.0 release based on findings |

---

## Success Metrics

### Quantitative

**Time Investment (20-session project):**
- Current: 100-200 minutes
- Target: 50-85 minutes (50-60% reduction)

**Context Recovery Success:**
- Current: X% (to be measured)
- Target: Same or better

**User Satisfaction:**
- Current: Unknown
- Target: >80% would recommend

### Qualitative

**User Experience:**
- "System feels lightweight, not bureaucratic"
- "I don't dread running /save anymore"
- "Context recovery still works great"

**ROI:**
- "Time invested is worth the value gained"
- "I'd recommend this to other developers"

---

## Risk Mitigation

### Risk 1: Two-Tier Model Doesn't Improve ROI

**Mitigation:**
- A/B test before full rollout
- Keep v1.8.0 available as fallback
- Gather data to inform adjustments

### Risk 2: Users Don't Know When to Use /save-full

**Mitigation:**
- Clear documentation
- /save provides hint: "Planning a break? Run /save-full for comprehensive docs"
- Config option for "remind me to use /save-full every N sessions"

### Risk 3: Sparse SESSIONS.md Reduces Recovery Success

**Mitigation:**
- A/B test will measure this
- If true, adjust model
- Fallback: Keep more frequent SESSIONS.md updates

---

## Open Questions

1. **How sparse can SESSIONS.md be?**
   - Answer via: A/B testing
   - Hypothesis: 3-5 entries per 20 sessions is sufficient

2. **Can git commits replace session history?**
   - Answer via: Experimental /generate-session-summary
   - Hypothesis: Enhanced git log can provide 80% of value

3. **Is QUICK_REF.md valuable?**
   - Answer via: Track references during recovery
   - Hypothesis: Medium value, keep but make optional

4. **What's the optimal overhead/benefit ratio?**
   - Answer via: Testing and user feedback
   - Hypothesis: 2-3 min per session is acceptable, 5-10 min is not

---

## Next Steps

### Immediate (This Week)

1. **Review and approve this action plan**
2. **Begin Phase 1: Add telemetry**
3. **Start tracking metrics on current projects**

### Next Week

1. **Implement /save command (minimal)**
2. **Rename /save-context to /save-full**
3. **Update all documentation**

### Following Weeks

1. **Recruit test users for A/B test**
2. **Run tests for 2 weeks**
3. **Analyze results and iterate**

---

## Conclusion

This action plan addresses the core frequency mismatch problem identified by real AI agent feedback. By implementing a two-tier model, we align overhead with benefit:

- **Minimal overhead** for continuous work (the common case)
- **Comprehensive documentation** only when actually needed (the edge case)

**Expected outcome:** 50-60% reduction in overhead while maintaining full context recovery quality.

This is grounded in empirical evidence from AI agent usage and focuses on measurable improvements.
