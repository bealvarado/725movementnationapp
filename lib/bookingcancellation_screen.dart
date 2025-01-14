import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class BookingCancellation extends StatefulWidget {
  final String bookingId;
  final String uid;

  const BookingCancellation({
    Key? key,
    required this.bookingId,
    required this.uid,
  }) : super(key: key);

  @override
  _BookingCancellationState createState() => _BookingCancellationState();
}

class _BookingCancellationState extends State<BookingCancellation> {
  bool _isLoading = false;

  Future<void> cancelBooking() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dio = Dio();
      final response = await dio.delete(
        'https://your-api.com/cancellation/booking',
        data: {
          'uid': widget.uid,
          'bookingId': widget.bookingId,
        },
      );

      if (response.statusCode == 200) {
        _showDialog(
          title: 'Success',
          content: 'Booking cancelled successfully! Credit refunded to your wallet.',
        );
      } else {
        _showDialog(
          title: 'Error',
          content: response.data['message'] ?? 'Failed to cancel the booking.',
        );
      }
    } catch (e) {
      _showDialog(
        title: 'Error',
        content: 'An unexpected error occurred.',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDialog({required String title, required String content}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancel Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Are you sure you want to cancel this booking?',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: cancelBooking,
                    child: const Text('I agree, cancel and refund'),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
      ),
    );
  }
}
