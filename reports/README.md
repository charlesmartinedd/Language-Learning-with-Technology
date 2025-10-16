# QA Testing Documentation
## Language Learning with Technology Project

**Last Updated:** 2025-10-16
**Status:** Ready for content generation and testing

---

## Overview

This directory contains all quality assurance testing documentation, test reports, and validation results for the Language Learning with Technology project.

## Current Project Status

**✅ QA Infrastructure:** Complete
- Testing scripts created
- Documentation prepared
- Tools configured
- Workflows defined

**⏳ Content Generation:** Pending
- Markdown chapters not yet created
- Website not yet built
- EPUB/DOCX not yet generated
- Course module not yet created

**➡️ Next Step:** Generate content files, then run QA tests

---

## Quick Start

### 1. Install Testing Tools

```bash
# Core tools
npm install -g cspell write-good readability-cli
npm install -g lighthouse pa11y html-validate
npm install -g broken-link-checker

# EPUBCheck (requires Java)
# Download from: https://github.com/w3c/epubcheck/releases
# Extract to: /usr/local/bin/ or C:\Program Files\epubcheck\
```

### 2. Run Individual Tests

```bash
# Content quality (spelling, grammar, readability)
bash scripts/test-content-quality.sh

# Accessibility (WCAG 2.1 AA)
bash scripts/test-accessibility.sh

# Lighthouse (performance, SEO)
bash scripts/test-lighthouse.sh

# EPUB validation
bash scripts/validate-epub.sh
```

### 3. Run All Tests

```bash
# Execute complete test suite
bash scripts/run-all-tests.sh
```

---

## Test Reports

### Current Reports (Templates/Ready)

| Report | Description | Status |
|--------|-------------|--------|
| `QA-SUMMARY.md` | Comprehensive QA overview | ✅ Template ready |
| `content-quality.md` | Spelling, grammar, readability | ✅ Template ready |
| `accessibility-audit.md` | WCAG 2.1 AA compliance | ✅ Template ready |
| `lighthouse-scores.json` | Performance metrics | ✅ Template ready |
| `epub-validation.log` | EPUB file validation | ✅ Template ready |
| `README.md` | This file | ✅ Complete |

### Reports Generated After Testing

These files will be created when tests run:

- `spelling-errors.txt` - Spell check results
- `grammar-issues.txt` - Grammar check results
- `readability-scores.txt` - Readability analysis
- `consistency-*.txt` - Consistency checks
- `html-validation.log` - HTML validation results
- `pa11y-*.json` - Accessibility test results
- `lighthouse-*.report.json` - Lighthouse JSON reports
- `lighthouse-*.report.html` - Lighthouse HTML reports
- `broken-links.txt` - Broken link report
- `FINAL-QA-REPORT.md` - Comprehensive test summary

---

## Testing Workflow

### Phase 1: Content Generation
**Status:** 🔴 Not Started

**Required Actions:**
1. Generate markdown chapters (content/chapters/*.md)
2. Create cover image (2560x1600px)
3. Write course quiz questions
4. Prepare slide content

**Dependencies:** Content team, subject matter experts

---

### Phase 2: Content Quality Testing
**Status:** 🟡 Ready to Run (pending content)

**Tests:**
- ✅ Spell checking (cspell)
- ✅ Grammar checking (write-good)
- ✅ Readability analysis (Flesch-Kincaid 8-10 target)
- ✅ Consistency validation (terminology, style)
- ⚠️ Fact-checking (manual, 2025 technology references)

**Command:**
```bash
bash scripts/test-content-quality.sh
```

**Acceptance Criteria:**
- 0 spelling errors
- <10 grammar issues
- Flesch-Kincaid grade level: 8-10
- Consistent terminology

---

### Phase 3: Website Build
**Status:** 🔴 Not Started

**Required Actions:**
1. Convert markdown to HTML
2. Apply CSS styling
3. Generate navigation
4. Optimize images
5. Deploy to dist/site/

**Dependencies:** Content (Phase 1)

---

### Phase 4: Website Validation
**Status:** 🟡 Ready to Run (pending website)

**Tests:**
- ✅ HTML validation (W3C compliant)
- ✅ Lighthouse audit (≥90 all categories)
- ✅ Accessibility testing (WCAG 2.1 AA)
- ✅ Responsive design (mobile, tablet, desktop)
- ✅ Link checking (internal/external)
- ✅ Cross-browser compatibility

**Commands:**
```bash
bash scripts/test-accessibility.sh
bash scripts/test-lighthouse.sh
```

**Acceptance Criteria:**
- HTML: 0 validation errors
- Lighthouse: ≥90 (Performance, Accessibility, Best Practices, SEO)
- Accessibility: 0 WCAG Level A/AA violations
- Links: 0 broken links

---

### Phase 5: Book File Generation
**Status:** 🔴 Not Started

**Required Actions:**
1. Generate EPUB (from markdown)
2. Generate DOCX (from markdown)
3. Generate PDF (optional)
4. Add metadata (title, author, ISBN)
5. Create table of contents

**Dependencies:** Content (Phase 1)

---

### Phase 6: Book File Validation
**Status:** 🟡 Ready to Run (pending files)

**Tests:**
- ✅ EPUB validation (EPUBCheck)
- ⚠️ DOCX verification (manual)
- ⚠️ Cover image validation (2560x1600px)
- ✅ Metadata verification
- ⚠️ TOC functionality testing

**Command:**
```bash
bash scripts/validate-epub.sh
```

**Acceptance Criteria:**
- EPUBCheck: 0 errors
- DOCX: Opens correctly in Word/Google Docs
- Cover: 2560x1600px, <50MB, 300+ DPI
- Metadata: Complete and accurate

---

### Phase 7: Course Module
**Status:** 🔴 Not Started

**Required Actions:**
1. Create quiz JSON files
2. Build certificate template
3. Generate slides (HTML + PDF)
4. Implement interactive elements

**Dependencies:** Content (Phase 1)

---

### Phase 8: Integration Testing
**Status:** 🔴 Not Started

**Tests:**
- Quiz functionality
- Certificate generation
- Slides rendering
- Interactive elements
- Mobile responsiveness
- Course progression

**Acceptance Criteria:**
- Quiz: Correct validation, scoring, feedback
- Certificate: Generates with correct name/date
- Slides: Render correctly in HTML and PDF
- Mobile: Fully responsive

---

### Phase 9: Final QA
**Status:** 🔴 Not Started

**Command:**
```bash
bash scripts/run-all-tests.sh
```

**Acceptance Criteria:**
- All automated tests pass
- All manual checks complete
- No critical issues
- Stakeholder approval

---

## Testing Checklist

### Before Testing
- [ ] All content files generated
- [ ] Website built (dist/site/)
- [ ] EPUB generated (dist/kdp/*.epub)
- [ ] DOCX generated (dist/kdp/*.docx)
- [ ] Course module built (dist/course/)
- [ ] All testing tools installed

### Automated Tests
- [ ] Content quality tests pass
- [ ] HTML validation passes
- [ ] Lighthouse scores ≥90
- [ ] pa11y accessibility tests pass
- [ ] EPUBCheck validation passes
- [ ] Link checking passes

### Manual Tests
- [ ] Keyboard navigation works
- [ ] Screen reader compatible
- [ ] Color contrast sufficient (≥4.5:1)
- [ ] Responsive design verified
- [ ] Cross-browser tested
- [ ] EPUB tested in readers
- [ ] Course module functional

### Documentation
- [ ] Test reports generated
- [ ] Issues documented
- [ ] Fixes implemented
- [ ] Re-testing complete
- [ ] Final report approved

---

## Issue Severity Levels

### 🔴 Critical (Must Fix Before Deployment)
- Broken core functionality
- WCAG Level A violations
- Spelling errors in titles/headings
- Invalid EPUB structure
- Security vulnerabilities

### 🟠 High Priority (Fix Before Release)
- WCAG Level AA violations
- Lighthouse scores <90
- HTML validation errors
- Broken links
- Grammar errors in main content

### 🟡 Medium Priority (Fix If Possible)
- Minor grammar issues
- Lighthouse warnings
- Inconsistent terminology
- Missing alt text on decorative images

### 🟢 Low Priority (Enhancement)
- WCAG Level AAA considerations
- Additional optimization opportunities
- Style guide refinements

---

## Tools Reference

### Spell Checking
- **Tool:** cspell (Code Spell Checker)
- **Config:** `.cspell.json` (custom dictionary)
- **Usage:** `cspell "content/**/*.md"`

### Grammar Checking
- **Tool:** write-good
- **Usage:** `write-good content/**/*.md`

### Readability Analysis
- **Tool:** readability-cli
- **Metrics:** Flesch Reading Ease, Flesch-Kincaid Grade Level
- **Target:** Grade level 8-10

### HTML Validation
- **Tool:** html-validate
- **Standard:** W3C HTML5
- **Usage:** `html-validate "dist/site/**/*.html"`

### Accessibility Testing
- **Tools:** pa11y, axe DevTools, WAVE
- **Standard:** WCAG 2.1 Level AA
- **Usage:** `pa11y http://localhost:8000 --standard WCAG2AA`

### Performance Testing
- **Tool:** Lighthouse
- **Categories:** Performance, Accessibility, Best Practices, SEO
- **Target:** ≥90 all categories
- **Usage:** `lighthouse http://localhost:8000 --output json html`

### EPUB Validation
- **Tool:** EPUBCheck 5.1.0
- **Requires:** Java Runtime Environment
- **Usage:** `java -jar epubcheck.jar book.epub`

### Link Checking
- **Tool:** broken-link-checker
- **Usage:** `blc http://localhost:8000 -ro`

---

## Common Issues & Solutions

### Issue: "cspell not found"
**Solution:**
```bash
npm install -g cspell
```

### Issue: "Lighthouse fails to start"
**Solution:**
```bash
# Update Node.js to latest LTS
# Reinstall Lighthouse
npm uninstall -g lighthouse
npm install -g lighthouse
```

### Issue: "EPUBCheck not found"
**Solution:**
1. Install Java: https://www.java.com/download/
2. Download EPUBCheck: https://github.com/w3c/epubcheck/releases
3. Extract and note path
4. Update `validate-epub.sh` with correct path

### Issue: "Server won't start on port 8000"
**Solution:**
```bash
# Check if port is in use
lsof -i :8000  # macOS/Linux
netstat -ano | findstr :8000  # Windows

# Kill process or use different port
python3 -m http.server 8001
```

### Issue: "Tests fail with 'permission denied'"
**Solution:**
```bash
# Make scripts executable
chmod +x scripts/*.sh
```

---

## Contact & Support

**QA Lead:** Testing and Validation Agent
**Task ID:** task-1760650864992-zju77st4h
**Date Created:** 2025-10-16

**For Issues:**
- Review test reports in this directory
- Check individual script error messages
- Consult tool documentation (links in QA-SUMMARY.md)

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-10-16 | Initial QA framework created |
| | | - All test scripts created |
| | | - Documentation complete |
| | | - Ready for content testing |

---

**Next Steps:**
1. Generate all content files
2. Run `bash scripts/run-all-tests.sh`
3. Review reports in this directory
4. Fix all critical and high-priority issues
5. Re-run tests until all pass
6. Proceed to deployment

**Status:** ✅ QA infrastructure complete, awaiting content
