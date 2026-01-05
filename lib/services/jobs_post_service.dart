import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ethioworks/models/job_post_model.dart';

class JobPostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<JobPost>> getAllJobs() async {
    try {
      final snapshot = await _firestore
          .collection('jobs')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => JobPost.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint('JobPostService: Error getting all jobs: $e');
      return [];
    }
  }




  Future<JobPost?> getJobById(String id) async {
    try {
      final doc = await _firestore.collection('jobs').doc(id).get();
      if (!doc.exists) return null;
      return JobPost.fromJson(doc.data()!);
    } catch (e) {
      debugPrint('JobPostService: Job not found: $e');
      return null;
    }
  }




  Future<List<JobPost>> getJobsByEmployer(String employerId) async {
    try {
      final snapshot = await _firestore
          .collection('jobs')
          .where('employerId', isEqualTo: employerId)
          .get();

      final jobs =
          snapshot.docs.map((doc) => JobPost.fromJson(doc.data())).toList();
      return jobs..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('JobPostService: Error getting jobs by employer: $e');
      return [];
    }
  }





  Future<JobPost?> createJob(JobPost job) async {
    try {
      final docRef = _firestore.collection('jobs').doc();
      final newJob = job.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await docRef.set(newJob.toJson());

      debugPrint('JobPostService: Job created successfully in Firestore');
      return newJob;
    } catch (e) {
      debugPrint('JobPostService: Error creating job: $e');
      return null;
    }
  }





  Future<JobPost?> updateJob(JobPost job) async {
    try {
      final updatedJob = job.copyWith(updatedAt: DateTime.now());
      await _firestore
          .collection('jobs')
          .doc(job.id)
          .update(updatedJob.toJson());

      debugPrint('JobPostService: Job updated successfully in Firestore');
      return updatedJob;
    } catch (e) {
      debugPrint('JobPostService: Error updating job: $e');
      return null;
    }
  }








  Future<bool> deleteJob(String id) async {
    try {
      await _firestore.collection('jobs').doc(id).delete();
      debugPrint('JobPostService: Job deleted successfully from Firestore');
      return true;
    } catch (e) {
      debugPrint('JobPostService: Error deleting job: $e');
      return false;
    }
  }






  Future<void> likeJob(String jobId, String userId) async {
    try {
      final reactionId = '${userId}_$jobId';
      final reactionRef = _firestore.collection('reactions').doc(reactionId);
      final jobRef = _firestore.collection('jobs').doc(jobId);

      final reactionDoc = await reactionRef.get();
      final previousReaction =
          reactionDoc.exists ? reactionDoc.data()!['type'] as String? : null;

      await _firestore.runTransaction((transaction) async {
        if (previousReaction == 'like') {
          // Unlike
          transaction.delete(reactionRef);
          transaction.update(jobRef, {'likes': FieldValue.increment(-1)});
        } else {
          // Like
          transaction.set(
              reactionRef, {'userId': userId, 'jobId': jobId, 'type': 'like'});
          if (previousReaction == 'dislike') {
            transaction.update(jobRef, {
              'likes': FieldValue.increment(1),
              'dislikes': FieldValue.increment(-1),
            });
          } else {
            transaction.update(jobRef, {'likes': FieldValue.increment(1)});
          }
        }
      });

      debugPrint('JobPostService: Job liked/unliked');
    } catch (e) {
      debugPrint('JobPostService: Error liking job: $e');
    }
  }






  Future<void> dislikeJob(String jobId, String userId) async {
    try {
      final reactionId = '${userId}_$jobId';
      final reactionRef = _firestore.collection('reactions').doc(reactionId);
      final jobRef = _firestore.collection('jobs').doc(jobId);

      final reactionDoc = await reactionRef.get();
      final previousReaction =
          reactionDoc.exists ? reactionDoc.data()!['type'] as String? : null;

      await _firestore.runTransaction((transaction) async {
        if (previousReaction == 'dislike') {
          // Undislike
          transaction.delete(reactionRef);
          transaction.update(jobRef, {'dislikes': FieldValue.increment(-1)});
        } else {
          // Dislike
          transaction.set(reactionRef,
              {'userId': userId, 'jobId': jobId, 'type': 'dislike'});
          if (previousReaction == 'like') {
            transaction.update(jobRef, {
              'dislikes': FieldValue.increment(1),
              'likes': FieldValue.increment(-1),
            });
          } else {
            transaction.update(jobRef, {'dislikes': FieldValue.increment(1)});
          }
        }
      });

      debugPrint('JobPostService: Job disliked/undisliked');
    } catch (e) {
      debugPrint('JobPostService: Error disliking job: $e');
    }
  }





  Future<String?> getUserReaction(String jobId, String userId) async {
    try {
      final reactionId = '${userId}_$jobId';
      final doc =
          await _firestore.collection('reactions').doc(reactionId).get();
      if (!doc.exists) return null;
      return doc.data()!['type'] as String?;
    } catch (e) {
      debugPrint('JobPostService: Error getting user reaction: $e');
      return null;
    }
  }




  Future<List<JobPost>> filterJobs({
    LocationType? locationType,
    String? minSalary,
    List<String>? skills,
  }) async {
    try {
      Query query = _firestore.collection('jobs');

      if (locationType != null) {
        query = query.where('locationType', isEqualTo: locationType.name);
      }

      final snapshot = await query.get();
      var jobs = snapshot.docs
          .map((doc) => JobPost.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      if (skills != null && skills.isNotEmpty) {
        jobs = jobs.where((job) {
          return job.expectedSkills.any((skill) =>
              skills.any((s) => skill.toLowerCase().contains(s.toLowerCase())));
        }).toList();
      }

      return jobs..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('JobPostService: Error filtering jobs: $e');
      return [];
    }
  }





  Future<List<JobPost>> searchJobs({String? title, String? location}) async {
    try {
      final snapshot = await _firestore.collection('jobs').get();
      var jobs =
          snapshot.docs.map((doc) => JobPost.fromJson(doc.data())).toList();

      if (title != null && title.isNotEmpty) {
        jobs = jobs
            .where((j) => j.title.toLowerCase().contains(title.toLowerCase()))
            .toList();
      }
      if (location != null && location.isNotEmpty) {
        jobs = jobs
            .where((j) => (j.location ?? '')
                .toLowerCase()
                .contains(location.toLowerCase()))
            .toList();
      }

      return jobs..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('JobPostService: Error searching jobs: $e');
      return [];
    }
  }





  
}
