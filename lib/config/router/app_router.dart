import 'package:dismov_app/app/menu/screen/Pet/pet.dart';
import 'package:dismov_app/app/menu/screen/menu_screen.dart';
import 'package:dismov_app/app/menu/screen/root_menu.dart';
import 'package:dismov_app/auth/screens/login_screen.dart';
import 'package:dismov_app/auth/screens/register_screen.dart';

import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
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
    GoRoute(
      path: '/pets',
      builder:(context, state) => const PetPage()
    ),

    ///* Route App
    GoRoute(
      path: '/Root',
      builder: (context, state) => const RootApp(),
    ),
  ],
);
