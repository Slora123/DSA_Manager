# Deployment Guide - DSA Tracker

This guide covers deploying DSA Tracker to production.

## 📋 Prerequisites

- PostgreSQL database (Neon, Vercel Postgres, or AWS RDS)
- Vercel account (for frontend) or alternative hosting
- Node.js runtime support
- Environment secrets configured

## 🗄️ 1. Database Setup

### Option A: Vercel Postgres (Recommended)

1. Create a Vercel Postgres database in your Vercel project
2. Copy the `POSTGRES_URL` from Vercel dashboard
3. Add to your `.env.production` file

### Option B: Neon

1. Sign up at [neon.tech](https://neon.tech)
2. Create a new project and database
3. Copy the connection string
4. Use as `POSTGRES_URL`

### Option C: AWS RDS

1. Create a PostgreSQL instance
2. Get the endpoint from AWS console
3. Format connection string:
   ```
   postgresql://username:password@endpoint:5432/dbname?sslmode=require
   ```

### Initialize Database Schema

```bash
# Download schema.sql from your repository
psql -U postgres -d your_database -f server/data/schema.sql

# Or use your database provider's SQL editor
# Copy contents of server/data/schema.sql and execute
```

## 🚀 2. Frontend Deployment (Vercel/Netlify)

### Vercel Deployment

#### Option 1: Direct from GitHub

1. Go to [vercel.com](https://vercel.com)
2. Click "New Project"
3. Import your GitHub repository
4. **Framework**: Select "Vite"
5. **Root Directory**: Set to `client/`
6. **Build Command**: `npm run build`
7. **Output Directory**: `dist`
8. Click "Deploy"

#### Option 2: GitHub Actions (Automatic)

Add `.github/workflows/deploy-frontend.yml`:
```yaml
name: Deploy Frontend

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: cd client && npm install
      - run: cd client && npm run build
      - uses: vercel/action@v4
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
```

### Environment Variables for Frontend

In Vercel dashboard → Settings → Environment Variables:
```
VITE_API_URL=https://your-api-domain.com/api
```

## 🔧 3. Backend Deployment (Vercel Functions or Node.js)

### Option A: Vercel Functions (Recommended)

1. Install Vercel CLI:
   ```bash
   npm i -g vercel
   ```

2. Configure `vercel.json`:
   ```json
   {
     "buildCommand": "cd server && npm install",
     "outputDirectory": "server",
     "env": {
       "POSTGRES_URL": "@postgres_url",
       "JWT_SECRET": "@jwt_secret"
     }
   }
   ```

3. Deploy:
   ```bash
   vercel --prod
   ```

### Option B: Traditional Node.js Hosting (Heroku, Railway, etc.)

#### Railway.app (Recommended)

1. Connect GitHub repository to Railway
2. Configure environment variables:
   - `POSTGRES_URL`: Your database connection string
   - `JWT_SECRET`: Strong random secret
   - `NODE_ENV`: `production`

3. Set startup command:
   ```
   npm install && npm start --prefix server
   ```

4. Deploy automatically on push

#### Heroku

1. Install Heroku CLI: `npm install -g heroku-cli`
2. Login: `heroku login`
3. Create app: `heroku create your-app-name`
4. Set environment variables:
   ```bash
   heroku config:set POSTGRES_URL=your_connection_string
   heroku config:set JWT_SECRET=your_secret
   ```
5. Deploy: `git push heroku main`

## 🔐 4. Environment Secrets Management

### Vercel Secrets

```bash
# Via CLI
vercel env add POSTGRES_URL
vercel env add JWT_SECRET

# Via Dashboard: Settings → Environment Variables
```

### GitHub Secrets (for CI/CD)

Go to GitHub → Settings → Secrets and variables → Actions:

```bash
# Add repository secrets:
POSTGRES_URL         # Your database connection string
JWT_SECRET          # Your JWT signing secret
VERCEL_TOKEN        # Vercel API token
VERCEL_ORG_ID       # Vercel organization ID
VERCEL_PROJECT_ID   # Vercel project ID
```

## ✅ 5. Pre-Deployment Checklist

- [ ] Database schema initialized (`server/data/schema.sql` executed)
- [ ] Environment variables configured
- [ ] CORS settings updated for production domain
- [ ] API routes updated (remove `localhost` references)
- [ ] No console errors in development build
- [ ] Security headers configured
- [ ] HTTPS enforced
- [ ] Database backups configured
- [ ] Monitoring/logging enabled
- [ ] Rate limiting configured (optional)

## 🔍 6. Post-Deployment Verification

### Test API Health Check

```bash
curl https://your-api-domain.com/api
# Should return: {"status":"ok","message":"DSA Tracker Pro API is running"}
```

### Test Authentication

```bash
# Test signup
curl -X POST https://your-api-domain.com/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"username":"test","email":"test@example.com","password":"test123"}'

# Test login
curl -X POST https://your-api-domain.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123"}'
```

### Monitor Logs

- Vercel: Dashboard → Logs
- Railway: Dashboard → Deployments → Logs
- Heroku: `heroku logs --tail`

## 🔄 7. Continuous Deployment

### Auto-Deploy on Push

**GitHub Actions Workflow** (`.github/workflows/deploy.yml`):

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]

jobs:
  test-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'

      # Install and test
      - name: Install dependencies
        run: npm install --workspaces

      - name: Run linter
        run: cd client && npm run lint

      - name: Build frontend
        run: cd client && npm run build

      # Deploy frontend
      - name: Deploy to Vercel
        uses: vercel/action@v4
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-args: '--prod'
```

## 📊 8. Monitoring & Logging

### Application Monitoring

- **Vercel Analytics**: Built-in performance monitoring
- **Sentry**: Error tracking (optional)
- **Uptime Monitoring**: Pingdom or StatusPage

### Database Monitoring

- **Neon**: Built-in monitoring in dashboard
- **Vercel Postgres**: Analytics in Vercel dashboard
- **AWS RDS**: CloudWatch metrics

### Enable Structured Logging

```javascript
// server/utils/logger.js
const log = (level, message, data) => {
  console.log(JSON.stringify({
    timestamp: new Date().toISOString(),
    level,
    message,
    ...data
  }));
};

module.exports = { log };
```

## 🔄 9. Updates & Maintenance

### Updating Dependencies

```bash
# Check for updates
npm outdated --workspaces

# Update safely
npm update --workspaces

# Update major versions (with care)
npm upgrade --workspace=server
npm upgrade --workspace=client
```

### Database Backups

- **Neon**: Automated daily backups
- **Vercel Postgres**: Point-in-time recovery
- **AWS RDS**: Multi-AZ deployments with automated backups

## 🆘 10. Troubleshooting

### Database Connection Issues

```bash
# Test connection
psql $POSTGRES_URL

# Check logs for detailed error
vercel logs
```

### Frontend Build Failures

```bash
# Clear cache and rebuild
rm -rf node_modules client/node_modules
npm install --workspaces
npm run build --workspace=client
```

### API Errors

- Check environment variables are set
- Verify database schema is initialized
- Check CORS configuration
- Review server logs

### Performance Issues

- Enable caching headers
- Compress response bodies
- Optimize database queries
- Use CDN for static assets

## 📚 Additional Resources

- [Vercel Documentation](https://vercel.com/docs)
- [Railway Documentation](https://docs.railway.app)
- [PostgreSQL Setup Guide](https://www.postgresql.org/docs/)
- [React Deployment](https://vitejs.dev/guide/static-deploy.html)

## 🚨 Emergency Procedures

### Rollback Deployment

```bash
# Vercel: Use dashboard to select previous deployment
# Railway: Redeploy from previous commit
# Heroku: heroku releases:rollback v123
```

### Database Recovery

1. Contact your database provider
2. Request point-in-time recovery
3. Restore to a previous backup
4. Test thoroughly before going live

---

**Questions?** Check [CONTRIBUTING.md](CONTRIBUTING.md) for support options.
