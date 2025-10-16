# Formatted Manuscript Files

This directory contains professionally formatted versions of the manuscript ready for Amazon KDP publishing.

## 📁 Files

### Publication-Ready Formats

1. **manuscript-formatted.md** - Enhanced markdown with:
   - Smart typography (curly quotes, em dashes, proper ellipses)
   - Page break markers for chapters
   - Styled callouts and section dividers
   - Professional formatting markers

2. **manuscript-formatted.html** - Print-ready HTML with:
   - Embedded CSS for 6" × 9" book layout
   - Professional typography (Georgia body, Helvetica headings)
   - Page break controls for printing
   - Proper margins for KDP requirements
   - **Ready to print to PDF from browser**

3. **manuscript-latex.tex** - LaTeX template with:
   - Professional book class formatting
   - Beautiful chapter styling
   - Table of contents
   - Front matter (title, copyright, dedication)
   - Complete typography control
   - **Compile with pdflatex for highest quality PDF**

### Documentation

4. **FORMATTING-GUIDE.md** - Complete instructions for:
   - Converting HTML to PDF (browser method)
   - Compiling LaTeX to PDF
   - Using Pandoc for advanced conversions
   - KDP formatting requirements
   - Troubleshooting common issues

### Utilities

5. **format-manuscript.py** - Python script that generated the formatted versions
6. **process-manuscript.js** - Alternative JavaScript processor

## 🚀 Quick Start

### Option 1: HTML to PDF (Easiest)

1. Open `manuscript-formatted.html` in **Google Chrome**
2. Press `Ctrl+P` (or `Cmd+P` on Mac)
3. Settings:
   - Destination: **Save as PDF**
   - Paper size: **Custom → 6" × 9"**
   - Margins: **Default**
   - Background graphics: **Checked**
   - Scale: **100%**
4. Click **Save**

**Result**: Print-ready PDF for Amazon KDP

### Option 2: LaTeX to PDF (Highest Quality)

#### Using Overleaf (No Installation Required)

1. Go to https://www.overleaf.com/
2. Create free account
3. New Project → Upload Project
4. Upload `manuscript-latex.tex`
5. Click **Recompile**
6. Download PDF

#### Using Local LaTeX Installation

```bash
# Install TeX (first time only)
# Windows: Download MiKTeX from https://miktex.org/
# Mac: Download MacTeX from https://www.tug.org/mactex/
# Linux: sudo apt-get install texlive-full

# Compile to PDF
pdflatex manuscript-latex.tex
pdflatex manuscript-latex.tex  # Run twice for TOC
```

**Result**: Professionally typeset PDF with perfect formatting

## 📐 Amazon KDP Specifications

The formatted files meet these KDP requirements:

- **Trim Size**: 6" × 9" (standard non-fiction)
- **Margins**:
  - Inner (gutter): 1.0"
  - Outer: 0.75"
  - Top/Bottom: 0.75"
- **Fonts**: Embedded in PDF
- **Page Numbers**: Centered footer
- **Chapter Breaks**: Start on new page
- **Front Matter**: Title, copyright, dedication, TOC
- **Typography**: Professional with proper quotes, dashes, spacing

## 🎨 Customization

### Change Fonts (HTML)

Edit the `<style>` section in `manuscript-formatted.html`:

```css
body {
  font-family: 'Palatino', 'Georgia', serif; /* Change this */
}
```

### Change Fonts (LaTeX)

Edit near top of `manuscript-latex.tex`:

```latex
\usepackage{mathptmx}  % Replace with your preferred font package
```

### Adjust Line Spacing (HTML)

```css
p {
  line-height: 1.8; /* Increase for more spacing */
}
```

### Adjust Line Spacing (LaTeX)

```latex
\setstretch{1.8}  % Increase for more spacing
```

## ✅ Pre-Upload Checklist

Before uploading to Amazon KDP:

- [ ] All content proofread
- [ ] Copyright page has correct year and name
- [ ] Table of contents page numbers match chapters
- [ ] No widows/orphans (single lines at top/bottom of pages)
- [ ] Chapter headings consistent
- [ ] Page numbers in footer
- [ ] Front matter uses Roman numerals (if applicable)
- [ ] Main content uses Arabic numerals
- [ ] Fonts embedded in PDF
- [ ] PDF page size exactly 6" × 9"
- [ ] Margins meet KDP minimums
- [ ] Physical proof copy ordered and reviewed

## 🔄 Regenerating Formatted Files

If you edit the source manuscript, regenerate the formatted versions:

```bash
cd dist/kdp/formatted
python format-manuscript.py
```

Or manually re-run the formatting process as documented in FORMATTING-GUIDE.md.

## 📚 Additional Resources

- **KDP Formatting Guide**: https://kdp.amazon.com/en_US/help/topic/G200645680
- **LaTeX Documentation**: https://www.overleaf.com/learn
- **Butterick's Practical Typography**: https://practicaltypography.com/

## 🆘 Support

For questions about formatting:
- See **FORMATTING-GUIDE.md** for detailed instructions
- Check KDP Community Forums
- Contact: drcharlesmartinjr@alexandriasdesign.com

---

**Version**: 1.0
**Last Updated**: October 2025
**Source**: `../manuscript.md`
