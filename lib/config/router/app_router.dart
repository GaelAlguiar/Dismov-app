import 'package:dismov_app/app/menu/screen/Pet/pet.dart';
import 'package:dismov_app/app/menu/screen/location/location.dart';
import 'package:dismov_app/app/menu/screen/menu_screen.dart';
import 'package:dismov_app/app/menu/screen/recommendations/recommendations_page.dart';
import 'package:dismov_app/app/menu/screen/root_menu.dart';
import 'package:dismov_app/auth/auth.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    ///* Auth Routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen()
    ),
    GoRoute(
      path: '/menu',
      builder: (context, state) => const MenuScreen(),
    ),

    GoRoute(path: '/pets', builder: (context, state) => const PetPage()),

    ///* Route App
    GoRoute(
      path: '/Root',
      builder: (context, state) => const RootApp(),
    ),

    ///* Location App
    GoRoute(
      path: '/location',
      builder: (context, state) => const GeolocationApp(),
    ),

    GoRoute(
      path: '/recommendations',
      builder: (context, state) => const RecommendationsPage(),
    )
  ],
);
