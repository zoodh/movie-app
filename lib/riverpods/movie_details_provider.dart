
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';





final detailsProvider = NotifierProvider.autoDispose<detailsNotifier,Map<String, dynamic>?>(
  detailsNotifier.new,
);

class detailsNotifier extends AutoDisposeNotifier<Map<String, dynamic>?> {
  final YtsApi _ytsApi = YtsApi();
  late int movieId;

  @override
  build() {
    return null;
  }

  Future<void> loadMovieDetails(movieId) async {
    try {
      final movieDetails = await _ytsApi.fetchMovieDetails(
        movieId,
        withImages: true,
      );
      state = movieDetails;
    } catch (e) {
      print('Error loading movie details: $e');
      throw e;
    }
  }
}