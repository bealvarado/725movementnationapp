const admin = require('firebase-admin');
const serviceAccount = require('../../config/serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://console.firebase.google.com/project/trial-f65c0/firestore/databases/-default-/data/~2Fusers~2F5dAFwmHL6Jc9jaLYAzSKEhL5NO93',  // Firebase database URL
});

const db = admin.firestore();  // Firestore reference
const auth = admin.auth();      // Firebase Authentication reference

module.exports = { db, auth };

