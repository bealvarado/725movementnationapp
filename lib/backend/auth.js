require('dotenv').config();

const { admin, db } = require("./firebase");
const fetch = require("node-fetch"); // Ensure fetch is available in Node.js

const signUp = async (req, res) => {
  const { email, password, fullName, phoneNumber } = req.body;
  try {
    const userRecord = await admin.auth().createUser({
      email,
      password,
      displayName: fullName,
      phoneNumber,
    });

    await db.collection("users").doc(userRecord.uid).set({
      email,
      fullName,
      phoneNumber,
      createdAt: admin.firestore.Timestamp.now(),
    });

    res.status(201).send({ message: "User created successfully", userId: userRecord.uid });
  } catch (error) {
    res.status(500).send({ error: error.message });
  }
};

const login = async (req, res) => {
  const { email, password } = req.body;
  try {
    // Validate credentials using Firebase Admin Authentication
    const userRecord = await admin.auth().getUserByEmail(email);
    if (!userRecord) throw new Error("User does not exist");

    // Check if password matches using Firebase Authentication REST API
    const firebaseAuthUrl = ⁠ https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${process.env.FIREBASE_API_KEY} ⁠;
    const response = await fetch(firebaseAuthUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password, returnSecureToken: true }),
    });

    const result = await response.json();

    if (result.error) throw new Error(result.error.message);

    // Fetch user data from Firestore
    const userSnapshot = await db.collection("users").where("email", "==", email).get();
    if (userSnapshot.empty) throw new Error("User data not found in Firestore");

    res.status(200).send({ message: "Login successful", user: userSnapshot.docs[0].data() });
  } catch (error) {
    res.status(401).send({ error: error.message });
  }
};

const forgotPassword = async (req, res) => {
  const { email } = req.body;
  try {
    await admin.auth().generatePasswordResetLink(email);
    res.status(200).send({ message: "Password reset link sent successfully" });
  } catch (error) {
    res.status(500).send({ error: error.message });
  }
};

const updateAccountSettings = async (req, res) => {
  const { uid, email, fullName, phoneNumber } = req.body;
  try {
    await admin.auth().updateUser(uid, { email, displayName: fullName, phoneNumber });
    await db.collection("users").doc(uid).update({ email, fullName, phoneNumber });
    res.status(200).send({ message: "Account settings updated successfully" });
  } catch (error) {
    res.status(500).send({ error: error.message });
  }
};

module.exports = { signUp, login, forgotPassword, updateAccountSettings };