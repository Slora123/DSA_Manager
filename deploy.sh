#!/bin/bash

# 🚀 DSA Tracker - Quick Deployment Checklist
# This script guides you through the deployment process

set -e

echo ""
echo "════════════════════════════════════════════════════════════"
echo "        🚀 DSA Tracker - Deployment Quick Start"
echo "════════════════════════════════════════════════════════════"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

step=1

section() {
  echo ""
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}STEP $step: $1${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  ((step++))
}

confirm() {
  read -p "$(echo -e ${BLUE})✓ $1 (yes/no): $(echo -e ${NC})" -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    return 0
  else
    return 1
  fi
}

section "Verify Local Setup"
echo -e "${GREEN}✅${NC} Make sure you have:"
echo "   • Git configured"
echo "   • Node.js 18+ installed"
echo "   • PostgreSQL/Neon account"
echo "   • Vercel account"
echo "   • Railway account (for backend)"
echo ""
if ! confirm "Do you have all of the above?"; then
  echo "Please set up the above first. See README.md for instructions."
  exit 1
fi

section "Create Local .env File"
if [ ! -f ".env" ]; then
  echo "Creating .env from .env.example..."
  cp .env.example .env
  echo -e "${GREEN}✅${NC} Created .env"
else
  echo -e "${YELLOW}⚠️${NC} .env already exists"
fi

echo ""
echo "📝 Now edit .env with your values:"
echo "   • JWT_SECRET (strong random value)"
echo "   • POSTGRES_URL (from Neon)"
echo "   • NODE_ENV (development)"
echo "   • VITE_API_URL (http://localhost:5001/api)"
echo ""
if ! confirm "Have you updated .env with your credentials?"; then
  echo "Please configure .env first."
  exit 1
fi

section "Test Local Deployment"
echo "Installing dependencies..."
npm install > /dev/null 2>&1
echo -e "${GREEN}✅${NC} Dependencies installed"

echo ""
echo "Testing server startup..."
if cd server && timeout 10 npm start > /dev/null 2>&1 &
then
  sleep 2
  if curl -s http://localhost:5001/api | grep -q "status"; then
    echo -e "${GREEN}✅${NC} Server running and responding"
  else
    echo -e "${YELLOW}⚠️${NC} Server running but API not responding"
  fi
  pkill -f "node server.js" 2>/dev/null || true
else
  echo -e "${YELLOW}⚠️${NC} Could not start server"
fi
cd ..

echo ""
echo "Testing client build..."
if npm run build --workspace=client > /dev/null 2>&1; then
  echo -e "${GREEN}✅${NC} Client builds successfully"
else
  echo -e "${YELLOW}❌${NC} Client build failed"
  exit 1
fi

section "Prepare GitHub"
echo "Checking git status..."
echo ""
git status || exit 1

echo ""
if [ -n "$(git status --porcelain)" ]; then
  echo -e "${YELLOW}⚠️${NC} You have uncommitted changes"
  if confirm "Do you want to commit these now?"; then
    git add .
    git commit -m "chore: deployment ready"
    echo -e "${GREEN}✅${NC} Changes committed"
  else
    echo "Please commit your changes before deploying."
    exit 1
  fi
fi

echo ""
if ! git remote get-url origin > /dev/null 2>&1; then
  echo -e "${YELLOW}❌${NC} Git remote 'origin' not configured"
  echo "Run: git remote add origin <your-github-url>"
  exit 1
fi
echo -e "${GREEN}✅${NC} Git remote configured"

section "Push to GitHub"
echo "Pushing to GitHub..."
git push -u origin main
echo -e "${GREEN}✅${NC} Pushed to GitHub"

section "Deploy Frontend (Vercel)"
echo ""
echo "📋 Deployment Steps:"
echo ""
echo "1. Go to https://vercel.com"
echo "2. Click 'Add New' → 'Project'"
echo "3. Select your GitHub repository"
echo "4. Configure:"
echo "   • Framework: Vite"
echo "   • Root Directory: ./client"
echo "   • Build Command: npm run build --workspace=client"
echo "   • Output Directory: dist"
echo "5. Environment Variables (All environments):"
echo "   • VITE_API_URL: https://your-railway-api.railway.app"
echo "   (You'll update this after deploying backend)"
echo "6. Click 'Deploy'"
echo ""
if confirm "Ready to deploy frontend?"; then
  open "https://vercel.com" 2>/dev/null || echo "Opening Vercel in browser..."
  echo ""
  echo "Once deployed, your frontend will be at: https://[project].vercel.app"
  read -p "Paste your Vercel URL here: " VERCEL_URL
  echo "Frontend URL: $VERCEL_URL"
else
  echo "Skipping frontend deployment for now."
fi

section "Deploy Backend (Railway)"
echo ""
echo "📋 Deployment Steps:"
echo ""
echo "1. Go to https://railway.app"
echo "2. Click 'Create New Project'"
echo "3. Select 'Deploy from GitHub'"
echo "4. Select your repository"
echo "5. Set Environment Variables:"
echo "   • POSTGRES_URL: (from Neon)"
echo "   • JWT_SECRET: (your JWT secret)"
echo "   • NODE_ENV: production"
echo "6. Set Start Command:"
echo "   npm start --prefix server"
echo "7. Click 'Deploy'"
echo ""
if confirm "Ready to deploy backend?"; then
  open "https://railway.app" 2>/dev/null || echo "Opening Railway in browser..."
  echo ""
  echo "Once deployed, your backend will be at: https://[project].railway.app"
  read -p "Paste your Railway API URL here: " RAILWAY_URL
  echo "Backend URL: $RAILWAY_URL"
else
  echo "Skipping backend deployment for now."
fi

section "Connect Frontend to Backend"
if [ -n "$RAILWAY_URL" ]; then
  echo "Updating VITE_API_URL in Vercel..."
  echo ""
  echo "Go to: https://vercel.com/dashboard"
  echo "1. Select your project"
  echo "2. Settings → Environment Variables"
  echo "3. Update VITE_API_URL: $RAILWAY_URL"
  echo "4. Vercel will automatically redeploy"
  echo ""
  if confirm "Have you updated VITE_API_URL in Vercel?"; then
    echo -e "${GREEN}✅${NC} Frontend connected to backend"
  fi
fi

section "Test Live Application"
echo ""
echo "Testing your deployed application..."
echo ""

if [ -n "$VERCEL_URL" ]; then
  echo "Frontend: $VERCEL_URL"
  echo ""
  echo "🧪 Manual Testing Steps:"
  echo "1. Open $VERCEL_URL in browser"
  echo "2. Click 'Sign Up'"
  echo "3. Create a test account"
  echo "4. Verify you can log in"
  echo "5. Verify you can see problem lists"
  echo ""
  if confirm "Can you access the application?"; then
    echo -e "${GREEN}✅${NC} Application is working!"
  else
    echo -e "${YELLOW}❌${NC} Application has issues"
    echo "Check the logs:"
    echo "• Browser console (F12) for frontend errors"
    echo "• Railway logs for backend errors"
    echo "• VITE_API_URL is correct in Vercel settings"
  fi
fi

echo ""
section "Final Steps"
echo ""
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo ""
echo "📚 Next Steps:"
echo "1. Monitor your application for errors"
echo "2. Set up custom domain (optional)"
echo "3. Configure CI/CD pipelines"
echo "4. Set up monitoring and alerts"
echo ""
echo "📖 Documentation:"
echo "• README.md - Project overview"
echo "• VERCEL_DEPLOYMENT_GUIDE.md - Detailed guide"
echo "• ENV_VARIABLES.md - Environment configuration"
echo "• DEPLOYMENT_READY.md - Status report"
echo ""
echo "🎉 Your DSA Tracker is now live!"
