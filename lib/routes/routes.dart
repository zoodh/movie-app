import 'package:go_router/go_router.dart';
import 'package:moviesapp/screens/favourited_movies_screen.dart';
import 'package:moviesapp/screens/genre_screen.dart';
import 'package:moviesapp/screens/home_screen.dart';
import 'package:moviesapp/screens/login_screen.dart';
import 'package:moviesapp/screens/registiration_screen.dart';

import '../screens/movie_details.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      name: RoutePaths.login.toString(),
      path: "/",
      builder: (context, state) => const LoginPage(),
      routes: [
        GoRoute(
          name: RoutePaths.registration.toString(),
          path: "registration",
          builder: (context, state) => RegistirationPage(),
        ),
      ]
    ),
    GoRoute(
      name: RoutePaths.home.toString(),
      path: "/home",
      builder: (context, state) => HomePage(),
      routes: [
        GoRoute(
          name: RoutePaths.movieDetails.toString(),
          path: "movie-details",
          builder: (context, state) {
            final movieIdString = state.queryParameters['id'] ?? '';
            final movieId = int.tryParse(movieIdString) ?? 0;
            return MovieDetailsPage(movieId: movieId);
          },
        ),GoRoute(
        name: RoutePaths.favouritescreen.toString(),
        path: "favouritescreen",
        builder: (context, state) => FavouriteMoviesScreen(),
        ),
        GoRoute(
          name: RoutePaths.genrescreen.toString(),
          path: "genrescreen",
          builder: (context, state) => GenreScreen(),
        )


      ],
    ),

  ],
);

enum RoutePaths {
  login,
  home,
  movieDetails,
  registration,
  favouritescreen,
  genrescreen,
}