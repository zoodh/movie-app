
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesapp/riverpods/movie_details_provider.dart';
import 'package:moviesapp/riverpods/favouriting_provider.dart';
class MovieDetailsPage extends ConsumerStatefulWidget {
  final int movieId;
  const MovieDetailsPage({super.key, required this.movieId});

  @override

  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends ConsumerState<MovieDetailsPage> {
  bool isFavourited = false;
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
                          height: 400,
                          width: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    movieDetails['title_long'] != null && movieDetails['title_long'].toString().isNotEmpty
                        ? movieDetails['title_long'].toString()
                        : 'No title available',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                      'Year: ${movieDetails['year'] != null ? movieDetails['year'].toString() : 'no year available'}'
                  ),
                  const SizedBox(height: 8),
                  Text(
                      'Rating: ${movieDetails['rating'] != null ? movieDetails['rating'].toString() : 'no rating available'}'
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Runtime: ${movieDetails['runtime'] != null ? movieDetails['runtime'].toString() : 'no runtime'} minutes',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description:\n ${movieDetails['description_full'] != null
                        && movieDetails['description_full'].toString().isNotEmpty ? movieDetails['description_full'].toString() : 'No description available'}',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  StreamBuilder<bool>(
                    stream: ref
                        .read(FavouriteProvider(widget.movieId.toString()).notifier)
                        .checkIfFavouritedStream(widget.movieId,
                        movieDetails['year'].toString(),
                        movieDetails['title_long']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        bool isFavourited = snapshot.data ?? false;
                        return IconButton(
                          onPressed: () {
                            if (isFavourited) {
                              ref
                                  .read(FavouriteProvider(widget.movieId.toString()).notifier)
                                  .deleteMovie(
                                widget.movieId,
                                movieDetails['year'].toString(),
                                movieDetails['title_long'],
                              );
                            } else {
                              ref
                                  .read(FavouriteProvider(widget.movieId.toString()).notifier)
                                  .saveMovie(
                                widget.movieId,
                                movieDetails['year'].toString(),
                                movieDetails['title_long'],
                              );
                            }
                          },
                          icon: Icon(Icons.favorite),
                          color: isFavourited ? Colors.red : Colors.grey,
                          iconSize: 30,
                        );
                      }
                    },
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