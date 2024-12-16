import 'package:flutter/material.dart';

class About extends StatelessWidget {
  final double fontSize;
  final double paragraphSpacing;

  // Constructor with default values for fontSize and paragraphSpacing
  About({this.fontSize = 16.0, this.paragraphSpacing = 8.0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        // Adjust the padding to include 100 pixels at the bottom
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionTitle('Vision'),
              buildSectionContent('EXPRESS • CONNECT • CONFIDENCE • CREATE'),
              buildSectionTitle('About'),
              buildSectionContent(
                  'To build confidence in individuals through the development of movement and self-expression.'),
              buildSectionContent(
                  'Movement Nation welcomes you to a positive and safe environment to explore and develop your creativity through movement. We hope to connect individuals of all backgrounds, ages and levels to come together and share a love for dance.'),
              buildSectionTitle('Location'),
              buildLocationContent('Parramatta',
                  'Our Parramatta studio is approximately 5 minutes walk from Parramatta Station and Westfield Parramatta. Take the exit next to Woolworths when exiting the station or go down the escalator next to Event Cinemas when inside Westfield. It will be a short walk straight down Church St and we are located on Level 1.'),
              buildContactInfo(),
              buildLocationContent('Hurstville',
                  'Our studio is located on Level 3 inside Wellness Department Gym which is a 5 minute walk from Hurstville Station. You can take the Forest Road exit upon leaving the station. We are situated in between Guardian Funerals and Coles Petrol Station. There is also a carpark behind our building which is 1hr free or street parking along Carrington Avenue.'),
              buildContactInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: paragraphSpacing, bottom: paragraphSpacing / 2),
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize - 2, // Adjusted font size for title
          fontWeight: FontWeight.bold,
          color: Color(0xFF9CA3AF),
          fontFamily: 'SF Pro Display',
        ),
      ),
    );
  }

  Widget buildSectionContent(String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: paragraphSpacing),
      child: Text(
        content,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.black,
          fontFamily: 'SF Pro Display',
        ),
      ),
    );
  }

  Widget buildLocationContent(String location, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          location,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'SF Pro Display',
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: paragraphSpacing),
          child: Text(
            description,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
              fontFamily: 'SF Pro Display',
            ),
          ),
        ),
      ],
    );
  }

  Widget buildContactInfo() {
    return Padding(
      padding: EdgeInsets.only(bottom: paragraphSpacing * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mobile: 0450 585 301',
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
              fontFamily: 'SF Pro Display',
            ),
          ),
          Text(
            'Email: 2023movementnation@gmail.com',
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
              fontFamily: 'SF Pro Display',
            ),
          ),
          Text(
            'Instagram: @movementnation.parramatta',
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
              fontFamily: 'SF Pro Display',
            ),
          ),
          Text(
            'Wechat: _2023movementnation',
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
              fontFamily: 'SF Pro Display',
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: About(),
  ));
}
