import 'package:flutter/material.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of image paths and names
    final List<String> imagePaths = [
      'assets/images/chantelle.png',
      'assets/images/ivy.png',
      'assets/images/janey.png',
      'assets/images/jeff.png',
      'assets/images/kurt.png',
      'assets/images/oliver.png',
      'assets/images/rishika.png',
      'assets/images/taymane.png',
      'assets/images/tommy.png',
      'assets/images/tracey.png',
      'assets/images/winter.png',
    ];

    final List<String> names = [
      'Chantelle',
      'Ivy',
      'Janey',
      'Jeff',
      'Kurt',
      'Oliver',
      'Rishika',
      'Taymane',
      'Tommy',
      'Tracey',
      'Winter',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Class Videos',
          style: TextStyle(
            fontSize: 20, // Change the font size here
            color: Colors.black, // Change the text color here
            fontFamily: 'SF Pro Display', // Change the font family here
            fontWeight: FontWeight.bold, // Add font weight
          ),
        ),
        centerTitle: false, // Align the title to the left
        elevation: 0, // Remove shadow
        backgroundColor: Colors.transparent, // Make AppBar transparent
        automaticallyImplyLeading: false, // Remove the back arrow
      ),
      backgroundColor: Colors.white, // Set the background color to white
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 4 columns
            crossAxisSpacing: 5, // space between columns
            mainAxisSpacing: 5, // space between rows
            mainAxisExtent: 120, // Ensure enough height for each item
          ),
          itemCount: imagePaths.length, // Total of 12 items
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40, // diameter
                  backgroundImage: AssetImage(imagePaths[index]),
                ),
                const SizedBox(height: 2), // space between image and text
                Text(
                  names[index], // Editable text
                  style: const TextStyle(
                    fontSize: 14, // 14px font size
                    fontFamily: 'SF Pro Display', // Font family
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
