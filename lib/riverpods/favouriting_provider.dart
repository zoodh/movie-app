import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_providers.dart';



final FavouriteProvider = NotifierProvider.family<FavouriteNotifier, bool, String>(
  FavouriteNotifier.new,
);
class FavouriteNotifier extends FamilyNotifier<bool, String> {
  @override
  bool build(String arg) {
    return state;
  }

  Future<void> saveMovie(int movieId, String year, String title) async {
    try {
      User? user = ref.read(firebaseAuthProvider).currentUser;
      await ref.read(firestoreProvider).collection('users').doc(user?.uid).collection('saved_movies').add({
        'movie_id': movieId,
        'title': title,
        'year': year,
      });
    } catch (e) {
      print('Error saving movie: $e');
    }
    state = true;
  }

  Future<void> deleteMovie(int movieId, String year, String title) async {
    try {
      User? user = ref.read(firebaseAuthProvider).currentUser;
      QuerySnapshot snapshot = await ref
          .read(firestoreProvider)
          .collection('users')
          .doc(user?.uid)
          .collection('saved_movies')
          .where('movie_id', isEqualTo: movieId)
          .where('title', isEqualTo: title)
          .where('year', isEqualTo: year)
          .get();
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting movie: $e');
    }
    state = false;
  }
  Stream<bool> checkIfFavouritedStream(int movieId, String year, String title) {
    try {
      User? user = ref.read(firebaseAuthProvider).currentUser;
      return ref
          .read(firestoreProvider)
          .collection('users')
          .doc(user?.uid)
          .collection('saved_movies')
          .where('movie_id', isEqualTo: movieId)
          .where('title', isEqualTo: title)
          .where('year', isEqualTo: year)
          .snapshots()
          .map((snapshot) => snapshot.docs.isNotEmpty);
    } catch (e) {
      print('Error checking if movie is favorited: $e');
      return Stream.value(false);
    }
  }
}