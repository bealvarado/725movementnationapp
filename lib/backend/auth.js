require("dotenv").config(); // Load environment variables
require("isomorphic-fetch"); // Add fetch functionality to Node.js

const { admin, db } = require("./firebase");

// Password validation function
const isPasswordValid = (password) => {
  const passwordRegex =
    /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&-_=+,.<>?:;#^])[A-Za-z\d@$!%*?&-_=+,.<>?:;#^]{8,}$/;
  return passwordRegex.test(password);
};

const signUp = async (req, res) => {
  const { email, password, fullName, phoneNumber } = req.body;

  // Validate password
  if (!isPasswordValid(password)) {
    return res.status(400).send({
      error:
        "Password must be at least 8 characters long, with at least one uppercase letter, one lowercase letter, one number, and one special character.",
    });
  }

  try {
    // Create a new user in Firebase Authentication
    const userRecord = await admin.auth().createUser({
      email,
      password,
      displayName: fullName,
      phoneNumber,
    });

    // Generate a username by concatenating the full name in lowercase without spaces
    const username = fullName.toLowerCase().replace(/\s+/g, "");

    // Initialize user details with default profile image, username, zero credit balance, and no package or promo
    await db.collection("users").doc(userRecord.uid).set({
      email,
      fullName,
      username,
      phoneNumber,
      creditBalance: 0,
      package: null,
      promo: false,
      profileImage: "assets/images/Avatar.png",
      createdAt: admin.firestore.Timestamp.now(),
    });

    res
      .status(201)
      .send({ message: "User created successfully", userId: userRecord.uid });
  } catch (error) {
    console.error("Error signing up user:", error);
    res.status(500).send({ error: error.message });
  }
};

const login = async (req, res) => {
  const { email, password } = req.body;
  try {
    console.log("Login request received:", email);

    // Validate credentials using Firebase Admin Authentication
    const userRecord = await admin.auth().getUserByEmail(email);
    if (!userRecord) throw new Error("User does not exist");

    console.log("User exists in Firebase Auth:", userRecord.uid);

    // Check if password matches using Firebase Authentication REST API
    const firebaseAuthUrl = `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${process.env.FIREBASE_API_KEY}`;
    const response = await fetch(firebaseAuthUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password, returnSecureToken: true }),
    });

    const result = await response.json();

    if (result.error) {
      console.log("Firebase Auth Error:", result.error.message);
      throw new Error(result.error.message);
    }

    console.log("Firebase Authentication successful for user:", email);

    // Fetch user data from Firestore
    const userSnapshot = await db.collection("users").where("email", "==", email).get();
    if (userSnapshot.empty) throw new Error("User data not found in Firestore");

    const userData = userSnapshot.docs[0].data();

    console.log("User data fetched from Firestore:", userData);

    res.status(200).send({
      message: "Login successful",
      uid: userRecord.uid,
      user: userData,
    });
  } catch (error) {
    console.error("Error during login:", error.message);
    res.status(401).send({ error: error.message });
  }
};

const forgotPassword = async (req, res) => {
  const { email } = req.body;

  const actionCodeSettings = {
    url: "http://localhost:3000/reset-password", // Replace with your app's domain or reset password page
    handleCodeInApp: true,
  };

  try {
    const resetLink = await admin.auth().generatePasswordResetLink(
      email,
      actionCodeSettings
    );
    console.log(`Password reset link generated: ${resetLink}`);
    res
      .status(200)
      .send({ message: "Password reset link sent successfully." });
  } catch (error) {
    console.error("Error generating password reset link:", error);
    res.status(500).send({ error: error.message });
  }
};

const updateAccountSettings = async (req, res) => {
  const { uid, username, email, fullName, phoneNumber, profileImage } = req.body;

  console.log("Debug: Incoming request to update account settings");

  try {
    const updateData = {};

    if (username !== undefined) updateData.username = username;
    if (email !== undefined) updateData.email = email;
    if (fullName !== undefined) updateData.fullName = fullName;
    if (phoneNumber !== undefined) updateData.phoneNumber = phoneNumber;
    if (profileImage !== undefined) updateData.profileImage = profileImage;

    await db.collection("users").doc(uid).update(updateData);

    res.status(200).send({ message: "Account settings updated successfully" });
  } catch (error) {
    console.error("Error updating account settings:", error.message);
    res.status(500).send({ error: error.message });
  }
};

const getAccountSettings = async (req, res) => {
  const { uid } = req.headers;

  if (!uid) {
    return res.status(400).send({ error: "User ID (uid) is required" });
  }

  try {
    const userDoc = await db.collection("users").doc(uid).get();

    if (!userDoc.exists) {
      return res.status(404).send({ error: "User not found" });
    }

    const userData = userDoc.data();

    res.status(200).send({
      username: userData.username || "Unknown",
      fullName: userData.fullName || "",
      phoneNumber: userData.phoneNumber || "",
      email: userData.email || "",
    });
  } catch (error) {
    console.error("Error fetching user data:", error);
    res.status(500).send({ error: "Failed to fetch user data" });
  }
};

// New: Change Password
const changePassword = async (req, res) => {
  const { uid, currentPassword, newPassword } = req.body;

  if (!isPasswordValid(newPassword)) {
    return res.status(400).send({
      error:
        "New password must be at least 8 characters long, with at least one uppercase letter, one lowercase letter, one number, and one special character.",
    });
  }

  try {
    // Re-authenticate the user with current password
    const userRecord = await admin.auth().getUser(uid);
    const firebaseAuthUrl = `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${process.env.FIREBASE_API_KEY}`;
    const response = await fetch(firebaseAuthUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: userRecord.email, password: currentPassword }),
    });

    const result = await response.json();

    if (result.error) {
      throw new Error("Current password is incorrect.");
    }

    // Update the password
    const user = await admin.auth().updateUser(uid, { password: newPassword });

    res.status(200).send({ message: "Password updated successfully." });
  } catch (error) {
    console.error("Error changing password:", error.message);
    res.status(400).send({ error: error.message });
  }
};


const validatePassword = async (req, res) => {
  const { uid, currentPassword } = req.body;

  if (!uid || !currentPassword) {
    return res
      .status(400)
      .send({ error: "UID and Current Password are required." });
  }

  try {
    // Retrieve user email based on UID
    const userRecord = await admin.auth().getUser(uid);
    const email = userRecord.email;

    // Validate current password using Firebase REST API
    const firebaseAuthUrl = `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${process.env.FIREBASE_API_KEY}`;
    const response = await fetch(firebaseAuthUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email, password: currentPassword }),
    });

    const result = await response.json();

    if (result.error) {
      return res.status(401).send({ error: "Current Password is incorrect." });
    }

    res.status(200).send({ message: "Password validated successfully." });
  } catch (error) {
    console.error("Error validating password:", error.message);
    res.status(500).send({ error: "Failed to validate current password." });
  }
};



module.exports = {
  signUp,
  login,
  forgotPassword,
  updateAccountSettings,
  getAccountSettings,
  changePassword, // Export the new function
  validatePassword
};
