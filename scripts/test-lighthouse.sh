#!/bin/bash

# Lighthouse Testing Script
# Language Learning with Technology Project

echo "=========================================="
echo "Lighthouse Performance & Quality Testing"
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

# Check if lighthouse is installed
if ! command -v lighthouse &> /dev/null; then
    echo "${YELLOW}⚠️  Lighthouse not found. Installing...${NC}"
    npm install -g lighthouse
fi

# Start local server
echo "${BLUE}🚀 Starting local server on port 8000...${NC}"
cd dist/site
python3 -m http.server 8000 > /dev/null 2>&1 &
SERVER_PID=$!
cd ../..

# Wait for server to start
sleep 3

# Check if server is running
if ! curl -s http://localhost:8000 > /dev/null; then
    echo "${RED}❌ Failed to start local server${NC}"
    exit 1
fi

echo "${GREEN}✅ Server running${NC}"
echo ""

# Define pages to test
PAGES=(
    "index.html"
    "chapter1.html"
    "chapter2.html"
    "chapter3.html"
)

# Test each page
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

for PAGE in "${PAGES[@]}"; do
    URL="http://localhost:8000/$PAGE"

    # Check if page exists
    if ! curl -s -f "$URL" > /dev/null 2>&1; then
        echo "${YELLOW}⚠️  Skipping $PAGE (not found)${NC}"
        continue
    fi

    TOTAL_TESTS=$((TOTAL_TESTS + 1))

    echo "-------------------------------------------"
    echo "Testing: $PAGE"
    echo "-------------------------------------------"

    # Run Lighthouse
    OUTPUT_BASE="reports/lighthouse-${PAGE%.html}"

    lighthouse "$URL" \
        --output json \
        --output html \
        --output-path "$OUTPUT_BASE" \
        --quiet \
        --chrome-flags="--headless" 2>&1 | grep -v "Chrome is being controlled"

    # Parse results
    RESULTS_FILE="${OUTPUT_BASE}.report.json"

    if [ ! -f "$RESULTS_FILE" ]; then
        echo "${RED}❌ Lighthouse failed to generate report${NC}"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        continue
    fi

    # Extract scores using jq (if available)
    if command -v jq &> /dev/null; then
        PERFORMANCE=$(jq -r '.categories.performance.score * 100 | floor' "$RESULTS_FILE")
        ACCESSIBILITY=$(jq -r '.categories.accessibility.score * 100 | floor' "$RESULTS_FILE")
        BEST_PRACTICES=$(jq -r '.categories["best-practices"].score * 100 | floor' "$RESULTS_FILE")
        SEO=$(jq -r '.categories.seo.score * 100 | floor' "$RESULTS_FILE")

        echo "  Performance:     $PERFORMANCE/100"
        echo "  Accessibility:   $ACCESSIBILITY/100"
        echo "  Best Practices:  $BEST_PRACTICES/100"
        echo "  SEO:             $SEO/100"

        # Check if all scores meet threshold
        THRESHOLD=90
        if [ "$PERFORMANCE" -ge "$THRESHOLD" ] && \
           [ "$ACCESSIBILITY" -ge "$THRESHOLD" ] && \
           [ "$BEST_PRACTICES" -ge "$THRESHOLD" ] && \
           [ "$SEO" -ge "$THRESHOLD" ]; then
            echo "${GREEN}  ✅ PASSED (all scores ≥ $THRESHOLD)${NC}"
            PASSED_TESTS=$((PASSED_TESTS + 1))
        else
            echo "${RED}  ❌ FAILED (some scores < $THRESHOLD)${NC}"
            FAILED_TESTS=$((FAILED_TESTS + 1))

            # Show which categories failed
            [ "$PERFORMANCE" -lt "$THRESHOLD" ] && echo "${RED}     - Performance: $PERFORMANCE < $THRESHOLD${NC}"
            [ "$ACCESSIBILITY" -lt "$THRESHOLD" ] && echo "${RED}     - Accessibility: $ACCESSIBILITY < $THRESHOLD${NC}"
            [ "$BEST_PRACTICES" -lt "$THRESHOLD" ] && echo "${RED}     - Best Practices: $BEST_PRACTICES < $THRESHOLD${NC}"
            [ "$SEO" -lt "$THRESHOLD" ] && echo "${RED}     - SEO: $SEO < $THRESHOLD${NC}"
        fi
    else
        echo "${YELLOW}⚠️  jq not installed, scores not parsed${NC}"
        echo "  Results saved to ${OUTPUT_BASE}.report.html"
    fi

    echo ""
done

# Stop server
echo "${BLUE}🛑 Stopping local server...${NC}"
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null

# Summary
echo "=========================================="
echo "SUMMARY"
echo "=========================================="
echo ""
echo "Total pages tested:     $TOTAL_TESTS"
echo "Passed (≥90 all):       $PASSED_TESTS"
echo "Failed (<90 any):       $FAILED_TESTS"
echo ""

# Generate markdown summary
cat > reports/lighthouse-summary.md <<EOF
# Lighthouse Test Results
**Date:** $(date +%Y-%m-%d)

## Summary
- **Total Pages Tested:** $TOTAL_TESTS
- **Passed:** $PASSED_TESTS
- **Failed:** $FAILED_TESTS

## Details
View individual HTML reports in the \`reports/\` directory:
EOF

for PAGE in "${PAGES[@]}"; do
    if [ -f "reports/lighthouse-${PAGE%.html}.report.html" ]; then
        echo "- [\`${PAGE}\`](lighthouse-${PAGE%.html}.report.html)" >> reports/lighthouse-summary.md
    fi
done

cat >> reports/lighthouse-summary.md <<EOF

## Criteria
All categories must score ≥ 90:
- ✅ Performance
- ✅ Accessibility
- ✅ Best Practices
- ✅ SEO

## Next Steps
1. Review failed reports
2. Fix identified issues
3. Re-run tests
4. Verify all scores ≥ 90
EOF

if [ "$FAILED_TESTS" -eq 0 ] && [ "$TOTAL_TESTS" -gt 0 ]; then
    echo "${GREEN}✅ All Lighthouse tests PASSED${NC}"
    echo ""
    exit 0
else
    echo "${RED}❌ Some Lighthouse tests FAILED${NC}"
    echo "Review reports in reports/ directory"
    echo ""
    exit 1
fi
