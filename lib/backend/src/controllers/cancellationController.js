const { db } = require('../../firebase');

const CLASS_COST = 22.00; // Fixed cost per class
const STUDIO_HIRE_COST = 150.00; // Fixed cost for a 2-hour studio hire

// Cancel a booking
async function cancelBooking(req, res) {
  try {
    const { uid, bookingId } = req.body;

    const bookingRef = db.collection('bookings').doc(bookingId);
    const bookingDoc = await bookingRef.get();

    if (!bookingDoc.exists) {
      return res.status(404).json({ message: 'Booking not found.' });
    }

    const bookingData = bookingDoc.data();

    if (bookingData.uid !== uid) {
      return res.status(403).json({ message: 'Unauthorized: User does not own this booking.' });
    }

    // Handle package-based bookings
    if (bookingData.isPackageBased) {
      return res.status(400).json({ message: 'Package-based bookings cannot be cancelled.' });
    }

    const currentTime = new Date();
    const bookingTime = new Date(`${bookingData.date} ${bookingData.time}`);
    const hoursDifference = (bookingTime - currentTime) / (1000 * 60 * 60);

    if (hoursDifference < 24) {
      return res.status(400).json({ message: 'Cancellations must be made at least 24 hours prior to the class.' });
    }

    const userRef = db.collection('users').doc(uid);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      return res.status(404).json({ message: 'User not found.' });
    }

    const userData = userDoc.data();
    const updatedCreditBalance = (userData.creditBalance || 0) + CLASS_COST;

    await userRef.update({
      creditBalance: updatedCreditBalance,
    });

    await bookingRef.delete();

    res.status(200).json({
      message: 'Booking cancelled successfully. Credit balance updated.',
      creditBalance: updatedCreditBalance,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to cancel booking.' });
  }
}

// Cancel a studio hire
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

    const currentTime = new Date();
    const hireTime = new Date(`${hireData.date} ${hireData.time}`);
    const hoursDifference = (hireTime - currentTime) / (1000 * 60 * 60);

    if (hoursDifference < 24) {
      return res.status(400).json({ message: 'Cancellations must be made at least 24 hours prior to the studio hire.' });
    }

    const userRef = db.collection('users').doc(uid);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      return res.status(404).json({ message: 'User not found.' });
    }

    const userData = userDoc.data();
    const updatedCreditBalance = (userData.creditBalance || 0) + STUDIO_HIRE_COST;

    await userRef.update({
      creditBalance: updatedCreditBalance,
    });

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

module.exports = { cancelBooking, cancelStudioHire };
