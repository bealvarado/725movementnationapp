import 'package:flutter/material.dart';
import 'package:dance_studio/classschedule_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding
import 'package:provider/provider.dart';
import 'package:dance_studio/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingScreen extends StatefulWidget {
  final int initialTabIndex;

  const BookingScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true; // Loading state for fetching bookings
  List<dynamic> _bookings = []; // List of bookings fetched from backend
  String? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTabIndex);
    _fetchBookings(); // Fetch bookings on initialization
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchBookings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch UID from UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final uid = userProvider.uid;

      if (uid == null || uid.isEmpty) {
        throw Exception("User UID is missing.");
      }

      print("Fetching bookings for UID: $uid");

      // Backend URL
      const apiUrl = 'http://localhost:3000/booking'; // Replace with your backend URL
      final response = await http.get(Uri.parse('$apiUrl?uid=$uid'));

      if (response.statusCode == 200) {
        final bookings = jsonDecode(response.body);
        print("Bookings fetched: $bookings");
        setState(() {
          _bookings = bookings;
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        print("No bookings found for UID: $uid");
        setState(() {
          _bookings = [];
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch bookings. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching bookings: $error");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching bookings: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          _buildWeekdayClassContent(context),
          _buildCoursesContent(context),
          _buildHireStudioContent(context),
        ],
      ),
    );
  }

Widget _buildWeekdayClassContent(BuildContext context) {
  if (_isLoading) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  if (_bookings.isEmpty) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            const SizedBox(height: 100), // Adjusted spacing to move the button down
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4146F5),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  selectLocation(context);
                },
                child: const Text(
                  'Book a Class',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  return Column(
    children: [
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _bookings.length,
          itemBuilder: (context, index) {
            final booking = _bookings[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking['className'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${booking['date']} at ${booking['time']}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Location: ${booking['location']}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Status: ${booking['status']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: booking['status'] == 'confirmed'
                          ? Colors.green
                          : Colors.orange,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4146F5),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () {
              selectLocation(context);
            },
            child: const Text(
              'Book a Class',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    ],
  );
}



  
  Future<void> storeSelectedLocation(String location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedLocation', location);
    } catch (e) {
      throw Exception("Failed to store location.");
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
                    'Choose where you want to attend classes.',
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedLocation != null
                              ? const Color(0xFF4146F5)
                              : const Color(0xFF93A4C1),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: _selectedLocation != null
                            ? () async {
                                try {
                                  await storeSelectedLocation(_selectedLocation!);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ClassSchedule(location: _selectedLocation!),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text("Failed to store location."),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            : null,
                        child: const Text(
                          'Book',
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF9CA3AF)),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
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
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLocationOption(
    BuildContext context,
    String location,
    String imagePath,
    String label,
    Color selectedColor,
    StateSetter setState,
  ) {
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
      },
    );
  }

  Widget _buildHireStudioContent(BuildContext context) {
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
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
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          studios[index]['price']!,
                          style: const TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      studios[index]['capacity']!,
                      style: const TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 14,
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
                          // Placeholder action for button click
                          print('Hire Studio button clicked for ${studios[index]['name']}');
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
  }
}
