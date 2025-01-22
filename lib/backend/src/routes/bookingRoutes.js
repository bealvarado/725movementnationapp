const express = require('express');
const router = express.Router();
const { createBooking, getBooking, processPayment, cancelBooking } = require('../controllers/bookingController');

// Route to create a booking
router.post('/create', createBooking);

// Route to get booking details
router.get('/', getBooking);

// Route to process payment for a booking
router.post('/payment', processPayment);

// Route to cancel a booking
router.delete('/cancel', cancelBooking);

module.exports = router;
