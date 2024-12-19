const admin = require("firebase-admin");
const serviceAccount = require("./trial-f65c0-firebase-adminsdk-3lbdz-87f28abfb3.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://trial-f65c0.firebaseio.com",
});

const db = admin.firestore();

module.exports = { admin, db };
