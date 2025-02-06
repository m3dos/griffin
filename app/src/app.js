// app.js

const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Simple Route (Health Check)
app.get('/health', (req, res) => {
  res.json({ status: 'health check passed' });
});

// Example API Route
app.get('/api', (req, res) => {
  res.json({ message: 'Hello from Express!' });
});

// Start the Server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});