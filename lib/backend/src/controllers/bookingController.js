const { db } = require("../../firebase");

const validPaymentMethods = ["Apple Pay", "Credit Card", "Afterpay", "Credit Balance"];
const CLASS_COST = 22.0; // Fixed cost per class

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

async function createBooking(req, res) {
  try {
    const { uid, className, location, date, time, isPackageBased = false } = req.body;

    // Validate required fields
    if (!uid || !className || !location || !date || !time) {
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

    // Validate date and time
    try {
      if (!validateFutureDateTime(date, time)) {
        return res.status(400).json({ message: "Bookings must be for present or future times only." });
      }
    } catch (error) {
      return res.status(400).json({ message: error.message });
    }

    // Check for conflicting bookings
    const conflictingBookings = await db
      .collection("bookings")
      .where("uid", "==", uid)
      .where("date", "==", date)
      .where("time", "==", time)
      .get();

    if (!conflictingBookings.empty) {
      return res.status(409).json({ message: "Time slot already booked." });
    }

    // Validate package usage if isPackageBased is true
    let usePackage = isPackageBased;
    if (usePackage) {
      const userPackage = userData.package || null;

      if (!userPackage || userPackage.remainingClasses <= 0) {
        return res.status(400).json({
          message: "No valid package found or no remaining classes left.",
        });
      }

      const currentDate = new Date();
      const expiryDate = new Date(userPackage.expiry._seconds * 1000);
      if (currentDate > expiryDate) {
        return res.status(400).json({
          message: "Your package has expired.",
        });
      }

      // Deduct one class from the package
      await userRef.update({
        "package.remainingClasses": userPackage.remainingClasses - 1,
      });

      console.log(
        `Package used for booking. Remaining classes: ${userPackage.remainingClasses - 1}`
      );
    }

    // Determine booking status
    const bookingStatus = usePackage ? "confirmed" : "pending";

    // Create the booking
    const bookingData = {
      uid,
      className,
      location,
      date,
      time,
      createdAt: new Date(),
      status: bookingStatus,
      isPackageBased: usePackage,
      paymentMethod: usePackage ? "Package" : null,
      amount: usePackage ? 0 : CLASS_COST, // Amount is $0 if using a package
    };

    const bookingRef = await db.collection("bookings").add(bookingData);

    res.status(200).json({
      message: "Booking created successfully",
      bookingId: bookingRef.id,
      isPackageBased: usePackage,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Failed to create booking." });
  }
}

async function getBooking(req, res) {
  try {
    const { uid } = req.query;

    const bookingSnapshot = await db.collection("bookings").where("uid", "==", uid).get();

    if (bookingSnapshot.empty) {
      return res.status(404).json({ message: "No bookings found for this user." });
    }

    const bookings = bookingSnapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    res.status(200).json(bookings);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Failed to retrieve bookings." });
  }
}

async function processPayment(req, res) {
  try {
    const { bookingId, paymentMethod, secondaryPaymentMethod } = req.body;

    // Validate required fields
    if (!bookingId || !paymentMethod) {
      return res.status(400).json({ message: "Missing required fields." });
    }

    // Validate the primary payment method
    if (!validPaymentMethods.includes(paymentMethod)) {
      return res.status(400).json({ message: "Invalid payment method." });
    }

    const bookingRef = db.collection("bookings").doc(bookingId);
    const bookingDoc = await bookingRef.get();

    if (!bookingDoc.exists) {
      return res.status(404).json({ message: "Booking not found." });
    }

    const bookingData = bookingDoc.data();

    if (bookingData.isPackageBased) {
      return res
        .status(400)
        .json({ message: "Package-based bookings are already confirmed and require no payment." });
    }

    const userRef = db.collection("users").doc(bookingData.uid);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      return res.status(404).json({ message: "User not found." });
    }

    const userData = userDoc.data();
    let remainingBalance = CLASS_COST;

    // Handle Credit Balance
    if (paymentMethod === "Credit Balance") {
      const userCreditBalance = userData.creditBalance || 0;

      if (userCreditBalance >= remainingBalance) {
        await userRef.update({
          creditBalance: userCreditBalance - remainingBalance,
        });
        remainingBalance = 0;
      } else {
        remainingBalance -= userCreditBalance;
        await userRef.update({ creditBalance: 0 });
      }

      if (remainingBalance > 0) {
        if (!secondaryPaymentMethod || !validPaymentMethods.includes(secondaryPaymentMethod)) {
          return res
            .status(400)
            .json({ message: "Secondary payment method required for split payment." });
        }
      }
    }

    const paymentResult = {
      transactionId: `txn_${Date.now()}`,
      paymentMethod: remainingBalance > 0 ? secondaryPaymentMethod || paymentMethod : paymentMethod,
      timestamp: new Date(),
    };

    await bookingRef.update({
      status: "confirmed",
      paymentMethod: paymentResult.paymentMethod,
      transactionId: paymentResult.transactionId,
      paymentTimestamp: paymentResult.timestamp,
    });

    res.status(200).json({
      message: "Payment processed successfully",
      transactionId: paymentResult.transactionId,
      status: "confirmed",
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Failed to process payment." });
  }
}

async function cancelBooking(req, res) {
  try {
    const { uid, bookingId } = req.body;

    const bookingRef = db.collection("bookings").doc(bookingId);
    const bookingDoc = await bookingRef.get();

    if (!bookingDoc.exists) {
      return res.status(404).json({ message: "Booking not found." });
    }

    const bookingData = bookingDoc.data();

    if (bookingData.isPackageBased) {
      return res.status(400).json({ message: "Package-based bookings cannot be canceled." });
    }

    const userRef = db.collection("users").doc(uid);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      return res.status(404).json({ message: "User not found." });
    }

    const userData = userDoc.data();
    const updatedCreditBalance = (userData.creditBalance || 0) + bookingData.amount;

    await userRef.update({ creditBalance: updatedCreditBalance });
    await bookingRef.delete();

    res.status(200).json({
      message: "Booking canceled successfully. Credit balance updated.",
      creditBalance: updatedCreditBalance,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Failed to cancel booking." });
  }
}

module.exports = { createBooking, getBooking, processPayment, cancelBooking };
