import 'package:dance_studio/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

void main() => runApp(const MaterialApp(home: LoginScreen()));

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonEnabled = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'SF Pro Display',
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
                            MaterialPageRoute(builder: (context) => const SamplePage()),
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
                    borderSide: BorderSide(color: Color(0xFF4146F5)), // Blue
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
                    borderSide: BorderSide(color: Color(0xFF4146F5)), // Blue
                  ),
                  suffixIcon: Icon(Icons.visibility),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color(0xFF4146F5); // Background color when pressed
                      }
                      return _isButtonEnabled
                          ? const Color(0xFF4146F5) // Default background color when enabled
                          : const Color(0xFF93A4C1); // Background color when disabled
                    },
                  ),
                  minimumSize: WidgetStateProperty.all<Size>(
                    const Size(double.infinity, 50),
                  ),
                  foregroundColor: WidgetStateProperty.all<Color>(
                    Colors.white, // Text color
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0), // 4px rounded border
                    ),
                  ),
                  textStyle: WidgetStateProperty.all<TextStyle>(
                    const TextStyle(
                      fontWeight: FontWeight.w600, // Semi-bold
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                ),
                onPressed: _isButtonEnabled
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      }
                    : null,
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 16),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Forgot Password',
                    style: const TextStyle(
                      color: Color(0xFFE84479), // Pink
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFFE84479), // Pink underline
                      fontWeight: FontWeight.w600, // Semi-bold
                      fontSize: 16,
                      fontFamily: 'SF Pro Display',
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SamplePage()),
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
        side: WidgetStateProperty.resolveWith<BorderSide>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return const BorderSide(color: Color(0xFF4146F5), width: 1); // Blue outline when pressed
            }
            return const BorderSide(color: Color(0xFFD0D5DD), width: 1); // Default gray outline
          },
        ),
      ),
    );
  }
}

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Page'),
      ),
      body: const Center(
        child: Text('This is a sample page.'),
      ),
    );
  }
}
