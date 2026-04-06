require('dotenv').config();
const express = require('express');
const cors = require('cors');

const scanRoutes = require('./routes/scan');
const collectionRoutes = require('./routes/collection');
const cardRoutes = require('./routes/cards');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Routes
app.use('/api/scan', scanRoutes);
app.use('/api/collection', collectionRoutes);
app.use('/api/cards', cardRoutes);

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});

module.exports = app;
