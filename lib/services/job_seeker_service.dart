import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ethioworks/models/job_seeker_model.dart';
import 'package:ethioworks/models/employer_model.dart';
import 'package:ethioworks/services/employer_service.dart';

class JobSeekerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _employerService = EmployerService();

  Future<JobSeeker?> getProfile(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (!doc.exists) return null;

      return JobSeeker.fromJson(doc.data()!);
    } catch (e) {
      debugPrint('JobSeekerService: Error getting profile: $e');
      return null;
    }
  }

  Future<JobSeeker?> updateProfile(JobSeeker seeker) async {
    try {
      final updatedSeeker = seeker.copyWith(updatedAt: DateTime.now());
      await _firestore
          .collection('users')
          .doc(seeker.id)
          .update(updatedSeeker.toJson());

      debugPrint('JobSeekerService: Profile updated successfully in Firestore');
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

      await _firestore.collection('users').doc(seekerId).update({
        'followedCompanies': FieldValue.arrayUnion([employerId]),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      await _employerService.incrementFollowers(employerId);

      debugPrint(
          'JobSeekerService: Company followed successfully in Firestore');
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

      await _firestore.collection('users').doc(seekerId).update({
        'followedCompanies': FieldValue.arrayRemove([employerId]),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      await _employerService.decrementFollowers(employerId);

      debugPrint(
          'JobSeekerService: Company unfollowed successfully in Firestore');
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
