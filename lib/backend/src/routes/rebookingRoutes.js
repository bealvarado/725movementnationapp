const express = require('express');
const router = express.Router();
const { rebookDanceClass, rebookStudioHire } = require('../controllers/rebookingController');

// Route to rebook a dance class
router.put('/dance-class', rebookDanceClass);

// Route to rebook a studio hire
router.put('/studio-hire', rebookStudioHire);

module.exports = router;
