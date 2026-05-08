import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userImageKey = 'user_image';
  static const String _usersListKey = 'registered_users';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> registerUser(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersListKey) ?? [];
    
    // Check if user already exists
    final users = usersJson.map((u) => jsonDecode(u)).toList();
    if (users.any((u) => u['email'] == email)) {
      throw Exception('User already exists');
    }

    final newUser = {
      'name': name,
      'email': email,
      'password': password,
    };
    
    usersJson.add(jsonEncode(newUser));
    await prefs.setStringList(_usersListKey, usersJson);
  }

  Future<Map<String, dynamic>?> verifyUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersListKey) ?? [];
    
    for (final uJson in usersJson) {
      final user = jsonDecode(uJson);
      if (user['email'] == email && user['password'] == password) {
        return user;
      }
    }
    return null;
  }

  Future<void> login(String email, [String? name]) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userEmailKey, email);
    if (name != null) {
      await prefs.setString(_userNameKey, name);
    }
  }

  Future<void> updateProfile(String name, String email, [String? imagePath]) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userEmailKey, email);
    if (imagePath != null) {
      await prefs.setString(_userImageKey, imagePath);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userImageKey);
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  Future<String?> getUserImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userImageKey);
  }
}
