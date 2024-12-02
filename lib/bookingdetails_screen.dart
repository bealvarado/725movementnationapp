import 'package:dance_studio/classschedule_screen.dart';
import 'package:dance_studio/paymentmethod_screen.dart';
import 'package:flutter/material.dart';

class BookingDetails extends StatefulWidget {
  final ClassCard classCard; // ClassCard is defined in ClassSchedule

  const BookingDetails({super.key, required this.classCard});

  @override
  // ignore: library_private_types_in_public_api
  _BookingDetailsState createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  int? _selectedOption; // Initialize with null

  @override
  void initState() {
    super.initState();
    _selectedOption = 1; // Explicitly set initial value
  }

  void _handleRadioValueChange(int? value) {
    setState(() {
      _selectedOption = value;
    });
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
      body: SingleChildScrollView(
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
            widget.classCard.time, // Assuming time includes date and time
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

  Widget _buildPaymentOptions() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pay for this class',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              fontFamily: 'SFProDisplay',
              color: Color(0xFF9CA3AF),
            ),
          ),
          RadioListTile<int>(
            title: const Text(
              'Casual pass',
              style: TextStyle(fontFamily: 'SFProDisplay', fontSize: 14, fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              '\$22',
              style: TextStyle(fontFamily: 'SFProDisplay', fontSize: 14),
            ),
            value: 1,
            groupValue: _selectedOption,
            onChanged: (value) {
              _handleRadioValueChange(value);
            },
            activeColor: const Color(0xFFE84479),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanOptions() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Avail a plan',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              fontFamily: 'SFProDisplay',
              color: Color(0xFF9CA3AF),
            ),
          ),
          RadioListTile<int>(
            title: const Text(
              '5x class package',
              style: TextStyle(fontFamily: 'SFProDisplay', fontSize: 14, fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              '\$99\nValid for 2 weeks',
              style: TextStyle(fontFamily: 'SFProDisplay', fontSize: 14),
            ),
            value: 2,
            groupValue: _selectedOption,
            onChanged: (value) {
              _handleRadioValueChange(value);
            },
            activeColor: const Color(0xFFE84479),
          ),
          RadioListTile<int>(
            title: const Text(
              '10x class package',
              style: TextStyle(fontFamily: 'SFProDisplay', fontSize: 14, fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              '\$200\nValid for 3 months',
              style: TextStyle(fontFamily: 'SFProDisplay', fontSize: 14),
            ),
            value: 3,
            groupValue: _selectedOption,
            onChanged: (value) {
              _handleRadioValueChange(value);
            },
            activeColor: const Color(0xFFE84479),
          ),
          RadioListTile<int>(
            title: const Text(
              '20x class package',
              style: TextStyle(fontFamily: 'SFProDisplay', fontSize: 14, fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              '\$380\nValid for 3 months',
              style: TextStyle(fontFamily: 'SFProDisplay', fontSize: 14),
            ),
            value: 4,
            groupValue: _selectedOption,
            onChanged: (value) {
              _handleRadioValueChange(value);
            },
            activeColor: const Color(0xFFE84479),
          ),
        ],
      ),
    );
  }

  Widget _buildAddOns() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add-ons',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              fontFamily: 'SFProDisplay',
              color: Color(0xFF9CA3AF),
            ),
          ),
          RadioListTile<int>(
            title: const Text(
              'Bring a Bestie',
              style: TextStyle(fontFamily: 'SFProDisplay', fontSize: 14, fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              '\$35\nOne-time use only',
              style: TextStyle(fontFamily: 'SFProDisplay', fontSize: 14),
            ),
            value: 5,
            groupValue: _selectedOption,
            onChanged: (value) {
              _handleRadioValueChange(value);
            },
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
        onPressed: _selectedOption != null ? () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PaymentScreen()),
          );
        } : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedOption != null ? const Color(0xFF4146F5) : const Color(0xFF93A4C1),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Next',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: _selectedOption != null ? Colors.white : const Color(0xFF93A4C1),
            fontFamily: 'SFProDisplay',
          ),
        ),
      ),
    );
  }
}