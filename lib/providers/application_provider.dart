import 'package:flutter/material.dart';
import 'package:ethioworks/models/application_model.dart';
import 'package:ethioworks/services/application_service.dart';

class ApplicationProvider with ChangeNotifier {
  final ApplicationService _applicationService = ApplicationService();
  
  List<Application> _applications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Application> get applications => _applications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  
  // submitting application function for job_seekers
  Future<bool> submitApplication(Application application) async {
    _isLoading = true;
    notifyListeners();

    final newApplication = await _applicationService.submitApplication(application);

    if (newApplication != null) {
      _applications.insert(0, newApplication);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'You have already applied to this job';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // loading applications function for both user types
  Future<void> loadApplicationsByJob(String jobId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _applications = await _applicationService.getApplicationsByJob(jobId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load applications';
    }

    _isLoading = false;
    notifyListeners();
  }

  // loading applications function for both user types
  Future<void> loadApplicationsByUser(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _applications = await _applicationService.getApplicationsByUser(userId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load applications';
    }

    _isLoading = false;
    notifyListeners();
  }

  // getting application by id function for both user types
  Future<Application?> getApplicationById(String id) async {
    return await _applicationService.getApplicationById(id);
  }

  // checking if user has applied to a job function for both user types
  Future<bool> hasUserApplied(String userId, String jobId) async {
    return await _applicationService.hasUserApplied(userId, jobId);
  }

  // clear error function for both user types
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
