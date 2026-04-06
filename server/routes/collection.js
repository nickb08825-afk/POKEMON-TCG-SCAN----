const express = require('express');
const {
  getCollection,
  addToCollection,
  removeFromCollection,
} = require('../controllers/collectionController');

const router = express.Router();

// GET  /api/collection        – list all saved cards
router.get('/', getCollection);

// POST /api/collection        – add a card to the collection
router.post('/', addToCollection);

// DELETE /api/collection/:id  – remove a card from the collection
router.delete('/:id', removeFromCollection);

module.exports = router;
