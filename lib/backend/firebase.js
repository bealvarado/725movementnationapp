const admin = require("firebase-admin");
const serviceAccount = require("./trialGPTServiceKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://trial-f65c0.firebaseio.com",
});

const db = admin.firestore();

module.exports = { admin, db };
