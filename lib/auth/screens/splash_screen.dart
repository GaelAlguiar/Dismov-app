import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:dismov_app/config/config.dart';
import 'package:dismov_app/services/user_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  void _checkLoginStatus() async {
    if (FirebaseAuth.instance.currentUser != null) {
      bool result = await UserService()
          .setUserInProvider(context, FirebaseAuth.instance.currentUser);
      debugPrint("RESULT>>>>>>>>>>>>>>>>>>>>>> $result");
      if (mounted) {
        debugPrint(FirebaseAuth.instance.currentUser?.email);
        debugPrint("going to root");
        context.go('/Root');
      }
    } else {
      debugPrint("going to login");
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColor.blue,
        ),
        child: const Center(
          child: Text(
            'PawtnerUp',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'PottaOne',
            ),
          ),
        ),
      ),
    );
  }
}
