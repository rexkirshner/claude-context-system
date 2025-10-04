---
description: Comprehensive code quality audit without making any changes
---

# /code-review Command

Conduct a thorough, unhurried code quality audit. This command **NEVER makes changes** - it only identifies issues and suggests improvements. Fixes happen in a separate session after review.

## ⚠️ CRITICAL RULES

1. **NEVER make code changes during review** - This is analysis only
2. **Take your time** - No rushing, no time pressure
3. **Don't break anything** - If uncertain, note it, don't change it
4. **Separate concerns** - Review finds issues, fixes come later
5. **Be thorough** - This is when we have time to be comprehensive

## When to Use This Command

- After completing a feature or phase
- Before deployment or major milestones
- When quality matters more than speed
- **Only when you have plenty of time** - user will only run this when unbound by time
- When you want deep analysis without pressure

**Never run when:**
- Time is limited
- In middle of active development
- During urgent fixes

## What This Command Does

1. Comprehensive code analysis
2. Quality assessment against standards
3. Issue identification and categorization
4. Improvement suggestions with rationale
5. Detailed report generation
6. **NO code modifications whatsoever**

## Execution Steps

### Step 0: Set Expectations

**Before starting, explicitly state:**

```
🔍 Starting Code Review

This will be a thorough, unhurried analysis.
I will NOT make any changes during this review.
All issues found will be documented for fixing in a separate session.
Taking my time to be comprehensive...
```

### Step 1: Load Context and Standards

**Read these files:**
- context/CODE_STYLE.md - Know the standards
- context/ARCHITECTURE.md - Understand design
- context/DECISIONS.md - Know past choices
- context/KNOWN_ISSUES.md - Aware of existing issues
- context/.context-config.json - User preferences

**Internalize standards:**
- Simplicity above all
- No temporary fixes
- Root cause solutions only
- Surgical code changes
- Full code flow tracing

### Step 2: Analyze Project Structure

**Scan directory structure:**
```bash
find . -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" | head -50
ls -la src/ app/ lib/ components/ 2>/dev/null
```

**Identify areas to review:**
- Core business logic
- API routes/endpoints
- Data handling
- UI components
- Utilities and helpers
- Configuration files
- Test coverage

**Create review checklist:**
- [ ] All major code areas identified
- [ ] Priority areas noted
- [ ] Scope is clear

### Step 3: Code Quality Analysis

Review each area systematically. **NO CHANGES - ONLY ANALYSIS**

#### Architecture & Design Review

**Check for:**
- [ ] Architectural patterns match ARCHITECTURE.md
- [ ] Separation of concerns maintained
- [ ] Dependencies flow in one direction
- [ ] Coupling is minimal
- [ ] Cohesion is high
- [ ] Abstraction levels appropriate

**Questions to answer:**
- Does the structure support the requirements?
- Are there architectural smells?
- Is the design over-engineered or under-engineered?
- Do patterns fit the problem?

**Document findings:**
```markdown
### Architecture Issues

**A1: Circular dependency in auth flow**
- Severity: Medium
- Location: lib/auth.ts ↔ middleware.ts
- Impact: Makes testing difficult, tight coupling
- Suggestion: Extract shared logic to lib/auth-utils.ts
```

#### Code Standards Review

**Check against CODE_STYLE.md:**
- [ ] Simplicity principle followed
- [ ] No temporary/hacky fixes
- [ ] Root causes addressed
- [ ] Minimal code impact per change
- [ ] Clear, readable code

**Scan for anti-patterns:**
- Complex functions (>50 lines)
- Deep nesting (>3 levels)
- Duplicate code
- Magic numbers/strings
- God objects/functions
- Premature optimization

**Document findings:**
```markdown
### Code Style Issues

**CS1: Complex authentication function**
- Severity: Low
- Location: lib/auth.ts:145-220
- Issue: 75-line function with 4 levels of nesting
- Suggestion: Extract validation logic to separate functions
```

#### Performance Review

**Check for:**
- [ ] Unnecessary re-renders (React)
- [ ] Inefficient database queries
- [ ] Memory leaks
- [ ] Blocking operations
- [ ] Large bundle sizes
- [ ] Unoptimized images

**Document findings:**
```markdown
### Performance Issues

**P1: Expensive computation in render**
- Severity: High
- Location: components/Dashboard.tsx:45
- Issue: Array.sort() called on every render
- Impact: Lag with large datasets
- Suggestion: Memoize with useMemo or compute server-side
```

#### Security Review

**Check for:**
- [ ] Input validation
- [ ] SQL injection risks
- [ ] XSS vulnerabilities
- [ ] CSRF protection
- [ ] Authentication/authorization
- [ ] Secrets in code
- [ ] Insecure dependencies

**Document findings:**
```markdown
### Security Issues

**S1: Missing input sanitization**
- Severity: Critical
- Location: app/api/search/route.ts:23
- Issue: User input directly in database query
- Impact: SQL injection risk
- Suggestion: Use parameterized queries
```

#### Error Handling Review

**Check for:**
- [ ] Proper try-catch usage
- [ ] Error boundaries (React)
- [ ] Meaningful error messages
- [ ] Error logging
- [ ] Graceful degradation
- [ ] User feedback

**Document findings:**
```markdown
### Error Handling Issues

**E1: Silent error swallowing**
- Severity: Medium
- Location: lib/api-client.ts:89
- Issue: Empty catch block suppresses errors
- Impact: Debugging nightmares, silent failures
- Suggestion: Log errors, show user feedback
```

#### Testing Review

**Check for:**
- [ ] Critical paths tested
- [ ] Edge cases covered
- [ ] Test quality (not just coverage)
- [ ] Integration tests exist
- [ ] E2E tests for critical flows
- [ ] Mocking appropriate

**Document findings:**
```markdown
### Testing Issues

**T1: No tests for authentication**
- Severity: High
- Location: lib/auth.ts (0% coverage)
- Issue: Critical auth logic untested
- Impact: Bugs in production, no regression safety
- Suggestion: Add unit + integration tests for auth flows
```

#### Accessibility Review (if UI)

**Check for:**
- [ ] Semantic HTML
- [ ] ARIA labels where needed
- [ ] Keyboard navigation
- [ ] Color contrast
- [ ] Screen reader support
- [ ] Focus management

**Document findings:**
```markdown
### Accessibility Issues

**A11Y1: Missing form labels**
- Severity: Medium
- Location: components/LoginForm.tsx
- Issue: Inputs lack associated labels
- Impact: Screen reader users can't use form
- Suggestion: Add proper <label> elements
```

#### SEO Review (if web/public site)

**Check for:**
- [ ] Meta tags (title, description, keywords)
- [ ] Open Graph tags for social sharing
- [ ] Twitter Card meta tags
- [ ] Canonical URLs
- [ ] Sitemap.xml and robots.txt
- [ ] Semantic HTML structure (proper heading hierarchy)
- [ ] Image alt text
- [ ] Page load performance (Core Web Vitals)
- [ ] Mobile responsiveness
- [ ] Internal linking structure
- [ ] Schema.org structured data (JSON-LD)
- [ ] URL structure (clean, descriptive URLs)

**Document findings:**
```markdown
### SEO Issues

**SEO1: Missing meta descriptions**
- Severity: High
- Location: app/layout.tsx or pages without metadata
- Issue: Pages lack meta descriptions
- Impact: Poor search engine snippets, lower click-through rates
- Suggestion: Add unique, compelling meta descriptions (150-160 chars) to all pages

**SEO2: Poor heading hierarchy**
- Severity: Medium
- Location: components/ArticlePage.tsx
- Issue: Multiple H1 tags, skipped heading levels (H1 → H3)
- Impact: Confuses search engines and screen readers
- Suggestion: Single H1 per page, sequential heading levels

**SEO3: Missing structured data**
- Severity: Medium
- Location: Article pages
- Issue: No JSON-LD schema markup
- Impact: Missing rich snippets in search results
- Suggestion: Add Article schema with author, datePublished, etc.

**SEO4: Slow page load speed**
- Severity: High
- Location: Homepage
- Issue: LCP > 4s, unoptimized images
- Impact: Poor Core Web Vitals, lower rankings
- Suggestion: Optimize images, implement lazy loading, reduce bundle size

**SEO5: Missing Open Graph tags**
- Severity: Low
- Location: All pages
- Issue: No OG tags for social sharing
- Impact: Poor social media previews
- Suggestion: Add og:title, og:description, og:image, og:url
```

**SEO Optimization Checklist:**
- [ ] Title tags: 50-60 chars, unique per page, include target keywords
- [ ] Meta descriptions: 150-160 chars, compelling call-to-action
- [ ] H1: Single per page, includes primary keyword
- [ ] Heading hierarchy: H1 → H2 → H3 (no skips)
- [ ] Image alt text: Descriptive, includes context
- [ ] Internal links: Natural, descriptive anchor text
- [ ] URL structure: Clean, readable, includes keywords
- [ ] Sitemap: Auto-generated, submitted to search engines
- [ ] Robots.txt: Properly configured
- [ ] Canonical URLs: Set for duplicate content
- [ ] Mobile-first: Responsive design, mobile-optimized
- [ ] Page speed: LCP < 2.5s, FID < 100ms, CLS < 0.1
- [ ] Schema markup: Article, Organization, BreadcrumbList as appropriate
- [ ] Social meta tags: OG and Twitter Card tags
- [ ] HTTPS: Secure connections
- [ ] XML sitemap: Updated automatically

**Performance Impact on SEO:**
```markdown
### Core Web Vitals Assessment

**LCP (Largest Contentful Paint):**
- Current: [X]s
- Target: < 2.5s
- Issues: [List issues]
- Fix: [Optimizations needed]

**FID (First Input Delay):**
- Current: [X]ms
- Target: < 100ms
- Issues: [List issues]
- Fix: [Optimizations needed]

**CLS (Cumulative Layout Shift):**
- Current: [X]
- Target: < 0.1
- Issues: [List issues]
- Fix: [Optimizations needed]
```

### Step 4: Identify Patterns and Root Causes

**Look for systemic issues:**
- Same mistake repeated across files?
- Architectural flaw causing problems?
- Missing knowledge/skills?
- Technical debt accumulated?

**Categorize issues:**
- **Quick wins:** Easy to fix, high impact
- **Refactoring needed:** Architectural changes
- **Technical debt:** Accumulated problems
- **Learning opportunities:** Skill gaps

### Step 5: Check Against KNOWN_ISSUES.md

**Cross-reference:**
- [ ] Are documented issues actually issues?
- [ ] Are there undocumented issues?
- [ ] Have documented issues been fixed?
- [ ] Are severities accurate?

**Update understanding:**
- Note issues to add to KNOWN_ISSUES.md
- Note issues to remove (if fixed)
- Adjust severities based on findings

### Step 6: Generate Comprehensive Report

Create detailed report in `context/reviews/session-[N]-review.md`:

```markdown
# Code Review Report - Session [N]
**Date:** YYYY-MM-DD
**Reviewer:** Claude Code
**Scope:** [What was reviewed]
**Duration:** [Time spent]

---

## Executive Summary

**Overall Grade:** [A/B/C/D/F]

**Overall Assessment:**
[2-3 sentences on code quality]

**Critical Issues:** [Number]
**High Priority:** [Number]
**Medium Priority:** [Number]
**Low Priority:** [Number]

**Top 3 Recommendations:**
1. [Most important thing to fix]
2. [Second most important]
3. [Third most important]

---

## Detailed Findings

### Critical Issues (Fix Immediately)

#### C1: [Issue Title]
- **Severity:** Critical
- **Location:** file.ts:123-145
- **Issue:** [What's wrong]
- **Impact:** [Why it matters]
- **Root Cause:** [Why it happened]
- **Suggestion:** [How to fix]
- **Effort:** [Time estimate]

[Repeat for each critical issue]

### High Priority Issues (Fix Soon)

[Same format as critical]

### Medium Priority Issues (Address When Possible)

[Same format]

### Low Priority Issues (Nice to Have)

[Same format]

---

## Positive Findings

**What's Working Well:**
- [Good pattern 1]
- [Good pattern 2]
- [Well-structured code area]

**Strengths:**
- [Architecture strength]
- [Code quality strength]
- [Best practices followed]

---

## Patterns Observed

**Recurring Issues:**
1. [Pattern repeated across codebase]
2. [Another common problem]

**Root Causes:**
1. [Systemic issue causing problems]
2. [Architectural flaw]

**Quick Wins:**
- [Easy fix with high impact]
- [Low-hanging fruit]

---

## Recommendations

### Immediate Actions (This Week)
1. [Critical fix 1]
2. [Critical fix 2]
3. [Critical fix 3]

### Short-term Improvements (This Month)
1. [High priority fix 1]
2. [High priority fix 2]
3. [Refactoring need]

### Long-term Enhancements (Backlog)
1. [Architectural improvement]
2. [Major refactor]
3. [Infrastructure upgrade]

---

## Metrics

- **Files Reviewed:** [N]
- **Lines of Code:** [N]
- **Issues Found:** [N total] (C:[N], H:[N], M:[N], L:[N])
- **Test Coverage:** [%] (if measurable)
- **Code Complexity:** [Assessment]

---

## Compliance Check

**CODE_STYLE.md Compliance:**
- [✅/⚠️/❌] Simplicity principle
- [✅/⚠️/❌] No temporary fixes
- [✅/⚠️/❌] Root cause solutions
- [✅/⚠️/❌] Minimal code impact

**ARCHITECTURE.md Compliance:**
- [✅/⚠️/❌] Follows documented patterns
- [✅/⚠️/❌] Respects design decisions
- [✅/⚠️/❌] Maintains separation

---

## Next Steps

**For User:**
1. Review this report
2. Prioritize issues to address
3. Run /save-context to capture state
4. Start fixing in new session

**Suggested Fix Order:**
1. [Critical issue to fix first]
2. [Then this]
3. [Then this]

**Estimated Total Effort:** [Hours/Days]

---

## Notes

- [Any additional context]
- [Uncertainties or questions]
- [Areas needing user input]

---

## Review Checklist

- [✅] All major areas reviewed
- [✅] Issues categorized by severity
- [✅] Root causes identified
- [✅] Suggestions provided
- [✅] No changes made to code
- [✅] Report is actionable
```

### Step 7: Report Completion

**Console output:**

```
✅ Code Review Complete

**Report saved to:** context/reviews/session-[N]-review.md

**Summary:**
- Grade: B+
- Critical Issues: 1
- High Priority: 3
- Medium Priority: 7
- Low Priority: 12

**Top 3 Recommendations:**
1. Fix SQL injection in search API (CRITICAL)
2. Add unit tests for authentication (HIGH)
3. Refactor complex Dashboard component (MEDIUM)

**Next Steps:**
1. Review full report at context/reviews/session-[N]-review.md
2. Prioritize fixes with user
3. Run /save-context
4. Address issues in separate session

⚠️ Remember: NO changes were made during review.
All issues documented for fixing later.
```

## Important Guidelines

### The "No Changes" Rule

**Why this rule exists:**
- Past experience: Changes during review broke things
- Time pressure leads to hasty fixes
- Review and fix are different mindsets
- Analysis requires different pace than implementation

**Temptations to resist:**
- "This is a quick fix" - NO, document it
- "Just renaming a variable" - NO, document it
- "Fixing a typo" - NO, document it
- "One-line change" - NO, document it

**What to do instead:**
- Document the issue thoroughly
- Explain how to fix it
- Note effort required
- Let user decide when to fix

### Taking Your Time

**This is the time to be thorough:**
- Read code carefully
- Trace through logic
- Consider edge cases
- Think about implications
- Question assumptions

**No rushing because:**
- User runs this when they have time
- Quality matters here
- Missing issues is worse than taking time
- This is preventative, not reactive

### Grading Rubric

**A (Excellent):**
- Follows all standards
- Well-tested, secure
- Clean architecture
- No critical issues
- Minimal tech debt

**B (Good):**
- Mostly follows standards
- Minor issues only
- Decent test coverage
- Some tech debt

**C (Adequate):**
- Some standard violations
- Medium priority issues
- Gaps in testing
- Notable tech debt

**D (Poor):**
- Many standard violations
- High priority issues
- Major gaps
- Significant debt

**F (Failing):**
- Critical issues
- Security problems
- No tests
- Unsustainable debt

## Error Handling

**If scope too large:**
- Report it
- Suggest focusing on critical areas first
- Offer to review in chunks

**If unfamiliar technology:**
- Note it in report
- Focus on general principles
- Recommend specialist review

**If can't determine issue:**
- Document uncertainty
- Explain what's unclear
- Suggest investigation steps

## Success Criteria

Review succeeds when:
- Comprehensive analysis completed
- All issues documented
- No changes made
- Clear recommendations provided
- Report is actionable
- User knows exactly what to fix
- Priorities are clear
- Effort estimates included

**Perfect review:**
- Thorough and unhurried
- Issues with root causes
- Clear fix suggestions
- Zero code changes
- Maintainable codebase as result
