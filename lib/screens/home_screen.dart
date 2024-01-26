
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviesapp/riverpods/movie_providers.dart';
import 'favourited_movies_screen.dart';
import 'movie_details.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    ref.read(MoviesProvider.notifier).loadMovies();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(MoviesProvider.notifier).loadMoreMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Movie App')),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              title: Text('Favorite Movies'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavouriteMoviesScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.deepPurple,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (query) {
                  ref.read(MoviesProvider.notifier).filterMovies(query);
                },
                decoration: InputDecoration(
                  hintText: 'Search movies',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: Consumer(
                builder: (context, watch, child) {
                  final moviesState = ref.watch(MoviesProvider);
                  if (moviesState.isNotEmpty) {
                    return ListView.separated(
                      controller: _scrollController,
                      itemCount: moviesState.length,
                      separatorBuilder: (context, int index) =>
                          Divider(
                            color: Colors.grey,
                          ),
                      itemBuilder: (context, index) {
                        final movie = moviesState[index];
                        if (index == moviesState.length - 1) {
                          ref.read(MoviesProvider.notifier).loadMoreMovies();
                        }
                        return ListTile(
                          title: Text(
                            movie.title,
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            'Year: ${movie.year}',
                            style: TextStyle(color: Colors.black),
                          ),
                          leading: Image.network(
                            movie.mediumCoverImage,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailsPage(movieId: movie.id,),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
