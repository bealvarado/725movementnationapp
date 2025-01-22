import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'login_screen.dart';
import 'providers/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isNavigating = false; // Navigation flag

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid'); // Check if user is logged in

    if (uid != null && uid.isNotEmpty) {
      Provider.of<UserProvider>(context, listen: false).loadUserData();
      _navigateToHome();
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToHome() {
    if (_isNavigating) return;
    _isNavigating = true;
    print("Navigating to HomeScreen...");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _navigateToLogin() {
    if (_isNavigating) return;
    _isNavigating = true;
    print("Navigating to LoginScreen...");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/splashlogo.png',
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              fit: BoxFit.contain,
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 50.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffE84479)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
