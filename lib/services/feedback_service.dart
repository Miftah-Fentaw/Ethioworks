import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ethioworks/models/feedback_model.dart';

class FeedbackService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<Feedback?> submitFeedback(Feedback feedback) async {
    try {
      final docRef = _firestore.collection('feedbacks').doc();
      final newFeedback = feedback.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
      );

      await docRef.set(newFeedback.toJson());

      debugPrint(
          'FeedbackService: Feedback submitted successfully to Firestore');
      return newFeedback;
    } catch (e) {
      debugPrint('FeedbackService: Error submitting feedback: $e');
      return null;
    }
  }




  Future<List<Feedback>> getAllFeedback() async {
    try {
      final snapshot = await _firestore
          .collection('feedbacks')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => Feedback.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint('FeedbackService: Error getting all feedback: $e');
      return [];
    }
  }
}
