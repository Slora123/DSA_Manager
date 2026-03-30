<p align="center">
  <img src="client/public/favicon.svg" width="120" alt="DSA Tracker Logo" />
</p>

<h1 align="center">DSA Tracker</h1>

<p align="center">
  <b>Master Data Structures & Algorithms with Precision.</b><br />
  A premium, high-performance web application designed for focused learning, smart revision scheduling, and comprehensive problem tracking.
</p>

<p align="center">
  <a href="https://github.com/yourusername/DSA_Management/blob/main/LICENSE">
    <img alt="License" src="https://img.shields.io/github/license/yourusername/DSA_Management?color=blue&style=flat-square">
  </a>
  <a href="https://github.com/yourusername/DSA_Management/releases">
    <img alt="Release" src="https://img.shields.io/github/v/release/yourusername/DSA_Management?style=flat-square">
  </a>
  <a href="https://nodejs.org/">
    <img alt="Node.js" src="https://img.shields.io/badge/node-18+-green?style=flat-square">
  </a>
  <a href="https://react.dev/">
    <img alt="React" src="https://img.shields.io/badge/react-19-blue?style=flat-square">
  </a>
  <a href="https://github.com/yourusername/DSA_Management/issues">
    <img alt="Issues" src="https://img.shields.io/github/issues/yourusername/DSA_Management?style=flat-square">
  </a>
  <a href="https://github.com/yourusername/DSA_Management/pulls">
    <img alt="PRs Welcome" src="https://img.shields.io/badge/PRs-welcome-brightgreen?style=flat-square">
  </a>
</p>

---

## 🎯 Quick Links

- [📖 Setup Guide](SETUP.md) - Get started locally
- [🚀 Deployment Guide](DEPLOYMENT.md) - Deploy to production
- [🤝 Contributing Guide](CONTRIBUTING.md) - How to contribute
- [📋 Code of Conduct](CODE_OF_CONDUCT.md) - Community guidelines
- [🐛 Report a Bug](https://github.com/yourusername/DSA_Management/issues/new?template=bug_report.md)
- [✨ Request a Feature](https://github.com/yourusername/DSA_Management/issues/new?template=feature_request.md)

---

### 📅 Intelligent Revision Ecosystem
- **Weekend-Optimized Scheduling**: Automatically aligns your revision workload with Saturdays and Sundays, keeping your weekdays clear for new learning.
- **Persistent Overdue Tracking**: Tasks not finished on the weekend carry over to weekdays automatically until they are "solved", ensuring zero knowledge rot.
- **Smart Load Balancing**: Intelligently distributes tasks between Saturday and Sunday to maintain a perfectly balanced workload.
- **Auto-Skip Logic**: Completing a revision automatically moves the next session to a future weekend cycle, preventing same-weekend repeats.

### ⏱️ Advanced Problem Logging
- **Multi-Day Solve Tracking**: Record your struggle and progress accurately by logging the same problem across multiple days.
- **Cumulative Solve History**: View every attempt at a glance with precise timestamps and duration metrics.
- **Dynamic Status Updates**: Problems move from "Solved" to "Revised" seamlessly within your personalized schedule.

### 🔍 Discovery & Resource Integration
- **Cheatsheet Integration**: Native support for the **NeetCode 150** problem set with instant search and category filtering.
- **AI-Powered Concept Mapping**: Explore related problems using an intelligent concept map that understands the underlying algorithms.
- **Real-time Search**: Blaze through your repository with high-performance filtering by name, tag, or difficulty.

### 📊 Focused UX/UI
- **Live Performance Dashboard**: Instantly view your current streak, pending revisions, and daily focus tasks.
- **Premium Aesthetics**: A stunning glassmorphism interface featuring smooth animations, dark mode, and a responsive layout.
- **One-Click Revisions**: Mark tasks as done directly from the calendar modal without leaving your workflow.

---

## 🛠️ Tech Stack

- **Core**: React 18, Node.js (Express), Vite.
- **Styling**: Tailwind CSS, Lucide Icons.
- **Architecture**: Scalable PostgreSQL persistence layer hosted on Vercel/Neon.
- **Optimization**: Production-ready serverless functions and static file serving.

---

## 🏗️ Quick Start

### Prerequisites
- Node.js (v18+)
- npm

### Installation
1. **Clone & Install**:
   ```bash
   cd server && npm install
   cd ../client && npm install
   ```
2. **Launch Dev Environment**:
   ```bash
   # Terminal 1 (API)
   cd server && npm run dev
   
   # Terminal 2 (UI)
   cd client && npm run dev
   ```

---

## 🌍 Deployment

### Quick Deploy to Vercel

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2Fyoursername%2FDSA_Management&env=POSTGRES_URL,JWT_SECRET&envDescription=Database%20connection%20and%20JWT%20secret)

### Prerequisites
- **Database**: PostgreSQL (Neon, Vercel Postgres, or AWS RDS)
- **Secrets**: JWT_SECRET

### Manual Deployment Steps

1. **Connect to Vercel**:
   ```bash
   npm install -g vercel
   vercel link
   ```

2. **Set Environment Variables**:
   ```bash
   vercel env add POSTGRES_URL
   vercel env add JWT_SECRET
   vercel env add VITE_API_URL
   ```

3. **Deploy**:
   ```bash
   vercel --prod
   ```

4. **Initialize Database**:
   Run `server/data/schema.sql` on your PostgreSQL database

For complete deployment guide, see [DEPLOYMENT.md](DEPLOYMENT.md).

---

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'feat: add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

---

## 📋 Critical Deployment Requirement
This app is designed for **Vercel** with a **PostgreSQL** database (e.g., Vercel Postgres or Neon). You **MUST** run the `server/data/schema.sql` on your database before deploying to initialize the tables.

For a full walkthrough, see the [Deployment Guide](DEPLOYMENT.md).

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Contributors

Thank you to all our contributors! We welcome new contributions. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📞 Support

- 📖 [Documentation](SETUP.md)
- 🐛 [Report Issues](https://github.com/yourusername/DSA_Management/issues)
- 💬 [Discussions](https://github.com/yourusername/DSA_Management/discussions)

## 🔗 Resources

- [LeetCode](https://leetcode.com/) - Problem platform
- [NeetCode](https://neetcode.io/) - Study guide
- [Neon](https://neon.tech/) - PostgreSQL hosting
- [Vercel](https://vercel.com/) - Hosting & deployment

---

<div align="center">

Made with ❤️ for the DSA learning community

[⬆ Back to Top](#dsa-tracker)

</div>
