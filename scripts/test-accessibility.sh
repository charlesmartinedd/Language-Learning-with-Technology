#!/bin/bash

# Accessibility Testing Script
# Language Learning with Technology Project

echo "=========================================="
echo "Accessibility Testing (WCAG 2.1 AA)"
echo "Language Learning with Technology"
echo "=========================================="
echo ""

# Check if website is built
if [ ! -d "dist/site" ] || [ -z "$(ls -A dist/site 2>/dev/null)" ]; then
    echo "⚠️  ERROR: No website found in dist/site/"
    echo "Please build the website before running tests."
    exit 1
fi

# Create reports directory
mkdir -p reports

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if pa11y is installed
if ! command -v pa11y &> /dev/null; then
    echo "${YELLOW}⚠️  pa11y not found. Installing...${NC}"
    npm install -g pa11y
fi

# Check if html-validate is installed
if ! command -v html-validate &> /dev/null; then
    echo "${YELLOW}⚠️  html-validate not found. Installing...${NC}"
    npm install -g html-validate
fi

# Start local server
echo "${BLUE}🚀 Starting local server on port 8000...${NC}"
cd dist/site
python3 -m http.server 8000 > /dev/null 2>&1 &
SERVER_PID=$!
cd ../..

sleep 3

if ! curl -s http://localhost:8000 > /dev/null; then
    echo "${RED}❌ Failed to start local server${NC}"
    exit 1
fi

echo "${GREEN}✅ Server running${NC}"
echo ""

# Test 1: HTML Validation
echo "📋 Test 1: HTML Validation"
echo "-------------------------------------------"

html-validate "dist/site/**/*.html" > reports/html-validation.log 2>&1
HTML_EXIT=$?

if [ $HTML_EXIT -eq 0 ]; then
    echo "${GREEN}✅ HTML validation passed${NC}"
    HTML_ERRORS=0
else
    HTML_ERRORS=$(grep -c "error" reports/html-validation.log || echo "0")
    HTML_WARNINGS=$(grep -c "warning" reports/html-validation.log || echo "0")
    echo "${RED}❌ Found $HTML_ERRORS HTML errors, $HTML_WARNINGS warnings${NC}"
    echo "   See reports/html-validation.log"
fi
echo ""

# Test 2: pa11y Accessibility Testing
echo "♿ Test 2: pa11y Accessibility Testing"
echo "-------------------------------------------"

# Define pages to test
PAGES=(
    "http://localhost:8000/index.html"
    "http://localhost:8000/chapter1.html"
    "http://localhost:8000/chapter2.html"
)

TOTAL_A11Y_ISSUES=0

for URL in "${PAGES[@]}"; do
    PAGE_NAME=$(basename "$URL")

    # Check if page exists
    if ! curl -s -f "$URL" > /dev/null 2>&1; then
        echo "${YELLOW}⚠️  Skipping $PAGE_NAME (not found)${NC}"
        continue
    fi

    echo "Testing: $PAGE_NAME"

    # Run pa11y
    pa11y "$URL" \
        --standard WCAG2AA \
        --reporter json \
        > "reports/pa11y-${PAGE_NAME%.html}.json" 2>&1

    # Count issues
    if command -v jq &> /dev/null; then
        ISSUES=$(jq 'length' "reports/pa11y-${PAGE_NAME%.html}.json" 2>/dev/null || echo "0")
        TOTAL_A11Y_ISSUES=$((TOTAL_A11Y_ISSUES + ISSUES))

        if [ "$ISSUES" -eq 0 ]; then
            echo "${GREEN}  ✅ No accessibility issues${NC}"
        else
            echo "${RED}  ❌ Found $ISSUES accessibility issues${NC}"

            # Show issue types
            ERRORS=$(jq '[.[] | select(.type == "error")] | length' "reports/pa11y-${PAGE_NAME%.html}.json" 2>/dev/null || echo "0")
            WARNINGS=$(jq '[.[] | select(.type == "warning")] | length' "reports/pa11y-${PAGE_NAME%.html}.json" 2>/dev/null || echo "0")
            NOTICES=$(jq '[.[] | select(.type == "notice")] | length' "reports/pa11y-${PAGE_NAME%.html}.json" 2>/dev/null || echo "0")

            echo "     Errors: $ERRORS, Warnings: $WARNINGS, Notices: $NOTICES"
        fi
    else
        echo "${YELLOW}  ⚠️  jq not installed, see reports/pa11y-${PAGE_NAME%.html}.json${NC}"
    fi
done
echo ""

# Test 3: Color Contrast Analysis
echo "🎨 Test 3: Color Contrast Check"
echo "-------------------------------------------"
echo "${YELLOW}⚠️  Manual check required:${NC}"
echo "   1. Open dist/site/index.html in Chrome"
echo "   2. Open DevTools (F12)"
echo "   3. Inspect text elements"
echo "   4. Check contrast ratios in color picker"
echo "   5. Ensure ≥4.5:1 for normal text, ≥3:1 for large text"
echo ""

# Test 4: Keyboard Navigation
echo "⌨️  Test 4: Keyboard Navigation"
echo "-------------------------------------------"
echo "${YELLOW}⚠️  Manual check required:${NC}"
echo "   1. Open website in browser"
echo "   2. Press Tab to navigate through interactive elements"
echo "   3. Verify focus indicators visible"
echo "   4. Ensure all functionality accessible via keyboard"
echo "   5. Check no keyboard traps"
echo ""

# Test 5: Screen Reader Testing
echo "🔊 Test 5: Screen Reader Compatibility"
echo "-------------------------------------------"
echo "${YELLOW}⚠️  Manual check required:${NC}"
echo "   Windows: NVDA (https://www.nvaccess.org/download/)"
echo "   macOS:   VoiceOver (Cmd+F5)"
echo "   1. Enable screen reader"
echo "   2. Navigate through website"
echo "   3. Verify all content announced"
echo "   4. Check alt text on images"
echo "   5. Ensure form labels present"
echo ""

# Test 6: Responsive Design
echo "📱 Test 6: Responsive Design"
echo "-------------------------------------------"
echo "${YELLOW}⚠️  Manual check required:${NC}"
echo "   1. Open DevTools (F12)"
echo "   2. Toggle device toolbar (Ctrl+Shift+M)"
echo "   3. Test at different viewport sizes:"
echo "      - Mobile: 375px width"
echo "      - Tablet: 768px width"
echo "      - Desktop: 1920px width"
echo "   4. Verify content reflows properly"
echo "   5. Check no horizontal scrolling at 320px"
echo ""

# Stop server
echo "${BLUE}🛑 Stopping local server...${NC}"
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null

# Summary
echo "=========================================="
echo "SUMMARY"
echo "=========================================="
echo ""
echo "HTML Validation Errors:     $HTML_ERRORS"
echo "Accessibility Issues:       $TOTAL_A11Y_ISSUES"
echo ""

# Generate markdown report
cat > reports/accessibility-summary.md <<EOF
# Accessibility Test Results
**Date:** $(date +%Y-%m-%d)
**Standard:** WCAG 2.1 Level AA

## Automated Tests

### HTML Validation
- **Errors:** $HTML_ERRORS
- **Details:** See \`html-validation.log\`

### pa11y Accessibility Testing
- **Total Issues:** $TOTAL_A11Y_ISSUES
- **Details:** See \`pa11y-*.json\` files

## Manual Tests Required

### ⌨️ Keyboard Navigation
- [ ] All interactive elements reachable via Tab
- [ ] Focus indicators visible (≥3:1 contrast)
- [ ] No keyboard traps
- [ ] Logical tab order

### 🎨 Color Contrast
- [ ] Normal text: ≥4.5:1
- [ ] Large text (18pt+): ≥3:1
- [ ] UI components: ≥3:1

### 🔊 Screen Reader
- [ ] Tested with NVDA/VoiceOver
- [ ] All content announced
- [ ] Images have alt text
- [ ] Forms have labels
- [ ] Landmarks present

### 📱 Responsive Design
- [ ] Mobile (375px): Content reflows
- [ ] Tablet (768px): Layout adapts
- [ ] Desktop (1920px): Full experience
- [ ] 320px width: No horizontal scroll

## Status
EOF

if [ "$HTML_ERRORS" -eq 0 ] && [ "$TOTAL_A11Y_ISSUES" -eq 0 ]; then
    echo "**Automated Tests:** ✅ PASSED" >> reports/accessibility-summary.md
    echo "${GREEN}✅ Automated accessibility tests PASSED${NC}"
    echo ""
    echo "Complete manual testing checklist in reports/accessibility-summary.md"
    exit 0
else
    echo "**Automated Tests:** ❌ FAILED" >> reports/accessibility-summary.md
    echo "${RED}❌ Automated accessibility tests FAILED${NC}"
    echo ""
    echo "Fix issues and complete manual testing"
    exit 1
fi
