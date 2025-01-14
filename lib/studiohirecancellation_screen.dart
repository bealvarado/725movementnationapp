import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class StudioHireCancellation extends StatefulWidget {
  final String hireId;
  final String uid;

  const StudioHireCancellation({
    Key? key,
    required this.hireId,
    required this.uid,
  }) : super(key: key);

  @override
  _StudioHireCancellationState createState() => _StudioHireCancellationState();
}

class _StudioHireCancellationState extends State<StudioHireCancellation> {
  bool _isLoading = false;

  Future<void> cancelStudioHire() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dio = Dio();
      final response = await dio.delete(
        'https://your-api.com/cancellation/studio-hire',
        data: {
          'uid': widget.uid,
          'hireId': widget.hireId,
        },
      );

      if (response.statusCode == 200) {
        _showDialog(
          title: 'Success',
          content: 'Studio hire cancelled successfully! Credit refunded to your wallet.',
        );
      } else {
        _showDialog(
          title: 'Error',
          content: response.data['message'] ?? 'Failed to cancel the studio hire.',
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
        title: const Text('Cancel Studio Hire'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Are you sure you want to cancel this studio hire?',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: cancelStudioHire,
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
