import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ethioworks/models/user_model.dart';
import 'package:ethioworks/models/job_seeker_model.dart';
import 'package:ethioworks/models/employer_model.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUp({
    required String email,
    required String password,
    required UserType userType,
    String? name,
    String? companyOrPersonalName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) return null;

      final now = DateTime.now();
      User newUser;
      if (userType == UserType.jobSeeker) {
        newUser = JobSeeker(
          id: firebaseUser.uid,
          email: email,
          name: name ?? 'User',
          createdAt: now,
          updatedAt: now,
        );
      } else {
        newUser = Employer(
          id: firebaseUser.uid,
          email: email,
          companyOrPersonalName: companyOrPersonalName ?? 'Company',
          createdAt: now,
          updatedAt: now,
        );
      }

      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(newUser.toJson());

      debugPrint('AuthService: User signed up successfully with Firebase');
      return newUser;
    } catch (e) {
      debugPrint('AuthService: Error during signup: $e');
      rethrow;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) return null;

      return await getUserById(firebaseUser.uid);
    } catch (e) {
      debugPrint('AuthService: Error during login: $e');
      rethrow;
    }
  }

  Future<User?> getUserById(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      if (data['userType'] == UserType.jobSeeker.name) {
        return JobSeeker.fromJson(data);
      } else {
        return Employer.fromJson(data);
      }
    } catch (e) {
      debugPrint('AuthService: Error getting user by ID: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      debugPrint('AuthService: User logged out');
    } catch (e) {
      debugPrint('AuthService: Error during logout: $e');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) return null;
      return await getUserById(firebaseUser.uid);
    } catch (e) {
      debugPrint('AuthService: Error getting current user: $e');
      return null;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint('AuthService: Password reset email sent');
      return true;
    } catch (e) {
      debugPrint('AuthService: Error during password reset: $e');
      return false;
    }
  }

  Future<void> updateCurrentUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
      debugPrint('AuthService: User updated successfully in Firestore');
    } catch (e) {
      debugPrint('AuthService: Error updating user: $e');
    }
  }
}
