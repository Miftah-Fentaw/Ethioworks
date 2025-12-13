import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ethioworks/models/job_seeker_model.dart';
import 'package:ethioworks/models/employer_model.dart';
import 'package:ethioworks/services/employer_service.dart';

class JobSeekerService {
  static const String _usersKey = 'users';
  
  final _employerService = EmployerService();

  Future<JobSeeker?> getProfile(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey) ?? '[]';
      final usersList = (jsonDecode(usersJson) as List).map((e) => e as Map<String, dynamic>).toList();
      
      final userJson = usersList.firstWhere(
        (u) => u['id'] == id,
        orElse: () => <String, dynamic>{},
      );
      
      if (userJson.isEmpty) return null;
      
      return JobSeeker.fromJson(userJson);
    } catch (e) {
      debugPrint('JobSeekerService: Error getting profile: $e');
      return null;
    }
  }

  Future<JobSeeker?> updateProfile(JobSeeker seeker) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey) ?? '[]';
      final usersList = (jsonDecode(usersJson) as List).map((e) => e as Map<String, dynamic>).toList();
      
      final index = usersList.indexWhere((u) => u['id'] == seeker.id);
      if (index == -1) {
        debugPrint('JobSeekerService: User not found');
        return null;
      }
      
      final updatedSeeker = seeker.copyWith(updatedAt: DateTime.now());
      usersList[index] = updatedSeeker.toJson();
      
      await prefs.setString(_usersKey, jsonEncode(usersList));
      
      debugPrint('JobSeekerService: Profile updated successfully');
      return updatedSeeker;
    } catch (e) {
      debugPrint('JobSeekerService: Error updating profile: $e');
      return null;
    }
  }

  Future<bool> followCompany(String seekerId, String employerId) async {
    try {
      final seeker = await getProfile(seekerId);
      if (seeker == null) return false;
      
      if (seeker.followedCompanies.contains(employerId)) {
        debugPrint('JobSeekerService: Already following this company');
        return false;
      }
      
      final updatedFollowed = [...seeker.followedCompanies, employerId];
      await updateProfile(seeker.copyWith(followedCompanies: updatedFollowed));
      
      await _employerService.incrementFollowers(employerId);
      
      debugPrint('JobSeekerService: Company followed successfully');
      return true;
    } catch (e) {
      debugPrint('JobSeekerService: Error following company: $e');
      return false;
    }
  }

  Future<bool> unfollowCompany(String seekerId, String employerId) async {
    try {
      final seeker = await getProfile(seekerId);
      if (seeker == null) return false;
      
      if (!seeker.followedCompanies.contains(employerId)) {
        debugPrint('JobSeekerService: Not following this company');
        return false;
      }
      
      final updatedFollowed = seeker.followedCompanies.where((id) => id != employerId).toList();
      await updateProfile(seeker.copyWith(followedCompanies: updatedFollowed));
      
      await _employerService.decrementFollowers(employerId);
      
      debugPrint('JobSeekerService: Company unfollowed successfully');
      return true;
    } catch (e) {
      debugPrint('JobSeekerService: Error unfollowing company: $e');
      return false;
    }
  }

  Future<List<Employer>> getFollowedCompanies(String seekerId) async {
    try {
      final seeker = await getProfile(seekerId);
      if (seeker == null) return [];
      
      final companies = <Employer>[];
      for (final employerId in seeker.followedCompanies) {
        final employer = await _employerService.getProfile(employerId);
        if (employer != null) {
          companies.add(employer);
        }
      }
      
      return companies;
    } catch (e) {
      debugPrint('JobSeekerService: Error getting followed companies: $e');
      return [];
    }
  }
}
