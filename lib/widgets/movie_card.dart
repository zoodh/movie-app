
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesapp/routes/routes.dart';

import '../models.dart';
import '../screens/movie_details.dart';
class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MovieDetailsPage(movieId: movie.id)),
          );
      },
        child: Stack(
          children: [
            Image.network(
              movie.mediumCoverImage,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Year: ${movie.year}',
                      style: TextStyle(
                        color: Colors.white,
                      )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}