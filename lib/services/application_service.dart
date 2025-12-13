import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:ethioworks/models/application_model.dart';

class ApplicationService {
  static const String _applicationsKey = 'applications';
  
  final _uuid = const Uuid();

  Future<Application?> submitApplication(Application application) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final applications = await _getAllApplications();
      
      final existing = applications.firstWhere(
        (app) => app.userId == application.userId && app.jobId == application.jobId,
        orElse: () => Application(
          id: '',
          coverLetter: '',
          portfolioLinks: [],
          resumeLink: '',
          telegramUsername: '',
          email: '',
          phoneNo: '',
          jobId: '',
          userId: '',
          applicantName: '',
          createdAt: DateTime.now(),
        ),
      );
      
      if (existing.id.isNotEmpty) {
        debugPrint('ApplicationService: User already applied to this job');
        return null;
      }
      
      final newApplication = application.copyWith(
        id: _uuid.v4(),
        createdAt: DateTime.now(),
      );
      
      applications.add(newApplication);
      
      await prefs.setString(_applicationsKey, jsonEncode(applications.map((a) => a.toJson()).toList()));
      
      debugPrint('ApplicationService: Application submitted successfully');
      return newApplication;
    } catch (e) {
      debugPrint('ApplicationService: Error submitting application: $e');
      return null;
    }
  }

  Future<List<Application>> getApplicationsByJob(String jobId) async {
    try {
      final applications = await _getAllApplications();
      return applications.where((app) => app.jobId == jobId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('ApplicationService: Error getting applications by job: $e');
      return [];
    }
  }

  Future<List<Application>> getApplicationsByUser(String userId) async {
    try {
      final applications = await _getAllApplications();
      return applications.where((app) => app.userId == userId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('ApplicationService: Error getting applications by user: $e');
      return [];
    }
  }

  Future<Application?> getApplicationById(String id) async {
    try {
      final applications = await _getAllApplications();
      return applications.firstWhere((app) => app.id == id);
    } catch (e) {
      debugPrint('ApplicationService: Application not found: $e');
      return null;
    }
  }

  Future<bool> hasUserApplied(String userId, String jobId) async {
    try {
      final applications = await _getAllApplications();
      return applications.any((app) => app.userId == userId && app.jobId == jobId);
    } catch (e) {
      debugPrint('ApplicationService: Error checking if user applied: $e');
      return false;
    }
  }

  Future<List<Application>> _getAllApplications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final applicationsJson = prefs.getString(_applicationsKey);
      
      if (applicationsJson == null || applicationsJson.isEmpty) {
        return [];
      }

      final applicationsList = (jsonDecode(applicationsJson) as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      
      final applications = <Application>[];
      for (final json in applicationsList) {
        try {
          applications.add(Application.fromJson(json));
        } catch (e) {
          debugPrint('ApplicationService: Skipping corrupted application: $e');
        }
      }
      
      return applications;
    } catch (e) {
      debugPrint('ApplicationService: Error getting all applications: $e');
      return [];
    }
  }
}
