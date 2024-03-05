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

    // ///* Product Routes
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) => const ProductsScreen(),
    // ),
  ],
);
