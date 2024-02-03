
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesapp/riverpods/firebase_providers.dart';

class GenreScreen extends ConsumerWidget {
  @override
  Widget build(context, WidgetRef ref) {
    return Scaffold(
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
            return  Center(
              child: Text('Number of genres: ${genres.length}'),
            );
          }
        },
      ),
    );
  }
}