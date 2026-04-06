// In-memory store for development.
// Replace with a real database (e.g., SQLite or PostgreSQL) for production.
let collection = [];
let nextId = 1;

/**
 * GET /api/collection
 */
function getCollection(req, res) {
  return res.json(collection);
}

/**
 * POST /api/collection
 * Body: { cardId, cardName, imageUrl }
 */
function addToCollection(req, res) {
  const { cardId, cardName, imageUrl } = req.body;
  if (!cardId || !cardName) {
    return res.status(400).json({ error: 'cardId and cardName are required.' });
  }
  const cardEntry = { id: nextId++, cardId, cardName, imageUrl, addedAt: new Date().toISOString() };
  collection.push(cardEntry);
  return res.status(201).json(cardEntry);
}

/**
 * DELETE /api/collection/:id
 */
function removeFromCollection(req, res) {
  const id = parseInt(req.params.id, 10);
  const index = collection.findIndex((c) => c.id === id);
  if (index === -1) {
    return res.status(404).json({ error: 'Entry not found.' });
  }
  collection.splice(index, 1);
  return res.status(204).send();
}

module.exports = { getCollection, addToCollection, removeFromCollection };
