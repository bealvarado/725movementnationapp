import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  File? _imageFile;
  final TextEditingController _usernameController = TextEditingController(text: 'beadancer');
  final TextEditingController _fullNameController = TextEditingController(text: 'Bea Alvarado');
  final TextEditingController _phoneNumberController = TextEditingController(text: '+61 412 345 678');
  final TextEditingController _emailController = TextEditingController(text: '12301095@students.koi.edu.au');
  bool _isLoading = false;

  // Function to pick an image from the gallery or camera
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _updateAccountSettings(); // Save changes when image is picked
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _updateAccountSettings() async {
    setState(() {
      _isLoading = true;
    });

    final String apiUrl = "http://localhost:3000/auth/account-settings";
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "uid": "user-id-placeholder", // Replace with actual user UID
        "email": _emailController.text,
        "fullName": _fullNameController.text,
        "phoneNumber": _phoneNumberController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      _showChangesSavedOverlay();
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

  void _showChangesSavedOverlay() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          width: 200, // Fixed width for the overlay
          alignment: Alignment.center, // Center the text within the container
          child: const Text(
            'Changes Saved',
            textAlign: TextAlign.center, // Center the text
            style: TextStyle(color: Colors.white, fontSize: 16), // Changeable text size
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Solid black color
        elevation: 0, // Remove shadow
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.25, vertical: MediaQuery.of(context).size.height * 0.4), // Center the SnackBar
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define colors
    const Color pinkColor = Color(0xFFE84479);
    const Color backgroundColor = Color(0xFFF8F8F8);
    const Color underlineColor = Color(0xFFDADADA);
    const Color activeUnderlineColor = Color(0xFF4146F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Account Settings'),
      ),
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).unfocus(); // Dismiss the keyboard
            },
            child: ListView(
              padding: const EdgeInsets.all(10.0),
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!)
                            : const AssetImage('assets/images/Avatar.png') as ImageProvider,
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickImage,
                        child: const Text(
                          'Upload image',
                          style: TextStyle(color: pinkColor, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Username', _usernameController, underlineColor, activeUnderlineColor),
                      _buildInfoRow('Full name', _fullNameController, underlineColor, activeUnderlineColor),
                      _buildInfoRow('Phone Number', _phoneNumberController, underlineColor, activeUnderlineColor),
                      _buildInfoRow('Email', _emailController, underlineColor, activeUnderlineColor),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: ListTile(
                    title: const Text('Change Password'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Handle action for change password
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: Image.asset(
                        'assets/images/membership.png',
                        width: 36,
                        height: 36,
                      ),
                    ),
                    title: const Text('Get a Membership'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Avail Now →',
                          style: TextStyle(color: pinkColor, fontSize: 16),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Handle action for membership
                    },
                  ),
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
    );
  }

  Widget _buildInfoRow(String title, TextEditingController controller, Color underlineColor, Color activeUnderlineColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      _updateAccountSettings(); // Save changes when focus is lost
                    }
                  },
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: underlineColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: activeUnderlineColor),
                      ),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
