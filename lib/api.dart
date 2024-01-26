import 'dart:convert';
import 'package:http/http.dart' as http;
class YtsApi {
  static const String baseUrl = 'https://yts.mx/api/v2/';

  Future<List<Map<String, dynamic>>> fetchMovies({String? query, int page = 1}) async {
    final url = query != null
        ? '$baseUrl/list_movies.json?query_term=$query&page=$page'
        : '$baseUrl/list_movies.json?page=$page';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> movies = List.from(data['data']['movies']);
      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }


  Future<Map<String, dynamic>> fetchMovieDetails(int movieId, {bool withImages = false}) async {
    final url = '$baseUrl/movie_details.json?movie_id=$movieId&with_images=$withImages';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> movieDetails = data['data']['movie'];
      return movieDetails;
    } else {
      throw Exception('Failed to load movie details');
    }
  }
}