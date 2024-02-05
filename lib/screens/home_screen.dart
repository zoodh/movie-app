
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moviesapp/riverpods/movie_providers.dart';
import 'package:moviesapp/routes/routes.dart';
import '../widgets/movie_card.dart';

class HomePage extends ConsumerStatefulWidget {
  final String? genre;
  const HomePage({super.key, this.genre});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    final genre = widget.genre;
    if (genre != null) {
      ref.read(MoviesProvider.notifier).filterMoviesByGenre(genre);
    } else {
      ref.read(MoviesProvider.notifier).loadMovies();
    }
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
  Widget build(context) {
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
               context.goNamed(RoutePaths.favouritescreen.toString());

                },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (query) {
                        ref.read(MoviesProvider.notifier).filterMovies(query);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search movies',
                        prefixIcon: Icon(Icons.search, color: Colors.purple),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.pushNamed(RoutePaths.genrescreen.toString());
                    },
                    icon: Icon(Icons.filter_list, color: Colors.purple),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer(
                builder: (context, watch, child) {
                  final moviesState = ref.watch(MoviesProvider);
                  if (moviesState.isNotEmpty) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: moviesState.length,
                      itemBuilder: (context, index) {
                        final movie = moviesState[index];
                        if (index == moviesState.length - 1) {
                          ref.read(MoviesProvider.notifier).loadMoreMovies();
                        }
                        return MovieCard(
                          movie: movie,
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