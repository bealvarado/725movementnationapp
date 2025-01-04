import 'dart:io';
import 'dart:convert'; // For encoding/decoding image data
import 'dart:typed_data';
import 'dart:js' as js;
import 'dart:html' as html; // For Web


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart'; // For local storage
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import 'gallery_screen.dart';
import 'forgotpassword_screen.dart';
import 'changepassword_screen.dart';
import 'providers/user_provider.dart';


class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  File? _imageFile;
  String? _imageDataUrl; // Base64-encoded image for web or mobile
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isEditing = false;
  bool _isPreviewDialogOpen = false;





  @override
  void initState() {
    super.initState();
    _loadUserData(); // Fetch user data from Firestore
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Check if profileImage is already loaded
    if (userProvider.profileImage == 'assets/images/Avatar.png') {
      userProvider.loadUserData(); // Load data from SharedPreferences
      _loadUserData(); // Fetch updated data from the backend
    } else {
      _imageDataUrl = userProvider.profileImage; // Use existing profileImage
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData(); // Reload user data whenever dependencies change
  }
  

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    final String apiUrl = "http://localhost:3000/auth/account-settings";
    final String? uid = Provider.of<UserProvider>(context, listen: false).uid;

    if (uid == null || uid.isEmpty) {
      _showErrorDialog("Failed to load user data: UID is missing or invalid.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json", "uid": uid},
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);

        // Update local fields
        _usernameController.text = userData['username'] ?? 'Unknown';
        _fullNameController.text = userData['fullName'] ?? '';
        _phoneNumberController.text = userData['phoneNumber'] ?? '';
        _emailController.text = userData['email'] ?? '';

        if (userData['profileImage'] != null) {
          setState(() {
            _imageDataUrl = userData['profileImage']; // Update with the fetched profile image
            Provider.of<UserProvider>(context, listen: false).setProfileImage(userData['profileImage']);
          });
        }
      } else {
        _showErrorDialog("Failed to load user data from the backend.");
      }
    } catch (error) {
      _showErrorDialog("Error loading user data: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    final String apiUrl = "http://localhost:3000/auth/account-settings";
    final String? uid = Provider.of<UserProvider>(context, listen: false).uid;

    if (uid == null) {
      _showErrorDialog("Failed to update user data: UID is missing.");
      setState(() {
        _isLoading = false;
        _isEditing = false;
      });
      return;
    }

    try {
      final profileImageBase64 = _imageDataUrl ??
          (_imageFile != null
              ? base64Encode(await _imageFile!.readAsBytes())
              : null);

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "uid": uid,
          "username": _usernameController.text.trim(),
          "email": _emailController.text.trim(),
          "fullName": _fullNameController.text.trim(),
          "phoneNumber": _phoneNumberController.text.trim(),
          "profileImage": profileImageBase64, // Include the profile image
        }),
      );

      if (response.statusCode == 200) {
        Provider.of<UserProvider>(context, listen: false).setUserDetails(
          fullName: _fullNameController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          email: _emailController.text.trim(),
          profileImage: profileImageBase64, // Update the provider with the new image
        );

        _showChangesSavedOverlay();
      } else {
        final errorMessage = jsonDecode(response.body)['error'];
        _showErrorDialog(errorMessage ?? "Failed to update user details.");
      }
    } catch (error) {
      _showErrorDialog("Error updating user details: $error");
    } finally {
      setState(() {
        _isLoading = false;
        _isEditing = false;
      });
    }
  }

  Future<void> _updateProfilePicture() async {
    setState(() {
      _isLoading = true; // Show loading indicator while updating
    });

    final String apiUrl = "http://localhost:3000/auth/account-settings";
    final String? uid = Provider.of<UserProvider>(context, listen: false).uid;

    if (uid == null) {
      print("Debug: UID is null; cannot update profile picture.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final profileImageBase64 = _imageDataUrl ??
          (_imageFile != null ? base64Encode(await _imageFile!.readAsBytes()) : null);

      if (profileImageBase64 == null) {
        print("Debug: No image data available to update.");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "uid": uid,
          "profileImage": profileImageBase64,
        }),
      );

      if (response.statusCode == 200) {
        print("Debug: Profile picture updated successfully in backend.");

        // Update the provider
        Provider.of<UserProvider>(context, listen: false).setProfileImage(profileImageBase64);

        // Update local state for real-time UI update
        setState(() {
          _imageDataUrl = profileImageBase64; // Update local variable
        });

        print("Debug: Profile picture updated in UI.");
      } else {
        print("Debug: Failed to update profile picture. Response: ${response.body}");
      }
    } catch (error) {
      print("Debug: Error updating profile picture: $error");
    } finally {
      setState(() {
        _isLoading = false; // Stop loading indicator
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final base64Image = base64Encode(bytes);

        setState(() {
          _imageDataUrl = 'data:image/png;base64,$base64Image'; // For preview only
          _imageFile = File(pickedFile.path); // File saved for potential upload
        });

        print("Debug: Image selected for preview.");
        print("Debug: Base64 Image Data URL - $_imageDataUrl");

        // Close the existing dialog before opening a new one
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        await _showPreviewDialog(); // Open the new preview dialog
      } else {
        print("Debug: No image selected.");
      }
    } catch (e) {
      print("Debug: Error picking image: $e");
    }
  }

  Future<void> _showPreviewDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Preview Image', textAlign: TextAlign.center),
          content: _imageDataUrl != null
              ? SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.memory(base64Decode(_imageDataUrl!.split(',').last)), // Show preview
                )
              : const Text("No image selected."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                // Reset the profile image to the default avatar
                await _setDefaultProfileImage();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
            TextButton.icon(
              onPressed: _pickImage, // Open image picker again
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload'),
            ),
            TextButton(
              onPressed: () async {
                if (_imageFile != null || _imageDataUrl != null) {
                  await _updateProfilePicture(); // Trigger PUT and fetch updated data
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile picture updated successfully.')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No image selected to upload.')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _setDefaultProfileImage() async {
    setState(() {
      _isLoading = true; // Show loading indicator while updating
    });

    final String apiUrl = "http://localhost:3000/auth/account-settings";
    final String? uid = Provider.of<UserProvider>(context, listen: false).uid;

    if (uid == null) {
      print("Debug: UID is null; cannot reset profile picture.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Reset the profile image to the default avatar
      final defaultImage = 'assets/images/Avatar.png'; // Default avatar path or placeholder

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "uid": uid,
          "profileImage": defaultImage, // Send default image identifier
        }),
      );

      if (response.statusCode == 200) {
        print("Debug: Profile picture reset to default in backend.");

        // Update the provider
        Provider.of<UserProvider>(context, listen: false).setProfileImage(defaultImage);

        // Update the local state for real-time UI update
        setState(() {
          _imageDataUrl = null; // Clear the Base64 data
          _imageFile = null; // Clear any selected image
        });

        print("Debug: Profile picture reset in UI.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture reset to default.')),
        );
      } else {
        print("Debug: Failed to reset profile picture. Response: ${response.body}");
      }
    } catch (error) {
      print("Debug: Error resetting profile picture: $error");
    } finally {
      setState(() {
        _isLoading = false; // Stop loading indicator
      });
    }
  }

  Widget _buildProfileImage() {
    final userProvider = Provider.of<UserProvider>(context);
    final userProfileImage = userProvider.profileImage;

    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey[200],
      backgroundImage: userProfileImage != null && userProfileImage.isNotEmpty
          ? (userProfileImage.startsWith('data:image') 
              ? MemoryImage(base64Decode(userProfileImage.split(',').last))
              : NetworkImage('$userProfileImage?timestamp=${DateTime.now().millisecondsSinceEpoch}')) // Add unique timestamp
          : const AssetImage('assets/images/Avatar.png') as ImageProvider,
    );
  }



  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showChangesSavedOverlay() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes Saved', textAlign: TextAlign.center),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color pinkColor = Color(0xFFE84479);
    const Color backgroundColor = Color(0xFFF8F8F8);

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
                      _buildProfileImage(),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: _showPreviewDialog,
                            icon: const Icon(Icons.edit, color: pinkColor),
                            label: const Text(
                              'Edit Image',
                              style: TextStyle(color: pinkColor),
                            ),
                          ),
                        ],
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
                      _buildEditableRow('Username', _usernameController, _isEditing),
                      _buildEditableRow('Full name', _fullNameController, _isEditing),
                      _buildEditableRow('Phone Number', _phoneNumberController, _isEditing),
                      _buildEditableRow('Email', _emailController, _isEditing),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      child: const Text("Edit"),
                    ),
                    ElevatedButton(
                      onPressed: _isEditing ? _updateUserDetails : null,
                      child: const Text("Save Changes"),
                    ),
                  ],
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                      );
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
                    leading: Image.asset(
                      'assets/images/membership.png',
                      width: 36,
                      height: 36,
                    ),
                    title: const Text('Get a Membership'),
                    trailing: const Text(
                      'Avail Now →',
                      style: TextStyle(color: pinkColor),
                    ),
                    onTap: () {
                      // Handle get membership
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

  Widget _buildEditableRow(String title, TextEditingController controller, bool editable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
            child: TextField(
              controller: controller,
              enabled: editable,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}