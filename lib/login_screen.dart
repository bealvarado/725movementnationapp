import 'package:dance_studio/createaccount_screen.dart';
import 'package:dance_studio/forgotpassword_screen.dart';
import 'package:dance_studio/home_screen.dart';
import 'package:dance_studio/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; // Facebook
import 'package:sign_in_with_apple/sign_in_with_apple.dart'; // Apple

import 'dart:convert';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _resetUserData(); // Reset user data when login screen loads
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

    final String apiUrl = "http://localhost:3000/auth/login";

    try {
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
        final responseBody = jsonDecode(response.body);

        if (responseBody.containsKey('uid') && responseBody.containsKey('user')) {
          final uid = responseBody['uid'];
          final user = responseBody['user'];

          final fullName = user['fullName'];
          final creditBalance = user['creditBalance'];
          final phoneNumber = user['phoneNumber'] ?? '';
          final email = user['email'] ?? '';
          final profileImage = user['profileImage'] ?? 'assets/images/Avatar.png';

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('uid', uid);
          await prefs.setString('fullName', fullName);
          await prefs.setInt('creditBalance', creditBalance);

          if (profileImage.startsWith('blob:') || profileImage.contains(',')) {
            await prefs.setString('profileImage', profileImage);
          } else if (profileImage.startsWith('http')) {
            await prefs.setString('profileImage', profileImage);
          } else {
            await prefs.setString('profileImage', 'assets/images/Avatar.png');
          }

          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(
            uid: uid,
            fullName: fullName,
            creditBalance: creditBalance,
          );
          userProvider.setUserDetails(
            fullName: fullName,
            phoneNumber: phoneNumber,
            email: email,
            profileImage: profileImage,
          );

          Navigator.pushReplacementNamed(context, '/home');
        } else {
          _showErrorDialog("Invalid response from server. Missing required keys.");
        }
      } else {
        final errorMessage = jsonDecode(response.body)['error'];
        _showErrorDialog(errorMessage ?? "Invalid credentials.");
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog("Something went wrong. Please try again.");
    }
  }

  Future<void> _resetUserData() async {
  try {
    // Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    debugPrint("SharedPreferences cleared on login screen load.");

    // Clear UserProvider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.clearUser();
    debugPrint("UserProvider cleared on login screen load.");
  } catch (error) {
    debugPrint("Error resetting user data: $error");
  }
}


  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final userEmail = googleUser.email;
      final userName = googleUser.displayName ?? "Google User";
      final userProfileImage = googleUser.photoUrl ?? 'assets/images/Avatar.png';

      const defaultPhoneNumber = "";

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', googleUser.id);
      await prefs.setString('fullName', userName);
      await prefs.setString('email', userEmail);
      await prefs.setString('profileImage', userProfileImage);
      await prefs.setString('phoneNumber', defaultPhoneNumber);

      Provider.of<UserProvider>(context, listen: false).setUserDetails(
        fullName: userName,
        email: userEmail,
        profileImage: userProfileImage,
        phoneNumber: defaultPhoneNumber,
      );

      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      print("Google Sign-In Error: $error");
      _showErrorDialog("Google Sign-In failed. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleFacebookSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        final userName = userData['name'] ?? 'Facebook User';
        final userEmail = userData['email'] ?? '';
        final userProfileImage = userData['picture']['data']['url'] ?? 'assets/images/Avatar.png';

        const defaultPhoneNumber = "";

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', userData['id']);
        await prefs.setString('fullName', userName);
        await prefs.setString('email', userEmail);
        await prefs.setString('profileImage', userProfileImage);
        await prefs.setString('phoneNumber', defaultPhoneNumber);

        Provider.of<UserProvider>(context, listen: false).setUserDetails(
          fullName: userName,
          email: userEmail,
          profileImage: userProfileImage,
          phoneNumber: defaultPhoneNumber,
        );

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showErrorDialog("Facebook Sign-In failed. Please try again.");
      }
    } catch (error) {
      print("Facebook Sign-In Error: $error");
      _showErrorDialog("Facebook Sign-In failed. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final userName = credential.givenName ?? 'Apple User';
      final userEmail = credential.email ?? '';
      const defaultPhoneNumber = "";

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', credential.userIdentifier ?? "");
      await prefs.setString('fullName', userName);
      await prefs.setString('email', userEmail);
      await prefs.setString('phoneNumber', defaultPhoneNumber);
      await prefs.setString('profileImage', 'assets/images/Avatar.png');

      Provider.of<UserProvider>(context, listen: false).setUserDetails(
        fullName: userName,
        email: userEmail,
        profileImage: 'assets/images/Avatar.png',
        phoneNumber: defaultPhoneNumber,
      );

      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      print("Apple Sign-In Error: $error");
      _showErrorDialog("Apple Sign-In failed. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF4146F5)),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        child: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
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
                    text: 'Sign in with Google',
                    onPressed: _handleGoogleSignIn,
                  ),
                  const SizedBox(height: 8),
                  SocialSignInButton(
                    assetName: 'assets/images/facebook_logo.png',
                    text: 'Sign up with Facebook',
                    onPressed: _handleFacebookSignIn,
                  ),
                  const SizedBox(height: 8),
                  SocialSignInButton(
                    assetName: 'assets/images/apple_logo.png',
                    text: 'Sign up with Apple',
                    onPressed: _handleAppleSignIn,
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
        side: const BorderSide(color: Color(0xFFD0D5DD), width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display',
        ),
      ).copyWith(
        side: MaterialStateProperty.resolveWith<BorderSide>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return const BorderSide(color: Color(0xFF4146F5), width: 1);
            }
            return const BorderSide(color: Color(0xFFD0D5DD), width: 1);
          },
        ),
      ),
    );
  }
}
