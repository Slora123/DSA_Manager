const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const crypto = require('crypto'); // Built-in Node.js module
const { query } = require('../utils/db');

// Signup
router.post('/signup', async (req, res) => {
  const startTime = Date.now();
  try {
    const { username, email, password } = req.body;
    console.log(`📝 [SIGNUP] Attempt from ${email}`);
    
    if (!username || !email || !password) {
      console.warn(`⚠️  [SIGNUP] Missing fields for ${email}`);
      return res.status(400).json({ message: "Please enter all fields" });
    }

    console.log(`🔍 [SIGNUP] Checking if user exists: ${email}`);
    const { rows: existingUsers } = await query('SELECT * FROM users WHERE email = $1', [email]);
    if (existingUsers.length > 0) {
      console.warn(`⚠️  [SIGNUP] User already exists: ${email}`);
      return res.status(400).json({ message: "User already exists" });
    }

    // Use bcryptjs for hashing
    console.log(`🔐 [SIGNUP] Hashing password for ${email}`);
    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);
    
    // Use native Node.js crypto for UUID
    const id = crypto.randomUUID();

    console.log(`💾 [SIGNUP] Creating user in database: ${id} (${email})`);
    const insertQuery = `
      INSERT INTO users (id, username, email, password)
      VALUES ($1, $2, $3, $4)
      RETURNING id, username, email
    `;
    const { rows } = await query(insertQuery, [id, username, email, passwordHash]);
    const newUser = rows[0];

    console.log(`🔑 [SIGNUP] Generating JWT token for ${newUser.id}`);
    const token = jwt.sign({ id: newUser.id }, process.env.JWT_SECRET || 'secret');
    
    console.log(`✅ [SIGNUP] Success for ${email} (${Date.now() - startTime}ms)`);
    res.json({
      token,
      user: newUser
    });

  } catch (err) {
    console.error(`❌ [SIGNUP] Error (${Date.now() - startTime}ms):`, {
      message: err.message,
      code: err.code,
      detail: err.detail || 'No detail'
    });
    res.status(500).json({ 
      error: "Signup failed", 
      message: err.message,
      code: err.code,
      detail: err.detail
    });
  }
});

// Login
router.post('/login', async (req, res) => {
  const startTime = Date.now();
  try {
    const { email, password } = req.body;
    console.log(`🔐 [LOGIN] Attempt from ${email}`);
    
    if (!email || !password) {
      console.warn(`⚠️  [LOGIN] Missing fields for ${email}`);
      return res.status(400).json({ message: "Please enter all fields" });
    }

    console.log(`🔍 [LOGIN] Looking up user: ${email}`);
    const { rows } = await query('SELECT * FROM users WHERE email = $1', [email]);
    const user = rows[0];
    
    if (!user) {
      console.warn(`⚠️  [LOGIN] User not found: ${email}`);
      return res.status(400).json({ message: "Invalid credentials" });
    }

    console.log(`✓ [LOGIN] User found, verifying password for ${email}`);
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      console.warn(`⚠️  [LOGIN] Wrong password for ${email}`);
      return res.status(400).json({ message: "Invalid credentials" });
    }

    console.log(`🔑 [LOGIN] Generating token for ${user.id}`);
    const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET || 'secret');
    
    console.log(`✅ [LOGIN] Success for ${email} (${Date.now() - startTime}ms)`);
    res.json({
      token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email
      }
    });

  } catch (err) {
    console.error(`❌ [LOGIN] Error (${Date.now() - startTime}ms):`, {
      message: err.message,
      code: err.code,
      detail: err.detail || 'No detail'
    });
    res.status(500).json({ 
      error: "Login failed", 
      message: err.message,
      code: err.code,
      detail: err.detail
    });
  }
});

module.exports = router;
