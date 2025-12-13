import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:ethioworks/models/job_post_model.dart';

class JobPostService {
  static const String _jobsKey = 'jobs';
  static const String _userJobReactionsKey = 'user_job_reactions';
  
  final _uuid = const Uuid();

  Future<List<JobPost>> getAllJobs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jobsJson = prefs.getString(_jobsKey);
      
      if (jobsJson == null || jobsJson.isEmpty) {
        return [];
      }

      final jobsList = (jsonDecode(jobsJson) as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      
      final jobs = <JobPost>[];
      for (final json in jobsList) {
        try {
          jobs.add(JobPost.fromJson(json));
        } catch (e) {
          debugPrint('JobPostService: Skipping corrupted job: $e');
        }
      }
      
      return jobs..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('JobPostService: Error getting all jobs: $e');
      return [];
    }
  }

  Future<JobPost?> getJobById(String id) async {
    try {
      final jobs = await getAllJobs();
      return jobs.firstWhere((job) => job.id == id);
    } catch (e) {
      debugPrint('JobPostService: Job not found: $e');
      return null;
    }
  }

  Future<List<JobPost>> getJobsByEmployer(String employerId) async {
    try {
      final jobs = await getAllJobs();
      return jobs.where((job) => job.employerId == employerId).toList();
    } catch (e) {
      debugPrint('JobPostService: Error getting jobs by employer: $e');
      return [];
    }
  }

  Future<JobPost?> createJob(JobPost job) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jobs = await getAllJobs();
      
      final newJob = job.copyWith(
        id: job.id.isEmpty ? _uuid.v4() : job.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      jobs.add(newJob);
      
      await prefs.setString(_jobsKey, jsonEncode(jobs.map((j) => j.toJson()).toList()));
      
      debugPrint('JobPostService: Job created successfully');
      return newJob;
    } catch (e) {
      debugPrint('JobPostService: Error creating job: $e');
      return null;
    }
  }

  Future<JobPost?> updateJob(JobPost job) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jobs = await getAllJobs();
      
      final index = jobs.indexWhere((j) => j.id == job.id);
      if (index == -1) {
        debugPrint('JobPostService: Job not found');
        return null;
      }
      
      final updatedJob = job.copyWith(updatedAt: DateTime.now());
      jobs[index] = updatedJob;
      
      await prefs.setString(_jobsKey, jsonEncode(jobs.map((j) => j.toJson()).toList()));
      
      debugPrint('JobPostService: Job updated successfully');
      return updatedJob;
    } catch (e) {
      debugPrint('JobPostService: Error updating job: $e');
      return null;
    }
  }

  Future<bool> deleteJob(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jobs = await getAllJobs();
      
      jobs.removeWhere((job) => job.id == id);
      
      await prefs.setString(_jobsKey, jsonEncode(jobs.map((j) => j.toJson()).toList()));
      
      debugPrint('JobPostService: Job deleted successfully');
      return true;
    } catch (e) {
      debugPrint('JobPostService: Error deleting job: $e');
      return false;
    }
  }

  Future<void> likeJob(String jobId, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reactionsJson = prefs.getString(_userJobReactionsKey) ?? '{}';
      final reactions = jsonDecode(reactionsJson) as Map<String, dynamic>;
      
      final userReactions = reactions[userId] as Map<String, dynamic>? ?? {};
      final previousReaction = userReactions[jobId] as String?;
      
      final jobs = await getAllJobs();
      final jobIndex = jobs.indexWhere((j) => j.id == jobId);
      if (jobIndex == -1) return;
      
      var job = jobs[jobIndex];
      
      if (previousReaction == 'like') {
        userReactions.remove(jobId);
        job = job.copyWith(likes: job.likes - 1);
      } else {
        userReactions[jobId] = 'like';
        if (previousReaction == 'dislike') {
          job = job.copyWith(likes: job.likes + 1, dislikes: job.dislikes - 1);
        } else {
          job = job.copyWith(likes: job.likes + 1);
        }
      }
      
      reactions[userId] = userReactions;
      await prefs.setString(_userJobReactionsKey, jsonEncode(reactions));
      
      jobs[jobIndex] = job;
      await prefs.setString(_jobsKey, jsonEncode(jobs.map((j) => j.toJson()).toList()));
      
      debugPrint('JobPostService: Job liked');
    } catch (e) {
      debugPrint('JobPostService: Error liking job: $e');
    }
  }

  Future<void> dislikeJob(String jobId, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reactionsJson = prefs.getString(_userJobReactionsKey) ?? '{}';
      final reactions = jsonDecode(reactionsJson) as Map<String, dynamic>;
      
      final userReactions = reactions[userId] as Map<String, dynamic>? ?? {};
      final previousReaction = userReactions[jobId] as String?;
      
      final jobs = await getAllJobs();
      final jobIndex = jobs.indexWhere((j) => j.id == jobId);
      if (jobIndex == -1) return;
      
      var job = jobs[jobIndex];
      
      if (previousReaction == 'dislike') {
        userReactions.remove(jobId);
        job = job.copyWith(dislikes: job.dislikes - 1);
      } else {
        userReactions[jobId] = 'dislike';
        if (previousReaction == 'like') {
          job = job.copyWith(dislikes: job.dislikes + 1, likes: job.likes - 1);
        } else {
          job = job.copyWith(dislikes: job.dislikes + 1);
        }
      }
      
      reactions[userId] = userReactions;
      await prefs.setString(_userJobReactionsKey, jsonEncode(reactions));
      
      jobs[jobIndex] = job;
      await prefs.setString(_jobsKey, jsonEncode(jobs.map((j) => j.toJson()).toList()));
      
      debugPrint('JobPostService: Job disliked');
    } catch (e) {
      debugPrint('JobPostService: Error disliking job: $e');
    }
  }

  Future<String?> getUserReaction(String jobId, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reactionsJson = prefs.getString(_userJobReactionsKey) ?? '{}';
      final reactions = jsonDecode(reactionsJson) as Map<String, dynamic>;
      
      final userReactions = reactions[userId] as Map<String, dynamic>? ?? {};
      return userReactions[jobId] as String?;
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
      var jobs = await getAllJobs();
      
      if (locationType != null) {
        jobs = jobs.where((job) => job.locationType == locationType).toList();
      }
      
      if (skills != null && skills.isNotEmpty) {
        jobs = jobs.where((job) {
          return job.expectedSkills.any((skill) => 
            skills.any((s) => skill.toLowerCase().contains(s.toLowerCase()))
          );
        }).toList();
      }
      
      return jobs;
    } catch (e) {
      debugPrint('JobPostService: Error filtering jobs: $e');
      return [];
    }
  }
}
