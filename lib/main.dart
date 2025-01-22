import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

// Socials
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'providers/user_provider.dart';

import 'createaccount_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'loading_screen.dart';
import 'classbooking_screen.dart';
import 'gallery_screen.dart';
import 'profile_screen.dart';
import 'classschedule_screen.dart';
import 'bookingdetails_screen.dart';
import 'splash_screen.dart';
import 'forgotpassword_screen.dart';
import 'resetpassword_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Firebase Initialization with options
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBHrFwQPQQmCgPfDCYLNpnutXW4CQXTq54",
        authDomain: "trial-f65c0.firebaseapp.com",
        projectId: "trial-f65c0",
        storageBucket: "trial-f65c0.appspot.com",
        messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
        appId: "1:789484622129:ios:b010b2897f3dc91b5fe010",
      ),
    );
    debugPrint("Firebase initialized successfully.");
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  // Initialize date formatting for localization
  try {
    await initializeDateFormatting();
    debugPrint("Date formatting initialized successfully.");
  } catch (e) {
    debugPrint("Error initializing date formatting: $e");
  }

  // Retrieve user details from SharedPreferences
  final userDetails = await retrieveUserData();

  // Run the app with MultiProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider()
            ..setUser(
              uid: userDetails['uid']!,
              fullName: userDetails['fullName']!,
              creditBalance: int.tryParse(userDetails['creditBalance']!) ?? 0,
            )
            ..setUserDetails(
              fullName: userDetails['fullName']!,
              phoneNumber: userDetails['phoneNumber']!,
              email: userDetails['email']!,
              profileImage: userDetails['profileImage']!,
            ),
        ),
      ],
      child: const DanceApp(),
    ),
  );
}

Future<Map<String, String>> retrieveUserData() async {
  final prefs = await SharedPreferences.getInstance();

  try {
    final uid = prefs.getString('uid') ?? "";
    final fullName = prefs.getString('fullName') ?? "Guest User";
    final creditBalance = prefs.getString('creditBalance') ?? "0";
    final phoneNumber = prefs.getString('phoneNumber') ?? "";
    final email = prefs.getString('email') ?? "";
    final profileImage = prefs.getString('profileImage') ?? 'assets/images/Avatar.png';

    debugPrint('User data retrieved from SharedPreferences: UID=$uid, FullName=$fullName');
    return {
      'uid': uid,
      'fullName': fullName,
      'creditBalance': creditBalance,
      'phoneNumber': phoneNumber,
      'email': email,
      'profileImage': profileImage,
    };
  } catch (e) {
    debugPrint('Error retrieving SharedPreferences data: $e');
    return {
      'uid': "",
      'fullName': "Guest User",
      'creditBalance': "0",
      'phoneNumber': "",
      'email': "",
      'profileImage': 'assets/images/Avatar.png',
    };
  }
}

class DanceApp extends StatelessWidget {
  const DanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dance Studio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return const Locale('en', 'US');
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return const Locale('en', 'US');
      },
      initialRoute: '/splash',
      routes: {
        '/': (context) => const LoginScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/loading': (context) => const LoadingScreen(),
        '/classbooking': (context) => BookingScreen(),
        '/gallery': (context) => const GalleryScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/splash': (context) => const SplashScreen(),
        '/createaccount': (context) => const CreateAccount(),
        '/forgotpassword': (context) => const ForgotPassword(),
      },
      onGenerateRoute: (settings) {
        try {
          if (settings.name == '/classSchedule') {
            final location = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => ClassSchedule(location: location),
            );
          } else if (settings.name == '/BookingDetails') {
            final args = settings.arguments as ClassCard;
            return MaterialPageRoute(
              builder: (context) => BookingDetails(classCard: args),
            );
          } else if (settings.name == '/reset-password') {
            final args = settings.arguments as Map<String, dynamic>?;
            final actionCode = args?['actionCode'] ?? '';

            return MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(actionCode: actionCode),
            );
          }
        } catch (e) {
          debugPrint('Error in onGenerateRoute: $e');
        }
        return null;
      },
    );
  }
}
