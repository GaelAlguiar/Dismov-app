import 'package:dismov_app/provider/auth_provider.dart';
import 'package:dismov_app/provider/location_provider.dart';
import 'package:dismov_app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:dismov_app/config/config.dart';
import 'package:dismov_app/config/router/app_router.dart';

// Firebase Imports
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// Hive Imports
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Hive Initialization
  await Hive.initFlutter();
  await Hive.openBox('userBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider())
      ],
      child: MaterialApp.router(
        title: 'Pawtner Up',
        routerConfig: appRouter,
        theme: AppTheme().getTheme(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
