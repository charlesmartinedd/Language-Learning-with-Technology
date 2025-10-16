# Deployment Guide - Language Learning with Technology

Complete guide for deploying and maintaining the Language Learning with Technology website on GitHub Pages.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Initial Deployment](#initial-deployment)
3. [Configuration](#configuration)
4. [Build Process](#build-process)
5. [Troubleshooting](#troubleshooting)
6. [Update Process](#update-process)
7. [Rollback Procedures](#rollback-procedures)
8. [Performance Optimization](#performance-optimization)

## Prerequisites

### Required Tools

- **Bun**: v1.0.0 or higher ([install guide](https://bun.sh/))
- **Git**: Latest version
- **GitHub Account**: With repository access
- **Node.js**: v18+ (for compatibility checks)

### Verify Installation

```bash
bun --version
git --version
node --version
```

## Initial Deployment

### Step 1: Configure Repository

1. **Update Astro Configuration**

Edit `astro.config.mjs`:

```javascript
export default defineConfig({
  site: 'https://YOUR_USERNAME.github.io',
  base: '/Language-Learning-with-Technology',
  // ... rest of config
});
```

Replace `YOUR_USERNAME` with your actual GitHub username.

2. **Initialize Git Repository**

```bash
cd Language-Learning-with-Technology
git init
git add .
git commit -m "Initial commit: Language Learning website"
```

3. **Create GitHub Repository**

```bash
# Using GitHub CLI (recommended)
gh repo create Language-Learning-with-Technology --public --source=. --remote=origin

# Or manually:
# - Go to github.com/new
# - Name: Language-Learning-with-Technology
# - Public repository
# - Don't initialize with README (already exists)
```

4. **Push to GitHub**

```bash
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/Language-Learning-with-Technology.git
git push -u origin main
```

### Step 2: Enable GitHub Pages

1. Navigate to repository settings: `https://github.com/YOUR_USERNAME/Language-Learning-with-Technology/settings/pages`

2. Under "Build and deployment":
   - **Source**: GitHub Actions
   - Save changes

3. Wait for the workflow to complete (check Actions tab)

4. Access your site at: `https://YOUR_USERNAME.github.io/Language-Learning-with-Technology`

## Configuration

### Astro Configuration Explained

```javascript
// astro.config.mjs
export default defineConfig({
  // Your site URL
  site: 'https://YOUR_USERNAME.github.io',

  // Repository name (important for GitHub Pages)
  base: '/Language-Learning-with-Technology',

  // Output directory for built files
  outDir: './dist',

  // Static assets folder
  publicDir: './public',

  // Enable sitemap generation
  integrations: [sitemap()],

  // Build optimizations
  build: {
    assets: '_assets'
  }
});
```

### GitHub Actions Workflow

The `.github/workflows/deploy.yml` file handles automatic deployment:

- **Trigger**: Push to `main` branch
- **Runner**: Ubuntu latest
- **Build Tool**: Bun
- **Deployment**: GitHub Pages

## Build Process

### Local Build

Test the build process locally before deploying:

```bash
# Install dependencies
bun install

# Run type checking
bun run typecheck

# Build for production
bun run build

# Preview the build
bun run preview
```

### Build Output

After building, the `dist/` folder contains:

```
dist/
├── _assets/        # Optimized CSS, JS, images
├── index.html      # Main page
├── sitemap.xml     # Generated sitemap
└── ...             # Other pages and assets
```

### GitHub Actions Build

When you push to `main`:

1. GitHub Actions checks out code
2. Sets up Bun environment
3. Installs dependencies with caching
4. Runs build process
5. Uploads artifact to GitHub Pages
6. Deploys to production

Monitor progress in the Actions tab: `https://github.com/YOUR_USERNAME/Language-Learning-with-Technology/actions`

## Troubleshooting

### Common Issues

#### 1. Build Fails - "Cannot find module 'astro'"

**Problem**: Dependencies not installed

**Solution**:
```bash
rm -rf node_modules
bun install
bun run build
```

#### 2. 404 Error on Deployed Site

**Problem**: Incorrect base path configuration

**Solution**:
1. Verify `base` in `astro.config.mjs` matches repository name
2. Update and rebuild:
```bash
# Edit astro.config.mjs
bun run build
git add .
git commit -m "Fix base path"
git push
```

#### 3. Assets Not Loading (404 on CSS/JS)

**Problem**: Base path not applied to asset URLs

**Solution**:
- Ensure all asset references use relative paths
- Check `public/` folder structure
- Verify `build.assets` configuration in `astro.config.mjs`

#### 4. GitHub Actions Workflow Fails

**Problem**: Permissions or workflow configuration

**Solutions**:

**Check Permissions**:
```yaml
# In deploy.yml
permissions:
  contents: read
  pages: write
  id-token: write
```

**Verify Pages Settings**:
- Settings → Pages → Source must be "GitHub Actions"

**Review Workflow Logs**:
- Go to Actions tab
- Click failed workflow
- Check each step's output

#### 5. Bun Command Not Found in GitHub Actions

**Problem**: Bun setup step failed

**Solution**:
The workflow includes Bun setup. If it fails:
```yaml
- name: Setup Bun
  uses: oven-sh/setup-bun@v1
  with:
    bun-version: latest
```

#### 6. Old Content Still Showing After Deployment

**Problem**: Browser cache

**Solution**:
- Hard refresh: `Ctrl+Shift+R` (Windows/Linux) or `Cmd+Shift+R` (Mac)
- Clear browser cache
- Try incognito/private mode
- Wait 5-10 minutes for CDN cache to clear

### Debug Mode

Enable verbose logging in GitHub Actions:

```yaml
- name: Build with Astro
  run: |
    bun run build --verbose
```

## Update Process

### Content Updates

1. **Make Changes Locally**:
```bash
# Edit files in src/, content/, or public/
# Test changes
bun run dev
```

2. **Test Build**:
```bash
bun run build
bun run preview
```

3. **Deploy**:
```bash
git add .
git commit -m "Update: [description of changes]"
git push
```

4. **Monitor Deployment**:
- Check Actions tab for workflow status
- Verify changes on live site (may take 2-5 minutes)

### Dependency Updates

```bash
# Check for updates
bun update --latest

# Update specific package
bun update astro

# Test after updates
bun run typecheck
bun run build

# Deploy
git add package.json
git commit -m "Update dependencies"
git push
```

## Rollback Procedures

### Quick Rollback

If a deployment breaks the site:

#### Method 1: Git Revert (Recommended)

```bash
# Find the last working commit
git log --oneline

# Revert to previous commit
git revert HEAD
git push

# Or reset to specific commit
git reset --hard <commit-hash>
git push --force
```

#### Method 2: GitHub Actions Re-run

1. Go to Actions tab
2. Find last successful workflow run
3. Click "Re-run all jobs"

#### Method 3: Deploy Previous Build

```bash
# Checkout previous version
git checkout <previous-commit-hash>

# Force push (use carefully!)
git push --force origin main
```

### Emergency Rollback Checklist

1. ✅ Identify the issue (build failure, broken links, content error)
2. ✅ Note the last working commit hash
3. ✅ Choose rollback method
4. ✅ Execute rollback
5. ✅ Verify site is working
6. ✅ Document the issue
7. ✅ Fix the problem in a new branch
8. ✅ Test thoroughly before re-deploying

## Performance Optimization

### Build Optimization

**1. Enable Compression**

Assets are automatically optimized by Astro. Verify in build output:
```bash
bun run build
# Look for: "optimizing assets..."
```

**2. Code Splitting**

Configure in `astro.config.mjs`:
```javascript
vite: {
  build: {
    cssCodeSplit: true,
    rollupOptions: {
      output: {
        manualChunks: undefined
      }
    }
  }
}
```

**3. Image Optimization**

Use Astro's built-in image optimization:
```astro
---
import { Image } from 'astro:assets';
import myImage from '../assets/image.jpg';
---
<Image src={myImage} alt="Description" />
```

### Deployment Speed

**Cache Dependencies**

GitHub Actions automatically caches Bun dependencies:
```yaml
- name: Setup Bun
  uses: oven-sh/setup-bun@v1
  with:
    bun-version: latest
# Caching handled by action
```

**Parallel Builds**

If you have multiple environments:
```yaml
strategy:
  matrix:
    node-version: [18, 20]
```

### Monitoring Performance

**Build Times**:
- Check Actions tab for build duration
- Target: <2 minutes for typical builds

**Site Speed**:
- Use [PageSpeed Insights](https://pagespeed.web.dev/)
- Target: >90 performance score

**Bundle Size**:
```bash
bun run build
# Check output for bundle sizes
# Target: <500KB total
```

## Best Practices

### Before Every Deploy

1. ✅ Run type checking: `bun run typecheck`
2. ✅ Test build locally: `bun run build && bun run preview`
3. ✅ Check for broken links
4. ✅ Review changes in preview
5. ✅ Write descriptive commit message

### Commit Message Format

```
type(scope): description

[optional body]
[optional footer]
```

Examples:
```
feat(content): add new research section
fix(layout): correct mobile navigation
docs(readme): update deployment instructions
chore(deps): update astro to v4.15.4
```

### Branch Strategy

For larger changes:

```bash
# Create feature branch
git checkout -b feature/new-section

# Make changes and test
bun run dev

# Build and preview
bun run build && bun run preview

# Push feature branch
git push origin feature/new-section

# Create PR on GitHub
gh pr create --title "Add new section" --body "Description"

# After review, merge to main (triggers deployment)
```

## Maintenance Schedule

### Weekly
- ✅ Check for broken links
- ✅ Review analytics (if configured)
- ✅ Monitor GitHub Actions status

### Monthly
- ✅ Update dependencies: `bun update`
- ✅ Review and update content
- ✅ Check performance metrics
- ✅ Test on multiple devices/browsers

### Quarterly
- ✅ Major dependency updates
- ✅ Security audit
- ✅ Performance optimization review
- ✅ Backup review

## Security Considerations

### Secrets Management

**Never commit**:
- `.env` files
- API keys
- Private tokens
- Credentials

**Use GitHub Secrets** for sensitive data:
1. Settings → Secrets and variables → Actions
2. Add repository secret
3. Reference in workflow: `${{ secrets.SECRET_NAME }}`

### Dependency Security

```bash
# Audit dependencies (when using npm/yarn)
bun install

# Bun automatically uses trusted registries
# Review dependencies regularly
```

## Support Resources

### Documentation
- [Astro Docs](https://docs.astro.build)
- [GitHub Pages Docs](https://docs.github.com/pages)
- [Bun Docs](https://bun.sh/docs)

### Getting Help

1. **Check this guide** for common issues
2. **Review workflow logs** in Actions tab
3. **Search GitHub Issues** in Astro repository
4. **Stack Overflow** with tags: astro, github-pages
5. **GitHub Discussions** in repository

### Useful Commands Quick Reference

```bash
# Development
bun run dev              # Start dev server
bun run preview          # Preview production build

# Build
bun run build            # Production build
bun run typecheck        # Type checking

# Git
git status               # Check status
git log --oneline        # View commits
git diff                 # View changes

# GitHub
gh repo view             # View repository
gh workflow view         # View workflows
gh run list              # List workflow runs
```

## Conclusion

This guide covers the complete deployment lifecycle for the Language Learning with Technology website. Follow these procedures for reliable, maintainable deployments.

For additional support or questions, refer to the main [README.md](../README.md) or open an issue on GitHub.

---

**Last Updated**: October 2025
**Version**: 1.0.0
**Maintainer**: Charles Martin
