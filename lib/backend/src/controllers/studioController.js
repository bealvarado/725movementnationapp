const { db } = require('../../firebase');

const validStudios = ['Parramatta', 'Hurstville'];
const validPaymentMethods = ['Apple Pay', 'Credit Card', 'Afterpay', 'Credit Balance'];
const STUDIO_HIRE_COST = 150.00; // Fixed cost for a 2-hour studio hire

// Helper function to validate if the hire is in the future
const validateFutureDateTime = (date, time) => {
  const hireDateTime = new Date(`${date} ${time}`);
  const now = new Date();
  return hireDateTime > now;
};

async function hireStudio(req, res) {
  try {
    const { uid, studioLocation, date, time, duration, purpose } = req.body;

    // Validate studio location
    if (!validStudios.includes(studioLocation)) {
      return res.status(400).json({ message: 'Invalid studio location.' });
    }

    // Check if the user exists
    const userDoc = await db.collection('users').doc(uid).get();
    if (!userDoc.exists) {
      return res.status(404).json({ message: 'User not found.' });
    }

    // Validate that the hire is for the present or future time
    if (!validateFutureDateTime(date, time)) {
      return res.status(400).json({ message: 'Studio hires must be for present or future times only.' });
    }

    // Check if the studio is already booked at the same time and location
    const conflictingHire = await db
      .collection('studioHires')
      .where('studioLocation', '==', studioLocation)
      .where('date', '==', date)
      .where('time', '==', time)
      .get();

    if (!conflictingHire.empty) {
      return res.status(400).json({ message: 'This studio is already booked for the selected date and time.' });
    }

    // Add studio hire request
    const hireRef = await db.collection('studioHires').add({
      uid,
      studioLocation,
      date,
      time,
      duration,
      purpose,
      amount: STUDIO_HIRE_COST, // Use STUDIO_HIRE_COST
      status: 'pending',
      createdAt: new Date(),
    });

    res.status(200).json({ message: 'Studio hire request created successfully', hireId: hireRef.id });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to create studio hire request.' });
  }
}

async function getStudioHire(req, res) {
  try {
    const { uid } = req.query;

    const hireSnapshot = await db.collection('studioHires').where('uid', '==', uid).get();

    if (hireSnapshot.empty) {
      return res.status(404).json({ message: 'No studio hire requests found for this user.' });
    }

    const hires = hireSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.status(200).json(hires);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to retrieve studio hire requests.' });
  }
}

async function processStudioPayment(req, res) {
  try {
    const { hireId, paymentMethod, secondaryPaymentMethod } = req.body;

    if (!hireId || !paymentMethod) {
      return res.status(400).json({ message: 'Missing required fields.' });
    }

    if (!validPaymentMethods.includes(paymentMethod)) {
      return res.status(400).json({ message: 'Invalid payment method.' });
    }

    const hireRef = db.collection('studioHires').doc(hireId);
    const hireDoc = await hireRef.get();

    if (!hireDoc.exists) {
      return res.status(404).json({ message: 'Studio hire request not found.' });
    }

    const hire = hireDoc.data();

    if (hire.status === 'confirmed') {
      return res.status(400).json({ message: 'This studio hire is already paid.' });
    }

    const userRef = db.collection('users').doc(hire.uid);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      return res.status(404).json({ message: 'User not found.' });
    }

    const user = userDoc.data();
    let remainingBalance = STUDIO_HIRE_COST;

    // Handle Credit Balance
    if (paymentMethod === 'Credit Balance') {
      const userCreditBalance = user.creditBalance || 0;

      if (userCreditBalance >= remainingBalance) {
        // Deduct full amount from credit balance
        await userRef.update({
          creditBalance: userCreditBalance - remainingBalance,
        });
        remainingBalance = 0;
      } else {
        // Deduct whatever is available
        remainingBalance -= userCreditBalance;
        await userRef.update({ creditBalance: 0 });
      }

      if (remainingBalance > 0) {
        // Ensure a secondary payment method is provided
        if (!secondaryPaymentMethod || !validPaymentMethods.includes(secondaryPaymentMethod)) {
          return res.status(400).json({ message: 'Secondary payment method required for split payment.' });
        }

        console.log(
          `Processing secondary payment of $${remainingBalance} for studio hire ${hireId} using ${secondaryPaymentMethod}`
        );
      }
    } else {
      console.log(`Processing full payment of $${remainingBalance} using ${paymentMethod}`);
    }

    // Simulate payment processing logic
    const paymentResult = {
      transactionId: `txn_${Date.now()}`,
      paymentMethod: remainingBalance > 0 ? secondaryPaymentMethod || paymentMethod : paymentMethod,
      timestamp: new Date(),
    };

    await hireRef.update({
      status: 'confirmed',
      paymentMethod: paymentResult.paymentMethod,
      transactionId: paymentResult.transactionId,
      paymentTimestamp: paymentResult.timestamp,
    });

    res.status(200).json({
      message: 'Payment processed successfully.',
      transactionId: paymentResult.transactionId,
      status: 'confirmed',
    });
  } catch (error) {
    console.error('Error during studio payment:', error);
    res.status(500).json({ message: 'Failed to process payment.' });
  }
}

async function cancelStudioHire(req, res) {
  try {
    const { uid, hireId } = req.body;

    const hireRef = db.collection('studioHires').doc(hireId);
    const hireDoc = await hireRef.get();

    if (!hireDoc.exists) {
      return res.status(404).json({ message: 'Studio hire not found.' });
    }

    const hireData = hireDoc.data();

    if (hireData.uid !== uid) {
      return res.status(403).json({ message: 'Unauthorized: User does not own this hire.' });
    }

    const userRef = db.collection('users').doc(uid);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      return res.status(404).json({ message: 'User not found.' });
    }

    const userData = userDoc.data();
    const updatedCreditBalance = (userData.creditBalance || 0) + hireData.amount;

    await userRef.update({ creditBalance: updatedCreditBalance });

    // Delete the studio hire
    await hireRef.delete();

    res.status(200).json({
      message: 'Studio hire cancelled successfully. Credit balance updated.',
      creditBalance: updatedCreditBalance,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to cancel studio hire.' });
  }
}

module.exports = { hireStudio, getStudioHire, processStudioPayment, cancelStudioHire };
