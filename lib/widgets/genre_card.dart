import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviesapp/screens/home_screen.dart';


class GenreCard extends StatelessWidget {
  final String imageUrl;
  final String genreName;

  const GenreCard({
    super.key,
    required this.imageUrl,
    required this.genreName,
  });

  @override
  Widget build(context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                     HomePage(genre: genreName,)
              )
          );

        },
        onLongPress: () {
          //stuck on the logic for adding multiple genres for now
        },
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              width: double.infinity,
              height: 400,
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
                      genreName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
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