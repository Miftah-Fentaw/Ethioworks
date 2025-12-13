import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ethioworks/models/employer_model.dart';

class EmployerService {
  static const String _usersKey = 'users';

  Future<Employer?> getProfile(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey) ?? '[]';
      final usersList = (jsonDecode(usersJson) as List).map((e) => e as Map<String, dynamic>).toList();
      
      final userJson = usersList.firstWhere(
        (u) => u['id'] == id,
        orElse: () => <String, dynamic>{},
      );
      
      if (userJson.isEmpty) return null;
      
      return Employer.fromJson(userJson);
    } catch (e) {
      debugPrint('EmployerService: Error getting profile: $e');
      return null;
    }
  }

  Future<Employer?> updateProfile(Employer employer) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey) ?? '[]';
      final usersList = (jsonDecode(usersJson) as List).map((e) => e as Map<String, dynamic>).toList();
      
      final index = usersList.indexWhere((u) => u['id'] == employer.id);
      if (index == -1) {
        debugPrint('EmployerService: User not found');
        return null;
      }
      
      final updatedEmployer = employer.copyWith(updatedAt: DateTime.now());
      usersList[index] = updatedEmployer.toJson();
      
      await prefs.setString(_usersKey, jsonEncode(usersList));
      
      debugPrint('EmployerService: Profile updated successfully');
      return updatedEmployer;
    } catch (e) {
      debugPrint('EmployerService: Error updating profile: $e');
      return null;
    }
  }

  Future<void> incrementFollowers(String employerId) async {
    try {
      final employer = await getProfile(employerId);
      if (employer == null) return;
      
      await updateProfile(employer.copyWith(followers: employer.followers + 1));
      
      debugPrint('EmployerService: Followers incremented');
    } catch (e) {
      debugPrint('EmployerService: Error incrementing followers: $e');
    }
  }

  Future<void> decrementFollowers(String employerId) async {
    try {
      final employer = await getProfile(employerId);
      if (employer == null) return;
      
      final newFollowers = employer.followers > 0 ? employer.followers - 1 : 0;
      await updateProfile(employer.copyWith(followers: newFollowers));
      
      debugPrint('EmployerService: Followers decremented');
    } catch (e) {
      debugPrint('EmployerService: Error decrementing followers: $e');
    }
  }

  Future<List<Employer>> getAllEmployers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey) ?? '[]';
      final usersList = (jsonDecode(usersJson) as List).map((e) => e as Map<String, dynamic>).toList();
      
      final employers = <Employer>[];
      for (final json in usersList) {
        try {
          if (json['userType'] == 'employer') {
            employers.add(Employer.fromJson(json));
          }
        } catch (e) {
          debugPrint('EmployerService: Skipping corrupted employer: $e');
        }
      }
      
      return employers;
    } catch (e) {
      debugPrint('EmployerService: Error getting all employers: $e');
      return [];
    }
  }
}
