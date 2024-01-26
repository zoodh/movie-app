
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesapp/riverpods/movie_details_provider.dart';
import 'package:moviesapp/riverpods/favouriting_provider.dart';

class MovieDetailsPage extends ConsumerStatefulWidget {
  final int movieId;
  const MovieDetailsPage({super.key, required this.movieId});
  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}class _MovieDetailsPageState extends ConsumerState<MovieDetailsPage> {
  @override
  void initState() {
    super.initState();
    ref.read(DetailsProvider.notifier).loadMovieDetails(widget.movieId);
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details'),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final movieDetails = ref.watch(DetailsProvider);
          if (movieDetails == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Image.network(
                          movieDetails['large_cover_image'],
                          height: 300,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    movieDetails['title_long'] ?? 'No title available',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Year: ${movieDetails['year'] ?? 'no year available'}'),
                  const SizedBox(height: 8),
                  Text('Rating: ${movieDetails['rating'] ?? 'no rating available'}'),
                  const SizedBox(height: 8),
                  Text(
                    'Runtime: ${movieDetails['runtime'] ?? 'no runtime'} minutes',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description:\n ${movieDetails['description_full'] ?? 'No description available'}',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  IconButton(
                    onPressed: () {
                      ref.read(
                          FavouriteProvider.notifier).saveMovie(
                          widget.movieId,
                          movieDetails['year'].toString()
                          ,movieDetails['title_long']);
                    },
                    icon: Icon(Icons.favorite),
                    color: Colors.grey,
                    iconSize: 30,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}