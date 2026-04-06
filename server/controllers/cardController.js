const { fetchCardById } = require('../services/pokemonTcgService');

/**
 * GET /api/cards/:id
 * Returns full card details from the Pokémon TCG API.
 */
async function getCard(req, res) {
  try {
    const card = await fetchCardById(req.params.id);
    if (!card) {
      return res.status(404).json({ error: 'Card not found.' });
    }
    return res.json(card);
  } catch (err) {
    console.error('Card lookup error:', err);
    return res.status(500).json({ error: 'Failed to fetch card.' });
  }
}

module.exports = { getCard };
