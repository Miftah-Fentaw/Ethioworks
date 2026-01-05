import 'package:flutter/material.dart';
import 'package:ethioworks/models/user_model.dart';
import 'package:ethioworks/models/job_seeker_model.dart';
import 'package:ethioworks/models/employer_model.dart';
import 'package:ethioworks/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;
  bool get isJobSeeker => _currentUser?.userType == UserType.jobSeeker;
  bool get isEmployer => _currentUser?.userType == UserType.employer;

  JobSeeker? get currentJobSeeker =>
      _currentUser is JobSeeker ? _currentUser as JobSeeker : null;
  Employer? get currentEmployer =>
      _currentUser is Employer ? _currentUser as Employer : null;

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    _currentUser = await _authService.getCurrentUser();
    _isLoading = false;
    notifyListeners();
  }




  // sign up function for both user types
  Future<bool> signUp({
    required String email,
    required String password,
    required UserType userType,
    String? name,
    String? companyOrPersonalName,
  }) async {
    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
        userType: userType,
        name: name,
        companyOrPersonalName: companyOrPersonalName,
      );

      if (user != null) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Signup failed. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      if (e is firebase_auth.FirebaseAuthException) {
        _errorMessage = e.message ?? e.code;
      } else {
        _errorMessage = e.toString();
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  
  
  
  // login function for both user types
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.login(email, password);

      if (user != null) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Login failed. Please try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      if (e is firebase_auth.FirebaseAuthException) {
        _errorMessage = e.message ?? e.code;
      } else {
        _errorMessage = e.toString();
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }



  // logout function for both user types
  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }



  // reset password function for both user types
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final success = await _authService.resetPassword(email);

    if (success) {
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Email not found';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // update user function for both user types
  Future<void> updateUser(User user) async {
    await _authService.updateCurrentUser(user);
    _currentUser = user;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
