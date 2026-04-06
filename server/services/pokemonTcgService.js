const axios = require('axios');

const POKEMON_TCG_BASE_URL = 'https://api.pokemontcg.io/v2';

function getHeaders() {
  const headers = {};
  if (process.env.POKEMON_TCG_API_KEY) {
    headers['X-Api-Key'] = process.env.POKEMON_TCG_API_KEY;
  }
  return headers;
}

/**
 * Search for cards by name using the Pokémon TCG API.
 * Returns the first matching card.
 */
async function fetchCardByName(name) {
  const response = await axios.get(`${POKEMON_TCG_BASE_URL}/cards`, {
    headers: getHeaders(),
    params: { q: `name:"${name}"`, pageSize: 1 },
  });
  const cards = response.data.data || [];
  return cards[0] || null;
}

/**
 * Fetch a specific card by its Pokémon TCG API ID.
 * Card IDs follow the format: <setId>-<number> (e.g. "base1-4", "swsh1-25").
 * Only alphanumeric characters and hyphens are allowed.
 */
async function fetchCardById(id) {
  if (!id || !/^[\w-]+$/.test(id)) {
    throw new Error('Invalid card ID.');
  }
  const response = await axios.get(`${POKEMON_TCG_BASE_URL}/cards/${encodeURIComponent(id)}`, {
    headers: getHeaders(),
  });
  return response.data.data || null;
}

module.exports = { fetchCardByName, fetchCardById };
