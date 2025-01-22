import 'package:dance_studio/classschedule_screen.dart' as Schedule;
import 'package:dance_studio/paymentmethod_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dance_studio/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingDetails extends StatefulWidget {
  final Schedule.ClassCard classCard;

  const BookingDetails({super.key, required this.classCard});

  @override
  _BookingDetailsState createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  int? _selectedOption;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedOption = 1; // Default to "Casual Pass"
    _checkUserSession();
  }

  /// Checks if the user is logged in via UserProvider
  Future<void> _checkUserSession() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.uid.isEmpty) {
      debugPrint("UserProvider UID is empty. User is not logged in.");
      await _showLoginRequiredDialog();
    }
  }

  /// Displays a dialog if login is required
  Future<void> _showLoginRequiredDialog() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('You need to log in to book a class.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pop(context); // Return to the previous screen
            },
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  /// Handles changes in the payment option
  void _handleRadioValueChange(int? value) {
    setState(() {
      _selectedOption = value;
    });
  }

  /// Sends booking creation request to the backend
  Future<void> _createBooking() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please log in to proceed with booking."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Convert time to `hh:mm AM/PM` format
    final formattedTime = _formatTimeTo12Hour(widget.classCard.time);

    final bookingData = {
      "uid": userProvider.uid,
      "className": widget.classCard.title,
      "location": widget.classCard.location,
      "date": DateFormat('yyyy-MM-dd').format(widget.classCard.date),
      "time": formattedTime,
      "isPackageBased": _selectedOption != 1,
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/booking/create'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bookingData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Booking created successfully."),
            backgroundColor: Colors.green,
          ),
        );

        final bookingId = jsonDecode(response.body)['bookingId'];

        // Navigate to Payment Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              classCard: widget.classCard,
              bookingId: bookingId, // Pass booking ID for payment
            ),
          ),
        );
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Unknown error occurred.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to create booking: $errorMessage"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error creating booking: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred. Please try again later."),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(fontFamily: 'SFProDisplay', fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildBookingInfo(),
                  const SizedBox(height: 16),
                  _buildPaymentOptions(),
                  const SizedBox(height: 16),
                  _buildPlanOptions(),
                  const SizedBox(height: 16),
                  _buildAddOns(),
                  const SizedBox(height: 16),
                  _buildConfirmButton(context),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBookingInfo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Details',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
              fontFamily: 'SFProDisplay',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.classCard.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SFProDisplay',
                ),
              ),
              Text(
                '\$${widget.classCard.price.toInt()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SFProDisplay',
                ),
              ),
            ],
          ),
          Text(
            _formatTimeTo12Hour(widget.classCard.time),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontFamily: 'SFProDisplay',
            ),
          ),
          Text(
            widget.classCard.subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontFamily: 'SFProDisplay',
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeTo12Hour(String time24) {
    final timeParts = time24.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;

    return '$hour12:${minute.toString().padLeft(2, '0')} $period';
  }

  Widget _buildPaymentOptions() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pay for this class',
            style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),
          RadioListTile<int>(
            title: const Text(
              'Casual pass (\$22)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            value: 1,
            groupValue: _selectedOption,
            onChanged: _handleRadioValueChange,
            activeColor: const Color(0xFFE84479),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanOptions() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Avail a plan',
            style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),
          RadioListTile<int>(
            title: const Text('5x Class Package (\$99)'),
            value: 2,
            groupValue: _selectedOption,
            onChanged: _handleRadioValueChange,
            activeColor: const Color(0xFFE84479),
          ),
          RadioListTile<int>(
            title: const Text('10x Class Package (\$200)'),
            value: 3,
            groupValue: _selectedOption,
            onChanged: _handleRadioValueChange,
            activeColor: const Color(0xFFE84479),
          ),
          RadioListTile<int>(
            title: const Text('20x Class Package (\$380)'),
            value: 4,
            groupValue: _selectedOption,
            onChanged: _handleRadioValueChange,
            activeColor: const Color(0xFFE84479),
          ),
        ],
      ),
    );
  }

  Widget _buildAddOns() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add-ons',
            style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),
          RadioListTile<int>(
            title: const Text('Bring a Bestie (\$35)'),
            value: 5,
            groupValue: _selectedOption,
            onChanged: _handleRadioValueChange,
            activeColor: const Color(0xFFE84479),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: ElevatedButton(
        onPressed: _selectedOption != null ? _createBooking : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedOption != null ? const Color(0xFF4146F5) : Colors.grey,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text(
          'Next',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
