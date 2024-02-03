import 'package:dio/dio.dart';
class YtsApi {
  static const String baseUrl = 'https://yts.mx/api/v2/';
  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> fetchMovies(
      {String? query, String? genre, int page = 1}) async {
    final url = query != null
        ? '$baseUrl/list_movies.json?query_term=$query&page=$page'
        : genre != null
        ? '$baseUrl/list_movies.json?genre=$genre&page=$page'
        : '$baseUrl/list_movies.json?page=$page';

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final List<Map<String, dynamic>> movies = List.from(data['data']['movies']);
        return movies;
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (error) {
      throw Exception('Failed to load movies: $error');
    }
  }

  Future<Map<String, dynamic>> fetchMovieDetails(int movieId,
      {bool withImages = false}) async {
    final url = '$baseUrl/movie_details.json?movie_id=$movieId&with_images=$withImages';

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final Map<String, dynamic> movieDetails = data['data']['movie'];
        return movieDetails;
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (error) {
      throw Exception('Failed to load movie details: $error');
    }
  }
}