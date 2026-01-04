import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ethioworks/models/application_model.dart';

class ApplicationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Application?> submitApplication(Application application) async {
    try {
      final docRef = _firestore.collection('applications').doc();

      // Check for existing application
      final existing = await _firestore
          .collection('applications')
          .where('userId', isEqualTo: application.userId)
          .where('jobId', isEqualTo: application.jobId)
          .get();

      if (existing.docs.isNotEmpty) {
        debugPrint('ApplicationService: User already applied to this job');
        return null;
      }

      final newApplication = application.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
      );

      await docRef.set(newApplication.toJson());

      debugPrint(
          'ApplicationService: Application submitted successfully to Firestore');
      return newApplication;
    } catch (e) {
      debugPrint('ApplicationService: Error submitting application: $e');
      return null;
    }
  }

  Future<List<Application>> getApplicationsByJob(String jobId) async {
    try {
      final snapshot = await _firestore
          .collection('applications')
          .where('jobId', isEqualTo: jobId)
          .get();

      final apps =
          snapshot.docs.map((doc) => Application.fromJson(doc.data())).toList();
      return apps..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('ApplicationService: Error getting applications by job: $e');
      return [];
    }
  }

  Future<List<Application>> getApplicationsByUser(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('applications')
          .where('userId', isEqualTo: userId)
          .get();

      final apps =
          snapshot.docs.map((doc) => Application.fromJson(doc.data())).toList();
      return apps..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('ApplicationService: Error getting applications by user: $e');
      return [];
    }
  }

  Future<Application?> getApplicationById(String id) async {
    try {
      final doc = await _firestore.collection('applications').doc(id).get();
      if (!doc.exists) return null;
      return Application.fromJson(doc.data()!);
    } catch (e) {
      debugPrint('ApplicationService: Application not found: $e');
      return null;
    }
  }

  Future<bool> hasUserApplied(String userId, String jobId) async {
    try {
      final snapshot = await _firestore
          .collection('applications')
          .where('userId', isEqualTo: userId)
          .where('jobId', isEqualTo: jobId)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('ApplicationService: Error checking if user applied: $e');
      return false;
    }
  }
}
