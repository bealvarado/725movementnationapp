const express = require('express');
const router = express.Router();
const { purchasePackage, purchasePromo } = require('../controllers/packageController');

// Route to purchase a package
router.post('/purchase', purchasePackage);

// Route to purchase the promo
router.post('/promo', purchasePromo);

module.exports = router;
