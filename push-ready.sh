#!/usr/bin/env bash

# DSA Tracker - GitHub & Vercel Push Ready Check

echo "🔍 DSA Tracker - Push Readiness Check"
echo "===================================="
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

pass=0
total=0

# Check function
check_item() {
  total=$((total + 1))
  if [ "$1" = "true" ]; then
    echo -e "${GREEN}✓${NC} $2"
    pass=$((pass + 1))
  elif [ "$1" = "warn" ]; then
    echo -e "${YELLOW}⚠${NC} $2"
    pass=$((pass + 1))
  else
    echo -e "${RED}✗${NC} $2"
  fi
}

# Run checks
[ -d ".git" ] && check_item "true" "Git repository initialized" || check_item "false" "Git not initialized"
[ -f ".gitignore" ] && check_item "true" ".gitignore exists" || check_item "false" ".gitignore missing"
! grep -q "node_modules" .gitignore 2>/dev/null && check_item "false" ".gitignore incomplete" || check_item "true" ".gitignore configured"
[ -f ".env.example" ] && check_item "true" ".env.example exists" || check_item "false" ".env.example missing"
[ -f "README.md" ] && check_item "true" "README.md exists" || check_item "false" "README.md missing"
[ -f "LICENSE" ] && check_item "true" "LICENSE exists" || check_item "false" "LICENSE missing"
[ -f "CONTRIBUTING.md" ] && check_item "true" "CONTRIBUTING.md exists" || check_item "warn" "CONTRIBUTING.md recommended"
[ -f "DEPLOYMENT.md" ] && check_item "true" "DEPLOYMENT.md exists" || check_item "warn" "DEPLOYMENT.md recommended"
[ -f "vercel.json" ] && check_item "true" "vercel.json exists" || check_item "warn" "vercel.json recommended for Vercel"
[ -d ".github/workflows" ] && check_item "true" ".github/workflows exists" || check_item "warn" ".github/workflows optional"
[ -f "package.json" ] && [ -f "server/package.json" ] && [ -f "client/package.json" ] && check_item "true" "package.json files complete" || check_item "false" "Missing package.json files"
command -v node >/dev/null && check_item "true" "Node.js installed" || check_item "false" "Node.js required"

echo ""
echo "===================================="
echo "Status: $pass / $total checks passed"
echo ""

if [ "$pass" -ge "$((total - 2))" ]; then
  echo -e "${GREEN}✅ Project is GitHub & Vercel deployment ready!${NC}"
  echo ""
  echo "📋 Next Steps:"
  echo "  1. Read: PUSH_AND_DEPLOY.md"
  echo "  2. Git push: git push origin main"
  echo "  3. Vercel: Connect repo and set env vars"
  echo ""
else
  echo -e "${YELLOW}⚠ Review items above before deploying${NC}"
  echo ""
  echo "📖 See PUSH_AND_DEPLOY.md for detailed guide"
  echo ""
fi
