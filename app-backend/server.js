// server.js

const express = require('express');
const bodyParser = require('body-parser');
const bookingRoutes = require('./src/routes/bookingRoutes');
const paymentRoutes = require('./src/routes/paymentRoutes'); 
const studioRoutes = require('./src/routes/studioRoutes');

const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.json()); // Middleware to parse JSON requests

// Register routes
app.use('/api/bookings', bookingRoutes);
app.use('/api/payments', paymentRoutes); 
app.use('/api/studios', studioRoutes);

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});


