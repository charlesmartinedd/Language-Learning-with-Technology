# How to Create PDF from Manuscript

Your manuscript is ready at: `dist/kdp/manuscript.md`

## Option 1: CloudConvert (Easiest - Recommended)

1. Go to https://cloudconvert.com/md-to-pdf
2. Upload `dist/kdp/manuscript.md`
3. Click "Convert"
4. Download `manuscript.pdf`

**Done in 2 minutes!**

## Option 2: Pandoc (If Installed)

```bash
# Install Pandoc first if needed:
# Windows: choco install pandoc
# Or download from: https://pandoc.org/installing.html

cd "C:\Users\charl\AI Projects\projects\Language-Learning-with-Technology\dist\kdp"

pandoc manuscript.md -o manuscript.pdf \
  --pdf-engine=xelatex \
  --metadata title="Language Learning with Technology" \
  --metadata author="Dr. Charles Martin" \
  --toc \
  --toc-depth=2 \
  -V geometry:margin=1in \
  -V fontsize=11pt \
  -V linestretch=1.5
```

## Option 3: Microsoft Word → PDF

1. Open `manuscript.md` in a text editor
2. Copy all content
3. Paste into Microsoft Word
4. Format as needed:
   - Title: Heading 1
   - Chapter headings: Heading 2
   - Subheadings: Heading 3
5. Save as PDF: File → Save As → PDF

## Option 4: Online Markdown Editors

**Typora** (https://typora.io/) - $14.99
- Open `manuscript.md`
- File → Export → PDF

**StackEdit** (https://stackedit.io/) - Free
- Open the website
- Copy/paste manuscript content
- Menu → Export to Disk → PDF

**Dillinger** (https://dillinger.io/) - Free
- Open the website
- Copy/paste manuscript content
- Save as → PDF

## Your Manuscript File

**Location:** `C:\Users\charl\AI Projects\projects\Language-Learning-with-Technology\dist\kdp\manuscript.md`

**Size:** 167 KB
**Word Count:** ~32,000 words
**Format:** Clean markdown with chapter breaks

## PDF Specifications

For Amazon KDP and general distribution:
- **Margins:** 1 inch on all sides
- **Font:** 11-12 pt serif (Times New Roman, Georgia)
- **Line spacing:** 1.5 or double
- **Page size:** Letter (8.5" x 11") or A4
- **Include:** Title page, copyright page, table of contents

## Next Steps

1. Create PDF using any method above
2. Review PDF for formatting
3. Optional: Share with friends for feedback
4. Ready for Amazon KDP upload or direct distribution

---

**Recommended:** Use CloudConvert for fastest results (2 minutes total).
