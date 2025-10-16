#!/bin/bash

# EPUB Validation Script
# Language Learning with Technology Project

echo "=========================================="
echo "EPUB Validation"
echo "Language Learning with Technology"
echo "=========================================="
echo ""

# Define EPUB file location
EPUB_FILE="dist/kdp/Language-Learning-with-Technology.epub"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Create reports directory
mkdir -p reports

# Check if EPUB file exists
if [ ! -f "$EPUB_FILE" ]; then
    echo "${RED}❌ ERROR: EPUB file not found: $EPUB_FILE${NC}"
    echo ""
    echo "Expected location: $EPUB_FILE"
    echo ""
    echo "Please generate the EPUB file before running validation."
    echo ""
    exit 1
fi

echo "${GREEN}✅ Found EPUB file: $EPUB_FILE${NC}"
echo ""

# Check file size
FILE_SIZE=$(du -h "$EPUB_FILE" | cut -f1)
echo "File size: $FILE_SIZE"
echo ""

# Check if EPUBCheck is available
EPUBCHECK_JAR=""

# Common locations to check
POSSIBLE_LOCATIONS=(
    "epubcheck.jar"
    "/usr/local/bin/epubcheck.jar"
    "/opt/epubcheck/epubcheck.jar"
    "$HOME/epubcheck/epubcheck.jar"
    "C:/Program Files/epubcheck/epubcheck.jar"
)

for LOCATION in "${POSSIBLE_LOCATIONS[@]}"; do
    if [ -f "$LOCATION" ]; then
        EPUBCHECK_JAR="$LOCATION"
        break
    fi
done

if [ -z "$EPUBCHECK_JAR" ]; then
    echo "${YELLOW}⚠️  EPUBCheck not found${NC}"
    echo ""
    echo "To install EPUBCheck:"
    echo "1. Install Java Runtime Environment (JRE) 8 or higher"
    echo "2. Download EPUBCheck from:"
    echo "   https://github.com/w3c/epubcheck/releases"
    echo "3. Extract epubcheck.jar to one of these locations:"
    for LOC in "${POSSIBLE_LOCATIONS[@]}"; do
        echo "   - $LOC"
    done
    echo ""
    echo "Then re-run this script."
    echo ""
    exit 1
fi

echo "${GREEN}✅ Found EPUBCheck: $EPUBCHECK_JAR${NC}"
echo ""

# Check Java version
if ! command -v java &> /dev/null; then
    echo "${RED}❌ Java not found. Please install Java Runtime Environment.${NC}"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | head -n 1)
echo "Java version: $JAVA_VERSION"
echo ""

# Run EPUBCheck
echo "${BLUE}🔍 Running EPUBCheck validation...${NC}"
echo "-------------------------------------------"

java -jar "$EPUBCHECK_JAR" "$EPUB_FILE" --mode exp --save 2>&1 | tee reports/epub-validation.log

EPUB_EXIT=${PIPESTATUS[0]}

echo "-------------------------------------------"
echo ""

# Parse results
if [ -f reports/epub-validation.log ]; then
    FATAL_ERRORS=$(grep -c "FATAL" reports/epub-validation.log || echo "0")
    ERRORS=$(grep -c "ERROR" reports/epub-validation.log || echo "0")
    WARNINGS=$(grep -c "WARNING" reports/epub-validation.log || echo "0")
    INFO=$(grep -c "INFO" reports/epub-validation.log || echo "0")

    echo "=========================================="
    echo "VALIDATION RESULTS"
    echo "=========================================="
    echo ""
    echo "Fatal Errors:  $FATAL_ERRORS"
    echo "Errors:        $ERRORS"
    echo "Warnings:      $WARNINGS"
    echo "Info:          $INFO"
    echo ""

    # Show sample errors if any
    if [ "$ERRORS" -gt 0 ] || [ "$FATAL_ERRORS" -gt 0 ]; then
        echo "${RED}❌ VALIDATION FAILED${NC}"
        echo ""
        echo "Sample errors:"
        grep -E "ERROR|FATAL" reports/epub-validation.log | head -5
        echo ""
        echo "Full report: reports/epub-validation.log"
        echo ""

        # Common fixes
        cat > reports/epub-fixes-recommended.md <<EOF
# EPUB Validation Issues - Recommended Fixes

## Common Errors Found

### 1. Missing or Invalid Metadata
**Error:** OPF-062: Required element missing

**Fix:** Add to content.opf:
\`\`\`xml
<metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
  <dc:title>Language Learning with Technology</dc:title>
  <dc:creator>Author Name</dc:creator>
  <dc:language>en</dc:language>
  <dc:identifier id="uid">urn:uuid:$(uuidgen)</dc:identifier>
  <dc:date>$(date +%Y-%m-%d)</dc:date>
</metadata>
\`\`\`

### 2. Invalid HTML/XHTML
**Error:** RSC-005: Error while parsing file

**Fix:** Ensure all content files are valid XHTML5:
- Properly closed tags
- Lowercase element names
- Quoted attributes
- Valid nesting

### 3. Missing TOC
**Error:** OPF-058: No TOC file found

**Fix:** Create nav.xhtml with navigation:
\`\`\`xml
<nav epub:type="toc">
  <h1>Table of Contents</h1>
  <ol>
    <li><a href="chapter1.xhtml">Chapter 1</a></li>
    <li><a href="chapter2.xhtml">Chapter 2</a></li>
  </ol>
</nav>
\`\`\`

### 4. Broken Links
**Error:** RSC-007: Referenced resource not found

**Fix:** Verify all links and file paths are correct.

### 5. Missing Cover Image
**Error:** OPF-012: Invalid cover-image property

**Fix:** Add cover image to manifest and mark as cover:
\`\`\`xml
<item id="cover-image" href="images/cover.jpg"
      media-type="image/jpeg" properties="cover-image"/>
\`\`\`

## Next Steps
1. Review full error log: reports/epub-validation.log
2. Fix all FATAL and ERROR issues
3. Address WARNINGS for best practices
4. Re-run validation
5. Test in EPUB readers (Calibre, Adobe Digital Editions)

EOF

        echo "Recommended fixes: reports/epub-fixes-recommended.md"
        exit 1

    elif [ "$WARNINGS" -gt 0 ]; then
        echo "${YELLOW}⚠️  VALIDATION PASSED WITH WARNINGS${NC}"
        echo ""
        echo "Sample warnings:"
        grep "WARNING" reports/epub-validation.log | head -5
        echo ""
        echo "Full report: reports/epub-validation.log"
        echo ""
        echo "Consider addressing warnings for better quality."
        exit 0
    else
        echo "${GREEN}✅ VALIDATION PASSED${NC}"
        echo ""
        echo "No errors or warnings found!"
        echo ""

        # Additional tests
        echo "📚 Additional Recommendations:"
        echo "-------------------------------------------"
        echo "1. Test in multiple EPUB readers:"
        echo "   - Calibre (Desktop)"
        echo "   - Adobe Digital Editions (Desktop)"
        echo "   - Apple Books (iOS/macOS)"
        echo "   - Google Play Books (Web/Mobile)"
        echo ""
        echo "2. Verify accessibility:"
        echo "   - All images have alt text"
        echo "   - Proper heading hierarchy"
        echo "   - Table structures correct"
        echo "   - Language attributes set"
        echo ""
        echo "3. Check cover image:"
        echo "   - Dimensions: 2560x1600px (KDP requirement)"
        echo "   - Format: JPG or PNG"
        echo "   - DPI: 300+"
        echo "   - File size: <50MB"
        echo ""

        exit 0
    fi
else
    echo "${RED}❌ Validation log not created${NC}"
    exit 1
fi
