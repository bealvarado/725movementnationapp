import 'package:dance_studio/createaccount_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'login_screen.dart';
import 'home_screen.dart';
import 'loading_screen.dart';
import 'classbooking_screen.dart';
import 'gallery_screen.dart';
import 'profile_screen.dart';
import 'classschedule_screen.dart';
import 'bookingdetails_screen.dart';
import 'splash_screen.dart';

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
      initialRoute: '/splash',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/loading': (context) => const LoadingScreen(),
        '/classbooking': (context) => const BookingScreen(),
        '/gallery': (context) => const GalleryScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/classSchedule': (context) => const ClassSchedule(),
        '/splash': (context) => const SplashScreen(),
        '/createaccount': (context) => const CreateAccount(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/BookingDetails') {
          final args = settings.arguments as ClassCard;
          return MaterialPageRoute(
            builder: (context) => BookingDetails(classCard: args),
          );
        }
        return null;
      },
    );
  }
}
