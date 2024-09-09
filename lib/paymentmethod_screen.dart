import 'package:dance_studio/confirmation_screen.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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

  void _processPayment() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a delay for loading
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    // Navigate to the confirmation screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConfirmationScreen()),
    );
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
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking Details',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                          fontFamily: 'SFProDisplay',
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Beginner Class with Winter',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SFProDisplay',
                            ),
                          ),
                          Text(
                            '\$22',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SFProDisplay',
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Wed, 1 Oct 6pm',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontFamily: 'SFProDisplay',
                        ),
                      ),
                      Text(
                        'Parramatta Studio',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontFamily: 'SFProDisplay',
                        ),
                      ),
                    ],
                  ),
                ),
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
                              'assets/images/apple_pay.png',
                              height: 50,
                              width: 50,
                            ),
                            const SizedBox(width: 8),
                            const Text('Apple Pay'),
                          ],
                        ),
                        value: 'Apple Pay',
                        groupValue: _selectedPaymentMethod,
                        onChanged: _handlePaymentMethodChange,
                        activeColor: const Color(0xFFE84479),
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
                            const Text('Credit card'),
                          ],
                        ),
                        value: 'Credit card',
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
                        value: 'Afterpay',
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
                                Text('\$22.00'),
                              ],
                            ),
                          ],
                        ),
                        value: 'Credit Balance',
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
                      backgroundColor: _selectedPaymentMethod != null ? const Color(0xFF4146F5) : const Color(0xFF9CA3AF),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Pay \$22 Now',
                      style: TextStyle(
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
}


