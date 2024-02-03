
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';





final DetailsProvider = NotifierProvider.autoDispose<DetailsNotifier,Map<String, dynamic>>(
  DetailsNotifier.new,
);

class DetailsNotifier extends AutoDisposeNotifier<Map<String, dynamic>> {
  final YtsApi _ytsApi = YtsApi();
  late int movieId;

  @override
  build() {
    return state;
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