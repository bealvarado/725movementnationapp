import 'package:flutter/material.dart';
import 'package:dance_studio/classschedule_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For jsonEncode

class BookingScreen extends StatefulWidget {
  final int initialTabIndex;

  const BookingScreen({super.key, this.initialTabIndex = 0});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isBookingComplete = false;
  String? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF4146F5),
              unselectedLabelColor: const Color(0xFF9CA3AF),
              indicatorColor: const Color(0xFF4146F5),
              tabs: const [
                Tab(text: 'Weekday Class'),
                Tab(text: 'Courses'),
                Tab(text: 'Hire Studio'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _isBookingComplete ? _buildBookingSummary(context) : _buildWeekdayClassContent(context),
          _buildCoursesContent(context),
          _buildHireStudioContent(context),
        ],
      ),
    );
  }

  Widget _buildWeekdayClassContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 120.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              width: 200,
              height: 200,
              child: Center(
                child: Image(
                  image: AssetImage('assets/images/BCempty_state.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Upcoming Booking',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontFamily: 'SF Pro Display',
              ),
            ),
            const Text(
              'Book your first class today!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'SF Pro Display',
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const Color(0xFF4146F5);
                        }
                        return const Color(0xFF4146F5);
                      },
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 50),
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white,
                    ),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    selectLocation(context);
                  },
                  child: const Text('Book a Class'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addBooking(String name, String location, String time) async {
    final url = Uri.parse('http://<your-server-ip>:5000/add-booking');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'location': location, 'time': time}),
      );

      if (response.statusCode == 200) {
        // Handle success
        print('Booking added successfully!');
        setState(() {
          _isBookingComplete = true;
        });
      } else {
        // Handle error
        print('Failed to add booking: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget _buildBookingSummary(BuildContext context) {
    return const Center(
      child: Text(
        'Booking Summary',
        style: TextStyle(
          fontSize: 24,
          fontFamily: 'SF Pro Display',
        ),
      ),
    );
  }

Widget _buildCoursesContent(BuildContext context) {
  final courses = [
    {'course': 'Kids Class', 'image': 'assets/images/kidscourse.png'},
    {'course': 'Beginner Course', 'image': 'assets/images/beginnercourse.png'},
    {'course': 'Intermediate and Advanced Courses', 'image': 'assets/images/intcourse.png'},
    {'course': 'Pop up / International Workshops', 'image': 'assets/images/popupcourse.png'},
  ];

  return ListView.builder(
    padding: const EdgeInsets.all(16.0),
    itemCount: courses.length,
    itemBuilder: (context, index) {
      try {
        return Container(
          height: 85,
          margin: const EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.asset(
                  courses[index]['image']!,
                  width: 140,
                  height: 95,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    courses[index]['course']!,
                    style: const TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ],
          ),
        );
      } catch (e) {
        print('Error building course item: $e');
        return const SizedBox.shrink(); // Return an empty widget on error
      }
    },
  );
}

Widget _buildHireStudioContent(BuildContext context) {
  try {
    final studios = [
      {
        'name': 'Big Studio',
        'image': 'assets/images/bigstudio.png',
        'price': '\$90 per hour',
        'capacity': 'Fits approx 30-35ppl',
      },
      {
        'name': 'Small Studio',
        'image': 'assets/images/smallstudio.png',
        'price': '\$50 per hour',
        'capacity': 'Fits approx 12-15ppl',
      },
    ];

    // Debugging: Check if studios list is populated
    print('Studios list length: ${studios.length}');

    if (studios.isEmpty) {
      return const Center(
        child: Text(
          'No studios available',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'SF Pro Display',
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: studios.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                child: Image.asset(
                  studios[index]['image']!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          studios[index]['name']!,
                          style: const TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.bold,
                            fontSize: 18, // Change font size if needed
                          ),
                        ),
                        Text(
                          studios[index]['price']!,
                          style: const TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.bold,
                            fontSize: 18, // Change font size if needed
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      studios[index]['capacity']!,
                      style: const TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 14, // Change font size if needed
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF4146F5),
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          // Handle hire studio action
                        },
                        child: const Text('Hire Studio'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  } catch (e) {
    print('Error building studio content: $e');
    return const Center(
      child: Text(
        'Error loading studios',
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'SF Pro Display',
          color: Colors.red,
        ),
      ),
    );
  }
}



  void selectLocation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                'Choose Location',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Choose where do you want to attend classes.',
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLocationOption(
                    context,
                    'Parramatta',
                    'assets/images/BlueLogo.png',
                    'Parramatta Studio',
                    const Color(0xFF4146F5),
                    setState,
                  ),
                  const SizedBox(height: 20),
                  _buildLocationOption(
                    context,
                    'Hurstville',
                    'assets/images/RedLogo.png',
                    'Hurstville Studio',
                    const Color(0xFFE84479),
                    setState,
                  ),
                ],
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return const Color(0xFF4146F5);
                          }
                          return _selectedLocation != null
                              ? const Color(0xFF4146F5)
                              : const Color(0xFF93A4C1);
                        },
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        const Size(double.infinity, 50),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SF Pro Display',
                          fontSize: 16,
                        ),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    // Inside the onPressed callback of the 'Book' button in selectLocation method
                    onPressed: _selectedLocation != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClassSchedule(location: _selectedLocation!),
                              ),
                            );
                          }
                        : null,
                    child: const Text(
                      'Book',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all<BorderSide>(
                          const BorderSide(color: Color(0xFF9CA3AF)),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                          const Size(double.infinity, 50),
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.black,
                        ),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SF Pro Display',
                            fontSize: 16,
                          ),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLocationOption(BuildContext context, String location, String imagePath, String label, Color selectedColor, StateSetter setState) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLocation = location;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedLocation == location ? selectedColor : const Color(0xFF9CA3AF),
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 73,
              height: 54,
              padding: const EdgeInsets.all(2.0),
              child: Image(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}