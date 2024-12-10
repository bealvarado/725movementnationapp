// paymentRoutes.js
const express = require('express');
const router = express.Router();
const { processPayment } = require('../controllers/paymentController');

// Route to process payment
router.post('/process', processPayment);

module.exports = router;

