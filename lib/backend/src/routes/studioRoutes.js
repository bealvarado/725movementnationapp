const express = require('express');
const router = express.Router();
const { hireStudio, getStudioHire, processStudioPayment, cancelStudioHire } = require('../controllers/studioController');

// Route to hire a studio
router.post('/hire', hireStudio);

// Route to get studio hire details
router.get('/hire', getStudioHire);

// Route to process payment for studio hire
router.post('/hire/payment', processStudioPayment); // Updated to include "hire"

// Route to cancel a studio hire
router.delete('/hire/cancel', cancelStudioHire); // Updated to include "hire"

module.exports = router;
