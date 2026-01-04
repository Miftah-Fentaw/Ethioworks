import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ethioworks/models/employer_model.dart';
import 'package:ethioworks/models/user_model.dart';

class EmployerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Employer?> getProfile(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (!doc.exists) return null;

      return Employer.fromJson(doc.data()!);
    } catch (e) {
      debugPrint('EmployerService: Error getting profile: $e');
      return null;
    }
  }

  Future<Employer?> updateProfile(Employer employer) async {
    try {
      final updatedEmployer = employer.copyWith(updatedAt: DateTime.now());
      await _firestore
          .collection('users')
          .doc(employer.id)
          .update(updatedEmployer.toJson());

      debugPrint('EmployerService: Profile updated successfully in Firestore');
      return updatedEmployer;
    } catch (e) {
      debugPrint('EmployerService: Error updating profile: $e');
      return null;
    }
  }

  Future<void> incrementFollowers(String employerId) async {
    try {
      await _firestore.collection('users').doc(employerId).update({
        'followers': FieldValue.increment(1),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      debugPrint('EmployerService: Followers incremented');
    } catch (e) {
      debugPrint('EmployerService: Error incrementing followers: $e');
    }
  }

  Future<void> decrementFollowers(String employerId) async {
    try {
      await _firestore.collection('users').doc(employerId).update({
        'followers': FieldValue.increment(-1),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      debugPrint('EmployerService: Followers decremented');
    } catch (e) {
      debugPrint('EmployerService: Error decrementing followers: $e');
    }
  }

  Future<List<Employer>> getAllEmployers() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('userType', isEqualTo: UserType.employer.name)
          .get();

      return snapshot.docs.map((doc) => Employer.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint('EmployerService: Error getting all employers: $e');
      return [];
    }
  }
}
