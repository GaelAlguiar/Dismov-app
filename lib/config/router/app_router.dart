import 'package:dismov_app/app/menu/screen/Pet/pet.dart';
import 'package:dismov_app/app/menu/screen/location/location.dart';
import 'package:dismov_app/app/menu/screen/menu_screen.dart';
import 'package:dismov_app/app/menu/screen/root_menu.dart';
import 'package:dismov_app/auth/screens/login_screen.dart';
import 'package:dismov_app/auth/screens/register_screen.dart';
import 'package:dismov_app/app/menu/screen/Pet/petprofile.dart';
import 'package:dismov_app/app/menu/screen/Pet/pProfile.dart';

import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/Root',
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

    ///* Menu Route
    GoRoute(
      path: '/menu',
      builder: (context, state) => const MenuScreen(),
    ),
    GoRoute(path: '/pets', builder: (context, state) => const PetPage()),
    GoRoute(
      name: "sample",
      path: "/sample",
      builder: (context, state) => SampleWidget(
        id1: state.uri.queryParameters['id1'],
      ),
    ),
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
  ],
);
