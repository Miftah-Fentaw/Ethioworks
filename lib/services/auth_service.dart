import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:ethioworks/models/user_model.dart';
import 'package:ethioworks/models/job_seeker_model.dart';
import 'package:ethioworks/models/employer_model.dart';

class AuthService {
  static const String _currentUserKey = 'current_user';
  static const String _usersKey = 'users';
  static const String _passwordsKey = 'passwords';
  
  final _uuid = const Uuid();

  Future<User?> signUp({
    required String email,
    required String password,
    required UserType userType,
    String? name,
    String? companyOrPersonalName,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final usersJson = prefs.getString(_usersKey) ?? '[]';
      final usersList = (jsonDecode(usersJson) as List).map((e) => e as Map<String, dynamic>).toList();
      
      if (usersList.any((u) => u['email'] == email)) {
        debugPrint('AuthService: Email already exists');
        return null;
      }

      final now = DateTime.now();
      final userId = _uuid.v4();

      User newUser;
      if (userType == UserType.jobSeeker) {
        newUser = JobSeeker(
          id: userId,
          email: email,
          name: name ?? 'User',
          createdAt: now,
          updatedAt: now,
        );
      } else {
        newUser = Employer(
          id: userId,
          email: email,
          companyOrPersonalName: companyOrPersonalName ?? 'Company',
          createdAt: now,
          updatedAt: now,
        );
      }

      usersList.add(newUser.toJson());
      await prefs.setString(_usersKey, jsonEncode(usersList));

      final passwordsJson = prefs.getString(_passwordsKey) ?? '{}';
      final passwordsMap = jsonDecode(passwordsJson) as Map<String, dynamic>;
      passwordsMap[email] = password;
      await prefs.setString(_passwordsKey, jsonEncode(passwordsMap));

      await prefs.setString(_currentUserKey, jsonEncode(newUser.toJson()));
      
      debugPrint('AuthService: User signed up successfully');
      return newUser;
    } catch (e) {
      debugPrint('AuthService: Error during signup: $e');
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final passwordsJson = prefs.getString(_passwordsKey) ?? '{}';
      final passwordsMap = jsonDecode(passwordsJson) as Map<String, dynamic>;
      
      if (passwordsMap[email] != password) {
        debugPrint('AuthService: Invalid credentials');
        return null;
      }

      final usersJson = prefs.getString(_usersKey) ?? '[]';
      final usersList = (jsonDecode(usersJson) as List).map((e) => e as Map<String, dynamic>).toList();
      
      final userJson = usersList.firstWhere(
        (u) => u['email'] == email,
        orElse: () => <String, dynamic>{},
      );

      if (userJson.isEmpty) {
        debugPrint('AuthService: User not found');
        return null;
      }

      User user;
      if (userJson['userType'] == UserType.jobSeeker.name) {
        user = JobSeeker.fromJson(userJson);
      } else {
        user = Employer.fromJson(userJson);
      }

      await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
      
      debugPrint('AuthService: User logged in successfully');
      return user;
    } catch (e) {
      debugPrint('AuthService: Error during login: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserKey);
      debugPrint('AuthService: User logged out');
    } catch (e) {
      debugPrint('AuthService: Error during logout: $e');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_currentUserKey);
      
      if (userJson == null) return null;

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      
      if (userMap['userType'] == UserType.jobSeeker.name) {
        return JobSeeker.fromJson(userMap);
      } else {
        return Employer.fromJson(userMap);
      }
    } catch (e) {
      debugPrint('AuthService: Error getting current user: $e');
      return null;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey) ?? '[]';
      final usersList = (jsonDecode(usersJson) as List).map((e) => e as Map<String, dynamic>).toList();
      
      final userExists = usersList.any((u) => u['email'] == email);
      
      if (userExists) {
        debugPrint('AuthService: Password reset email sent to $email');
        return true;
      }
      
      debugPrint('AuthService: Email not found');
      return false;
    } catch (e) {
      debugPrint('AuthService: Error during password reset: $e');
      return false;
    }
  }

  Future<void> updateCurrentUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
      
      final usersJson = prefs.getString(_usersKey) ?? '[]';
      final usersList = (jsonDecode(usersJson) as List).map((e) => e as Map<String, dynamic>).toList();
      
      final index = usersList.indexWhere((u) => u['id'] == user.id);
      if (index != -1) {
        usersList[index] = user.toJson();
        await prefs.setString(_usersKey, jsonEncode(usersList));
      }
      
      debugPrint('AuthService: User updated successfully');
    } catch (e) {
      debugPrint('AuthService: Error updating user: $e');
    }
  }
}
