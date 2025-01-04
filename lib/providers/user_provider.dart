import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // For NetworkAssetBundle

import 'dart:convert';
import 'dart:typed_data';


class UserProvider with ChangeNotifier {
  String _uid = "";
  String _fullName = "Guest User";
  int _creditBalance = 0;
  String _phoneNumber = "";
  String _email = "";
  String _username = ""; // Added username field
  String? _profileImage; // Added profile image field

  // Getters
  String get uid => _uid;
  String get fullName => _fullName;
  int get creditBalance => _creditBalance;
  String get phoneNumber => _phoneNumber;
  String get email => _email;
  String get username => _username; // Added getter for username
  String? get profileImage =>
      _profileImage ?? 'assets/images/Avatar.png'; // Default fallback

  // Setters
  void setUser({
    required String uid,
    required String fullName,
    required int creditBalance,
  }) async {
    _uid = uid;
    _fullName = fullName;
    _creditBalance = creditBalance;
    await _saveToSharedPreferences('uid', uid);
    await _saveToSharedPreferences('fullName', fullName);
    await _saveToSharedPreferences(
        'creditBalance', creditBalance.toString());
    notifyListeners();
  }

  void setUserDetails({
    required String fullName,
    required String phoneNumber,
    required String email,
    String? profileImage,
  }) {
    _fullName = fullName;
    _phoneNumber = phoneNumber;
    _email = email;

    if (profileImage != null) {
      _profileImage = profileImage;
    }

    notifyListeners();
  }


  void setUsername(String username) async {
    _username = username;
    await _saveToSharedPreferences('username', username);
    notifyListeners();
  }

  void setProfileImage(String profileImageBase64) async {
    _profileImage = profileImageBase64;

    print("Debug: Profile image updated in UserProvider - $_profileImage");

    await _saveToSharedPreferences('profileImage', _profileImage!);
    notifyListeners(); // Notify listeners for immediate UI update
  }

  void setCreditBalance(int balance) async {
    _creditBalance = balance;
    await _saveToSharedPreferences('creditBalance', balance.toString());
    notifyListeners();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _uid = prefs.getString('uid') ?? "";
    _fullName = prefs.getString('fullName') ?? "Guest User";
    _creditBalance = int.tryParse(prefs.getString('creditBalance') ?? "0") ?? 0;
    _phoneNumber = prefs.getString('phoneNumber') ?? "";
    _email = prefs.getString('email') ?? "";
    _username = prefs.getString('username') ?? "";

    final profileImageFromPrefs = prefs.getString('profileImage');
    if (profileImageFromPrefs != null && profileImageFromPrefs.isNotEmpty) {
      _profileImage = profileImageFromPrefs;
    } else {
      _profileImage = 'assets/images/Avatar.png';
    }
    print("Loaded profileImage in UserProvider: $_profileImage"); // Debugging
    notifyListeners();
  }


  void clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _uid = "";
    _fullName = "Guest User";
    _creditBalance = 0;
    _phoneNumber = "";
    _email = "";
    _username = "";
    _profileImage = 'assets/images/Avatar.png'; // Reset profile image
    print("User data cleared and reset to default.");
    notifyListeners();
  }


  Future<void> _saveToSharedPreferences(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}
