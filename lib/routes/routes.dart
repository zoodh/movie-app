import 'package:go_router/go_router.dart';
import 'package:moviesapp/screens/home_screen.dart';
import 'package:moviesapp/screens/login_screen.dart';
//WIP
final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      name: RoutePaths.login.toString(),
      path: "/",
      builder: (context, state) => const LoginPage(),
      routes: [
        GoRoute(
          name: RoutePaths.home.toString(),
          path: "home",
          builder: (context, state) => HomePage(),
          routes: [


          ],
        ),
      ],
    ),
  ],
);

enum RoutePaths {
  login,
  home,
  movieDetails,
}