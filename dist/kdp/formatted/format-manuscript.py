#!/usr/bin/env python3
"""
Manuscript Formatter
Processes the manuscript.md file and creates professionally formatted versions
"""

import re
import os

# File paths
INPUT_FILE = os.path.join(os.path.dirname(__file__), '..', 'manuscript.md')
OUTPUT_DIR = os.path.dirname(__file__)
FORMATTED_MD = os.path.join(OUTPUT_DIR, 'manuscript-formatted.md')
FORMATTED_HTML = os.path.join(OUTPUT_DIR, 'manuscript-formatted.html')

print('Processing manuscript for publication...\n')

# Read the manuscript
with open(INPUT_FILE, 'r', encoding='utf-8') as f:
    manuscript = f.read()

# Typography enhancements
def enhance_typography(text):
    # Smart quotes
    text = re.sub(r'"([^"]*)"', r'"\1"', text)

    # Em dashes
    text = text.replace('--', '—')
    text = re.sub(r' - ', ' — ', text)

    # Ellipses
    text = text.replace('...', '…')

    # Proper spacing
    text = re.sub(r'  +', ' ', text)  # Multiple spaces to single
    text = re.sub(r'\n\n\n+', '\n\n', text)  # Multiple line breaks to double

    return text

# Create formatted markdown
def create_formatted_markdown():
    print('Creating enhanced markdown...')

    formatted = enhance_typography(manuscript)

    # Add page break markers for chapters
    formatted = re.sub(r'^# ', r'\n\n<div style="page-break-before: always;"></div>\n\n# ', formatted, flags=re.MULTILINE)
    formatted = re.sub(r'^## Chapter ', r'\n\n<div style="page-break-before: always;"></div>\n\n## Chapter ', formatted, flags=re.MULTILINE)

    # Style important callouts
    formatted = re.sub(r'\*\*(\w+):\*\*', r'**>> \1:**', formatted)

    # Add section dividers
    formatted = re.sub(r'^---$', '\n* * *\n', formatted, flags=re.MULTILINE)

    with open(FORMATTED_MD, 'w', encoding='utf-8') as f:
        f.write(formatted)

    print('[OK] Created: manuscript-formatted.md')

# Create HTML version (using simple Pandoc-style conversion)
def create_formatted_html():
    print('Creating HTML version...')

    html_header = '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Technology-Powered Language Learning</title>
  <style>
    @page {
      size: 6in 9in;
      margin: 0.75in 0.75in 0.75in 1in;
    }

    @media print {
      .chapter {
        page-break-before: always;
      }

      h1, h2, h3 {
        page-break-after: avoid;
      }

      p {
        orphans: 3;
        widows: 3;
      }
    }

    body {
      font-family: 'Georgia', 'Palatino', 'Times New Roman', serif;
      font-size: 11pt;
      line-height: 1.6;
      color: #1a1a1a;
      max-width: 6in;
      margin: 0 auto;
      padding: 0.75in;
    }

    h1 {
      font-family: 'Helvetica', 'Arial', sans-serif;
      font-size: 24pt;
      font-weight: bold;
      margin: 60pt 0 30pt 0;
      text-align: center;
      page-break-before: always;
    }

    h2 {
      font-family: 'Helvetica', 'Arial', sans-serif;
      font-size: 18pt;
      font-weight: bold;
      margin: 40pt 0 20pt 0;
    }

    h2.chapter-title {
      font-size: 22pt;
      margin-top: 72pt;
      margin-bottom: 36pt;
      text-align: center;
      page-break-before: always;
    }

    h3 {
      font-family: 'Helvetica', 'Arial', sans-serif;
      font-size: 14pt;
      font-weight: bold;
      margin: 24pt 0 12pt 0;
    }

    p {
      margin: 0 0 12pt 0;
      text-align: justify;
    }

    blockquote {
      margin: 24pt 36pt;
      font-style: italic;
      border-left: 3pt solid #ccc;
      padding-left: 18pt;
    }

    ul, ol {
      margin: 12pt 0 12pt 24pt;
      line-height: 1.8;
    }

    li {
      margin-bottom: 6pt;
    }

    .front-matter {
      text-align: center;
      page-break-after: always;
    }

    .copyright {
      font-size: 9pt;
      line-height: 1.4;
      text-align: center;
      page-break-after: always;
    }

    .dedication {
      font-style: italic;
      text-align: center;
      margin: 150pt 60pt;
      page-break-after: always;
    }

    .toc {
      page-break-after: always;
    }

    .section-break {
      text-align: center;
      font-size: 18pt;
      margin: 36pt 0;
      letter-spacing: 12pt;
    }
  </style>
</head>
<body>
'''

    html_footer = '''
</body>
</html>'''

    # Simple markdown to HTML conversion
    content = enhance_typography(manuscript)

    # Convert headings
    content = re.sub(r'^# (.*?)$', r'<h1>\1</h1>', content, flags=re.MULTILINE)
    content = re.sub(r'^## (.*?)$', r'<h2>\1</h2>', content, flags=re.MULTILINE)
    content = re.sub(r'^### (.*?)$', r'<h3>\1</h3>', content, flags=re.MULTILINE)

    # Convert chapter markers
    content = re.sub(r'<h2>Chapter (\d+): (.*?)</h2>', r'<h2 class="chapter-title">Chapter \1: \2</h2>', content)
    content = re.sub(r'<h2>Introduction: (.*?)</h2>', r'<h2 class="chapter-title">Introduction: \1</h2>', content)

    # Convert lists (basic)
    lines = content.split('\n')
    in_list = False
    new_lines = []

    for line in lines:
        if line.startswith('- '):
            if not in_list:
                new_lines.append('<ul>')
                in_list = True
            new_lines.append(f'<li>{line[2:]}</li>')
        else:
            if in_list:
                new_lines.append('</ul>')
                in_list = False
            new_lines.append(line)

    if in_list:
        new_lines.append('</ul>')

    content = '\n'.join(new_lines)

    # Convert section breaks
    content = re.sub(r'^---$', '<div class="section-break">* * *</div>', content, flags=re.MULTILINE)

    # Convert paragraphs (lines that aren't already HTML)
    lines = content.split('\n')
    new_lines = []

    for line in lines:
        if line.strip() and not line.startswith('<') and not line.startswith('**'):
            new_lines.append(f'<p>{line}</p>')
        else:
            new_lines.append(line)

    content = '\n'.join(new_lines)

    # Write HTML file
    with open(FORMATTED_HTML, 'w', encoding='utf-8') as f:
        f.write(html_header)
        f.write(content)
        f.write(html_footer)

    print('[OK] Created: manuscript-formatted.html')

# Run formatters
try:
    create_formatted_markdown()
    create_formatted_html()

    print('\nFormatting complete!')
    print('\nOutput files:')
    print('  - manuscript-formatted.md')
    print('  - manuscript-formatted.html')
    print('  - FORMATTING-GUIDE.md')
    print('\nSee FORMATTING-GUIDE.md for conversion to PDF')
    print('\nTo convert HTML to PDF:')
    print('   Open manuscript-formatted.html in Chrome')
    print('   Press Ctrl+P > Save as PDF > Custom size: 6" x 9"')

except Exception as e:
    print(f'ERROR: {str(e)}')
    exit(1)
