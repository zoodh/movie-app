
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesapp/riverpods/movie_details_provider.dart';
import 'package:moviesapp/riverpods/favouriting_provider.dart';
import 'package:moviesapp/riverpods/review_provider.dart';

import '../riverpods/firebase_providers.dart';
class MovieDetailsPage extends ConsumerStatefulWidget {
  final int movieId;

  const MovieDetailsPage({super.key, required this.movieId});

  @override

  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends ConsumerState<MovieDetailsPage> {
  final TextEditingController reviewController = TextEditingController();


  bool isFavourited = false;
  double selectedRating = 1;

  @override
  void initState() {
    super.initState();
    ref.read(detailsProvider.notifier).loadMovieDetails(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    String heroTag = 'movieHero_${widget.movieId}';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(
              'assets/aflami.png',
              height: 30,
              width: 30,
            ),
            SizedBox(width: 7),
            Text('Aflami',),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: Consumer(
        builder: (context, watch, child) {
          final movieDetails = ref.watch(detailsProvider);
          if (movieDetails == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Hero(
                        tag: heroTag,
                        child: Image.network(
                          movieDetails['large_cover_image'],
                          height: 400,
                          width: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  movieDetails['title_long'] != null &&
                      movieDetails['title_long']
                          .toString()
                          .isNotEmpty
                      ? movieDetails['title_long'].toString()
                      : 'No title available',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Year: ${movieDetails['year'] != null ? movieDetails['year']
                      .toString() : 'no year available'}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rating: ${movieDetails['rating'] != null
                      ? movieDetails['rating'].toString()
                      : 'no rating available'}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Runtime: ${movieDetails['runtime'] != null
                      ? movieDetails['runtime'].toString()
                      : 'no runtime'} minutes',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Description:\n ${movieDetails['description_full'] != null
                      && movieDetails['description_full']
                          .toString()
                          .isNotEmpty ? movieDetails['description_full']
                      .toString() : 'No description available'}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                StreamBuilder<bool>(
                  stream: ref
                      .read(
                      FavouriteProvider(widget.movieId.toString()).notifier)
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
                                .read(
                                FavouriteProvider(widget.movieId.toString())
                                    .notifier)
                                .deleteMovie(
                              widget.movieId,
                              movieDetails['year'].toString(),
                              movieDetails['title_long'],
                            );
                          } else {
                            ref
                                .read(
                                FavouriteProvider(widget.movieId.toString())
                                    .notifier)
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

                TextField(
                  controller: reviewController,
                  decoration: InputDecoration(
                    suffixIcon: RatingBar.builder(
                      initialRating: 1,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (double value) {
                        selectedRating = value;
                      },
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final user = ref
                        .read(firebaseAuthProvider)
                        .currentUser;
                    if (user != null) {
                      ref.read(reviewProvider.notifier).postReview(
                        widget.movieId,
                        user.uid,
                        reviewController.text,
                        selectedRating,
                      );
                    } else {
                      print('Error: Current user is null.');
                    }
                  },
                  icon: Icon(Icons.post_add),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: ref.read(reviewProvider.notifier).fetchReviews(widget.movieId),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final List<DocumentSnapshot> documents = snapshot.data!.docs;

                      if (documents.isNotEmpty) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Map<String, dynamic> reviewData = documents[index].data()
                            as Map<String, dynamic>;
                            return ListTile(
                              title: Text(
                                'User: ${reviewData['user_id']}',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IgnorePointer(
                                    ignoring: true,
                                    child: RatingBar.builder(
                                      initialRating: reviewData['rating'].toDouble(),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 20,
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (double value) {
                                      },
                                    ),
                                  ),
                                  Text(
                                    '${reviewData['review_text']}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(child: Text('No reviews found'));
                      }
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}