import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'login_screen.dart'; // Import the LoginScreen
import 'home_screen.dart'; // Import the HomeScreen
import 'loading_screen.dart'; // Import the LoadingScreen
import 'classbooking_screen.dart'; // Import the BookingScreen
import 'gallery_screen.dart'; // Import the GalleryScreen
import 'profile_screen.dart'; // Import the ProfileScreen
import 'classschedule_screen.dart'; // Import the ClassScheduleScreen
import 'bookingdetails_screen.dart'; // Import the BookingDetails screen

void main() {
  initializeDateFormatting().then((_) => runApp(const DanceApp()));
}

class DanceApp extends StatelessWidget {
  const DanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dance Studio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        // Add other supported locales here
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/loading': (context) => const LoadingScreen(),
        '/classbooking': (context) => const BookingScreen(),
        '/gallery': (context) => const GalleryScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/classSchedule': (context) => const ClassSchedule(),
        '/BookingDetails': (context) => const BookingDetails(), // Add the BookingDetails route
      },
    );
  }
}
