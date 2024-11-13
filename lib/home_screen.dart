import 'package:flutter/material.dart';
import 'classbooking_screen.dart';
import 'gallery_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreenContent(),
    GalleryScreen(),
    BookingScreen(),
    BookingScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 2,
        title: Image.asset('assets/images/brandlogo.png', height: 40),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.image_outlined),
              label: 'Gallery',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'Book',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF4146F5),
          unselectedItemColor: const Color(0xFF9CA3AF),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Container(
                height: 240,
                margin: const EdgeInsets.only(top: 90),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/bannerimage.png'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      bottom: 66,
                      left: 16,
                      child: Text(
                        'Start your dance journey today!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const BookingScreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE84479),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'Book Class',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Courses Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Courses',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  child: const Text(
                    'See all',
                    style: TextStyle(
                      color: Color(0xFFE84479),
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 0),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CourseCard(
                    image: 'assets/images/course1.png',
                    title: 'Beginner',
                    targetClass: BookingScreen(), // Placeholder for target class
                  ),
                  CourseCard(
                    image: 'assets/images/course2.png',
                    title: 'Intermediate and Advanced',
                    targetClass: BookingScreen(), // Placeholder for target class
                  ),
                  CourseCard(
                    image: 'assets/images/course3.png',
                    title: 'Pop Dance',
                    targetClass: BookingScreen(), // Placeholder for target class
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // Upcoming Events Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upcoming Events',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  child: const Text(
                    'See all',
                    style: TextStyle(
                      color: Color(0xFFE84479),
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  EventCard(
                    image: 'assets/images/event1.png',
                    title: 'Spring Showcase',
                    date: 'Mon, Dec 3 • 11am - 5pm',
                    location: 'Parramatta Studio',
                    targetClass: BookingScreen(), // Placeholder for target class
                  ),
                  EventCard(
                    image: 'assets/images/event2.png',
                    title: 'Summer Showcase',
                    date: 'Mon, Dec 3 • 11am - 5pm',
                    location: 'Parramatta Studio',
                    targetClass: BookingScreen(), // Placeholder for target class
                  ),
                  EventCard(
                    image: 'assets/images/event3.png',
                    title: 'Kids Dance',
                    date: 'Mon, Dec 3 • 11am - 5pm',
                    location: 'Parramatta Studio',
                    targetClass: BookingScreen(), // Placeholder for target class
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String image;
  final String title;
  final Widget targetClass; // Placeholder for target class

  const CourseCard({
    super.key,
    required this.image,
    required this.title,
    required this.targetClass,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetClass),
        );
      },
      child: Container(
        width: 160,
        height: 128,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF4146F5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 160,
              height: 95,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: 'SF Pro Display',
                      ),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String image;
  final String title;
  final String date;
  final String location;
  final Widget targetClass; // Placeholder for target class

  const EventCard({
    super.key,
    required this.image,
    required this.title,
    required this.date,
    required this.location,
    required this.targetClass,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetClass),
        );
      },
      child: Container(
        width: 160, // Adjusted width for better layout
        height: 180, // Adjusted height for better layout
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
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
            Container(
              height: 95, // Adjusted height for the image
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 1, bottom: 0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15, // Adjusted font size
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SF Pro Display',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 1, bottom: 0),
              child: Text(
                date,
                style: const TextStyle(
                  fontSize: 12, // Adjusted font size
                  color: Color(0xFF9CA3AF),
                  fontFamily: 'SF Pro Display',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 1, bottom: 0),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: Color(0xFFE84479)), // Adjusted icon size
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      location,
                      style: const TextStyle(
                        fontSize: 12, // Adjusted font size
                        color: Color(0xFF9CA3AF),
                        fontFamily: 'SF Pro Display',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
