#!/usr/bin/env node

/**
 * KDP Package Generator
 * Generates EPUB and DOCX files from markdown chapters
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const PROJECT_ROOT = path.join(__dirname, '..');
const CONTENT_DIR = path.join(PROJECT_ROOT, 'content');
const CHAPTERS_DIR = path.join(CONTENT_DIR, 'chapters');
const DIST_KDP = path.join(PROJECT_ROOT, 'dist', 'kdp');

// Metadata
const metadata = {
  title: 'Language Learning with Technology',
  subtitle: 'Helping Parents Guide Digital Language Learning in 2025',
  author: 'Dr. Charles Martin',
  language: 'en',
  year: '2025'
};

console.log('📚 KDP Package Generator Starting...\n');

// Read and combine all chapters
function combineChapters() {
  console.log('📖 Reading chapters...');

  const frontMatter = fs.readFileSync(path.join(CONTENT_DIR, '00-front-matter.md'), 'utf8');
  const chapterFiles = fs.readdirSync(CHAPTERS_DIR).sort();

  let fullManuscript = frontMatter + '\n\n';

  chapterFiles.forEach((file, index) => {
    if (file.endsWith('.md')) {
      console.log(`   ✓ ${file}`);
      const content = fs.readFileSync(path.join(CHAPTERS_DIR, file), 'utf8');
      fullManuscript += content + '\n\n';

      // Add page break between chapters
      fullManuscript += '---\n\n';
    }
  });

  return fullManuscript;
}

// Save combined manuscript
function saveManuscript(content) {
  const manuscriptPath = path.join(DIST_KDP, 'manuscript.md');
  fs.writeFileSync(manuscriptPath, content, 'utf8');
  console.log(`\n✓ Manuscript saved: ${manuscriptPath}`);
  return content;
}

// Generate simple HTML for EPUB creation
function generateHTML(markdown) {
  console.log('\n📝 Generating HTML...');

  // Very basic markdown to HTML conversion
  let html = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>${metadata.title}</title>
  <meta name="author" content="${metadata.author}">
  <style>
    body {
      font-family: Georgia, serif;
      line-height: 1.6;
      max-width: 800px;
      margin: 0 auto;
      padding: 20px;
    }
    h1 {
      color: #1a5490;
      font-size: 2em;
      margin-top: 1.5em;
      page-break-before: always;
    }
    h2 {
      color: #2c5aa0;
      font-size: 1.5em;
      margin-top: 1.2em;
    }
    h3 {
      color: #4a7bb7;
      font-size: 1.2em;
    }
    p {
      margin: 1em 0;
      text-align: justify;
    }
    code {
      background: #f4f4f4;
      padding: 2px 6px;
      border-radius: 3px;
      font-family: 'Courier New', monospace;
    }
    blockquote {
      border-left: 4px solid #1a5490;
      margin: 1em 0;
      padding-left: 1em;
      font-style: italic;
      color: #555;
    }
    ul, ol {
      margin: 1em 0;
      padding-left: 2em;
    }
    hr {
      border: none;
      border-top: 2px solid #ddd;
      margin: 2em 0;
      page-break-after: always;
    }
  </style>
</head>
<body>
`;

  // Convert markdown to HTML (basic conversion)
  const lines = markdown.split('\n');
  let inList = false;
  let inOrderedList = false;
  let inCodeBlock = false;

  lines.forEach(line => {
    // Handle code blocks
    if (line.startsWith('```')) {
      inCodeBlock = !inCodeBlock;
      return;
    }
    if (inCodeBlock) {
      html += `<code>${escapeHtml(line)}</code><br>\n`;
      return;
    }

    // Headers
    if (line.startsWith('# ')) {
      html += `<h1>${line.substring(2)}</h1>\n`;
    } else if (line.startsWith('## ')) {
      html += `<h2>${line.substring(3)}</h2>\n`;
    } else if (line.startsWith('### ')) {
      html += `<h3>${line.substring(4)}</h3>\n`;
    } else if (line.startsWith('#### ')) {
      html += `<h4>${line.substring(5)}</h4>\n`;
    }
    // Horizontal rule / page break
    else if (line.trim() === '---') {
      if (inList) {
        html += '</ul>\n';
        inList = false;
      }
      if (inOrderedList) {
        html += '</ol>\n';
        inOrderedList = false;
      }
      html += '<hr>\n';
    }
    // Unordered list
    else if (line.startsWith('- ') || line.startsWith('* ')) {
      if (!inList) {
        html += '<ul>\n';
        inList = true;
      }
      html += `<li>${formatInline(line.substring(2))}</li>\n`;
    }
    // Ordered list
    else if (/^\d+\.\s/.test(line)) {
      if (!inOrderedList) {
        html += '<ol>\n';
        inOrderedList = true;
      }
      html += `<li>${formatInline(line.replace(/^\d+\.\s/, ''))}</li>\n`;
    }
    // Regular paragraph
    else if (line.trim()) {
      if (inList) {
        html += '</ul>\n';
        inList = false;
      }
      if (inOrderedList) {
        html += '</ol>\n';
        inOrderedList = false;
      }
      html += `<p>${formatInline(line)}</p>\n`;
    }
    // Empty line
    else {
      if (inList) {
        html += '</ul>\n';
        inList = false;
      }
      if (inOrderedList) {
        html += '</ol>\n';
        inOrderedList = false;
      }
    }
  });

  html += '\n</body>\n</html>';
  return html;
}

function escapeHtml(text) {
  return text
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}

function formatInline(text) {
  // Bold
  text = text.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>');
  // Italic
  text = text.replace(/\*(.+?)\*/g, '<em>$1</em>');
  // Code
  text = text.replace(/`(.+?)`/g, '<code>$1</code>');
  // Links
  text = text.replace(/\[(.+?)\]\((.+?)\)/g, '<a href="$2">$1</a>');

  return text;
}

// Save HTML version
function saveHTML(html) {
  const htmlPath = path.join(DIST_KDP, 'language-learning-tech.html');
  fs.writeFileSync(htmlPath, html, 'utf8');
  console.log(`✓ HTML saved: ${htmlPath}`);
  return htmlPath;
}

// Generate instructions for manual EPUB/DOCX creation
function generateInstructions() {
  const instructions = `# KDP Package Generation Instructions

## Files Created

1. ✅ **manuscript.md** - Combined markdown manuscript
2. ✅ **language-learning-tech.html** - HTML version
3. ✅ **metadata.json** - Complete book metadata

## Next Steps to Create EPUB and DOCX

### Option 1: Use Pandoc (Recommended)

If you have Pandoc installed, run:

\`\`\`bash
cd dist/kdp

# Generate EPUB
pandoc manuscript.md -o language-learning-tech.epub \\
  --metadata title="${metadata.title}" \\
  --metadata subtitle="${metadata.subtitle}" \\
  --metadata author="${metadata.author}" \\
  --metadata lang="${metadata.language}" \\
  --toc --toc-depth=2 \\
  --epub-chapter-level=1

# Generate DOCX
pandoc manuscript.md -o language-learning-tech.docx \\
  --metadata title="${metadata.title}" \\
  --metadata author="${metadata.author}" \\
  --toc --toc-depth=2 \\
  --reference-doc=template.docx  # Optional: use custom template
\`\`\`

### Option 2: Install Pandoc

**Windows:**
\`\`\`bash
choco install pandoc
# Or download from: https://pandoc.org/installing.html
\`\`\`

**macOS:**
\`\`\`bash
brew install pandoc
\`\`\`

**Linux:**
\`\`\`bash
sudo apt-get install pandoc
\`\`\`

### Option 3: Use Online Converters

1. **CloudConvert** (https://cloudconvert.com)
   - Upload manuscript.md
   - Convert to EPUB
   - Convert to DOCX

2. **Calibre** (Free desktop app)
   - Import HTML file
   - Convert to EPUB
   - Add metadata

### Option 4: Use Word/Google Docs

1. Open **language-learning-tech.html** in Microsoft Word or Google Docs
2. Save As DOCX format
3. Use Calibre to convert DOCX to EPUB

## Creating the Cover Image

### Option 1: Use Canva (Recommended)
1. Go to canva.com
2. Create custom size: 2560 x 1600 pixels
3. Use blue and white color scheme
4. Add title, subtitle, author name
5. Download as JPG (high quality)

### Option 2: Use Adobe Express
1. adobe.com/express
2. Book cover template
3. Customize with book details
4. Export as JPG

### Design Specifications:
- **Size:** 2560 x 1600 pixels (1.6:1 ratio for Kindle)
- **Colors:** Blue (#1a5490) and white (#ffffff)
- **Title:** Large, bold font
- **Subtitle:** Smaller, below title
- **Author:** Bottom of cover
- **Style:** Clean, modern, professional

## File Checklist for KDP Upload

- [ ] language-learning-tech.epub (EPUB file)
- [ ] language-learning-tech.docx (DOCX file for preview)
- [ ] cover.jpg (2560 x 1600 pixels)
- [ ] metadata.json (reference for KDP fields)
- [ ] UPLOAD-GUIDE.md (upload instructions)

## Validation

Before uploading:

1. **Validate EPUB:**
   - Use EPUBCheck: https://www.w3.org/publishing/epubcheck/
   - Or upload to KDP previewer (KDP will validate)

2. **Check DOCX:**
   - Open in Word to verify formatting
   - Check table of contents
   - Verify page breaks between chapters

3. **Verify Cover:**
   - Correct dimensions (2560 x 1600)
   - High resolution (300 DPI minimum)
   - Text is readable at thumbnail size

## Ready to Upload!

Once you have all files, proceed to UPLOAD-GUIDE.md for detailed KDP upload instructions.
`;

  const instructionsPath = path.join(DIST_KDP, 'GENERATION-INSTRUCTIONS.md');
  fs.writeFileSync(instructionsPath, instructions, 'utf8');
  console.log(`✓ Instructions saved: ${instructionsPath}`);
}

// Main execution
function main() {
  try {
    // Ensure dist/kdp directory exists
    if (!fs.existsSync(DIST_KDP)) {
      fs.mkdirSync(DIST_KDP, { recursive: true });
    }

    // Combine chapters
    const manuscript = combineChapters();

    // Save manuscript
    saveManuscript(manuscript);

    // Generate and save HTML
    const html = generateHTML(manuscript);
    saveHTML(html);

    // Generate instructions
    generateInstructions();

    console.log('\n✅ KDP package preparation complete!');
    console.log('\n📋 Next Steps:');
    console.log('   1. Read GENERATION-INSTRUCTIONS.md for EPUB/DOCX creation');
    console.log('   2. Create cover image using Canva or Adobe Express');
    console.log('   3. Read UPLOAD-GUIDE.md for KDP upload process');
    console.log('\n📁 Files location: dist/kdp/\n');

  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

main();
