const express = require('express');
const bodyParser = require('body-parser');
const admin = require('firebase-admin');

// Correct path to the Firebase service account key
const serviceAccount = require('C:/Users/Amyelito/dance-booking-backend/dance-booking-backend/movement-nation-dance-st-52a74-firebase-adminsdk-8msti-1a0a989b80.json');

const app = express();
const port = 4000;

// Initialize Firebase Admin SDK with service account key
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://movement-nation-dance-st-52a74.firebaseio.com", // Correct Firebase Realtime Database URL
});

const db = admin.firestore();

// Middleware to parse JSON
app.use(bodyParser.json());

// POST route to create a booking
app.post('/create-booking', async (req, res) => {
  try {
    const { location, date, time } = req.body;

    if (!location || !date || !time) {
      return res.status(400).send('Missing required fields');
    }

    // Add the booking to Firestore
    const bookingRef = await db.collection('bookings').add({
      location: location,
      date: date,
      time: time,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    res.status(200).json({
      message: 'Booking created successfully!',
      bookingId: bookingRef.id,
    });
  } catch (error) {
    console.error("Error creating booking:", error);
    res.status(500).send('Internal Server Error');
  }
});

// POST route to process a payment
app.post('/process-payment', async (req, res) => {
  try {
    const { bookingDetails, paymentMethod, amount } = req.body;

    // Validate input
    if (!bookingDetails || !paymentMethod || !amount) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // Simulate payment processing
    const paymentStatus = 'success'; // Mock payment status

    // Save payment details to Firestore
    const paymentRef = await db.collection('payments').add({
      bookingDetails: bookingDetails,
      paymentMethod: paymentMethod,
      amount: amount,
      status: paymentStatus,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    res.status(200).json({
      message: 'Payment processed successfully!',
      paymentId: paymentRef.id,
      paymentStatus,
    });
  } catch (error) {
    console.error("Error processing payment:", error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Start server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});

