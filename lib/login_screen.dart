import 'package:dance_studio/createaccount_screen.dart';
import 'package:dance_studio/forgotpassword_screen.dart';
import 'package:dance_studio/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MaterialApp(home: LoginScreen()));

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateInputs);
    _passwordController.addListener(_validateInputs);
  }

  void _validateInputs() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    final String apiUrl = "http://localhost:3000/auth/login"; // Replace with your API URL
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": _emailController.text,
        "password": _passwordController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      // Navigate to HomeScreen on successful login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      final errorMessage = jsonDecode(response.body)['error'];
      _showErrorDialog(errorMessage ?? "Invalid credentials.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'SF Pro Display',
                      letterSpacing: -2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      text: 'Login below or ',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontFamily: 'SF Pro Display',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'create an account',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE84479),
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFFE84479),
                            fontFamily: 'SF Pro Display',
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const CreateAccount()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email address',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF4146F5)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF4146F5)),
                      ),
                      suffixIcon: Icon(Icons.visibility),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return const Color(0xFF4146F5);
                          }
                          return _isButtonEnabled
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                    ),
                    onPressed: _isButtonEnabled ? _handleSignIn : null,
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Forgot Password',
                        style: const TextStyle(
                          color: Color(0xFFE84479),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFFE84479),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: 'SF Pro Display',
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ForgotPassword()),
                            );
                          },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SocialSignInButton(
                    assetName: 'assets/images/google_logo.png',
                    text: 'Sign up with Google',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  SocialSignInButton(
                    assetName: 'assets/images/facebook_logo.png',
                    text: 'Sign up with Facebook',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  SocialSignInButton(
                    assetName: 'assets/images/apple_logo.png',
                    text: 'Sign up with Apple',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SocialSignInButton extends StatelessWidget {
  final String assetName;
  final String text;
  final VoidCallback onPressed;

  const SocialSignInButton({
    super.key,
    required this.assetName,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Image.asset(
        assetName,
        height: 24,
        width: 24,
      ),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: Color(0xFFD0D5DD), width: 1), // Gray outline
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0), // 4px rounded border
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600, // Semi-bold
          fontFamily: 'SF Pro Display',
        ),
      ).copyWith(
        side: MaterialStateProperty.resolveWith<BorderSide>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return const BorderSide(color: Color(0xFF4146F5), width: 1); // Blue outline when pressed
            }
            return const BorderSide(color: Color(0xFFD0D5DD), width: 1); // Default gray outline
          },
        ),
      ),
    );
  }
}
