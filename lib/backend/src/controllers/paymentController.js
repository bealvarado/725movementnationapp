const { db } = require('../../firebase');

async function processPayment(req, res) {
  try {
    const { bookingId, paymentMethod, secondaryPaymentMethod } = req.body;

    // Validate required fields
    if (!bookingId || !paymentMethod) {
      return res.status(400).json({ message: 'Missing required fields.' });
    }

    const validPaymentMethods = ['Apple Pay', 'Credit Card', 'Afterpay', 'Credit Balance'];
    if (!validPaymentMethods.includes(paymentMethod)) {
      return res.status(400).json({ message: 'Invalid payment method.' });
    }

    // Fetch the booking document from Firestore
    const bookingRef = db.collection('bookings').doc(bookingId);
    const bookingDoc = await bookingRef.get();

    if (!bookingDoc.exists) {
      return res.status(404).json({ message: 'Booking not found.' });
    }

    const bookingData = bookingDoc.data();

    // Check if payment has already been processed
    if (bookingData.status === 'confirmed') {
      return res.status(400).json({ message: 'This booking has already been paid.' });
    }

    const userRef = db.collection('users').doc(bookingData.uid);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      return res.status(404).json({ message: 'User not found.' });
    }

    const userData = userDoc.data();
    const bookingCost = bookingData.amount || 0; // Ensure booking amount is available
    let remainingBalance = bookingCost;

    // Handle Credit Balance
    if (paymentMethod === 'Credit Balance') {
      const userCreditBalance = userData.creditBalance || 0;

      if (userCreditBalance >= remainingBalance) {
        // Deduct full amount from credit balance
        await userRef.update({
          creditBalance: userCreditBalance - remainingBalance,
        });
        remainingBalance = 0;
      } else {
        // Deduct available balance and mark remaining
        remainingBalance -= userCreditBalance;
        await userRef.update({ creditBalance: 0 });
      }

      if (remainingBalance > 0) {
        // Ensure a secondary payment method is provided
        if (!secondaryPaymentMethod || !validPaymentMethods.includes(secondaryPaymentMethod)) {
          return res.status(400).json({ message: 'Secondary payment method required for split payment.' });
        }

        console.log(
          `Processing secondary payment of $${remainingBalance} for booking ${bookingId} using ${secondaryPaymentMethod}`
        );
      }
    } else {
      console.log(`Processing full payment of $${remainingBalance} using ${paymentMethod}`);
    }

    // Simulate payment processing
    const paymentResult = {
      transactionId: `txn_${Date.now()}`,
      paymentMethod: remainingBalance > 0 ? secondaryPaymentMethod || paymentMethod : paymentMethod,
      timestamp: new Date(),
    };

    // Update booking status and payment details
    await bookingRef.update({
      status: 'confirmed',
      paymentMethod: paymentResult.paymentMethod,
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
    res.status(500).json({ message: 'Failed to process payment.' });
  }
}

module.exports = { processPayment };
