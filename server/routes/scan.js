const express = require('express');
const multer = require('multer');
const { scanCard } = require('../controllers/scanController');

const router = express.Router();
const upload = multer({ storage: multer.memoryStorage() });

// POST /api/scan – accepts a card image and returns identified card data
router.post('/', upload.single('image'), scanCard);

module.exports = router;
