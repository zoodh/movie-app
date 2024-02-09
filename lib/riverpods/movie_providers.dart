
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesapp/models.dart';
import 'package:http/http.dart' as http;
import '../api.dart';

final MoviesProvider =
NotifierProvider.autoDispose<MoviesNotifier, List<Movie>>(
  MoviesNotifier.new,
);

class MoviesNotifier extends  AutoDisposeNotifier<List<Movie>> {
final YtsApi _ytsApi = YtsApi();
int _currentPage = 1;

@override
build() {
  return [];
}

Future<void> loadMovies() async {
  try {
    final List<Map<String, dynamic>> movieMaps =
    await _ytsApi.fetchMovies(page: _currentPage);
    final List<Movie> movies =
    movieMaps.map((map) => Movie.fromJson(map)).toList();
    state = movies;
  } catch (e) {
    print('Error loading movies: $e');
  }
}

Future<void> loadMoreMovies() async {
  _currentPage++;
  try {
    final List<Map<String, dynamic>> movieMaps =
    await _ytsApi.fetchMovies(page: _currentPage);
    final List<Movie> newMovies =
    movieMaps.map((map) => Movie.fromJson(map)).toList();
    state = [...state, ...newMovies];
  } catch (e) {
    print('Error loading more movies: $e');
  }
}

Future<void> filterMovies(String query) async {
  if (query.isEmpty) {
    return;
  }

  try {
    final response = await http.get(Uri.parse(
        '${YtsApi.baseUrl}/list_movies.json?query_term=$query'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Movie> moviesData = List.from(data['data']['movies']
          .map((movieJson) => Movie.fromJson(movieJson)));
      state = moviesData;
    } else {
      throw Exception('Failed to search movies');
    }
  } catch (e) {
    print('Error searching movies: $e');
  }
}
Future<void> filterMoviesByGenre(String genre) async {
  if (genre.isEmpty) {
    return;
  }

  try {
    final response = await _ytsApi.fetchMovies(genre: genre);
    final List<Movie> moviesData =
    response.map((movieJson) => Movie.fromJson(movieJson)).toList();
    state = moviesData;
  } catch (e) {
    print('Error filtering movies by genre: $e');
  }
}
}

