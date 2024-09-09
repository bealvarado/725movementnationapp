import 'package:flutter/material.dart';
import 'classbooking_screen.dart'; // Import the BookingScreen
import 'classschedule_screen.dart'; // Import the ClassSchedule

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Center(
          child: Image.asset('assets/images/brandlogo.png', height: 40),
        ),
        actions: const [
          SizedBox(width: 48), // To balance the leading icon
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 60), // Space above the image
            // Image space
            Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Cempty_state.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Booking Confirmation Text
            const Text(
              'Booking Confirmed!',
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Additional Information Text
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontSize: 16,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: 'Your booking for '),
                  TextSpan(
                    text: 'Beginner Class with Winter',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' is all set. If you have any questions, feel free to reach out.'),
                ],
              ),
            ),
            const Spacer(),
            // Back to Booking Button
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BookingScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4146F5),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Back to Booking',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'SFProDisplay',
                  ),
                ),
              ),
            ),
            // Book Another Class Button
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ClassSchedule()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF4146F5)),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Book Another Class',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4146F5),
                    fontFamily: 'SFProDisplay',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
