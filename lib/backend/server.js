const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors"); // Import CORS
const bookingRoutes = require("./src/routes/bookingRoutes");
const paymentRoutes = require("./src/routes/paymentRoutes");
const studioRoutes = require('./src/routes/studioRoutes');
const rebookingRoutes = require("./src/routes/rebookingRoutes");
const cancellationRoutes = require("./src/routes/cancellationRoutes");
const packageRoutes = require("./src/routes/packageRoutes");
const {
  signUp,
  login,
  forgotPassword,
  updateAccountSettings,
  getAccountSettings,
  changePassword, // Import changePassword
  validatePassword,
} = require("./auth");

const app = express();

// Middleware
app.use(cors()); // Enable CORS
app.use(bodyParser.json()); // Parse JSON request bodies

// Log all incoming requests
app.use((req, res, next) => {
  console.log(`${req.method} request to ${req.url}`);
  next();
});

// Auth Routes
app.post("/auth/signup", signUp);
app.post("/auth/login", login);
app.post("/auth/forgot-password", forgotPassword);
app.put("/auth/account-settings", updateAccountSettings);
app.get("/auth/account-settings", getAccountSettings);
app.post("/auth/change-password", changePassword); // New Change Password Route
app.post("/auth/validate-password", validatePassword);

// Booking Routes
app.use("/booking", bookingRoutes);

// Payment Routes
app.use("/payment", paymentRoutes);

// Studio Routes
app.use('/studio', studioRoutes);

// Rebooking Routes
app.use("/rebooking", rebookingRoutes);

// Cancellation Routes
app.use("/cancellation", cancellationRoutes);

// Package Routes
app.use("/packages", packageRoutes);

// Catch-all route for undefined endpoints
app.use((req, res) => {
  res.status(404).send({ error: "Route not found" });
});

// Global error handler
app.use((err, req, res, next) => {
  console.error("Error:", err.message || err);
  res.status(err.status || 500).json({ error: err.message || "Internal Server Error" });
});

// Start the server
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
