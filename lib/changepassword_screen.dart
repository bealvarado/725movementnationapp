import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

import 'providers/user_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _reenterPasswordController =
      TextEditingController();

  String? _uid;
  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureReenterPassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUserData());
  }

  Future<void> _loadUserData() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.uid == null || userProvider.uid!.isEmpty) {
        throw Exception("UID is missing or invalid.");
      }
      setState(() {
        _uid = userProvider.uid;
      });
      debugPrint("Debug: UID fetched from UserProvider: $_uid");
    } catch (error) {
      debugPrint("Error loading user data: $error");
      await _showErrorDialog("Failed to load user data: UID is missing or invalid.");
      Navigator.pop(context); // Go back to the previous screen
    }
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus(); // Ensure input focus is cleared

    setState(() {
      _isLoading = true;
    });

    // Validate UID before making the API call
    if (_uid == null || _uid!.isEmpty) {
      await _showErrorDialog("UID is missing. Please log in again.");
      return;
    }

    const String apiUrl = "http://localhost:3000/auth/change-password";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "uid": _uid,
          "currentPassword": _currentPasswordController.text,
          "newPassword": _newPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        await _showSuccessDialog("Password updated successfully!");
      } else {
        final errorMessage = jsonDecode(response.body)['error'] ?? "Failed to change password.";
        await _showErrorDialog(errorMessage);
      }
    } catch (error) {
      await _showErrorDialog("Something went wrong. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showErrorDialog(String message) async {
    FocusScope.of(context).unfocus(); // Clear input focus
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
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

  Future<void> _showSuccessDialog(String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                debugPrint("Success dialog dismissed.");
                Navigator.of(context).pop(); // Dismiss the dialog
                Navigator.of(context).pop(); // Return to AccountSettings screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Enter your current password and set a new one.",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      controller: _currentPasswordController,
                      labelText: "Current Password",
                      obscureText: _obscureCurrentPassword,
                      onToggle: () {
                        setState(() {
                          _obscureCurrentPassword = !_obscureCurrentPassword;
                        });
                      },
                      validator: (value) =>
                          value == null || value.isEmpty ? "This field is required" : null,
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordFieldWithQuestionMark(
                      controller: _newPasswordController,
                      labelText: "New Password",
                      obscureText: _obscureNewPassword,
                      onToggle: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                      onQuestionMarkPressed: () {
                        _showErrorDialog(
                          'Your password must meet the following requirements:\n\n'
                          '• At least 8 characters long\n'
                          '• Include at least 1 uppercase letter\n'
                          '• Include at least 1 lowercase letter\n'
                          '• Include at least 1 number\n'
                          '• Include at least 1 special character (e.g., @, #, \$, %)',
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required";
                        }
                        if (!RegExp(
                                r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&-_=+,.<>?:;#^])[A-Za-z\d@$!%*?&-_=+,.<>?:;#^]{8,}$')
                            .hasMatch(value)) {
                          return "Invalid password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      controller: _reenterPasswordController,
                      labelText: "Re-enter New Password",
                      obscureText: _obscureReenterPassword,
                      onToggle: () {
                        setState(() {
                          _obscureReenterPassword = !_obscureReenterPassword;
                        });
                      },
                      validator: (value) =>
                          value != _newPasswordController.text ? "Passwords do not match" : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _changePassword,
                      child: const Text("Change Password"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: (_) {
        if (_formKey.currentState != null) {
          _formKey.currentState!.validate();
        }
      },
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggle,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordFieldWithQuestionMark({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    required VoidCallback onToggle,
    required VoidCallback onQuestionMarkPressed,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: (_) {
        if (_formKey.currentState != null) {
          _formKey.currentState!.validate();
        }
      },
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Password Restrictions"),
                      content: const Text(
                        'Your password must meet the following requirements:\n\n'
                        '• At least 8 characters long\n'
                        '• Include at least 1 uppercase letter\n'
                        '• Include at least 1 lowercase letter\n'
                        '• Include at least 1 number\n'
                        '• Include at least 1 special character (e.g., @, #, \$, %)',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: onToggle,
            ),
          ],
        ),
      ),
      validator: validator,
    );
  }

}
