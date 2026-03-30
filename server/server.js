const app = require('./index');

const PORT = process.env.PORT || 5001;

const server = app.listen(PORT, () => {
  console.log(`
╔════════════════════════════════════════════════╗
║  🚀 DSA Tracker Pro Server Started             ║
║  📍 http://localhost:${PORT}                       ║
║  🔌 Ready to receive requests                  ║
╚════════════════════════════════════════════════╝
  `);
});

// Handle server errors
server.on('error', (err) => {
  if (err.code === 'EADDRINUSE') {
    console.error(`❌ Port ${PORT} is already in use. Try killing the process or using a different port.`);
  } else {
    console.error('❌ Server error:', err);
  }
  process.exit(1);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('\n📍 SIGTERM signal received: closing HTTP server');
  server.close(() => {
    console.log('✅ HTTP server closed');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('\n📍 SIGINT signal received: closing HTTP server');
  server.close(() => {
    console.log('✅ HTTP server closed');
    process.exit(0);
  });
});

