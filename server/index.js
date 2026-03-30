const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();

// Debug middleware - log all requests
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
  next();
});

// Middleware
app.use(cors({
  origin: process.env.CORS_ORIGIN || '*',
  credentials: true
}));
app.use(express.json());

// Health check route
app.get('/api', (req, res) => {
  res.json({ 
    status: 'ok',
    message: 'DSA Tracker Pro API is running',
    timestamp: new Date().toISOString()
  });
});

// Import routes
let authRoutes, problemRoutes, leetcodeRoutes, neetcodeRoutes;
try {
  authRoutes = require('./routes/auth');
  console.log('✅ Auth routes loaded');
  problemRoutes = require('./routes/problems');
  console.log('✅ Problem routes loaded');
  leetcodeRoutes = require('./routes/leetcode');
  console.log('✅ LeetCode routes loaded');
  neetcodeRoutes = require('./routes/neetcode');
  console.log('✅ NeetCode routes loaded');
} catch (err) {
  console.error('❌ Error loading routes:', err.message);
}

app.use('/api/auth', authRoutes);
app.use('/api/problems', problemRoutes);
app.use('/api/leetcode', leetcodeRoutes);
app.use('/api/neetcode', neetcodeRoutes);

// 404 handler
app.use((req, res) => {
  console.warn(`[404] ${req.method} ${req.path} - Route not found`);
  res.status(404).json({ 
    error: 'Not Found',
    message: `Route ${req.method} ${req.path} not found`,
    path: req.path
  });
});

// Global Error Handler
app.use((err, req, res, next) => {
  console.error(`❌ [ERROR] ${req.method} ${req.path}:`, err.message);
  console.error('Stack:', err.stack);
  res.status(500).json({ 
    error: 'Internal Server Error', 
    message: err.message,
    timestamp: new Date().toISOString()
  });
});

module.exports = app;
