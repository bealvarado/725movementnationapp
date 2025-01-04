// Import required packages
const express = require('express');
const admin = require('firebase-admin');
const bodyParser = require('body-parser');      

// Initialize Express app
const app = express();
app.use(bodyParser.json()); // Middleware to parse JSON request bodies

// Path to your Firebase service account key
const serviceAccount = require('C:/Users/Amyelito/dance-booking-backend/movement-nation-dance-st-52a74-firebase-adminsdk-8msti-ae0e233fbd.json');

// Initialize Firebase Admin SDK with service account credentials
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// Firestore reference
const db = admin.firestore();

// Define a simple route to test the server
app.get('/', (req, res) => {
  res.send('Hello from the backend!');
});

// Define a POST route to add a booking to Firestore
app.post('/add-booking', async (req, res) => {
  const { name, location, time } = req.body;

  if (!name || !location || !time) {
    return res.status(400).json({ error: 'Missing booking details' });
  }

  try {
    const bookingRef = db.collection('bookings').doc();
    await bookingRef.set({
      name,
      location,
      time,
    });
    return res.status(200).json({ success: 'Booking added successfully!' });
  } catch (error) {
    console.error('Error adding booking: ', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
});

// Start the server on a specific port
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
