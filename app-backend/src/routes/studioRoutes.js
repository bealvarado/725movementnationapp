const express = require('express');
const router = express.Router();
const { hireStudio, getStudioHire, processStudioPayment } = require('../controllers/studioController');

// Route to hire a studio
router.post('/hire', hireStudio);

// Route to get a specific studio hire request
router.get('/:hireId', getStudioHire);

// Route to process payment for a studio hire
router.post('/hire/payment', processStudioPayment);

module.exports = router;
