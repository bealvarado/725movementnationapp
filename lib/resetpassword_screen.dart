import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String actionCode;

  const ResetPasswordScreen({Key? key, required this.actionCode}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showMessageDialog('Error', 'Both fields are required.');
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessageDialog('Error', 'Passwords do not match.');
      return;
    }

    if (!_isValidPassword(newPassword)) {
      _showMessageDialog(
        'Error',
        'Password must be at least 8 characters long, contain at least one uppercase letter, one lowercase letter, one number, and one special character.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: widget.actionCode,
        newPassword: newPassword,
      );

      _showMessageDialog(
        'Success',
        'Password reset successful. You can now log in with your new password.',
        redirect: true,
      );
    } catch (e) {
      _showMessageDialog(
        'Error',
        'Failed to reset password. Please try again. $e',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isValidPassword(String password) {
    final passwordRegex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&-_=+,.<>?:;#^])[A-Za-z\d@$!%*?&-_=+,.<>?:;#^]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  void _showMessageDialog(String title, String message, {bool redirect = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (redirect) {
                Navigator.pop(context); // Navigate back after success
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _resetPassword,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color(0xFF4146F5),
                    ),
                    child: const Text('Reset Password'),
                  ),
          ],
        ),
      ),
    );
  }
}
