import 'package:ethioworks/services/jobs_post_service.dart';
import 'package:flutter/material.dart';
import 'package:ethioworks/models/job_post_model.dart';

class JobProvider with ChangeNotifier {
  final JobPostService _jobService = JobPostService();

  List<JobPost> _allJobs = [];
  List<JobPost> _filteredJobs = [];
  bool _isLoading = false;
  String? _errorMessage;

  LocationType? _selectedLocationType;
  List<String> _selectedSkills = [];

  List<JobPost> get jobs => _filteredJobs.isEmpty &&
          _selectedLocationType == null &&
          _selectedSkills.isEmpty
      ? _allJobs
      : _filteredJobs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LocationType? get selectedLocationType => _selectedLocationType;
  List<String> get selectedSkills => _selectedSkills;


  // load jobs function in job browsing screens
  Future<void> loadJobs() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allJobs = await _jobService.getAllJobs();
      _filteredJobs = [];
      _searchTitle = '';
      _searchLocation = '';
      _selectedLocationType = null;
      _selectedSkills = [];
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load jobs';
    }

    _isLoading = false;
    notifyListeners();
  }

  

  // load employer jobs function in employer dashboard
  Future<void> loadEmployerJobs(String employerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _allJobs = await _jobService.getJobsByEmployer(employerId);
      _filteredJobs = [];
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load jobs';
    }

    _isLoading = false;
    notifyListeners();
  }

  
  Future<JobPost?> getJobById(String id) async {
    return await _jobService.getJobById(id);
  }

  Future<bool> createJob(JobPost job) async {
    _isLoading = true;
    notifyListeners();

    final newJob = await _jobService.createJob(job);

    if (newJob != null) {
      _allJobs.insert(0, newJob);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Failed to create job';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }



  // update job function in employer dashboard
  Future<bool> updateJob(JobPost job) async {
    _isLoading = true;
    notifyListeners();

    final updatedJob = await _jobService.updateJob(job);

    if (updatedJob != null) {
      final index = _allJobs.indexWhere((j) => j.id == job.id);
      if (index != -1) {
        _allJobs[index] = updatedJob;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Failed to update job';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // delete job function in employer dashboard
  Future<bool> deleteJob(String id) async {
    _isLoading = true;
    notifyListeners();

    final success = await _jobService.deleteJob(id);

    if (success) {
      _allJobs.removeWhere((job) => job.id == id);
      _filteredJobs.removeWhere((job) => job.id == id);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Failed to delete job';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }




  Future<void> likeJob(String jobId, String userId) async {
    await _jobService.likeJob(jobId, userId);
    await loadJobs();
  }


  Future<void> dislikeJob(String jobId, String userId) async {
    await _jobService.dislikeJob(jobId, userId);
    await loadJobs();
  }

  Future<String?> getUserReaction(String jobId, String userId) async {
    return await _jobService.getUserReaction(jobId, userId);
  }

  String _searchTitle = '';
  String _searchLocation = '';

  String get searchTitle => _searchTitle;
  String get searchLocation => _searchLocation;



  // filter jobs function in job browsing screens
  void filterJobs({LocationType? locationType, List<String>? skills}) {
    _selectedLocationType = locationType;
    _selectedSkills = skills ?? [];
    _applyLocalFilters();
  }

  // search jobs function in job browsing screens
  void searchJobs({String? title, String? location}) {
    _searchTitle = title ?? '';
    _searchLocation = location ?? '';
    _applyLocalFilters();
  }

  // apply local filters function in job browsing screens
  void _applyLocalFilters() {
    _isLoading = true;
    notifyListeners();

    try {
      List<JobPost> tempJobs = List.from(_allJobs);

      // Filter by Title/Keywords
      if (_searchTitle.isNotEmpty) {
        tempJobs = tempJobs
            .where((job) =>
                job.title.toLowerCase().contains(_searchTitle.toLowerCase()) ||
                job.description
                    .toLowerCase()
                    .contains(_searchTitle.toLowerCase()))
            .toList();
      }

      // Filter by Location Query
      if (_searchLocation.isNotEmpty) {
        tempJobs = tempJobs
            .where((job) => (job.location ?? '')
                .toLowerCase()
                .contains(_searchLocation.toLowerCase()))
            .toList();
      }

      // Filter by Location Type
      if (_selectedLocationType != null) {
        tempJobs = tempJobs
            .where((job) => job.locationType == _selectedLocationType)
            .toList();
      }

      // Filter by Skills
      if (_selectedSkills.isNotEmpty) {
        tempJobs = tempJobs.where((job) {
          return job.expectedSkills.any((skill) => _selectedSkills
              .any((s) => skill.toLowerCase().contains(s.toLowerCase())));
        }).toList();
      }

      _filteredJobs = tempJobs;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to apply filters';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearFilters() {
    _selectedLocationType = null;
    _selectedSkills = [];
    _searchTitle = '';
    _searchLocation = '';
    _filteredJobs = [];
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
