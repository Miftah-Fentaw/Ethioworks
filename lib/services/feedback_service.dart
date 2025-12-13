import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:ethioworks/models/feedback_model.dart';

class FeedbackService {
  static const String _feedbackKey = 'feedbacks';
  
  final _uuid = const Uuid();

  Future<Feedback?> submitFeedback(Feedback feedback) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final feedbacks = await getAllFeedback();
      
      final newFeedback = feedback.copyWith(
        id: _uuid.v4(),
        createdAt: DateTime.now(),
      );
      
      feedbacks.add(newFeedback);
      
      await prefs.setString(_feedbackKey, jsonEncode(feedbacks.map((f) => f.toJson()).toList()));
      
      debugPrint('FeedbackService: Feedback submitted successfully');
      return newFeedback;
    } catch (e) {
      debugPrint('FeedbackService: Error submitting feedback: $e');
      return null;
    }
  }

  Future<List<Feedback>> getAllFeedback() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final feedbackJson = prefs.getString(_feedbackKey);
      
      if (feedbackJson == null || feedbackJson.isEmpty) {
        return [];
      }

      final feedbackList = (jsonDecode(feedbackJson) as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      
      final feedbacks = <Feedback>[];
      for (final json in feedbackList) {
        try {
          feedbacks.add(Feedback.fromJson(json));
        } catch (e) {
          debugPrint('FeedbackService: Skipping corrupted feedback: $e');
        }
      }
      
      return feedbacks..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('FeedbackService: Error getting all feedback: $e');
      return [];
    }
  }
}
