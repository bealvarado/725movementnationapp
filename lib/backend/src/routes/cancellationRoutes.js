const express = require('express');
const router = express.Router();
const { cancelBooking, cancelStudioHire } = require('../controllers/cancellationController');

// Route to cancel a booking
router.delete('/booking', cancelBooking);

// Route to cancel a studio hire
router.delete('/studio-hire', cancelStudioHire);

module.exports = router;
