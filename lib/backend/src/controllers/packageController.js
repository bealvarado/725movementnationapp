const { db } = require('../../firebase');

const validPaymentMethods = ['Apple Pay', 'Credit Card', 'Afterpay', 'Credit Balance'];

const validPackages = {
  "5x": { cost: 99.00, expiry: 14 },  // 2-week expiry
  "10x": { cost: 200.00, expiry: 90 }, // 3-month expiry
  "20x": { cost: 380.00, expiry: 90 }  // 3-month expiry
};

const promoDetails = {
  cost: 35.00,
};

// Generate a unique receipt ID
const generateReceiptId = () => `receipt_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;

// Purchase a package
async function purchasePackage(req, res) {
  try {
    const { uid, packageType, paymentMethod, secondaryPaymentMethod } = req.body;

    // Validate required fields
    if (!uid || !packageType || !paymentMethod) {
      return res.status(400).json({ message: 'Missing required fields.' });
    }

    // Validate package type
    if (!validPackages[packageType]) {
      return res.status(400).json({ message: 'Invalid package type.' });
    }

    // Validate payment method
    if (!validPaymentMethods.includes(paymentMethod)) {
      return res.status(400).json({ message: 'Invalid payment method.' });
    }

    const packageDetails = validPackages[packageType];

    // Fetch the user's document
    const userRef = db.collection('users').doc(uid);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      return res.status(404).json({ message: 'User not found.' });
    }

    const userData = userDoc.data();
    const currentPackage = userData.package || null;

    if (currentPackage) {
      const currentDate = new Date();
      const expiryDate = new Date(currentPackage.expiry);

      if (currentDate < expiryDate || currentPackage.remainingClasses > 0) {
        return res.status(400).json({
          message: 'You cannot purchase a new package until the current package is expired or all classes are used up.',
        });
      }
    }

    // Handle payment
    let remainingBalance = packageDetails.cost;

    if (paymentMethod === 'Credit Balance') {
      const userCreditBalance = userData.creditBalance || 0;

      if (userCreditBalance >= remainingBalance) {
        await userRef.update({
          creditBalance: userCreditBalance - remainingBalance,
        });
        remainingBalance = 0;
      } else {
        remainingBalance -= userCreditBalance;
        await userRef.update({ creditBalance: 0 });
      }

      if (remainingBalance > 0) {
        if (!secondaryPaymentMethod || !validPaymentMethods.includes(secondaryPaymentMethod)) {
          return res.status(400).json({ message: 'Secondary payment method required for split payment.' });
        }
      }
    }

    const receiptId = generateReceiptId();
    console.log(`Processing payment for package ${packageType} using ${paymentMethod}, receipt ID: ${receiptId}`);

    // Set the new package for the user
    const currentDate = new Date();
    const expiryDate = new Date(currentDate);
    expiryDate.setDate(expiryDate.getDate() + packageDetails.expiry);

    await userRef.update({
      package: {
        type: packageType,
        remainingClasses: parseInt(packageType), // Extract classes from package type
        expiry: expiryDate,
      },
    });

    res.status(200).json({
      message: 'Package purchased successfully.',
      package: packageType,
      expiryDate: expiryDate.toISOString(),
      receiptId,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to purchase package.' });
  }
}

// Purchase the promo
async function purchasePromo(req, res) {
  try {
    const { uid, paymentMethod, secondaryPaymentMethod } = req.body;

    if (!uid || !paymentMethod) {
      return res.status(400).json({ message: 'Missing required fields.' });
    }

    if (!validPaymentMethods.includes(paymentMethod)) {
      return res.status(400).json({ message: 'Invalid payment method.' });
    }

    const userRef = db.collection('users').doc(uid);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      return res.status(404).json({ message: 'User not found.' });
    }

    const userData = userDoc.data();

    let remainingBalance = promoDetails.cost;

    if (paymentMethod === 'Credit Balance') {
      const userCreditBalance = userData.creditBalance || 0;

      if (userCreditBalance >= remainingBalance) {
        await userRef.update({
          creditBalance: userCreditBalance - remainingBalance,
        });
        remainingBalance = 0;
      } else {
        remainingBalance -= userCreditBalance;
        await userRef.update({ creditBalance: 0 });
      }

      if (remainingBalance > 0) {
        if (!secondaryPaymentMethod || !validPaymentMethods.includes(secondaryPaymentMethod)) {
          return res.status(400).json({ message: 'Secondary payment method required for split payment.' });
        }
      }
    }

    const receiptId = generateReceiptId();
    console.log(`Processing promo purchase using ${paymentMethod}, receipt ID: ${receiptId}`);

    await userRef.update({
      promo: true,
    });

    res.status(200).json({
      message: 'Promo purchased successfully.',
      receiptId,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to purchase promo.' });
  }
}

module.exports = { purchasePackage, purchasePromo };
