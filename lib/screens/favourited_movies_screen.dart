//todo
// fetch the favourited movies from the firestoer
//display in a list view //done :)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesapp/riverpods/favouriting_provider.dart';
import 'package:moviesapp/riverpods/firebase_providers.dart';

import 'movie_details.dart';

class FavouriteMoviesScreen extends ConsumerWidget {
@override
Widget build(context, WidgetRef ref) {
  final user = ref.read(firebaseAuthProvider).currentUser;
  return Scaffold(
    appBar: AppBar(
      title: const Center(child:
      Text('Favorite Movies')),
    ),
    body: StreamBuilder<QuerySnapshot>(
      stream: ref.read(firestoreProvider).collection('users')
          .doc(user?.uid)
          .collection('saved_movies')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No movies found.'),
          );
        }
        final movies = snapshot.data!.docs;

        return ListView.separated(
          itemCount: movies.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey,
          ),
          itemBuilder: (context, index) {
            final movie = movies[index].data() as Map<String, dynamic>;
            final title = movie['title'] ?? 'Unknown Title';
            final year = movie['year'] ?? 'Unknown Year';
            final movieId = movie['movie_id'];
            return ListTile(
              title: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Year: $year'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovieDetailsPage(movieId: movieId)),
                );
              },
              trailing: IconButton(onPressed: () {
                ref.read(FavouriteProvider(movieId.toString()).notifier).deleteMovie
                  (movieId,
                    year,
                    title);

              }, icon: Icon(Icons.delete_forever, color: Colors.red)),

            );
          },
        );
      },
    ),
  );
}
}