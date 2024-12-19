const express = require("express");
const bodyParser = require("body-parser");
const { signUp, login, forgotPassword, updateAccountSettings } = require("./auth");

const app = express();
app.use(bodyParser.json());

// Define routes
app.post("/auth/signup", signUp);
app.post("/auth/login", login);
app.post("/auth/forgot-password", forgotPassword);
app.put("/auth/account-settings", updateAccountSettings);

// Catch-all route for undefined endpoints
app.use((req, res) => {
  res.status(404).send({ error: "Route not found" });
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
