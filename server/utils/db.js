const { Pool } = require('pg');

// Vercel Postgres uses POSTGRES_URL
const pool = new Pool({
  connectionString: process.env.POSTGRES_URL || process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

// Log connection events
pool.on('connect', () => {
  console.log('✅ Database pool connected');
});

pool.on('error', (err) => {
  console.error('❌ Database pool error:', err.message);
});

async function query(text, params) {
  const startTime = Date.now();
  try {
    console.log(`📊 [DB] Query: ${text.substring(0, 50)}...${params ? ' [' + params.length + ' params]' : ''}`);
    const result = await pool.query(text, params);
    console.log(`✅ [DB] Query successful (${Date.now() - startTime}ms, ${result.rows.length} rows)`);
    return result;
  } catch (err) {
    console.error(`❌ [DB] Query failed (${Date.now() - startTime}ms):`, {
      text: text.substring(0, 100),
      message: err.message,
      code: err.code
    });
    throw err;
  }
}

module.exports = { query };
