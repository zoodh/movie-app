
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesapp/riverpods/firebase_providers.dart';
import '../widgets/genre_card.dart';

class GenreScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children:[
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
      body: FutureBuilder<QuerySnapshot>(
        future: ref.read(firestoreProvider).collection('genres').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final genres = snapshot.data!.docs;
            return ListView.builder(
              itemCount: genres.length,
              itemBuilder: (context, index) {
                final genre = genres[index];
                final imageUrl = genre['imageurl'] as String;
                final genreName = genre.id;
                return GenreCard(
                  imageUrl: imageUrl,
                  genreName: genreName,
                );
              },
            );
          }
        },
      ),
    );
  }
}