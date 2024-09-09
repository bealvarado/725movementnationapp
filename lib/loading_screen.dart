import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 100.0, // Customize the width
          height: 100.0, // Customize the height
          child: CircularProgressIndicator(
            color: Colors.pink, // Customize the color if needed
            strokeWidth: 4.0, // Customize the stroke width if needed
          ),
        ),
      ),
    );
  }
}
