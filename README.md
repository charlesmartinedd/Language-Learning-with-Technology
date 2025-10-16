# Language Learning with Technology

A comprehensive educational resource exploring how modern technology transforms language learning through AI, mobile apps, gamification, and digital tools.

## Project Overview

This project delivers a multi-format educational product:
- **Interactive Website** - Responsive educational site with chapter navigation
- **Amazon KDP Book** - Professional EPUB and DOCX formats for publishing
- **Online Course Module** - Interactive slides, quizzes, and certificates

**Target Audience:** Language learners, educators, EdTech professionals, and technology enthusiasts

**Core Value:** Bridges theoretical understanding with practical application of language learning technology

### Features

- **Static Site Generation**: Lightning-fast performance with Astro
- **Responsive Design**: Mobile-first approach for accessibility
- **SEO Optimized**: Sitemap generation and meta tags
- **Type-Safe**: Built with TypeScript for reliability
- **Modern Architecture**: Component-based structure
- **Multi-Format Publishing**: Website, eBook (EPUB/DOCX), and course module
- **KDP Ready**: Amazon Kindle Direct Publishing compliant

## Setup Instructions

### Prerequisites

- [Bun](https://bun.sh/) installed (v1.0.0 or higher)
- Git installed
- Node.js 18+ (for compatibility)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/YOUR_USERNAME/Language-Learning-with-Technology.git
cd Language-Learning-with-Technology
```

2. Install dependencies:
```bash
bun install
```

3. Start development server:
```bash
bun run dev
```

The site will be available at `http://localhost:4321`

## Build Commands

### Development
```bash
bun run dev          # Start development server (website)
bun run start        # Alias for dev
```

### Production Builds
```bash
bun run build        # Build all deliverables
bun run build:site   # Build website only (static export)
bun run build:book   # Build KDP book package (EPUB + DOCX)
bun run build:course # Build course module
bun run preview      # Preview production build locally
bun run typecheck    # Run TypeScript type checking
```

### Quality Assurance
```bash
bun run test              # Run all tests
bun run test:lighthouse   # Performance audit
bun run test:accessibility # WCAG compliance testing
bun run test:epub         # Validate EPUB format
bun run qa                # Complete QA suite
bun run lint              # Code quality check
bun run format            # Code formatting
```

## Project Structure

```
Language-Learning-with-Technology/
├── content/                  # Book content and chapters
│   ├── chapters/            # Markdown chapter files
│   ├── raw_text/            # Original content
│   └── rewritten/           # Edited versions
├── src/                     # Website source code
│   ├── components/          # Reusable UI components
│   ├── layouts/             # Page layouts
│   ├── pages/               # Website pages
│   └── styles/              # Global styles
├── public/                  # Static assets
│   ├── assets/              # CSS, JS files
│   └── images/              # Images, cover art
├── dist/                    # Built deliverables
│   ├── site/                # Static website export
│   ├── kdp/                 # Amazon KDP package
│   │   ├── *.epub           # Book EPUB
│   │   ├── *.docx           # Book DOCX
│   │   ├── cover.jpg        # Cover image
│   │   ├── metadata.json    # Book metadata
│   │   ├── UPLOAD-GUIDE.md  # KDP publishing guide
│   │   └── AMAZON-LISTING.txt # Listing copy
│   └── course/              # Course module
│       ├── slides/          # Presentation files
│       ├── quiz.html        # Interactive quiz
│       └── certificate.pdf  # Certificate template
├── reports/                 # QA and testing reports
├── scripts/                 # Build and utility scripts
├── tests/                   # Test files
└── config/                  # Configuration files
```

## Deployment Instructions

### GitHub Pages Deployment

This project is configured for automatic deployment to GitHub Pages via GitHub Actions.

#### Initial Setup

1. **Update Astro Config**: Edit `astro.config.mjs` and replace `YOUR_USERNAME` with your GitHub username:
```javascript
site: 'https://YOUR_USERNAME.github.io',
base: '/Language-Learning-with-Technology',
```

2. **Push to GitHub**:
```bash
git add .
git commit -m "Initial commit"
git push origin main
```

3. **Enable GitHub Pages**:
   - Go to your repository settings
   - Navigate to Pages section
   - Set source to "GitHub Actions"

4. **Deployment**: The workflow automatically triggers on push to `main` branch

#### Manual Deployment

If you need to deploy manually:

```bash
# Build the site
bun run build

# The dist/ folder contains your static site
# Push to gh-pages branch manually if needed
```

### Deployment URL

Once deployed, your site will be available at:
```
https://YOUR_USERNAME.github.io/Language-Learning-with-Technology
```

## Maintenance Guide

### Updating Content

1. Edit pages in `src/pages/`
2. Update components in `src/components/`
3. Modify content in `content/`
4. Commit and push changes
5. GitHub Actions will automatically rebuild and deploy

### Updating Dependencies

```bash
# Check for updates
bun update

# Update specific package
bun update astro

# Rebuild after updates
bun run build
```

### Troubleshooting

See [DEPLOYMENT-GUIDE.md](./docs/DEPLOYMENT-GUIDE.md) for detailed troubleshooting steps.

## CI/CD Pipeline

This project uses GitHub Actions for continuous deployment:

- **Trigger**: Push to `main` branch
- **Build Tool**: Bun
- **Target**: GitHub Pages
- **Caching**: Dependencies cached for faster builds
- **Workflow**: `.github/workflows/deploy.yml`

## Development Guidelines

### Code Style

- TypeScript strict mode enabled
- ESLint configuration for code quality
- Prettier for code formatting
- Component-based architecture

### Performance

- Static site generation for optimal loading
- Asset optimization enabled
- Code splitting configured
- Sitemap generation for SEO

## Author

**Charles Martin**
Dissertation: Language Learning with Technology

## License

MIT License - See LICENSE file for details

## Support

For issues or questions:
- Open an issue on GitHub
- Review the [DEPLOYMENT-GUIDE.md](./docs/DEPLOYMENT-GUIDE.md)
- Check Astro documentation: https://docs.astro.build

---

Built with [Astro](https://astro.build) 🚀

