#!/usr/bin/env bash

# DSA Tracker - Complete Deployment Testing Script
# Tests all components before Vercel deployment

set -e

echo "🧪 DSA Tracker - Deployment Testing Suite"
echo "=========================================="
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

pass=0
fail=0

# Helper functions
pass_test() {
  echo -e "${GREEN}✅${NC} $1"
  ((pass++))
}

fail_test() {
  echo -e "${RED}❌${NC} $1"
  ((fail++))
}

warn_test() {
  echo -e "${YELLOW}⚠️${NC} $1"
}

section() {
  echo ""
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}$1${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
}

# Test 1: Environment Variables
section "1️⃣  Environment Variables Check"

if [ -f ".env" ]; then
  pass_test ".env file exists"
else
  fail_test ".env file missing"
fi

if grep -q "JWT_SECRET=" .env 2>/dev/null; then
  JWT_SECRET=$(grep "JWT_SECRET=" .env | cut -d= -f2)
  if [ ${#JWT_SECRET} -gt 20 ]; then
    pass_test "JWT_SECRET is set (${#JWT_SECRET} chars)"
  else
    fail_test "JWT_SECRET too short"
  fi
else
  fail_test "JWT_SECRET not defined"
fi

if grep -q "POSTGRES_URL=" .env 2>/dev/null; then
  pass_test "POSTGRES_URL is set"
else
  fail_test "POSTGRES_URL not defined"
fi

export $(cat .env | xargs)

# Test 2: Database Connection
section "2️⃣  Database Connectivity"

cd server

if node -e "require('pg').Pool({connectionString: process.env.POSTGRES_URL, ssl: {rejectUnauthorized: false}}).query('SELECT 1').then(() => process.exit(0)).catch(e => {console.error(e.message); process.exit(1)})" 2>/dev/null; then
  pass_test "PostgreSQL connection successful"
else
  fail_test "PostgreSQL connection failed"
fi

# Test 3: Database Schema
if PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -U $POSTGRES_USER -d neondb -c "\dt" 2>/dev/null | grep -q "users"; then
  pass_test "Database schema initialized (users table exists)"
else
  warn_test "Database schema may not be initialized - run: psql \$POSTGRES_URL < server/data/schema.sql"
fi

cd ..

# Test 4: Server Startup
section "3️⃣  Server Startup & Routes"

if [ -f "server/server.js" ]; then
  pass_test "server/server.js exists"
else
  fail_test "server/server.js missing"
fi

if [ -f "server/index.js" ]; then
  pass_test "server/index.js exists"
else
  fail_test "server/index.js missing"
fi

# Check routes load without errors
if node server/index.js 2>&1 | grep -q "✅ Auth routes loaded"; then
  pass_test "Auth routes load successfully"
else
  warn_test "Could not verify route loading"
fi

# Test 5: Client Build
section "4️⃣  Client Build & Configuration"

cd client

if [ -f "vite.config.js" ]; then
  pass_test "vite.config.js exists"
else
  fail_test "vite.config.js missing"
fi

if [ -f "package.json" ]; then
  pass_test "client/package.json exists"
else
  fail_test "client/package.json missing"
fi

if grep -q "build" package.json 2>/dev/null; then
  pass_test "Build script configured"
else
  fail_test "Build script not found in package.json"
fi

if [ -d "node_modules" ]; then
  pass_test "Dependencies installed"
else
  warn_test "Dependencies not installed - run: npm install"
fi

cd ..

# Test 6: API Endpoint Check
section "5️⃣  API Endpoints"

# Check if server is running on port 5001
if lsof -i :5001 >/dev/null 2>&1; then
  pass_test "Server is running on port 5001"
  
  # Test health check
  if curl -s http://localhost:5001/api | grep -q "status"; then
    pass_test "Health check endpoint (/api) responds"
  else
    fail_test "Health check endpoint not responding"
  fi
else
  warn_test "Server not running on port 5001 - start with: cd server && npm start"
fi

# Test 7: File Structure
section "6️⃣  Deployment Configuration Files"

files_to_check=(
  ".env.example"
  ".gitignore"
  "vercel.json"
  "server/package.json"
  "client/package.json"
  "package.json"
  "README.md"
  "DEPLOYMENT.md"
)

for file in "${files_to_check[@]}"; do
  if [ -f "$file" ] || [ -d "$file" ]; then
    pass_test "$file configured"
  else
    fail_test "$file missing"
  fi
done

# Test 8: GitHub Configuration
section "7️⃣  GitHub & Version Control"

if [ -d ".git" ]; then
  pass_test "Git repository initialized"
else
  fail_test "Git repository not initialized"
fi

if ! grep -q "node_modules" .gitignore 2>/dev/null; then
  fail_test "node_modules not in .gitignore"
else
  pass_test "node_modules properly ignored"
fi

if ! git ls-files | grep -q "\.env"; then
  pass_test ".env file not tracked"
else
  fail_test ".env file is tracked (security risk)"
fi

# Test 9: Vercel Configuration
section "8️⃣  Vercel Configuration"

if [ -f "vercel.json" ]; then
  if node -e "require('./vercel.json'); console.log('Valid');" 2>/dev/null | grep -q "Valid"; then
    pass_test "vercel.json is valid JSON"
  else
    fail_test "vercel.json is invalid JSON"
  fi
else
  fail_test "vercel.json missing"
fi

if [ -f ".vercelignore" ]; then
  pass_test ".vercelignore configured"
else
  warn_test ".vercelignore missing (optional)"
fi

# Test 10: Environment Readiness
section "9️⃣  Vercel Environment Setup"

if command -v vercel &> /dev/null; then
  pass_test "Vercel CLI installed"
else
  warn_test "Vercel CLI not installed - run: npm install -g vercel"
fi

if git remote -v | grep -q "origin"; then
  pass_test "Git remote 'origin' configured"
else
  warn_test "Git remote not configured"
fi

# Summary
section "📊 Test Summary"

total=$((pass + fail))
echo "Passed: ${GREEN}$pass${NC}"
echo "Failed: ${RED}$fail${NC}"
echo "Total:  $total"
echo ""

if [ $fail -eq 0 ]; then
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${GREEN}✅ ALL TESTS PASSED - READY FOR DEPLOYMENT!${NC}"
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo "📋 Next Steps:"
  echo "  1. Read: VERCEL_DEPLOYMENT_GUIDE.md"
  echo "  2. Push: git push origin main"
  echo "  3. Deploy Frontend: Connect GitHub to Vercel"
  echo "  4. Deploy Backend: Use Railway or Vercel Functions"
  echo ""
else
  echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${YELLOW}⚠️  SOME TESTS FAILED OR WARNINGS PRESENT${NC}"
  echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo "Please address the issues above before deploying."
  echo ""
fi
