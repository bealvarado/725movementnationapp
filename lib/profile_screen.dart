import 'dart:convert'; // For base64Encode and base64Decode

import 'package:dance_studio/bookinghistory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dance_studio/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'accountsettings.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'about.dart';
import 'privacytermscondition.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final profileImageFromPrefs = prefs.getString('profileImage');

    setState(() {
      if (profileImageFromPrefs != null && profileImageFromPrefs.isNotEmpty) {
        if (profileImageFromPrefs.startsWith('data:image')) {
          // Base64 image
          _profileImage = profileImageFromPrefs;
        } else if (profileImageFromPrefs.startsWith('/')) {
          // File path
          _profileImage = profileImageFromPrefs;
        } else {
          // Default fallback
          _profileImage = 'assets/images/Avatar.png';
        }
      } else {
        _profileImage = 'assets/images/Avatar.png';
      }
    });

    print("Profile image loaded: $_profileImage");
  }

  Future<void> _reloadProfileImage() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final profileImage = userProvider.profileImage ?? 'assets/images/Avatar.png';

    setState(() {
      _profileImage = profileImage;
    });

    print("Profile image reloaded from UserProvider: $_profileImage");
  }

  Future<void> _showErrorDialog(String message) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    try {
      print("Logout initiated...");

      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      print("UID before clearing: ${prefs.getString('uid')}"); // Debug: UID before clearing
      await prefs.clear();
      print("SharedPreferences cleared. UID after clearing: ${prefs.getString('uid')}"); // Debug: UID after clearing

      // Clear user data in UserProvider
      Provider.of<UserProvider>(context, listen: false).clearUser();
      print("User data in UserProvider cleared.");

      // Navigate to SplashScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
      print("Navigated to SplashScreen.");
    } catch (error) {
      print("Error during logout: $error");
      await _showErrorDialog("Failed to log out. Please try again.");
    }

    print("Logout process completed.");
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final fullName = userProvider.fullName;
    final walletCredit = userProvider.creditBalance.toString();
    final profileImage = userProvider.profileImage;

    // Debugging: Log the current profile image path
    print("Profile image in UserProvider: $profileImage");

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          children: [
            const SizedBox(height: 120),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF9CA3AF),
                  width: 2.5,
                ),
              ),
              child: CircleAvatar(
                radius: 46,
                backgroundImage: userProvider.profileImage != null
                    ? (userProvider.profileImage!.startsWith('data:image')
                        ? MemoryImage(base64Decode(userProvider.profileImage!.split(',').last))
                        : AssetImage(userProvider.profileImage!) as ImageProvider)
                    : const AssetImage('assets/images/Avatar.png'),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              fullName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCustomContainers(context, walletCredit),
            const SizedBox(height: 16),
            _buildSettingsList(context, userProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomContainers(BuildContext context, String walletCredit) {
    double containerWidth = MediaQuery.of(context).size.width - 12;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPackagePlanContainer(context, containerWidth),
            const SizedBox(width: 8),
            _buildWalletCreditContainer(containerWidth, walletCredit),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInfoContainer("Total Classes", containerWidth),
            const SizedBox(width: 8),
            _buildInfoContainer("Monthly Classes", containerWidth),
            const SizedBox(width: 8),
            _buildInfoContainer("Goals", containerWidth),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsList(BuildContext context, UserProvider userProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
          _buildSettingsItem('assets/images/settings.png', "Account Settings", context, () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AccountSettings()),
            );

            // Reload profile image when coming back
            await _reloadProfileImage();
          }),
          const SizedBox(height: 20),
          _buildSettingsItem('assets/images/history.png', "Booking History", context, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookingHistory()),
            );
          }),
          const SizedBox(height: 20),
          _buildSettingsItem('assets/images/about.png', "About", context, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => About()),
            );
          }),
          const SizedBox(height: 20),
          _buildSettingsItem('assets/images/privacy.png', "Privacy, Terms and Conditions", context,
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrivacyTermsAndConditions()),
            );
          }),
          const SizedBox(height: 20),
          _buildSettingsItem('assets/images/logout.png', "Log out", context, () async {
            print("Logout initiated...");

            try {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              print("SharedPreferences cleared.");

              Provider.of<UserProvider>(context, listen: false).clearUser();
              print("User data in UserProvider cleared.");

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SplashScreen()),
              );
              print("Navigated to SplashScreen.");

              await Future.delayed(const Duration(seconds: 2), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
                print("Navigated to LoginScreen after delay.");
              });
            } catch (error) {
              print("Error during logout: $error");
              await _showErrorDialog("Failed to log out. Please try again.");
            }

            print("Logout process completed.");
          }),
        ],
      ),
    );
  }

   Widget _buildPackagePlanContainer(BuildContext context, double width) {
    return Container(
      width: width / 2 - 4,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0x0D696969),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey[300]!,
                width: 3.5,
              ),
            ),
            child: Center(
              child: SizedBox(
                width: 44,
                height: 44,
                child: Image.asset('assets/images/dance-3.png'),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Package Plan",
                  style: TextStyle(
                    fontFamily: 'SF-Pro-Display',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  child: const Text(
                    "Avail Now →",
                    style: TextStyle(
                      fontFamily: 'SF-Pro-Display',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE84479),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCreditContainer(double width, String walletCredit) {
    return Container(
      width: width / 2 - 4,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0x0D696969),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey[300]!,
                width: 3.5,
              ),
            ),
            child: Center(
              child: Text(
                "\$$walletCredit",
                style: const TextStyle(
                  fontFamily: 'SF-Pro-Display',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              "Wallet Credit",
              style: TextStyle(
                fontFamily: 'SF-Pro-Display',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
      String imagePath, String title, BuildContext context, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                imagePath,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'SF-Pro-Display',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF9CA3AF),
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContainer(String title, double width) {
    return Container(
      width: width / 3 - 5.33,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0x0D696969),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey[300]!,
                width: 2.5,
              ),
            ),
            child: const Center(
              child: Text(
                "0",
                style: TextStyle(
                  fontFamily: 'SF-Pro-Display',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'SF-Pro-Display',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
