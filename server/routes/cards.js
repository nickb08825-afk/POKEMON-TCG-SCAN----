const express = require('express');
const { getCard } = require('../controllers/cardController');

const router = express.Router();

// GET /api/cards/:id – get details for a specific card by Pokémon TCG API ID
router.get('/:id', getCard);

module.exports = router;
