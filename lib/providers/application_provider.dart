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

  Future<Application?> getApplicationById(String id) async {
    return await _applicationService.getApplicationById(id);
  }

  Future<bool> hasUserApplied(String userId, String jobId) async {
    return await _applicationService.hasUserApplied(userId, jobId);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
