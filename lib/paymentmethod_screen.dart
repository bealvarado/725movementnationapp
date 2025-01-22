import 'dart:convert'; // For encoding data
import 'package:dance_studio/classschedule_screen.dart';
import 'package:dance_studio/confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For backend integration
import 'package:intl/intl.dart'; // Import the intl package

class PaymentScreen extends StatefulWidget {
  final ClassCard classCard; // Add this line to receive classCard data
  final String bookingId; // Add bookingId for linking to backend

  const PaymentScreen({super.key, required this.classCard, required this.bookingId});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod;
  bool _isLoading = false;

  void _handlePaymentMethodChange(String? value) {
    setState(() {
      _selectedPaymentMethod = value;
    });
  }

  Future<void> _processPayment() async {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a payment method."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Backend payment processing
      const apiUrl = "http://localhost:3000/booking/payment";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "bookingId": widget.bookingId,
          "paymentMethod": _selectedPaymentMethod,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message']),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to the confirmation screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConfirmationScreen(classCard: widget.classCard)),
        );
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Payment failed: ${errorData['message']}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error processing payment: $error"),
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
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text('Payment')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBookingInfo(), // Display booking details
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose payment method',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                          fontFamily: 'SFProDisplay',
                        ),
                      ),
                      RadioListTile(
                        title: Row(
                          children: [
                            Image.asset(
                              'assets/images/credit_card.png',
                              height: 50,
                              width: 50,
                            ),
                            const SizedBox(width: 8),
                            const Text('Credit Card'), // Match backend string
                          ],
                        ),
                        value: 'Credit Card',
                        groupValue: _selectedPaymentMethod,
                        onChanged: _handlePaymentMethodChange,
                        activeColor: const Color(0xFFE84479),
                      ),
                      RadioListTile(
                        title: Row(
                          children: [
                            Image.asset(
                              'assets/images/credit_balance.png',
                              height: 50,
                              width: 50,
                            ),
                            const SizedBox(width: 8),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Credit Balance'),
                                Text('\$0.00'),
                              ],
                            ),
                          ],
                        ),
                        value: 'Credit Balance', // Match backend string
                        groupValue: _selectedPaymentMethod,
                        onChanged: _handlePaymentMethodChange,
                        activeColor: const Color(0xFFE84479),
                      ),
                      RadioListTile(
                        title: Row(
                          children: [
                            Image.asset(
                              'assets/images/apple_pay.png',
                              height: 50,
                              width: 50,
                            ),
                            const SizedBox(width: 8),
                            const Text('Apple Pay'),
                          ],
                        ),
                        value: 'Apple Pay', // Match backend string
                        groupValue: _selectedPaymentMethod,
                        onChanged: _handlePaymentMethodChange,
                        activeColor: const Color(0xFFE84479),
                      ),
                      RadioListTile(
                        title: Row(
                          children: [
                            Image.asset(
                              'assets/images/afterpay.png',
                              height: 50,
                              width: 50,
                            ),
                            const SizedBox(width: 8),
                            const Text('Afterpay'),
                          ],
                        ),
                        value: 'Afterpay', // Match backend string
                        groupValue: _selectedPaymentMethod,
                        onChanged: _handlePaymentMethodChange,
                        activeColor: const Color(0xFFE84479),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: ElevatedButton(
                    onPressed: _selectedPaymentMethod != null ? _processPayment : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedPaymentMethod != null ? const Color(0xFF4146F5) : const Color(0xFF93A4AF),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Pay \$${widget.classCard.price.toInt()} Now', // Dynamically show price
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'SFProDisplay',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.white.withOpacity(0.8),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE84479)),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBookingInfo() {
    return Container(
      width: double.infinity,
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
                '\$${widget.classCard.price.toInt()}', // Ensure price is a whole number
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SFProDisplay',
                ),
              ),
            ],
          ),
          Text(
            _formatTimeTo12Hour(widget.classCard.time), // Format time to 12-hour format
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontFamily: 'SFProDisplay',
            ),
          ),
          Text(
            widget.classCard.subtitle, // Assuming subtitle is used for location or additional info
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
}
