import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_providers.dart';



final FavouriteProvider = NotifierProvider<FavouriteNotifier, void>(
  FavouriteNotifier.new,
);

class FavouriteNotifier extends Notifier<void> {
  @override
  build() {
    return;
  }

  Future<void> saveMovie(int movieId, String year, String title) async {
    try {
      User? user = ref
          .read(firebaseAuthProvider)
          .currentUser;

      await ref.read(firestoreProvider).collection('users')
          .doc(user?.uid)
          .collection('saved_movies')
          .add({
        'movie_id': movieId,
        'title': title,
        'year': year
      });
    } catch (e) {
      print('Error saving movie: $e');
    }
  }
}