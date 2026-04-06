const { identifyCard } = require('../services/aiService');
const { fetchCardByName } = require('../services/pokemonTcgService');

/**
 * POST /api/scan
 * Accepts a card image upload, identifies it with AI, and returns card details.
 */
async function scanCard(req, res) {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No image file provided.' });
    }

    // Step 1: Use AI to identify the card name from the image
    const cardName = await identifyCard(req.file.buffer);

    // Step 2: Look up the card in the Pokémon TCG API
    const cardData = await fetchCardByName(cardName);

    return res.json({ cardName, cardData });
  } catch (err) {
    console.error('Scan error:', err);
    return res.status(500).json({ error: 'Failed to scan card.' });
  }
}

module.exports = { scanCard };
