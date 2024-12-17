const { db } = require('../utils/firebaseConfig');

const validStudios = ['Parramatta', 'Hurstville']; // Valid studio locations

// Create a studio hire request
async function hireStudio(req, res) {
  try {
    const { userId, studioLocation, date, time, duration, purpose } = req.body;

    // Validate studio location
    if (!validStudios.includes(studioLocation)) {
      return res.status(400).json({ message: `Invalid studio location.` });
    }

    // Add a new studio hire request to Firestore
    const hireRef = await db.collection('studioHires').add({
      userId,
      studioLocation,
      date,
      time,
      duration,
      purpose,
      status: 'pending', // Default status is pending until confirmed
      createdAt: new Date(),
    });

    res.status(200).json({
      message: 'Studio hire request created successfully',
      hireId: hireRef.id,
    });
  } catch (error) {
    console.error('Error creating studio hire request:', error);
    res.status(500).json({ message: 'Failed to create studio hire request' });
  }
}

// Fetch a studio hire request by ID
async function getStudioHire(req, res) {
  try {
    const hireId = req.params.hireId;

    const hireDoc = await db.collection('studioHires').doc(hireId).get();

    if (!hireDoc.exists) {
      return res.status(404).json({ message: 'Studio hire request not found' });
    }

    res.status(200).json(hireDoc.data());
  } catch (error) {
    console.error('Error fetching studio hire:', error);
    res.status(500).json({ message: 'Failed to fetch studio hire request' });
  }
}

// Process payment for studio hire
async function processStudioPayment(req, res) {
  try {
    const { hireId, paymentMethod, amount } = req.body;

    // Validate payment method
    const validMethods = ['Apple Pay', 'Credit Card', 'Afterpay', 'Credit Balance'];
    if (!validMethods.includes(paymentMethod)) {
      return res.status(400).json({ message: 'Invalid payment method' });
    }

    // Simulate payment processing (replace this with a real payment gateway integration)
    console.log(`Processing payment of $${amount} for hire ID ${hireId} using ${paymentMethod}`);
    const paymentResult = {
      transactionId: `txn_${Date.now()}`,
      paymentMethod,
      timestamp: new Date(),
    };

    // Update the hire request with payment details
    const hireRef = db.collection('studioHires').doc(hireId);
    const hireDoc = await hireRef.get();

    if (!hireDoc.exists) {
      return res.status(404).json({ message: 'Studio hire request not found' });
    }

    await hireRef.update({
      status: 'confirmed',
      paymentMethod,
      transactionId: paymentResult.transactionId,
      paymentTimestamp: paymentResult.timestamp,
    });

    res.status(200).json({
      message: 'Payment processed successfully',
      transactionId: paymentResult.transactionId,
      status: 'confirmed',
    });
  } catch (error) {
    console.error('Error processing payment:', error);
    res.status(500).json({ message: 'Failed to process payment' });
  }
}

module.exports = { hireStudio, getStudioHire, processStudioPayment };
