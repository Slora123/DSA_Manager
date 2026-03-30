# 🚀 Quick Start: GitHub Push & Vercel Deploy

This guide walks you through pushing your project to GitHub and deploying to Vercel.

## Step 1: Pre-Push Verification

Run the readiness check:

```bash
./push-ready.sh
```

This validates:
- ✅ Git repository setup
- ✅ Essential files present
- ✅ No secrets committed
- ✅ Dependencies installed
- ✅ Code quality checks

## Step 2: Configure GitHub Repository

### If you haven't created the repository yet:

1. Go to [github.com/new](https://github.com/new)
2. Create repository `DSA_Management`
3. Copy the HTTPS URL
4. In your project root:

```bash
git remote add origin https://github.com/YOUR_USERNAME/DSA_Management.git
git branch -M main
```

### If you already have a repository set up, verify:

```bash
git remote -v
# Should show: origin https://github.com/YOUR_USERNAME/DSA_Management.git
```

## Step 3: Make First Commit

```bash
git add .
git commit -m "chore: initial commit - DSA Tracker project setup"
```

Verify status:
```bash
git status
# Should show: "On branch main, nothing to commit, working tree clean"
```

## Step 4: Push to GitHub

```bash
git push -u origin main
```

Verify on GitHub:
- Visit: https://github.com/YOUR_USERNAME/DSA_Management
- Confirm all files are there
- Confirm `.env` and `node_modules` are NOT present

## Step 5: Vercel Account Setup

1. Go to [vercel.com](https://vercel.com)
2. Sign up (or log in)
3. Click "Add New..." → "Project"
4. Import your GitHub repository
5. Configure build settings:
   - **Framework Preset**: Other
   - **Build Command**: `npm run build --workspace=client`
   - **Output Directory**: `client/dist`
   - **Install Command**: `npm install`
   - **Root Directory**: `./`

## Step 6: Set Environment Variables in Vercel

In Vercel Dashboard → Settings → Environment Variables:

### For All Environments:
```
VITE_API_URL = /api
```

### For Production Environment:
```
POSTGRES_URL = postgresql://username:password@host/dbname
JWT_SECRET = (generate with: node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")
NODE_ENV = production
```

## Step 7: Setup Database (Critical!)

Choose your database:

### Option A: Vercel Postgres (Recommended)
```bash
# In Vercel dashboard, add Postgres storage
# Copy the POSTGRES_URL to environment variables
# Automatically initialized
```

### Option B: Neon
```bash
# 1. Sign up at https://neon.tech
# 2. Create a database
# 3. Run schema initialization

psql $POSTGRES_URL < server/data/schema.sql

# Verify
psql $POSTGRES_URL -c "SELECT 1"
```

### Option C: AWS RDS / Self-hosted
```bash
# Get your connection string
# Run schema on your database
psql -U postgres -d your_db < server/data/schema.sql
```

## Step 8: Deploy

### Option 1: Automatic (Recommended)
Just push to GitHub - Vercel auto-deploys:
```bash
git push origin main
```

Check Vercel dashboard for deployment progress.

### Option 2: Manual Deploy via CLI
```bash
# Install Vercel CLI
npm install -g vercel

# Login
vercel login

# Link project
vercel link

# Deploy preview
vercel

# Deploy production
vercel --prod
```

## Step 9: Post-Deployment Verification

### Test Your Deployment
```bash
# Health check
curl https://your-project.vercel.app/api
# Should return: {"status":"ok","message":"..."}

# Test signup
curl -X POST https://your-project.vercel.app/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"username":"test","email":"test@example.com","password":"test123"}'
```

### Verify in Browser
1. Open: https://your-project.vercel.app
2. Test signup/login
3. Check browser console for errors
4. Check Network tab for API calls

## Step 10: Configure GitHub Secrets (for CI/CD)

For automatic deployments via GitHub Actions:

Go to: GitHub → Settings → Secrets and variables → Actions

Add these secrets:
```
VERCEL_TOKEN      → Get from Vercel Settings
VERCEL_ORG_ID     → Get from Vercel URL
VERCEL_PROJECT_ID → Get from Vercel URL
VITE_API_URL      → https://your-project.vercel.app/api
POSTGRES_URL      → Your database connection
JWT_SECRET        → Your JWT secret
```

## 📋 Verify Everything Works

### Local Development
```bash
npm install --workspaces
npm run dev --workspace=client  # Terminal 1
npm run dev --workspace=server  # Terminal 2
```

Test at http://localhost:5173

### Production
- Visit your Vercel deployment URL
- Test signup/login
- Check API connectivity
- Review browser console

## 🆘 Troubleshooting

### Vercel Build Fails
```bash
# Check logs in Vercel dashboard
# Verify environment variables are set
# Run locally: npm run build --workspace=client
```

### Database Connection Error
```bash
# Verify POSTGRES_URL is set in Vercel
# Test locally: psql $POSTGRES_URL -c "SELECT 1"
# Check if schema is initialized
```

### API Not Working
```bash
# Check VITE_API_URL is set correctly
# Verify server is running
# Check CORS settings
# Review server logs in Vercel
```

## 📚 Additional Resources

- [GITHUB_VERCEL_CHECKLIST.md](GITHUB_VERCEL_CHECKLIST.md) - Complete checklist
- [DEPLOYMENT.md](DEPLOYMENT.md) - Detailed deployment guide
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contributing guidelines
- [Vercel Docs](https://vercel.com/docs)
- [GitHub Docs](https://docs.github.com)

## 🎯 Success Indicators

You're ready to show the world your project when:

- ✅ Repository visible on GitHub
- ✅ README displays correct badges and links
- ✅ Vercel shows "Ready" deployment status
- ✅ Live application works in browser
- ✅ API requests complete successfully
- ✅ GitHub Actions run successfully on push

---

**Questions?** Check the [DEPLOYMENT.md](DEPLOYMENT.md) or [CONTRIBUTING.md](CONTRIBUTING.md) guides.

Happy deploying! 🚀
