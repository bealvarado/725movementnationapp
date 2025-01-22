import 'package:flutter/material.dart';

class BookingHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Set background color
      appBar: AppBar(
        title: Text('Booking History'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Adjust arrow color
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.normal,
          fontFamily: 'SF Pro Display',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'October 2024',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'SF Pro Display',
              ),
            ),
            SizedBox(height: 16), // Adjustable spacing between title and containers
            BookingItem(
              title: 'Wallet Credit',
              subtitle: 'Class with Winter cancellation',
              amount: '+22',
              amountColor: Colors.green,
            ),
            BookingItem(
              title: 'Class with Winter',
              subtitle: 'Cancelled Class Booking\nWed, Oct 1 6pm',
              amount: '',
              amountColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

class BookingItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;

  BookingItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SF Pro Display',
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: amountColor,
              fontFamily: 'SF Pro Display',
            ),
          ),
        ],
      ),
    );
  }
}
