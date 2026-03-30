# 🔐 Environment Variables Documentation

Complete guide to all environment variables required for local development and deployment.

## 📋 Quick Reference

| Variable | Service | Environment | Required | Example |
|----------|---------|-------------|----------|---------|
| `JWT_SECRET` | Server | All | ✅ | `21c9e672d23f...` |
| `POSTGRES_URL` | Server | All (except dev may use local) | ✅ | `postgresql://user:pass@host/dbname` |
| `NODE_ENV` | Server | Dev/Production | ⚠️ | `development` \| `production` |
| `PORT` | Server | Local only | ⚠️ | `5001` |
| `VITE_API_URL` | Client | All | ✅ | `http://localhost:5001/api` \| `https://api.example.com` |

---

## 🖥️ Local Development Setup

### Prerequisites
- Node.js 18+ installed
- PostgreSQL access or Neon account
- `.env` file in project root

### Environment File: `.env`

```bash
# ============================================
# 🔐 AUTHENTICATION
# ============================================
# JWT secret for signing tokens (generate: openssl rand -hex 64)
JWT_SECRET=21c9e672d23f8541f682707d88a8176e51451a6a030827adbb01aa177b8e6d0cf8541f682707d88a8176e51451a6a030827adbb01aa177b8e6d0c

# ============================================
# 🗄️  DATABASE
# ============================================
# PostgreSQL connection string
# Format: postgresql://user:password@host:port/database?sslmode=require
POSTGRES_URL=postgresql://neondb_owner:npg_2IgTXfY9Abzc@ep-quiet-union-a1hj3l83-pooler.ap-southeast-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require

# ============================================
# 🌍 SERVER CONFIGURATION
# ============================================
# Environment mode
NODE_ENV=development

# Server port (local development)
PORT=5001

# ============================================
# 💻 CLIENT CONFIGURATION
# ============================================
# API base URL for frontend requests
# Local dev: points to local server
# Production: points to deployed API
VITE_API_URL=http://localhost:5001/api
```

### Verification

```bash
# Load and verify variables
source .env

# Check JWT_SECRET (should be 128 characters)
echo $JWT_SECRET | wc -c
# Output: 129 (includes newline)

# Check POSTGRES_URL is set
echo $POSTGRES_URL | grep postgresql
# Output: postgresql://...

# Test database connection
psql $POSTGRES_URL -c "SELECT version();"
# Should return PostgreSQL version
```

---

## 🚀 Vercel Deployment

### Frontend (Vercel)

#### Environment Variables
```
VITE_API_URL=https://your-backend-api.com
```

**OR** if using Vercel Functions for backend:
```
VITE_API_URL=/api
```

**Set in Vercel UI:**
1. Project Settings → Environment Variables
2. Add for all environments (Production, Preview, Development)
3. Redeploy after adding

#### Build Configuration
- **Framework:** Vite
- **Build Command:** `npm run build --workspace=client`
- **Output Directory:** `client/dist`
- **Node Version:** 18.x (recommended)

---

### Backend (Railway/Heroku/Vercel Functions)

#### Environment Variables

```
# REQUIRED - Authentication
JWT_SECRET=21c9e672d23f8541f682707d88a8176e51451a6a030827adbb01aa177b8e6d0cf8541f682707d88a8176e51451a6a030827adbb01aa177b8e6d0c

# REQUIRED - Database
POSTGRES_URL=postgresql://user:pass@host:port/dbname?sslmode=require

# RECOMMENDED
NODE_ENV=production
```

**Set in service UI:**
1. **Railway:** Project Settings → Variables
2. **Heroku:** Settings → Config Vars
3. **Vercel Functions:** Settings → Environment Variables
4. Redeploy after changes

#### Start Command
```bash
npm start --prefix server
```

---

## 🔄 Configuration by Environment

### Development (Local Machine)

```
┌─────────────────────────────────────┐
│ .env (Git ignored)                  │
├─────────────────────────────────────┤
│ JWT_SECRET=<dev-secret>             │
│ POSTGRES_URL=local_or_neon          │
│ NODE_ENV=development                │
│ PORT=5001                           │
│ VITE_API_URL=http://localhost:5001  │
└─────────────────────────────────────┘
```

**Start Development:**
```bash
# Terminal 1: Start server
cd server && npm start

# Terminal 2: Start client
cd client && npm run dev
```

---

### Staging (Vercel Preview)

```
┌──────────────────────────────────┐
│ Vercel Preview Environment        │
├──────────────────────────────────┤
│ VITE_API_URL=staging-api-url     │
└──────────────────────────────────┘

┌──────────────────────────────────┐
│ Backend (Railway Staging)         │
├──────────────────────────────────┤
│ JWT_SECRET=<prod-secret>          │
│ POSTGRES_URL=staging-db           │
│ NODE_ENV=production               │
└──────────────────────────────────┘
```

---

### Production (Live)

```
┌──────────────────────────────────┐
│ Vercel (Frontend)                │
├──────────────────────────────────┤
│ VITE_API_URL=https://api.domain  │
└──────────────────────────────────┘

┌──────────────────────────────────┐
│ Railway/Heroku (Backend)          │
├──────────────────────────────────┤
│ JWT_SECRET=<secure-secret>        │
│ POSTGRES_URL=prod-neon-db         │
│ NODE_ENV=production               │
└──────────────────────────────────┘
```

---

## 🔑 Generating Environment Values

### JWT_SECRET

```bash
# Generate 64-byte hex secret (recommended)
openssl rand -hex 64

# Output example:
# 21c9e672d23f8541f682707d88a8176e51451a6a030827adbb01aa177b8e6d0c...

# This is already provided in deployment docs
```

### POSTGRES_URL

Get from your database provider:

**Neon.tech:**
1. Dashboard → Project
2. Connection strings
3. Copy "Connection string" (includes all params)

**AWS RDS:**
```
postgresql://user:password@endpoint:5432/dbname?sslmode=require
```

**Local PostgreSQL:**
```
postgresql://postgres:password@localhost:5432/dsa_tracker
```

---

## ✅ Environment Variable Checklist

### Before Local Development
- [ ] `.env` file created in project root
- [ ] `JWT_SECRET` set (64+ characters)
- [ ] `POSTGRES_URL` set and accessible
- [ ] `NODE_ENV=development`
- [ ] `VITE_API_URL=http://localhost:5001/api`
- [ ] `.env` added to `.gitignore`

### Before Vercel Frontend Deployment
- [ ] `VITE_API_URL` set (points to backend)
- [ ] Build succeeds: `npm run build --workspace=client`
- [ ] `client/dist` folder created
- [ ] No hardcoded API URLs in code

### Before Backend Deployment
- [ ] `JWT_SECRET` is strong (64+ hex characters)
- [ ] `POSTGRES_URL` is correct format
- [ ] Database is accessible from deployment server
- [ ] `NODE_ENV=production`
- [ ] All secrets in service UI (NOT in code)

### Before Full Integration Testing
- [ ] Frontend deployed and accessible
- [ ] Backend deployed and accessible
- [ ] `VITE_API_URL` on frontend matches backend URL
- [ ] Health check works: `curl $BACKEND_URL/api`
- [ ] Signup/login endpoints tested
- [ ] Token generation and validation works

---

## 🐛 Troubleshooting

### "POSTGRES_URL is not defined"
```bash
# Check if .env is loaded
node -e "require('dotenv').config(); console.log(process.env.POSTGRES_URL)"

# Should output: postgresql://...

# If not, ensure .env file exists in project root
ls -la .env
```

### "Cannot connect to database"
```bash
# Test connection directly
psql $POSTGRES_URL -c "SELECT 1"

# If fails, check:
1. POSTGRES_URL is correct
2. Database is accessible from your network
3. SSL/TLS settings match (sslmode in URL)
4. Connection limit not exceeded
```

### "JWT_SECRET is invalid"
```bash
# Check length
echo $JWT_SECRET | wc -c
# Should be > 20 characters (64+ recommended)

# Regenerate
openssl rand -hex 64 > jwt.txt
cat jwt.txt
```

### "API endpoint returns 404"
```bash
# Verify server is running
lsof -i :5001
# Should show node process

# Check VITE_API_URL doesn't have trailing slash
# ✅ http://localhost:5001/api
# ❌ http://localhost:5001/api/

# Verify routes are loaded
curl http://localhost:5001/api
# Should return: {"status":"ok",...}
```

### VITE build includes hardcoded API URL
```bash
# Check for hardcoded URLs
grep -r "localhost:5001" client/src/
grep -r "http://" client/src/

# Solution: Use VITE_API_URL in .env and client/src/utils/api.js
# Verify: cat client/src/utils/api.js | grep baseURL
```

---

## 📚 Environment Variable Best Practices

### ✅ DO:
- Store secrets in environment variables
- Use strong, unique JWT_SECRET (64+ hex characters)
- Set `NODE_ENV=production` in production
- Rotate secrets periodically
- Use different secrets per environment
- Document required variables (see above)
- Add `.env.example` to git (without values)

### ❌ DON'T:
- Commit `.env` file to git
- Use same secret in multiple environments
- Expose secrets in console/logs
- Leave database connections unsecured
- Use short or predictable secrets
- Hardcode API URLs in client code
- Share environment files via unencrypted channels

---

## 🔗 Related Documentation

- [VERCEL_DEPLOYMENT_GUIDE.md](./VERCEL_DEPLOYMENT_GUIDE.md) - Step-by-step deployment
- [DEPLOYMENT.md](./DEPLOYMENT.md) - General deployment info
- [README.md](./README.md) - Project overview
- [.env.example](./.env.example) - Template file

---

## 📞 Questions?

For issues with specific variables:
1. Check your service provider's documentation
2. Verify format matches examples above
3. Test connection locally first
4. Review error logs
5. Consult deployment guides above
