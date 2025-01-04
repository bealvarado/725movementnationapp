const admin = require("firebase-admin");
const serviceAccount = require("./trial-f65c0-firebase-adminsdk-3lbdz-93946d4523.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://trial-f65c0.firebaseio.com",
  authDomain: "trial-f65c0.firebaseapp.com", 
});

const db = admin.firestore();

module.exports = { admin, db };
