import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'gallery_screen.dart';
import 'classbooking_screen.dart';
import 'profile_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavBar createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const GalleryScreen(),
    const BookingScreen(),
    const BookingScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Book',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF4146F5),
        unselectedItemColor: const Color(0xFF9CA3AF),
        onTap: _onItemTapped,
      ),
    );
  }
}

class ClassBookingScreen {
}
