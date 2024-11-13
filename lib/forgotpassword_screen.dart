import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ForgotPassword(),
    );
  }
}

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _isButtonEnabled = _emailController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: Text(
                    'Forget password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: const TextSpan(
                    text: 'Reset password or ',
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'login',
                        style: TextStyle(color: Color(0xFFE84479)),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'create an account',
                        style: TextStyle(color: Color(0xFFE84479)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Email',
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color: _isButtonEnabled ? const Color(0xFF4146F5) : const Color(0xFF9CA3AF),
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _isButtonEnabled ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isButtonEnabled ? const Color(0xFF4146F5) : const Color(0xFF9CA3AF),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
