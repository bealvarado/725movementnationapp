import 'package:dance_studio/privacytermscondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:dance_studio/home_screen.dart';
import 'package:dance_studio/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF4146F5),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontFamily: 'SF Pro Display', fontWeight: FontWeight.bold, fontSize: 24),
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: const CreateAccount(),
    );
  }
}

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController(text: '+61');
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reenterPasswordController = TextEditingController();

  // Placeholder for backend data
  final Set<String> _takenEmails = {'example@example.com'}; // Example taken emails
  final Set<String> _takenPhoneNumbers = {'+61123456789'}; // Example taken phone numbers

  void _checkFormValidity() {
    setState(() {
      _isButtonEnabled = _formKey.currentState?.validate() ?? false;
    });
  }

  Future<void> _handleSignUp() async {
    setState(() {
      _isLoading = true;
    });

    final String apiUrl = "http://localhost:3000/auth/signup";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": _emailController.text,
        "password": _passwordController.text,
        "fullName": _fullNameController.text,
        "phoneNumber": _phoneNumberController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      _showSuccessDialog("Account created successfully!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      final errorMessage = jsonDecode(response.body)['error'];
      _showErrorDialog(errorMessage ?? "Something went wrong.");
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

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Success"),
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

  void _showLoginConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to login?'),
          content: const Text('Changes made in creating an account will not be saved.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction, // Validate on user interaction
              onChanged: _checkFormValidity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40), // Padding before "Create an account"
                  const Text('Create an account', style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      text: 'Enter your account details below or ',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontFamily: 'SF Pro Display',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'login',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600, // Semi-bold
                            color: Color(0xFFE84479), // Pink
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFFE84479), // Pink underline
                            fontFamily: 'SF Pro Display',
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _showLoginConfirmationDialog,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  _buildTextField('Full name', controller: _fullNameController, validator: null),
                  const SizedBox(height: 22),
                  _buildTextField('Phone Number', controller: _phoneNumberController, validator: _validatePhoneNumber, keyboardType: TextInputType.number),
                  const SizedBox(height: 22),
                  _buildTextField('Email', controller: _emailController, validator: _validateEmail),
                  const SizedBox(height: 22),
                  _buildPasswordField(),
                  const SizedBox(height: 22),
                  _buildReenterPasswordField(),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: 'By continuing you agree to the Movement Nations ',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontFamily: 'SF Pro Display',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'terms of service ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600, // Semi-bold
                            color: Color(0xFFE84479), // Pink
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFFE84479), // Pink underline
                            fontFamily: 'SF Pro Display',
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PrivacyTermsAndConditions()),
                              );
                            },
                        ),
                        const TextSpan(
                          text: 'and ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        TextSpan(
                          text: 'privacy policy',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600, // Semi-bold
                            color: Color(0xFFE84479), // Pink
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFFE84479), // Pink underline
                            fontFamily: 'SF Pro Display',
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PrivacyTermsAndConditions()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0), // 100px padding from the bottom
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 32, // Match the width of the input fields
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const Color(0xFF4146F5); // Background color when pressed
                        }
                        return _isButtonEnabled
                            ? const Color(0xFF4146F5) // Default background color when enabled
                            : const Color(0xFF93A4C1); // Background color when disabled
                      },
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 50),
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white, // Text color
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0), // 4px rounded border
                      ),
                    ),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(
                        fontWeight: FontWeight.w600, // Semi-bold
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ),
                  onPressed: _isButtonEnabled ? _handleSignUp : null,
                  child: const Text('Sign Up'), // Updated text to "Sign Up"
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3), // Black overlay with 30% opacity
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFE84479), // Pink color for loading indicator
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, {required TextEditingController controller, String? Function(String?)? validator, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: Color(0xFF9CA3AF), width: 4.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: Color(0xFF4146F5), width: 4.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return validator != null ? validator(value) : null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: Color(0xFF9CA3AF), width: 4.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: Color(0xFF4146F5), width: 4.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget _buildReenterPasswordField() {
    return TextFormField(
      controller: _reenterPasswordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Re-enter Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: Color(0xFF9CA3AF), width: 4.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: Color(0xFF4146F5), width: 4.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!value.startsWith('+61')) {
      return 'Phone number must start with +61';
    }
    if (value.length != 12 || !RegExp(r'^\+61\d{9}$').hasMatch(value)) { // +61 followed by 9 digits
      return 'Phone number must be 9 digits long';
    }
    // Placeholder for backend validation
    if (_takenPhoneNumbers.contains(value)) {
      return 'Phone number already taken';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    // Placeholder for backend validation
    if (_takenEmails.contains(value)) {
      return 'Email already taken';
    }
    return null;
  }
}
