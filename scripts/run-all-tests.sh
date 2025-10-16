#!/bin/bash

# Master QA Testing Script
# Language Learning with Technology Project
# Runs all QA tests in sequence

echo "=========================================="
echo "COMPLETE QA TESTING SUITE"
echo "Language Learning with Technology"
echo "=========================================="
echo ""
echo "This script will run all QA tests:"
echo "1. Content Quality (spelling, grammar, readability)"
echo "2. HTML Validation"
echo "3. Accessibility Testing (WCAG 2.1 AA)"
echo "4. Lighthouse Performance Testing"
echo "5. EPUB Validation"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test results tracking
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0

# Make sure we're in project root
if [ ! -f "package.json" ] && [ ! -d "scripts" ]; then
    echo "${RED}❌ Error: Run this script from project root${NC}"
    exit 1
fi

# Create reports directory
mkdir -p reports

# Make scripts executable
chmod +x scripts/*.sh 2>/dev/null

# Test 1: Content Quality
echo ""
echo "${BLUE}═══════════════════════════════════════════${NC}"
echo "${BLUE}TEST 1/5: Content Quality${NC}"
echo "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

if [ -f "scripts/test-content-quality.sh" ]; then
    TESTS_RUN=$((TESTS_RUN + 1))
    if bash scripts/test-content-quality.sh; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "${GREEN}✅ Content Quality: PASSED${NC}"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "${RED}❌ Content Quality: FAILED${NC}"
    fi
else
    TESTS_SKIPPED=$((TESTS_SKIPPED + 1))
    echo "${YELLOW}⚠️  Content Quality: SKIPPED (script not found)${NC}"
fi

# Test 2: Accessibility
echo ""
echo "${BLUE}═══════════════════════════════════════════${NC}"
echo "${BLUE}TEST 2/5: Accessibility (WCAG 2.1 AA)${NC}"
echo "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

if [ -f "scripts/test-accessibility.sh" ]; then
    TESTS_RUN=$((TESTS_RUN + 1))
    if bash scripts/test-accessibility.sh; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "${GREEN}✅ Accessibility: PASSED${NC}"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "${RED}❌ Accessibility: FAILED${NC}"
    fi
else
    TESTS_SKIPPED=$((TESTS_SKIPPED + 1))
    echo "${YELLOW}⚠️  Accessibility: SKIPPED (script not found)${NC}"
fi

# Test 3: Lighthouse
echo ""
echo "${BLUE}═══════════════════════════════════════════${NC}"
echo "${BLUE}TEST 3/5: Lighthouse Performance${NC}"
echo "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

if [ -f "scripts/test-lighthouse.sh" ]; then
    TESTS_RUN=$((TESTS_RUN + 1))
    if bash scripts/test-lighthouse.sh; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "${GREEN}✅ Lighthouse: PASSED${NC}"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "${RED}❌ Lighthouse: FAILED${NC}"
    fi
else
    TESTS_SKIPPED=$((TESTS_SKIPPED + 1))
    echo "${YELLOW}⚠️  Lighthouse: SKIPPED (script not found)${NC}"
fi

# Test 4: EPUB Validation
echo ""
echo "${BLUE}═══════════════════════════════════════════${NC}"
echo "${BLUE}TEST 4/5: EPUB Validation${NC}"
echo "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

if [ -f "scripts/validate-epub.sh" ]; then
    TESTS_RUN=$((TESTS_RUN + 1))
    if bash scripts/validate-epub.sh; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "${GREEN}✅ EPUB Validation: PASSED${NC}"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "${RED}❌ EPUB Validation: FAILED${NC}"
    fi
else
    TESTS_SKIPPED=$((TESTS_SKIPPED + 1))
    echo "${YELLOW}⚠️  EPUB Validation: SKIPPED (script not found)${NC}"
fi

# Test 5: Link Checking (if website exists)
echo ""
echo "${BLUE}═══════════════════════════════════════════${NC}"
echo "${BLUE}TEST 5/5: Link Checking${NC}"
echo "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

if [ -d "dist/site" ] && [ -n "$(ls -A dist/site 2>/dev/null)" ]; then
    TESTS_RUN=$((TESTS_RUN + 1))

    # Check if broken-link-checker is installed
    if ! command -v blc &> /dev/null; then
        echo "${YELLOW}⚠️  Installing broken-link-checker...${NC}"
        npm install -g broken-link-checker
    fi

    # Start server
    cd dist/site
    python3 -m http.server 8000 > /dev/null 2>&1 &
    SERVER_PID=$!
    cd ../..
    sleep 2

    # Run link checker
    blc http://localhost:8000 -ro --filter-level 3 > reports/broken-links.txt 2>&1
    BLC_EXIT=$?

    # Stop server
    kill $SERVER_PID 2>/dev/null
    wait $SERVER_PID 2>/dev/null

    BROKEN_LINKS=$(grep -c "BROKEN" reports/broken-links.txt || echo "0")

    if [ "$BROKEN_LINKS" -eq 0 ]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo "${GREEN}✅ Link Checking: PASSED (0 broken links)${NC}"
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "${RED}❌ Link Checking: FAILED ($BROKEN_LINKS broken links)${NC}"
        echo "   See reports/broken-links.txt"
    fi
else
    TESTS_SKIPPED=$((TESTS_SKIPPED + 1))
    echo "${YELLOW}⚠️  Link Checking: SKIPPED (no website to test)${NC}"
fi

# Final Summary
echo ""
echo "=========================================="
echo "FINAL TEST SUMMARY"
echo "=========================================="
echo ""
echo "Tests Run:      $TESTS_RUN"
echo "Tests Passed:   $TESTS_PASSED"
echo "Tests Failed:   $TESTS_FAILED"
echo "Tests Skipped:  $TESTS_SKIPPED"
echo ""

# Calculate pass rate
if [ "$TESTS_RUN" -gt 0 ]; then
    PASS_RATE=$((TESTS_PASSED * 100 / TESTS_RUN))
    echo "Pass Rate:      $PASS_RATE%"
    echo ""
fi

# Generate comprehensive report
cat > reports/FINAL-QA-REPORT.md <<EOF
# Final QA Test Report
**Project:** Language Learning with Technology
**Date:** $(date +%Y-%m-%d)
**Time:** $(date +%H:%M:%S)

## Test Summary
- **Tests Run:** $TESTS_RUN
- **Tests Passed:** $TESTS_PASSED ✅
- **Tests Failed:** $TESTS_FAILED ❌
- **Tests Skipped:** $TESTS_SKIPPED ⚠️
EOF

if [ "$TESTS_RUN" -gt 0 ]; then
    PASS_RATE=$((TESTS_PASSED * 100 / TESTS_RUN))
    echo "- **Pass Rate:** $PASS_RATE%" >> reports/FINAL-QA-REPORT.md
fi

cat >> reports/FINAL-QA-REPORT.md <<EOF

## Test Results

### 1. Content Quality
- Spelling check
- Grammar check
- Readability analysis
- Consistency validation

**Report:** \`content-quality-summary.md\`

### 2. Accessibility (WCAG 2.1 AA)
- HTML validation
- pa11y automated testing
- Keyboard navigation (manual)
- Screen reader compatibility (manual)

**Report:** \`accessibility-summary.md\`

### 3. Lighthouse Performance
- Performance score
- Accessibility score
- Best practices score
- SEO score

**Report:** \`lighthouse-summary.md\`

### 4. EPUB Validation
- EPUBCheck validation
- Metadata verification
- Structure validation

**Report:** \`epub-validation.log\`

### 5. Link Checking
- Internal link validation
- External link validation

**Report:** \`broken-links.txt\`

## Detailed Reports
All detailed test reports are available in the \`reports/\` directory:
- \`content-quality-summary.md\`
- \`accessibility-summary.md\`
- \`lighthouse-summary.md\`
- \`epub-validation.log\`
- \`broken-links.txt\`

## Next Steps
EOF

if [ "$TESTS_FAILED" -eq 0 ] && [ "$TESTS_RUN" -gt 0 ]; then
    cat >> reports/FINAL-QA-REPORT.md <<EOF

✅ **All tests passed!** Project is ready for deployment.

### Pre-Deployment Checklist
- [ ] Final content review
- [ ] Stakeholder approval
- [ ] Backup all files
- [ ] Prepare deployment package
- [ ] Deploy to staging environment
- [ ] Final smoke test
- [ ] Deploy to production
EOF
else
    cat >> reports/FINAL-QA-REPORT.md <<EOF

❌ **Some tests failed.** Please review and fix issues before deployment.

### Action Items
1. Review failed test reports in \`reports/\` directory
2. Fix all critical issues (errors, broken links, accessibility violations)
3. Re-run failed tests: \`bash scripts/run-all-tests.sh\`
4. Verify all tests pass
5. Proceed to deployment

### Failed Tests
EOF

    # List failed tests
    if grep -q "Content Quality: FAILED" reports/FINAL-QA-REPORT.md 2>/dev/null; then
        echo "- Content Quality (spelling, grammar, readability)" >> reports/FINAL-QA-REPORT.md
    fi
fi

echo "Comprehensive report: reports/FINAL-QA-REPORT.md"
echo ""

# Exit with appropriate code
if [ "$TESTS_FAILED" -eq 0 ] && [ "$TESTS_RUN" -gt 0 ]; then
    echo "${GREEN}✅ ALL QA TESTS PASSED${NC}"
    echo ""
    exit 0
else
    echo "${RED}❌ SOME QA TESTS FAILED${NC}"
    echo "Review reports and fix issues before deployment."
    echo ""
    exit 1
fi
