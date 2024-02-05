
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_providers.dart';
final ReviewProvider =  NotifierProvider<ReviewNotifier, String>(
  ReviewNotifier.new,
);

class ReviewNotifier extends Notifier<String> {
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


}
