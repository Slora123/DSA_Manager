# GitHub & Vercel Deployment Checklist

Use this checklist before pushing to GitHub and deploying to Vercel.

## ✅ Pre-Push Checklist (GitHub)

### Repository Setup
- [ ] Project is initialized with `git init`
- [ ] Remote is configured: `git remote -v`
- [ ] `.gitignore` contains all necessary exclusions
- [ ] `.gitattributes` properly configured for line endings
- [ ] No `.env` file is tracked (only `.env.example` exists)
- [ ] No `node_modules` are committed
- [ ] No IDE/editor files (.vscode, .idea) are committed

### Code Quality
- [ ] Run `npm run lint` — all files pass linting (or intentionally ignored)
- [ ] No console errors or warnings in development
- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] All environment variables are in `.env.example`
- [ ] Dependencies are up to date: `npm audit`

### Documentation
- [ ] `README.md` is comprehensive and up-to-date
- [ ] `SETUP.md` has clear local development instructions
- [ ] `DEPLOYMENT.md` covers Vercel deployment
- [ ] `CONTRIBUTING.md` exists and is clear
- [ ] `CODE_OF_CONDUCT.md` is present
- [ ] `LICENSE` file exists (MIT by default)
- [ ] `CHANGELOG.md` documents version history
- [ ] `SECURITY.md` exists with security guidelines

### GitHub Files
- [ ] `.github/workflows/` contains CI/CD pipelines
- [ ] `.github/workflows/lint-and-test.yml` exists
- [ ] `.github/workflows/security-audit.yml` exists
- [ ] `.github/workflows/vercel-deploy.yml` exists

### Package Configuration
- [ ] `package.json` (root) has proper metadata
  - Name, description, author, license, repository
  - Proper workspaces configuration
- [ ] `server/package.json` has proper engines (node >=18)
- [ ] `client/package.json` has proper engines (node >=18)
- [ ] All dependencies are explicitly listed (no global installs)

## ✅ First-Time Push Commands

```bash
# Initialize if not already done
git init

# Add GitHub remote (replace with your repo URL)
git remote add origin https://github.com/yourusername/DSA_Management.git

# Create initial commit
git add .
git commit -m "chore: initial commit - DSA Tracker project setup"

# Push to main branch
git branch -M main
git push -u origin main
```

## ✅ Vercel Deployment Checklist

### Vercel Project Setup
- [ ] Vercel account created and logged in
- [ ] Project connected to GitHub repository
- [ ] Framework preset set to "Other"
- [ ] Build command: `npm run build --workspace=client`
- [ ] Output directory: `client/dist`
- [ ] Install command: `npm install`

### Environment Variables in Vercel
Set these in Vercel dashboard → Settings → Environment Variables:

**All Environments:**
- [ ] `VITE_API_URL` = `/api` (for production, or your API domain)

**Production Environment:**
- [ ] `POSTGRES_URL` = Your database connection string
- [ ] `JWT_SECRET` = Your JWT signing secret
- [ ] `NODE_ENV` = `production`

### Database Setup
- [ ] PostgreSQL database created (Neon or Vercel Postgres recommended)
- [ ] Database schema initialized: `server/data/schema.sql`
- [ ] Connection string copied to environment variables
- [ ] Test connection: `psql $POSTGRES_URL -c "SELECT 1"`

### Security
- [ ] All secrets are added to Vercel (not in code)
- [ ] `.vercelignore` properly configured
- [ ] No sensitive files in `.gitignore` but outside `.vercelignore`
- [ ] CORS headers configured if needed
- [ ] HTTPS enforced (Vercel default)

### Pre-Deployment Test
```bash
# Verify builds locally
npm run build --workspace=client
npm run build --workspace=server

# Run linter
npm run lint --workspace=client

# Check for security issues
npm audit --workspaces
```

### Deploy
- [ ] Push code to `main` or `production` branch
- [ ] GitHub Action triggers automatically
- [ ] Vercel builds and deploys successfully
- [ ] Test the deployed application
- [ ] Verify API connectivity

## ✅ GitHub Secrets for CI/CD

Go to GitHub repo → Settings → Secrets and variables → Actions

Add these repository secrets:
```
VERCEL_TOKEN        # From Vercel account settings
VERCEL_ORG_ID       # From Vercel project settings
VERCEL_PROJECT_ID   # From Vercel project URL
VITE_API_URL        # e.g., https://api.yourdomain.com
POSTGRES_URL        # Database connection string
JWT_SECRET          # JWT signing secret
SLACK_WEBHOOK       # (Optional) Slack notification webhook
```

## ✅ Post-Deployment Verification

- [ ] Frontend loads without errors at production URL
- [ ] API health check passes: `/api` returns status
- [ ] Login/signup works correctly
- [ ] Database queries work (problems page loads)
- [ ] Network requests show correct API URL
- [ ] Performance metrics are acceptable (Lighthouse)
- [ ] No console errors in browser DevTools
- [ ] Mobile responsive design works

## 🔄 Continuous Deployment

**Automatic deploys trigger on:**
- [ ] Push to `main` → Preview deployment
- [ ] Push to `production` → Production deployment
- [ ] PR to main → Comment with preview URL

**Monitor deployments:**
- [ ] Check GitHub Actions for workflow status
- [ ] Review Vercel dashboard deployment logs
- [ ] Monitor application logs for errors

## 📋 Verification Commands

```bash
# Verify repository is clean
git status

# Check remote is set correctly
git remote -v

# View commit history
git log --oneline -5

# Test build locally
npm install --workspaces
npm run build --workspace=client

# Run linter
npm run lint --workspace=client

# Run security audit
npm audit --workspaces
```

## 🆘 Troubleshooting

### Build fails on Vercel
1. Check Vercel logs: Dashboard → Deployments → Logs
2. Verify environment variables are set
3. Ensure `vercel.json` is correct
4. Test build locally: `npm run build --workspace=client`

### Database connection fails
1. Verify `POSTGRES_URL` in Vercel environment
2. Test connection: `psql $POSTGRES_URL -c "SELECT 1"`
3. Check if schema is initialized

### Deploy rejected by GitHub Actions
1. Check `.github/workflows/` files are valid YAML
2. Verify GitHub Secrets are configured
3. Check branch protection rules don't block deploys

---

**Last Updated:** March 30, 2026

For questions, see [CONTRIBUTING.md](CONTRIBUTING.md) or [DEPLOYMENT.md](DEPLOYMENT.md)
