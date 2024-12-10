const { db } = require('../utils/firebaseConfig');

const validLocations = ['Parramatta', 'Hurstville']; // Valid locations for booking

async function createBooking(req, res) {
  try {
    const { userId, className, location, date, time } = req.body;

    // Validate the location
    if (!validLocations.includes(location)) {
      return res.status(400).json({ message: `Invalid location.` });
    }

    // Add a new booking to Firestore
    const bookingRef = await db.collection('bookings').add({
      userId,
      className,
      location,
      date,
      time,
      createdAt: new Date(),
      status: 'pending', // Default status is pending until payment is processed
    });

    res.status(200).json({ message: 'Booking created', bookingId: bookingRef.id });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to create booking' });
  }
}

async function getBooking(req, res) {
  try {
    const bookingId = req.params.bookingId;
    const bookingDoc = await db.collection('bookings').doc(bookingId).get();

    if (!bookingDoc.exists) {
      return res.status(404).json({ message: 'Booking not found' });
    }

    res.status(200).json(bookingDoc.data());
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to retrieve booking' });
  }
}

// Fetch available payment methods
async function getPaymentMethods(req, res) {
  const paymentMethods = [
    { name: 'Apple Pay', image: 'apple_pay.png' },
    { name: 'Credit Card', image: 'credit_card.png' },
    { name: 'Afterpay', image: 'afterpay.png' },
    { name: 'Credit Balance', image: 'credit_balance.png', balance: 22 },
  ];
  res.status(200).json(paymentMethods);
}

// Process payment and update booking status
async function processPayment(req, res) {
  try {
    const { bookingId, paymentMethod } = req.body;

    // Validate payment method (ensure it exists)
    const validMethods = ['Apple Pay', 'Credit Card', 'Afterpay', 'Credit Balance'];
    if (!validMethods.includes(paymentMethod)) {
      return res.status(400).json({ message: 'Invalid payment method' });
    }

    // Simulate payment processing logic (You can integrate a real payment API here)
    const paymentResult = {
      transactionId: `txn_${Date.now()}`,
      paymentMethod,
      timestamp: new Date(),
    };

    // Update booking with payment details and status
    const bookingRef = db.collection('bookings').doc(bookingId);
    const bookingDoc = await bookingRef.get();

    if (!bookingDoc.exists) {
      return res.status(404).json({ message: 'Booking not found' });
    }

    // Update booking status and payment info
    await bookingRef.update({
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
    console.error(error);
    res.status(500).json({ message: 'Failed to process payment' });
  }
}

module.exports = { createBooking, getBooking, getPaymentMethods, processPayment };


