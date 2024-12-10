// bookingRoutes.js
const express = require('express');
const router = express.Router();
const { createBooking, getBooking, getPaymentMethods } = require('../controllers/bookingController');
const { processPayment } = require('../controllers/paymentController');

// Route to create a booking
router.post('/create', createBooking);

// Route to get booking details
router.get('/:bookingId', getBooking);

// Route to get available payment methods
router.get('/payment-methods', getPaymentMethods);

// Route to process payment for a booking
router.post('/payment', processPayment);

module.exports = router;

