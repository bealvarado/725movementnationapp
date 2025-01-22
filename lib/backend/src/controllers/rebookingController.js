const { db } = require("../../firebase");

// Helper function to validate date and time format
const validateFutureDateTime = (date, time) => {
  try {
    // Validate the date format
    const dateRegex = /^\d{4}-\d{2}-\d{2}$/; // Format: YYYY-MM-DD
    if (!dateRegex.test(date)) {
      throw new Error("Invalid date format. Expected format: YYYY-MM-DD");
    }

    // Validate the time format
    const timeRegex = /^(\d{1,2}):(\d{2})\s*(AM|PM)$/i; // Format: hh:mm AM/PM
    const timeMatch = time.match(timeRegex);
    if (!timeMatch) {
      throw new Error("Invalid time format. Expected format: hh:mm AM/PM");
    }

    // Convert time to 24-hour format
    const [hours, minutes, meridian] = timeMatch.slice(1);
    const parsedHours =
      meridian.toUpperCase() === "PM" && hours !== "12"
        ? parseInt(hours) + 12
        : meridian.toUpperCase() === "AM" && hours === "12"
        ? 0
        : parseInt(hours);

    // Combine date and time into a single Date object
    const bookingDateTime = new Date(`${date}T${String(parsedHours).padStart(2, "0")}:${minutes}:00Z`);
    const now = new Date();

    console.log("Booking DateTime:", bookingDateTime, "Now:", now);
    return bookingDateTime > now;
  } catch (error) {
    console.error("Error parsing date and time:", error.message);
    throw error;
  }
};

async function rebookDanceClass(req, res) {
  try {
    const { uid, bookingId, newDate, newTime } = req.body;

    // Validate required fields
    if (!uid || !bookingId || !newDate || !newTime) {
      return res.status(400).json({ message: "Missing required fields." });
    }

    // Check if the user exists
    const userRef = db.collection("users").doc(uid);
    const userDoc = await userRef.get();
    if (!userDoc.exists) {
      return res.status(404).json({ message: "User not found." });
    }

    const userData = userDoc.data();
    console.log("User Data:", userData);

    // Fetch the existing booking
    const bookingRef = db.collection("bookings").doc(bookingId);
    const bookingDoc = await bookingRef.get();

    if (!bookingDoc.exists) {
      return res.status(404).json({ message: "Booking not found." });
    }

    const bookingData = bookingDoc.data();
    console.log("Booking Data:", bookingData);

    // Ensure the booking has not already lapsed
    const currentDate = new Date();
    const bookingDateTime = new Date(`${bookingData.date}T${bookingData.time}`);
    if (currentDate > bookingDateTime) {
      return res.status(400).json({ message: "Cannot rebook a past booking." });
    }

    // For package-based bookings
    if (bookingData.isPackageBased) {
      const userPackage = userData.package;

      if (!userPackage || userPackage.remainingClasses < 0) {
        return res.status(400).json({ message: "No valid package found for rebooking." });
      }

      // Ensure the package has not expired
      const expiryDate = new Date(userPackage.expiry._seconds * 1000);
      if (currentDate > expiryDate) {
        return res.status(400).json({ message: "Package expired. Cannot rebook." });
      }

      // Ensure the new booking date is within the package expiry
      const newBookingDateTime = new Date(newDate);
      if (newBookingDateTime > expiryDate) {
        return res.status(400).json({ message: "New booking date exceeds package expiry." });
      }
    }

    // Validate the new date and time
    try {
      if (!validateFutureDateTime(newDate, newTime)) {
        return res.status(400).json({ message: "Rebookings must be for future times only." });
      }
    } catch (error) {
      return res.status(400).json({ message: error.message });
    }

    // Check if the new time and date are available
    const conflictingBookings = await db
      .collection("bookings")
      .where("uid", "==", uid)
      .where("date", "==", newDate)
      .where("time", "==", newTime)
      .get();

    if (!conflictingBookings.empty) {
      return res.status(409).json({ message: "Time slot already booked." });
    }

    // Update the booking with the new date and time
    await bookingRef.update({
      date: newDate,
      time: newTime,
      updatedAt: new Date(),
    });

    res.status(200).json({ message: "Booking rebooked successfully." });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Failed to rebook the class." });
  }
}
// Rebook a studio hire
async function rebookStudioHire(req, res) {
  try {
    const { uid, hireId, newDate, newTime } = req.body;

    // Validate required fields
    if (!uid || !hireId || !newDate || !newTime) {
      return res.status(400).json({ message: 'Missing required fields.' });
    }

    console.log('Rebooking Studio Input Data:', req.body);

    // Check if the user exists
    const userRef = db.collection('users').doc(uid);
    const userDoc = await userRef.get();
    if (!userDoc.exists) {
      return res.status(404).json({ message: 'User not found.' });
    }

    // Check if the new time and date are available
    const conflictingHires = await db
      .collection('studioHires')
      .where('date', '==', newDate)
      .where('time', '==', newTime)
      .where('uid', '==', uid)
      .get();

    if (!conflictingHires.empty) {
      return res.status(409).json({ message: 'Time slot already hired.' });
    }

    // Fetch the existing studio hire
    const hireRef = db.collection('studioHires').doc(hireId);
    const hireDoc = await hireRef.get();

    if (!hireDoc.exists) {
      return res.status(404).json({ message: 'Studio hire not found.' });
    }

    // Update the studio hire with the new date and time
    await hireRef.update({
      date: newDate,
      time: newTime,
      updatedAt: new Date(), // Optional: track rebooking time
    });

    console.log('Studio hire successfully rebooked:', hireId);

    res.status(200).json({ message: 'Studio hire rebooked successfully.' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to rebook the studio hire.' });
  }
}

module.exports = { rebookDanceClass, rebookStudioHire };
