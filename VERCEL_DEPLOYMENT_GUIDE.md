# 🚀 Vercel Deployment Guide - Separate Client & Server

Complete guide for deploying DSA Tracker on Vercel with separate client and server projects.

## 📋 Architecture Overview

```
GitHub Repositories:
├── DSA_Management (main)
│   ├── client/          → Deploy to Vercel (Frontend)
│   └── server/          → Deploy to Vercel Functions OR separate backend
```

---

## 🎯 Deployment Strategies

### Strategy 1: Both on Single Vercel Project (Recommended for Simplicity)
- Single repo → Single Vercel project
- Client: Frontend at `/`
- Server: API routes via Vercel Functions

### Strategy 2: Separate Vercel Projects (Recommended for Scale)
- Client: Vercel frontend project
- Server: Vercel backend/Railway/Heroku
- API: Separate domain for backend

This guide covers **Strategy 2** (most common for production).

---

## 🔐 Environment Variables

### Server Environment Variables

#### Required:
```
JWT_SECRET=21c9e672d23f8541f682707d88a8176e51451a6a030827adbb01aa177b8e6d0cf8541f682707d88a8176e51451a6a030827adbb01aa177b8e6d0c
POSTGRES_URL=postgresql://neondb_owner:npg_2IgTXfY9Abzc@ep-quiet-union-a1hj3l83-pooler.ap-southeast-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require
NODE_ENV=production
PORT=5001
```

### Client Environment Variables

#### Required:
```
VITE_API_URL=https://your-api-domain.com/api
# Or if API is on same domain:
VITE_API_URL=/api
```

---

## 📦 Part 1: Deploy Client (Frontend) to Vercel

### Step 1: Prepare Client for Deployment

1. **Verify build configuration** (`client/vite.config.js`):
```bash
cd client && npm run build
```

2. **Check build output** exists in `client/dist/`:
```bash
ls -la dist/ | head
```

### Step 2: Create Vercel Frontend Project

1. Go to [vercel.com](https://vercel.com)
2. Click **"Add New"** → **"Project"**
3. **Import your GitHub repository**
4. **Configure Project Settings:**

| Setting | Value |
|---------|-------|
| Framework | Vite |
| Root Directory | `./client` |
| Build Command | `npm run build --workspace=client` |
| Output Directory | `dist` |
| Install Command | `npm install` |

5. **Environment Variables** (All Environments):
```
VITE_API_URL=/api
```

6. **Deploy** → Click "Deploy"

### Step 3: Verify Frontend

```bash
# Test at your Vercel URL
curl https://your-project.vercel.app/
# Should return HTML
```

---

## 🔧 Part 2: Deploy Server (Backend)

### Option A: Vercel Functions (Same Vercel Project)

#### Setup Vercel Functions:

1. **Create `api/` directory** in root:
```bash
mkdir -p api
```

2. **Move server routes** as Vercel Functions:
```bash
# Create function files that wrap your Express routes
# vercel.json should handle routing
```

3. **Update `vercel.json`**:
```json
{
  "version": 2,
  "buildCommand": "npm install && npm run build --workspace=client",
  "outputDirectory": "client/dist",
  "functions": {
    "api/**/*.js": {
      "runtime": "nodejs18.x",
      "memory": 1024
    }
  },
  "env": {
    "POSTGRES_URL": "@postgres_url",
    "JWT_SECRET": "@jwt_secret"
  },
  "rewrites": [
    {
      "source": "/api/(.*)",
      "destination": "/api/$1"
    },
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

### Option B: Separate Backend Service (Recommended)

Deploy server to Railway, Heroku, or Render.

#### On Railway.app:

1. Go to [railway.app](https://railway.app)
2. **Create New Project** → **Deploy from GitHub**
3. **Configure Environment:**

| Variable | Value |
|----------|-------|
| `POSTGRES_URL` | Your database connection |
| `JWT_SECRET` | Your JWT secret |
| `NODE_ENV` | `production` |
| `PORT` | `5001` (auto-assigned by Railway) |

4. **Set Start Command:**
```bash
npm start --prefix server
```

5. **Domain:** Railway auto-assigns `https://your-app.railway.app`

---

## 🌐 Part 3: Connect Client to Server

### Update Client API URL

**In client environment variables (Vercel):**

If server is at `https://api.yourdomain.vercel.app`:
```
VITE_API_URL=https://api.yourdomain.vercel.app
```

If server is at `https://your-backend.railway.app`:
```
VITE_API_URL=https://your-backend.railway.app
```

If server is same domain (Vercel Functions):
```
VITE_API_URL=/api
```

---

## ✅ Testing Deployment

### 1. Test API Health Check

```bash
# From your deployed API
curl https://your-api-url.vercel.app/api
# Expected response:
# {"status":"ok","message":"DSA Tracker Pro API is running","timestamp":"..."}
```

### 2. Test Database Connection

```bash
# Check server logs
vercel logs
# or
railway logs

# Should show: "✅ Database pool connected"
```

### 3. Test Authentication

```bash
# Signup
curl -X POST https://your-api-url/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "Test123"
  }'

# Expected: 200 with token
```

### 4. Test Frontend

1. Visit: `https://your-frontend.vercel.app`
2. Try signup/login
3. Open DevTools → Network tab
4. Verify API requests go to correct backend URL

---

## 🚀 Configuration Reference

### Server (API) Requirements

```
Deployed URL: https://api-yourdomain.vercel.app
Environment Variables:
  - POSTGRES_URL (required)
  - JWT_SECRET (required)
  - NODE_ENV=production
  - PORT (auto-assigned if Vercel Functions)
Runtime: Node 18+
```

### Client (Frontend) Requirements

```
Deployed URL: https://yourdomain.vercel.app
Environment Variables:
  - VITE_API_URL (required)
Build Command: npm run build --workspace=client
Output: client/dist
Framework: Vite
```

---

## 📋 Step-by-Step Summary

### Week 1: Initial Setup
- [ ] Test locally: `npm run dev` (client & server)
- [ ] Verify database connection: `node test-db.js`
- [ ] Commit and push to GitHub

### Week 2: Vercel Deployment
- [ ] Create Vercel frontend project
- [ ] Set `VITE_API_URL` environment variable
- [ ] Deploy and verify frontend loads

### Week 3: Backend Deployment
- [ ] Choose backend platform (Railway/Vercel/Heroku)
- [ ] Set `POSTGRES_URL` and `JWT_SECRET`
- [ ] Deploy server
- [ ] Get API URL

### Week 4: Integration & Testing
- [ ] Update client `VITE_API_URL` to backend URL
- [ ] Redeploy client
- [ ] Test signup/login
- [ ] Verify all API endpoints
- [ ] Check performance metrics

---

## 🔐 Security Checklist

- [ ] No `.env` file committed
- [ ] All secrets in Vercel environment variables
- [ ] Database connection over SSL/TLS
- [ ] JWT_SECRET is strong and unique
- [ ] CORS headers configured if needed
- [ ] HTTPS enforced (Vercel default)
- [ ] No sensitive data in logs

---

## 🐛 Troubleshooting

### API Returns 404
```
Issue: Frontend can't find API
Solution: Check VITE_API_URL in Vercel environment variables
```

### Database Connection Fails
```
Issue: POSTGRES_URL not set
Solution: 
1. Verify in Vercel/Railway environment variables
2. Test locally: psql $POSTGRES_URL -c "SELECT 1"
3. Check if database schema is initialized
```

### Authentication Fails
```
Issue: JWT token errors
Solution:
1. Verify JWT_SECRET is set the same on both deployments
2. Check token expiration
3. Review middleware/auth.js logs
```

### CORS Errors
```
Issue: Browser blocks API requests
Solution:
1. Verify API_URL doesn't have trailing slash
2. Check CORS headers in server
3. Review browser console for exact error
```

---

## 📊 Environment Variable Checklist

### Local Development (`.env`)
```
✅ JWT_SECRET
✅ POSTGRES_URL
✅ NODE_ENV=development
✅ PORT=5001
✅ VITE_API_URL=http://localhost:5001/api
```

### Vercel Frontend
```
✅ VITE_API_URL=https://your-backend-url
```

### Vercel/Railway Backend
```
✅ JWT_SECRET
✅ POSTGRES_URL
✅ NODE_ENV=production
```

---

## 📞 Support Resources

- [Vercel Documentation](https://vercel.com/docs)
- [Railway Documentation](https://docs.railway.app)
- [Neon PostgreSQL](https://neon.tech/docs)
- [GitHub Actions Guide](https://docs.github.com/actions)

---

## ✨ Next Steps

1. **Choose your backend platform** (Railway recommended)
2. **Set environment variables** for all services
3. **Deploy and test** each component
4. **Monitor logs** for any issues
5. **Update DNS** if using custom domain

Good luck with your deployment! 🚀
