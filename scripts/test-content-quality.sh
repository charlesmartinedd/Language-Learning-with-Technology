#!/bin/bash

# Content Quality Testing Script
# Language Learning with Technology Project

echo "=========================================="
echo "Content Quality Testing"
echo "Language Learning with Technology"
echo "=========================================="
echo ""

# Check if content exists
if [ ! -d "content/chapters" ] || [ -z "$(ls -A content/chapters 2>/dev/null)" ]; then
    echo "⚠️  WARNING: No content files found in content/chapters/"
    echo "Please generate content before running tests."
    exit 1
fi

# Create reports directory
mkdir -p reports

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "📝 Testing Phase 1: Spell Checking"
echo "-------------------------------------------"

# Check if cspell is installed
if ! command -v cspell &> /dev/null; then
    echo "${YELLOW}⚠️  cspell not found. Installing...${NC}"
    npm install -g cspell
fi

# Run spell check on markdown files
cspell "content/**/*.md" --show-context --show-suggestions > reports/spelling-errors.txt 2>&1
SPELL_EXIT=$?

if [ $SPELL_EXIT -eq 0 ]; then
    echo "${GREEN}✅ No spelling errors found${NC}"
    SPELL_ERRORS=0
else
    SPELL_ERRORS=$(grep -c "Unknown word" reports/spelling-errors.txt || echo "0")
    echo "${RED}❌ Found $SPELL_ERRORS spelling errors${NC}"
    echo "   See reports/spelling-errors.txt for details"
fi
echo ""

echo "📖 Testing Phase 2: Grammar Checking"
echo "-------------------------------------------"

# Check if write-good is installed
if ! command -v write-good &> /dev/null; then
    echo "${YELLOW}⚠️  write-good not found. Installing...${NC}"
    npm install -g write-good
fi

# Run grammar check
write-good content/**/*.md > reports/grammar-issues.txt 2>&1
GRAMMAR_EXIT=$?

if [ $GRAMMAR_EXIT -eq 0 ]; then
    echo "${GREEN}✅ No grammar issues found${NC}"
    GRAMMAR_ISSUES=0
else
    GRAMMAR_ISSUES=$(wc -l < reports/grammar-issues.txt || echo "0")
    echo "${YELLOW}⚠️  Found $GRAMMAR_ISSUES grammar suggestions${NC}"
    echo "   See reports/grammar-issues.txt for details"
fi
echo ""

echo "📊 Testing Phase 3: Readability Analysis"
echo "-------------------------------------------"

# Check if readability-cli is installed
if ! command -v readability &> /dev/null; then
    echo "${YELLOW}⚠️  readability-cli not found. Installing...${NC}"
    npm install -g readability-cli
fi

# Run readability analysis
readability content/**/*.md > reports/readability-scores.txt 2>&1

# Parse readability scores (if available)
if [ -f reports/readability-scores.txt ]; then
    echo "${GREEN}✅ Readability analysis complete${NC}"
    echo "   See reports/readability-scores.txt for details"

    # Try to extract Flesch Reading Ease score
    FLESCH_SCORE=$(grep -oP "Flesch Reading Ease: \K[0-9.]+" reports/readability-scores.txt | head -1 || echo "N/A")
    if [ "$FLESCH_SCORE" != "N/A" ]; then
        echo "   Flesch Reading Ease: $FLESCH_SCORE (Target: 60-70)"
    fi
else
    echo "${YELLOW}⚠️  Readability analysis incomplete${NC}"
fi
echo ""

echo "🔍 Testing Phase 4: Consistency Checking"
echo "-------------------------------------------"

# Check for common inconsistencies
CONSISTENCY_ISSUES=0

# Check for inconsistent AI terminology
grep -rn "A\.I\." content/chapters/*.md > reports/consistency-ai-dots.txt 2>/dev/null
AI_DOTS=$(wc -l < reports/consistency-ai-dots.txt || echo "0")

if [ "$AI_DOTS" -gt 0 ]; then
    echo "${YELLOW}⚠️  Found $AI_DOTS instances of 'A.I.' (prefer 'AI')${NC}"
    CONSISTENCY_ISSUES=$((CONSISTENCY_ISSUES + AI_DOTS))
fi

# Check for inconsistent e-learning spelling
grep -rn "eLearning\|e-Learning" content/chapters/*.md > reports/consistency-elearning.txt 2>/dev/null
ELEARNING_INCONSISTENT=$(wc -l < reports/consistency-elearning.txt || echo "0")

if [ "$ELEARNING_INCONSISTENT" -gt 0 ]; then
    echo "${YELLOW}⚠️  Found inconsistent e-learning spelling (use 'e-learning')${NC}"
    CONSISTENCY_ISSUES=$((CONSISTENCY_ISSUES + ELEARNING_INCONSISTENT))
fi

# Check for 'click here' links
grep -rn "click here\|Click here" content/chapters/*.md > reports/consistency-click-here.txt 2>/dev/null
CLICK_HERE=$(wc -l < reports/consistency-click-here.txt || echo "0")

if [ "$CLICK_HERE" -gt 0 ]; then
    echo "${YELLOW}⚠️  Found $CLICK_HERE instances of 'click here' (use descriptive links)${NC}"
    CONSISTENCY_ISSUES=$((CONSISTENCY_ISSUES + CLICK_HERE))
fi

if [ "$CONSISTENCY_ISSUES" -eq 0 ]; then
    echo "${GREEN}✅ No consistency issues found${NC}"
else
    echo "${YELLOW}⚠️  Found $CONSISTENCY_ISSUES consistency issues${NC}"
fi
echo ""

echo "✅ Testing Phase 5: Fact-Checking Reminders"
echo "-------------------------------------------"
echo "⚠️  Manual fact-checking required for:"
echo "   - Technology version numbers (ChatGPT, Claude, etc.)"
echo "   - Statistics and research data"
echo "   - Product features and capabilities"
echo "   - Publication dates and citations"
echo ""

# Generate summary report
echo "=========================================="
echo "SUMMARY"
echo "=========================================="
echo ""

TOTAL_ISSUES=$((SPELL_ERRORS + GRAMMAR_ISSUES + CONSISTENCY_ISSUES))

echo "Spelling errors:        $SPELL_ERRORS"
echo "Grammar suggestions:    $GRAMMAR_ISSUES"
echo "Consistency issues:     $CONSISTENCY_ISSUES"
echo "-------------------------------------------"
echo "Total issues:           $TOTAL_ISSUES"
echo ""

# Generate combined report
cat > reports/content-quality-summary.md <<EOF
# Content Quality Test Results
**Date:** $(date +%Y-%m-%d)

## Summary
- **Spelling Errors:** $SPELL_ERRORS
- **Grammar Issues:** $GRAMMAR_ISSUES
- **Consistency Issues:** $CONSISTENCY_ISSUES
- **Total Issues:** $TOTAL_ISSUES

## Details
- Spelling: See \`spelling-errors.txt\`
- Grammar: See \`grammar-issues.txt\`
- Readability: See \`readability-scores.txt\`
- Consistency: See \`consistency-*.txt\`

## Status
EOF

if [ "$TOTAL_ISSUES" -eq 0 ]; then
    echo "**Status:** ✅ PASSED - All automated checks passed" >> reports/content-quality-summary.md
    echo ""
    echo "${GREEN}✅ All content quality checks PASSED${NC}"
    echo ""
    echo "Detailed reports saved in reports/ directory"
    exit 0
else
    echo "**Status:** ❌ FAILED - Issues found requiring review" >> reports/content-quality-summary.md
    echo ""
    echo "${RED}❌ Content quality checks FAILED${NC}"
    echo ""
    echo "Please review and fix issues documented in reports/ directory"
    echo ""
    exit 1
fi
