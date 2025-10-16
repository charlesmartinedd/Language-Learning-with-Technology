# Book Formatting Guide

This guide explains how to use the formatted manuscript files for publishing on Amazon KDP or other platforms.

## 📁 Files Included

1. **manuscript-formatted.md** - Enhanced markdown with professional typography
2. **manuscript-formatted.html** - Print-ready HTML with embedded CSS
3. **manuscript-latex.tex** - LaTeX source for highest-quality PDF
4. **FORMATTING-GUIDE.md** - This file

## 🎯 Amazon KDP Requirements

### Standard Trim Sizes
- **Recommended**: 6" × 9" (most common for non-fiction)
- Alternatives: 5.5" × 8.5", 5.25" × 8", 8" × 10"
- Our templates use 6" × 9"

### Margins
- **Inner (gutter)**: 1.0" minimum
- **Outer**: 0.75"
- **Top/Bottom**: 0.75"
- Our templates meet these requirements

### File Format
- **Accepted**: PDF (preferred), DOCX, or uploaded directly
- **Resolution**: 300 DPI for images
- **Fonts**: Embedded in PDF

## 📖 Converting HTML to PDF

### Method 1: Print from Browser (Easiest)

1. Open `manuscript-formatted.html` in **Google Chrome** or **Microsoft Edge**
2. Press `Ctrl+P` (or `Cmd+P` on Mac)
3. Configure print settings:
   - **Destination**: Save as PDF
   - **Paper size**: 6" × 9" (custom)
   - **Margins**: Default (CSS handles margins)
   - **Options**: Check "Background graphics"
   - **Scale**: 100%
4. Click "Save" and choose location

**Tip**: The HTML file includes `@page` CSS rules that should automatically set correct page size.

### Method 2: Using Calibre (Free Software)

1. Download Calibre: https://calibre-ebook.com/
2. Add `manuscript-formatted.html` to Calibre
3. Click "Convert books"
4. Set output format to PDF
5. Configure PDF output:
   - Paper size: Custom (6" × 9")
   - Margins: 72pts top/bottom, 54pts outer, 72pts inner
6. Click OK to convert

### Method 3: Using Prince XML (Professional)

```bash
prince manuscript-formatted.html -o manuscript.pdf
```

Prince XML (commercial software) produces the highest quality PDF from HTML.

## 📝 Compiling LaTeX to PDF

### Requirements

Install a LaTeX distribution:
- **Windows**: MiKTeX (https://miktex.org/)
- **Mac**: MacTeX (https://www.tug.org/mactex/)
- **Linux**: TeX Live (`sudo apt-get install texlive-full`)

### Compilation Steps

1. **Basic compilation**:
   ```bash
   cd dist/kdp/formatted
   pdflatex manuscript-latex.tex
   ```

2. **For table of contents** (run twice):
   ```bash
   pdflatex manuscript-latex.tex
   pdflatex manuscript-latex.tex
   ```

3. **Full compilation with index**:
   ```bash
   pdflatex manuscript-latex.tex
   makeindex manuscript-latex.idx
   pdflatex manuscript-latex.tex
   pdflatex manuscript-latex.tex
   ```

### Using Overleaf (Online LaTeX Editor)

1. Go to https://www.overleaf.com/
2. Create free account
3. Upload `manuscript-latex.tex`
4. Click "Recompile"
5. Download PDF

**Advantage**: No local installation needed, handles all dependencies automatically.

## 🔧 Using Pandoc for Advanced Conversion

Pandoc is a universal document converter.

### Installation
- **Windows**: Download from https://pandoc.org/installing.html
- **Mac**: `brew install pandoc`
- **Linux**: `sudo apt-get install pandoc`

### Convert Markdown to PDF via LaTeX
```bash
pandoc manuscript-formatted.md -o manuscript.pdf \
  --pdf-engine=xelatex \
  --variable papersize=6in:9in \
  --variable margin-left=1in \
  --variable margin-right=0.75in \
  --variable margin-top=0.75in \
  --variable margin-bottom=0.75in \
  --variable fontsize=11pt \
  --variable mainfont="Georgia" \
  --variable linestretch=1.6
```

### Convert Markdown to DOCX
```bash
pandoc manuscript-formatted.md -o manuscript.docx \
  --reference-doc=custom-styles.docx
```

## 🎨 Customizing the Formats

### Adjusting HTML Styles

Edit the `<style>` section in `manuscript-formatted.html`:

```css
/* Change body font */
body {
  font-family: 'Palatino', 'Georgia', serif;
}

/* Adjust line height */
p {
  line-height: 1.8; /* Was 1.6 */
}

/* Modify chapter headings */
.chapter-title {
  font-size: 28pt; /* Adjust size */
  color: #1a1a1a; /* Change color */
}
```

### Adjusting LaTeX Layout

Edit these lines in `manuscript-latex.tex`:

```latex
% Change margins
\usepackage[top=0.75in, bottom=0.75in, inner=1in, outer=0.75in]{geometry}

% Change fonts
\setmainfont{Palatino}  % Body font
\setsansfont{Helvetica} % Heading font

% Change line spacing
\setstretch{1.8}  % Was 1.6

% Change chapter style
\titleformat{\chapter}[display]
  {\normalfont\sffamily\huge\bfseries}
  {\chaptertitlename\ \thechapter}{20pt}{\Huge}
```

## 📏 KDP-Specific Formatting Tips

### Front Matter Order
1. Half-title page (optional)
2. Title page
3. Copyright page
4. Dedication
5. Table of Contents
6. Foreword/Preface (if any)
7. Introduction

### Back Matter Order
1. Appendices (if any)
2. Glossary
3. Resources/Bibliography
4. About the Author
5. Also by Author (if applicable)

### Page Numbers
- **Front matter**: Lowercase Roman numerals (i, ii, iii, iv)
- **Main content**: Arabic numerals (1, 2, 3, 4)
- **Start main numbering from Chapter 1**

Our LaTeX template handles this automatically. For HTML/PDF, you may need to adjust manually.

### Avoiding Common Rejections

❌ **DON'T**:
- Include contact info or URLs in main content (put in About Author)
- Use images wider than text area
- Have blank pages (except intentional chapter breaks)
- Use page numbers in footer on chapter opening pages

✅ **DO**:
- Embed all fonts in PDF
- Use consistent heading hierarchy
- Include proper copyright notice
- Test all links if using digital format

## 🖨️ Print Quality Checklist

Before uploading to KDP, verify:

- [ ] All fonts embedded in PDF
- [ ] Page size exactly 6" × 9" (or chosen size)
- [ ] Margins meet minimums (1" inner, 0.75" outer)
- [ ] No widows/orphans (single lines at top/bottom of pages)
- [ ] Chapter breaks start on odd (right-hand) pages
- [ ] Page numbers correct and consistent
- [ ] Images at 300 DPI or vector
- [ ] Copyright page includes year and author
- [ ] Table of contents matches chapter pages
- [ ] Running headers don't appear on chapter opening pages
- [ ] Text doesn't extend into margins

## 📱 E-Book (Kindle) Considerations

If creating a Kindle version:

1. **Use reflowable format** (EPUB/MOBI), not fixed layout
2. **Convert markdown directly**:
   ```bash
   pandoc manuscript-formatted.md -o manuscript.epub \
     --toc --epub-metadata=metadata.xml
   ```
3. **Simplify formatting**:
   - Remove page-specific CSS
   - Use standard fonts (serif/sans-serif)
   - Avoid fixed spacing
4. **Test on Kindle Previewer** (free from Amazon)

## 🎯 Recommended Workflow

### For Print Book (KDP Paperback)

1. **Start with LaTeX** for highest quality:
   ```bash
   pdflatex manuscript-latex.tex
   pdflatex manuscript-latex.tex
   ```

2. **Verify PDF**:
   - Open in Adobe Reader
   - Check page size (File → Properties)
   - Review all pages for formatting issues
   - Check fonts are embedded

3. **Upload to KDP**:
   - Go to KDP Dashboard
   - Create new title
   - Upload PDF in "Manuscript" section
   - Use online previewer to check

### For E-Book (Kindle)

1. **Use Markdown or HTML**:
   ```bash
   pandoc manuscript-formatted.md -o manuscript.epub
   ```

2. **Test in Kindle Previewer**:
   - Download from https://kdp.amazon.com/en_US/help/topic/G202131170
   - Load EPUB file
   - Check on multiple device sizes

3. **Upload to KDP**:
   - Same process as print
   - Upload EPUB in e-book section

## 🔍 Quality Assurance

### Print a Proof Copy

Before publishing, **always order a physical proof**:
1. KDP offers free proof copies (you pay shipping)
2. Review every page in physical form
3. Check that margins aren't too tight
4. Verify images look sharp
5. Ensure text is readable at actual size

### Get Beta Readers

Ask 2-3 people to review the formatted version:
- Does it look professional?
- Are there any formatting inconsistencies?
- Is anything hard to read?
- Any suggestions for improvement?

## 📊 File Size Optimization

If your PDF is too large:

### Compress PDF
```bash
# Using Ghostscript
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 \
   -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH \
   -sOutputFile=manuscript-compressed.pdf manuscript.pdf
```

### Optimize Images
- Use JPEG for photos (quality 85%)
- Use PNG for diagrams
- Resize to actual print size before inserting
- 300 DPI for print, 150 DPI for digital

## 🆘 Troubleshooting

### LaTeX Won't Compile
- **Missing packages**: Install full TeX distribution
- **Font errors**: Remove custom fonts, use built-in fonts
- **Encoding issues**: Ensure file saved as UTF-8

### HTML Print Margins Wrong
- **Browser ignoring @page**: Try different browser (Chrome best)
- **Custom paper size not available**: Use A4 then trim, or use PDF editor to crop

### PDF Rejected by KDP
- **Fonts not embedded**: Re-export with "Embed fonts" option
- **Wrong page size**: Use PDF editor to adjust page size
- **Margins too small**: Regenerate with larger margins

## 📚 Additional Resources

### LaTeX Resources
- **Overleaf Documentation**: https://www.overleaf.com/learn
- **LaTeX Wikibook**: https://en.wikibooks.org/wiki/LaTeX
- **TeX Stack Exchange**: https://tex.stackexchange.com/

### KDP Resources
- **KDP Formatting Guide**: https://kdp.amazon.com/en_US/help/topic/G200645680
- **KDP Community**: https://kdp.amazon.com/en_US/community
- **Kindle Create Tool**: https://kdp.amazon.com/en_US/help/topic/GHU4YEWXQGNLU94T

### Typography Resources
- **Butterick's Practical Typography**: https://practicaltypography.com/
- **The Elements of Typographic Style**: Classic book by Robert Bringhurst

## ✅ Final Checklist

Before uploading to KDP:

- [ ] All content proofread and edited
- [ ] Copyright page includes correct year and author name
- [ ] Table of contents page numbers match actual pages
- [ ] All chapter headings consistent
- [ ] No widows/orphans
- [ ] Running headers correct
- [ ] Page numbers in correct position
- [ ] Front matter uses Roman numerals
- [ ] Main content uses Arabic numerals
- [ ] About the Author section complete
- [ ] Contact info only in About section
- [ ] All fonts embedded
- [ ] PDF page size exactly matches chosen trim size
- [ ] Margins meet KDP minimums
- [ ] Physical proof copy reviewed
- [ ] Backup copy saved in multiple locations

## 🎉 You're Ready!

Your manuscript is now professionally formatted and ready for publication. Good luck with your book launch!

---

**Questions or Issues?**
Contact: drcharlesmartinjr@alexandriasdesign.com

**Template Version**: 1.0
**Last Updated**: 2025
