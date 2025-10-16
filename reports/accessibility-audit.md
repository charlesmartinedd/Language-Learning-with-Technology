# Accessibility Audit Report
## Language Learning with Technology

**Date:** 2025-10-16
**Standard:** WCAG 2.1 Level AA
**Status:** PENDING - No website files available

---

## Executive Summary

This report outlines the accessibility testing plan for the Language Learning with Technology website. All testing will be performed against WCAG 2.1 Level AA standards.

**Current Status:** Awaiting website build
**Target Compliance:** WCAG 2.1 Level AA
**Tools Ready:** ✅ Testing methodology prepared

---

## 1. WCAG 2.1 PRINCIPLES

### 1.1 Perceivable
Information and user interface components must be presentable to users in ways they can perceive.

### 1.2 Operable
User interface components and navigation must be operable.

### 1.3 Understandable
Information and the operation of the user interface must be understandable.

### 1.4 Robust
Content must be robust enough to be interpreted by a wide variety of user agents, including assistive technologies.

---

## 2. TESTING METHODOLOGY

### Automated Testing Tools

#### 2.1 axe DevTools (Browser Extension)
- **Install:** Chrome Web Store or Firefox Add-ons
- **Coverage:** WCAG 2.0 Level A, AA, AAA
- **Tests:** 90+ accessibility rules
- **Usage:** Run on each page, export results

#### 2.2 Lighthouse (Chrome DevTools)
- **Built-in:** Chrome browser
- **Command Line:** `npm install -g lighthouse`
- **Tests:** Performance, Accessibility, Best Practices, SEO
- **Target:** Accessibility score ≥ 90

#### 2.3 pa11y (Command Line)
```bash
npm install -g pa11y
pa11y http://localhost:8000
pa11y-ci --config .pa11yci.json
```

#### 2.4 WAVE (Browser Extension)
- **Install:** Chrome/Firefox extension
- **Visual:** Highlights issues on page
- **Categories:** Errors, alerts, features, structural elements

### Manual Testing Requirements

#### 2.5 Keyboard Navigation
- [ ] Tab through all interactive elements
- [ ] Test all functionality without mouse
- [ ] Verify focus indicators visible
- [ ] Check no keyboard traps
- [ ] Test skip navigation links

#### 2.6 Screen Reader Testing
- [ ] NVDA (Windows - Free)
- [ ] JAWS (Windows - Trial/Paid)
- [ ] VoiceOver (macOS/iOS - Built-in)
- [ ] TalkBack (Android - Built-in)

#### 2.7 Visual Testing
- [ ] Zoom to 200% (no loss of content/functionality)
- [ ] Test with high contrast mode
- [ ] Test with color blindness simulators
- [ ] Verify text spacing adjustable

---

## 3. DETAILED TESTING CHECKLIST

### 3.1 PERCEIVABLE

#### 1.1.1 Non-text Content (Level A)
- [ ] All images have alt text
- [ ] Decorative images use alt=""
- [ ] Complex images have detailed descriptions
- [ ] Form inputs have associated labels
- [ ] Icons have text alternatives

**Test Command:**
```bash
pa11y http://localhost:8000 --standard WCAG2AA --rule "WCAG2AA.Principle1.Guideline1_1.*"
```

#### 1.2.1 Audio-only and Video-only (Level A)
- [ ] Transcripts for audio content
- [ ] Audio description or transcript for video
- [ ] Captions for pre-recorded video

#### 1.3.1 Info and Relationships (Level A)
- [ ] Semantic HTML elements used
- [ ] Headings in logical order (H1 → H2 → H3)
- [ ] Lists use proper markup (ul, ol, dl)
- [ ] Tables use th, caption, scope
- [ ] Form labels properly associated

**Test Command:**
```bash
# Check heading hierarchy
pa11y http://localhost:8000 --rule "WCAG2AA.Principle1.Guideline1_3.1_3_1_H42"
```

#### 1.3.2 Meaningful Sequence (Level A)
- [ ] Reading order matches visual order
- [ ] Content makes sense when linearized
- [ ] CSS positioning doesn't break order

#### 1.3.3 Sensory Characteristics (Level A)
- [ ] Instructions don't rely only on shape/size/visual location/orientation/sound
- [ ] Example: "Click the button on the right" → "Click the Submit button"

#### 1.4.1 Use of Color (Level A)
- [ ] Color not sole means of conveying information
- [ ] Links distinguishable without color alone
- [ ] Form errors shown with text, not just red color

#### 1.4.3 Contrast (Minimum) (Level AA) ⭐
- [ ] Text contrast ≥ 4.5:1 (normal text)
- [ ] Text contrast ≥ 3:1 (large text: 18pt+ or 14pt+ bold)
- [ ] UI component contrast ≥ 3:1

**Test Tools:**
- Chrome DevTools (Inspect → Color picker shows contrast ratio)
- WebAIM Contrast Checker: https://webaim.org/resources/contrastchecker/
- axe DevTools automatically checks

#### 1.4.4 Resize Text (Level AA)
- [ ] Text resizable to 200% without loss of content/functionality
- [ ] No horizontal scrolling (vertical OK)

**Test:** Browser zoom to 200%

#### 1.4.5 Images of Text (Level AA)
- [ ] Use actual text instead of images of text
- [ ] Exception: Logos, essential images

#### 1.4.10 Reflow (Level AA)
- [ ] Content reflows at 320px width (mobile)
- [ ] No 2D scrolling required

#### 1.4.11 Non-text Contrast (Level AA)
- [ ] UI components ≥ 3:1 contrast
- [ ] Graphical objects ≥ 3:1 contrast

#### 1.4.12 Text Spacing (Level AA)
- [ ] Content adapts to:
  - Line height: 1.5x font size
  - Paragraph spacing: 2x font size
  - Letter spacing: 0.12x font size
  - Word spacing: 0.16x font size

#### 1.4.13 Content on Hover or Focus (Level AA)
- [ ] Hover/focus content dismissible
- [ ] Hoverable (pointer can move to it)
- [ ] Persistent (doesn't disappear)

---

### 3.2 OPERABLE

#### 2.1.1 Keyboard (Level A) ⭐
- [ ] All functionality available via keyboard
- [ ] Tab order logical
- [ ] Enter/Space activates buttons
- [ ] Arrow keys navigate menus/tabs

**Manual Test:** Unplug mouse, use only keyboard

#### 2.1.2 No Keyboard Trap (Level A)
- [ ] Focus never trapped
- [ ] Can exit all components with keyboard

#### 2.1.4 Character Key Shortcuts (Level A)
- [ ] Single character shortcuts can be disabled/remapped
- [ ] Only active when component has focus

#### 2.4.1 Bypass Blocks (Level A)
- [ ] Skip navigation link present
- [ ] Landmark regions defined (header, nav, main, footer)
- [ ] Heading structure allows navigation

**Implementation:**
```html
<a href="#main-content" class="skip-link">Skip to main content</a>
<main id="main-content">
  <!-- Content -->
</main>
```

#### 2.4.2 Page Titled (Level A)
- [ ] Every page has unique, descriptive title
- [ ] Title format: "Page Name - Site Name"

#### 2.4.3 Focus Order (Level A)
- [ ] Focus order logical and intuitive
- [ ] Matches visual layout

#### 2.4.4 Link Purpose (In Context) (Level A)
- [ ] Link text describes destination
- [ ] Avoid "Click here", "Read more" without context
- [ ] Use aria-label if needed

#### 2.4.5 Multiple Ways (Level AA)
- [ ] Navigation menu
- [ ] Search function
- [ ] Sitemap
- [ ] Table of contents

#### 2.4.6 Headings and Labels (Level AA)
- [ ] Headings describe content
- [ ] Labels describe inputs

#### 2.4.7 Focus Visible (Level AA) ⭐
- [ ] Focus indicator always visible
- [ ] Sufficient contrast (≥3:1)
- [ ] Not just browser default

**CSS Example:**
```css
:focus {
  outline: 2px solid #0066cc;
  outline-offset: 2px;
}
```

#### 2.5.1 Pointer Gestures (Level A)
- [ ] No multipoint or path-based gestures required
- [ ] Alternative single-pointer methods available

#### 2.5.2 Pointer Cancellation (Level A)
- [ ] Click activates on up-event, not down-event
- [ ] Can abort by moving pointer away

#### 2.5.3 Label in Name (Level A)
- [ ] Visible label matches accessible name

#### 2.5.4 Motion Actuation (Level A)
- [ ] Features triggered by device motion have alternative
- [ ] Can disable motion actuation

---

### 3.3 UNDERSTANDABLE

#### 3.1.1 Language of Page (Level A)
- [ ] HTML lang attribute set
- [ ] Example: `<html lang="en">`

#### 3.1.2 Language of Parts (Level AA)
- [ ] Language changes marked
- [ ] Example: `<span lang="es">Hola</span>`

#### 3.2.1 On Focus (Level A)
- [ ] No automatic change of context on focus
- [ ] No popups, no form submission

#### 3.2.2 On Input (Level A)
- [ ] No automatic change of context on input
- [ ] Exception: User is warned

#### 3.2.3 Consistent Navigation (Level AA)
- [ ] Navigation same on every page
- [ ] Same order, same position

#### 3.2.4 Consistent Identification (Level AA)
- [ ] Same icons/buttons have same function across site
- [ ] Same labels for same functionality

#### 3.3.1 Error Identification (Level A)
- [ ] Errors identified in text
- [ ] Location of error indicated

#### 3.3.2 Labels or Instructions (Level A)
- [ ] All form inputs have labels
- [ ] Required fields indicated
- [ ] Format requirements explained

#### 3.3.3 Error Suggestion (Level AA)
- [ ] Error messages suggest how to fix
- [ ] Example: "Email must include @"

#### 3.3.4 Error Prevention (Legal, Financial, Data) (Level AA)
- [ ] Reversible submissions
- [ ] Data validated before final submission
- [ ] Confirmation page provided

---

### 3.4 ROBUST

#### 4.1.1 Parsing (Level A)
- [ ] Valid HTML (W3C validator)
- [ ] Unique IDs
- [ ] Properly nested elements

**Test:**
```bash
html-validate dist/site/**/*.html
```

#### 4.1.2 Name, Role, Value (Level A)
- [ ] All UI components have:
  - Accessible name
  - Role (button, link, input, etc.)
  - State (expanded, checked, etc.)

#### 4.1.3 Status Messages (Level AA)
- [ ] Status messages announced to screen readers
- [ ] Use role="status" or role="alert"

---

## 4. PRIORITY ISSUES TO FIX

### Critical (Must Fix) ❌
- Missing alt text on images
- Insufficient color contrast (<4.5:1)
- Form inputs without labels
- Keyboard traps
- Missing page titles
- Invalid HTML
- No focus indicators

### High Priority ⚠️
- Poor heading structure
- Unclear link text
- Missing skip navigation
- No language attribute
- Inconsistent navigation
- Missing error messages

### Medium Priority 📋
- Suboptimal focus order
- Missing ARIA labels
- No text resize support
- Missing landmark regions

### Low Priority/Enhancement ✨
- Level AAA criteria
- Enhanced descriptions
- Additional navigation methods

---

## 5. TESTING TOOLS SETUP

### Install All Tools
```bash
# Lighthouse
npm install -g lighthouse

# pa11y
npm install -g pa11y
npm install -g pa11y-ci

# HTML validation
npm install -g html-validate

# Accessibility linter
npm install -g eslint-plugin-jsx-a11y
```

### Configuration Files

#### .pa11yci.json
```json
{
  "defaults": {
    "standard": "WCAG2AA",
    "runners": ["axe", "htmlcs"],
    "timeout": 10000
  },
  "urls": [
    "http://localhost:8000/index.html",
    "http://localhost:8000/chapter1.html",
    "http://localhost:8000/chapter2.html"
  ]
}
```

#### .html-validate.json
```json
{
  "extends": ["html-validate:recommended"],
  "rules": {
    "wcag/h37": "error",
    "wcag/h67": "error",
    "no-missing-references": "error",
    "require-sri": "off"
  }
}
```

---

## 6. AUTOMATED TEST SCRIPT

### scripts/test-accessibility.sh
```bash
#!/bin/bash

echo "=================================="
echo "Accessibility Testing"
echo "=================================="
echo ""

# Start local server
echo "Starting local server..."
cd dist/site
python3 -m http.server 8000 &
SERVER_PID=$!
sleep 2

cd ../..

# 1. Lighthouse
echo "1. Running Lighthouse audit..."
lighthouse http://localhost:8000 \
  --only-categories=accessibility \
  --output json \
  --output html \
  --output-path reports/lighthouse-accessibility

LIGHTHOUSE_SCORE=$(jq '.categories.accessibility.score * 100' reports/lighthouse-accessibility.report.json)
echo "   Accessibility score: $LIGHTHOUSE_SCORE/100"
echo ""

# 2. pa11y
echo "2. Running pa11y..."
pa11y-ci --config .pa11yci.json > reports/pa11y-results.txt 2>&1
PA11Y_ISSUES=$(grep -c "Error" reports/pa11y-results.txt || echo "0")
echo "   Issues found: $PA11Y_ISSUES"
echo ""

# 3. HTML validation
echo "3. Validating HTML..."
html-validate "dist/site/**/*.html" > reports/html-validation.log 2>&1
HTML_ERRORS=$(grep -c "error" reports/html-validation.log || echo "0")
echo "   HTML errors: $HTML_ERRORS"
echo ""

# Stop server
kill $SERVER_PID

# Summary
echo "=================================="
echo "Summary"
echo "=================================="
echo "Lighthouse Score:       $LIGHTHOUSE_SCORE/100"
echo "pa11y Issues:           $PA11Y_ISSUES"
echo "HTML Errors:            $HTML_ERRORS"
echo ""

# Pass/Fail
if [ "$LIGHTHOUSE_SCORE" -ge 90 ] && [ "$PA11Y_ISSUES" -eq 0 ] && [ "$HTML_ERRORS" -eq 0 ]; then
    echo "✅ Accessibility tests PASSED"
    exit 0
else
    echo "❌ Accessibility tests FAILED"
    echo "Review reports/ directory for details"
    exit 1
fi
```

---

## 7. MANUAL TESTING GUIDE

### Screen Reader Testing

#### NVDA (Windows)
1. Download: https://www.nvaccess.org/download/
2. Install and launch
3. Navigate with:
   - H (headings)
   - Tab (links/buttons)
   - Insert+Down (read all)
4. Listen for:
   - All content announced
   - Links make sense out of context
   - Form fields have labels
   - Images have descriptions

#### VoiceOver (macOS)
1. Enable: System Preferences → Accessibility → VoiceOver
2. Activate: Cmd+F5
3. Navigate with:
   - VO+Right/Left (items)
   - VO+U (rotor)
   - Tab (interactive elements)

### Keyboard Testing Checklist
- [ ] Unplug mouse
- [ ] Press Tab repeatedly
- [ ] Verify focus visible on all elements
- [ ] Press Enter/Space on buttons
- [ ] Navigate menus with arrows
- [ ] Close modals with Escape
- [ ] Submit forms with Enter
- [ ] No elements unreachable
- [ ] No focus traps

### Color Contrast Testing
1. Use browser extension (e.g., "Color Contrast Analyzer")
2. Check every text element
3. Check UI components
4. Test with:
   - Normal text: ≥4.5:1
   - Large text: ≥3:1
   - UI components: ≥3:1

---

## 8. COMMON ISSUES & FIXES

### Issue: Images Missing Alt Text
```html
<!-- ❌ Bad -->
<img src="chart.png">

<!-- ✅ Good -->
<img src="chart.png" alt="Bar chart showing 65% of students prefer AI-assisted learning">

<!-- ✅ Decorative -->
<img src="decoration.png" alt="">
```

### Issue: Poor Color Contrast
```css
/* ❌ Bad (2.5:1 ratio) */
color: #777;
background: #fff;

/* ✅ Good (7.0:1 ratio) */
color: #333;
background: #fff;
```

### Issue: Form Without Labels
```html
<!-- ❌ Bad -->
<input type="text" placeholder="Enter email">

<!-- ✅ Good -->
<label for="email">Email Address</label>
<input type="text" id="email" name="email" required>
```

### Issue: No Focus Indicator
```css
/* ❌ Bad */
*:focus {
  outline: none;
}

/* ✅ Good */
*:focus {
  outline: 2px solid #0066cc;
  outline-offset: 2px;
}
```

### Issue: Non-Semantic HTML
```html
<!-- ❌ Bad -->
<div onclick="submit()">Submit</div>

<!-- ✅ Good -->
<button type="submit">Submit</button>
```

---

## 9. NEXT STEPS

1. **Build Website**
   - Generate all HTML pages
   - Apply semantic HTML
   - Include ARIA where needed

2. **Run Automated Tests**
   - Execute scripts/test-accessibility.sh
   - Review all reports
   - Fix all critical issues

3. **Manual Testing**
   - Test with screen readers
   - Test keyboard navigation
   - Verify color contrast

4. **Iterative Improvement**
   - Fix issues
   - Re-test
   - Document changes

5. **Final Validation**
   - All automated tests pass
   - Manual review complete
   - Accessibility statement published

---

**Report Status:** READY FOR TESTING
**Compliance Target:** WCAG 2.1 Level AA
**Next Action:** Build website files for testing
