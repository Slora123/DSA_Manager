# Contributing to DSA Tracker

Thank you for your interest in contributing to DSA Tracker! This document provides guidelines and instructions for contributing.

## 🎯 Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on the work, not the person
- Help others succeed

## 🚀 Getting Started

### Prerequisites
- Node.js v18+
- npm 9+
- Git
- PostgreSQL database access (Neon or Vercel Postgres recommended)

### Local Development Setup

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/DSA_Management.git
cd DSA_Management

# 2. Install dependencies
npm install --workspaces

# 3. Setup environment variables
cp .env.example .env
# Edit .env with your database credentials and JWT secret

# 4. Database setup
# Run schema.sql on your PostgreSQL database
psql -U postgres -d your_db_name -f server/data/schema.sql

# 5. Start development servers
# Terminal 1: Backend
cd server && npm run dev

# Terminal 2: Frontend
cd client && npm run dev
```

## 📝 Contribution Types

### Bug Reports
1. Check if the bug already exists in Issues
2. Provide a clear title and description
3. Include steps to reproduce
4. Add screenshots/logs if applicable
5. Specify your environment (OS, Node version, etc.)

### Feature Requests
1. Describe the feature and use case
2. Explain expected behavior
3. Suggest implementation approach if possible
4. Consider backward compatibility

### Code Contributions
1. **Fork** the repository
2. **Create a feature branch**: `git checkout -b feature/your-feature-name`
3. **Make your changes** following the style guide
4. **Test thoroughly**
5. **Commit with clear messages**:
   ```bash
   git commit -m "feat: add new feature description"
   git commit -m "fix: resolve issue with X"
   git commit -m "docs: update README"
   ```
6. **Push** to your fork: `git push origin feature/your-feature-name`
7. **Open a Pull Request** with a clear description

## 📋 Commit Message Convention

Use conventional commit messages:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation updates
- `style:` - Code style changes (formatting, missing semicolons, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Build, dependencies, or tooling changes

Example:
```
feat: add revision calendar view
fix: resolve auth token expiration issue
docs: update deployment guide
```

## 🎨 Code Style

### JavaScript/React
- Use ESLint configuration provided in the project
- Follow existing code patterns
- Use meaningful variable and function names
- Add comments for complex logic

```bash
# Check linting
cd client && npm run lint

# Fix linting issues
cd client && npm run lint -- --fix
```

### Naming Conventions
- Components: PascalCase (e.g., `LoginForm.jsx`)
- Functions/variables: camelCase (e.g., `getUserData()`)
- Constants: UPPER_SNAKE_CASE (e.g., `MAX_RETRIES`)
- CSS classes: kebab-case (e.g., `.user-profile`)

### File Organization
```
client/src/
├── components/     # Reusable UI components
├── pages/         # Page-level components
├── context/       # React Context (state management)
├── utils/         # Utility functions and helpers
├── assets/        # Images, fonts, etc.
└── index.css      # Global styles

server/
├── routes/        # API route handlers
├── middleware/    # Express middleware
├── utils/         # Server utilities
└── data/          # Data files and schemas
```

## 🧪 Testing

- Test locally before submitting PR
- Test in both development and production modes
- Verify responsive design on mobile devices
- Test authentication flows
- Check database operations

## 📚 Documentation

- Update README.md for major features
- Add comments for complex code sections
- Document API endpoints (method, path, params, response)
- Update SETUP.md if changing development setup

## 🔄 Pull Request Process

1. **Before submitting:**
   - Update documentation
   - Run `npm run lint`
   - Test thoroughly
   - Ensure no console errors

2. **PR Template:**
   ```markdown
   ## Description
   Brief description of changes

   ## Related Issues
   Closes #123

   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Breaking change
   - [ ] Documentation update

   ## Testing
   - [ ] Tested on desktop
   - [ ] Tested on mobile
   - [ ] All existing tests pass

   ## Screenshots/Videos (if applicable)
   ```

3. **Review Process:**
   - Code review by maintainers
   - Address feedback constructively
   - Make requested changes
   - Maintainers merge when approved

## 🐛 Debugging Tips

### Server Debugging
```bash
# Run with verbose logging
NODE_DEBUG=* npm start

# Check database connection
node server/test-db.js

# Run database tests
node server/test.js
```

### Client Debugging
- Use React Developer Tools browser extension
- Check browser DevTools Console and Network tabs
- Use `console.log()` for debugging
- Use VS Code debugger with appropriate configuration

## 🔒 Security Guidelines

- ❌ Never commit `.env` files or secrets
- ❌ Never hardcode API keys or passwords
- ✅ Use environment variables for sensitive data
- ✅ Validate all user inputs
- ✅ Sanitize database queries
- ✅ Use HTTPS in production
- ✅ Keep dependencies updated

## 📦 Dependency Management

- Only add necessary dependencies
- Use `npm audit` to check for vulnerabilities
- Update `package.json` version following semver
- Document why new dependencies are needed

```bash
# Check for security vulnerabilities
npm audit

# Update dependencies safely
npm update
```

## 🚢 Release Process

Releases follow semantic versioning (MAJOR.MINOR.PATCH):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes

Maintainers will create releases and tag commits.

## 💬 Getting Help

- **Issues**: For bugs and feature requests
- **Discussions**: For questions and ideas
- **Pull Requests**: For code contributions
- **Email**: Contact maintainers directly

## 📖 Additional Resources

- [Setup Guide](SETUP.md)
- [Deployment Guide](DEPLOYMENT.md)
- [Tech Stack Documentation](README.md#-tech-stack)

---

**Thank you for contributing to DSA Tracker! 🙏**

Every contribution, big or small, helps improve the project and the DSA learning experience for everyone.
