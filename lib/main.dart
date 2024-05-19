import 'package:dismov_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:dismov_app/config/config.dart';
import 'package:dismov_app/config/router/app_router.dart';

//Firebase Imports
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //DataBase Connection
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthenticationProvider())],
      child: MaterialApp.router(
      title: 'Pawtner Up',
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
      )
    );
    }
}
