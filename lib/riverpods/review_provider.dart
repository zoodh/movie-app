
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_providers.dart';
final reviewProvider =  NotifierProvider<Reviewnotifier, String>(
  Reviewnotifier.new,
);

class Reviewnotifier extends Notifier<String> {
  @override
  build() {
    return state;
  }

  Future<void> postReview(int movieId, String userId, String reviewText,
      double rating) async {
    try {
      await ref.read(firestoreProvider).collection('reviews').add({
        'movie_id': movieId,
        'user_id': userId,
        'review_text': reviewText,
        'rating': rating,
      });
    } catch (e) {
      print('Error posting review: $e');
    }
  }

  Stream<QuerySnapshot> fetchReviews(int movieId) {
    try {
      final Stream<QuerySnapshot> stream = ref
          .read(firestoreProvider)
          .collection('reviews')
          .where('movie_id', isEqualTo: movieId)
          .snapshots();

      return stream;
    } catch (e) {
      print('Error fetching reviews: $e');
      return Stream.empty();
    }
  }



}
