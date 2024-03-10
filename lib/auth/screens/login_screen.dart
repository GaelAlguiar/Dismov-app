import 'dart:math';

import 'package:dismov_app/Json/users.dart';
import 'package:dismov_app/auth/db/sqlite.dart';
import 'package:dismov_app/config/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dismov_app/shared/shared.dart';

//Firebase Services
import 'package:dismov_app/services/firebase_service.dart';
//Google Services for login
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';



// LoginScreen
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 45),
                // Icon Banner
                IconButton(
                  icon: Image.asset(
                    'assets/images/image.png',
                    width: 220,
                    height: 170,
                  ),
                  onPressed: () => {},
                ),
                const SizedBox(height: 45),
                Container(
                  height: MediaQuery.of(context).size.height - 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                    ),
                  ),
                  child: _LoginForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final username = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isLoginTrue = false;

  final db = DatabaseHelper();

  Future<void> login() async {
    var response = await db.login(
      Users(userName: username.text, userPassword: password.text),
    );
    if (response == true) {
      //If login is correct, then goto notes
      if (!mounted) return;
      context.go("/");
    } else {
      //If not, true the bool value to show error message
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text('Iniciar Sesión', style: textStyles.titleLarge),
          const SizedBox(height: 90),
          CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            controller: username,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            controller: password,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Ingresar',
              buttonColor: AppColor.yellowCustom,
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    print("Entró");
                    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: username.text,
                        password: password.text,
                    );
                    //context.go("/Menu");
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      //print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      //print('Wrong password provided for that user.');
                    }
                  };
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          //Login with Google Button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: "Iniciar Sesion con Google",
              buttonColor: AppColor.darker,
              onPressed: () async {
                await signInWithGoogle();
              },
            ),
          ),
          const SizedBox(height: 10),
          //Login with Google Button
          SizedBox(
            width: double.infinity,
            height: 30,
            child: CustomFilledButton(
              text: "Cerrar Sesión",
              buttonColor: AppColor.darker,
              onPressed: () async {
                await signOutGoogle();
              },
            ),
          ),
          const Spacer(flex: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿No tienes cuenta?'),
              TextButton(
                onPressed: () => context.go('/register'),
                child: const Text('Crea una aquí'),
              ),
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}

//Login with Google
Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

//signOutGoogle
Future<void> signOutGoogle() async{
  await GoogleSignIn().signOut();


}
