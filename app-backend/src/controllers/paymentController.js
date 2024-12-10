// paymentController.js
const { db } = require('../utils/firebaseConfig');

async function processPayment(req, res) {
  try {
    const { bookingId, paymentMethod, amount } = req.body;

    // Validate required fields
    if (!bookingId || !paymentMethod || !amount) {
      return res.status(400).json({ message: 'Missing required fields.' });
    }

    // Simulate payment processing logic (Replace this with real payment gateway integration)
    console.log(`Processing payment of $${amount} for booking ${bookingId} using ${paymentMethod}`);

    // Assuming payment is successful, simulate a payment result
    const paymentResult = {
      transactionId: `txn_${Date.now()}`,
      paymentMethod,
      timestamp: new Date(),
    };

    // Fetch the booking from Firestore and update its status
    const bookingRef = db.collection('bookings').doc(bookingId);
    const bookingDoc = await bookingRef.get();

    if (!bookingDoc.exists) {
      return res.status(404).json({ message: 'Booking not found' });
    }

    // Update booking status and payment info in Firestore
    await bookingRef.update({
      status: 'confirmed',  // Update status to 'confirmed' after payment
      paymentMethod,
      transactionId: paymentResult.transactionId,
      paymentTimestamp: paymentResult.timestamp,
    });

    // Return the payment result in the response
    res.status(200).json({
      message: 'Payment processed successfully',
      transactionId: paymentResult.transactionId,
      status: 'confirmed',
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Payment failed. Try again." });
  }
}

module.exports = { processPayment };
