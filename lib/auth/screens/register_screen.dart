// import 'package:dismov_app/Json/users.dart';
// import 'package:dismov_app/auth/db/sqlite.dart';
import 'package:dismov_app/config/config.dart';
import 'package:dismov_app/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dismov_app/shared/shared.dart';

import 'package:firebase_auth/firebase_auth.dart';
//Utils for Google Login
import 'package:dismov_app/utils/login_google_utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// RegisterScreen
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/fondoblue.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 260,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),

                    //ICON
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: IconButton(
                            onPressed: () {
                              context.go("/login");
                            },
                            icon: const Icon(Icons.arrow_back_rounded,
                                size: 40, color: Colors.white),
                          ),
                        ),
                        //const Spacer(flex: 1),
                        IconButton(
                          icon: Image.asset(
                            'assets/images/image.png',
                            width: 220,
                            height: 170,
                          ),
                          onPressed: () => {},
                        ),

                        //const SizedBox(height: 5),
                        /*
                      Text(
                        'Crear cuenta',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),*/
                        //const Spacer(flex:1),
                      ],
                    ),

                    const Text('PawnterUp',
                        style: TextStyle(
                            fontFamily: 'PottaOne',
                            color: Colors.white,
                            fontSize: 50,
                            letterSpacing: 2.0,
                            shadows: [
                              Shadow(
                                color: Color.fromRGBO(0, 0, 0, 0.7),
                                blurRadius: 20,
                                offset: Offset(4, 4),
                              )
                            ])),

                    const SizedBox(height: 15),

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                        ),
                      ),
                      child: const _RegisterForm(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Crear Cuenta',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: AppColor.darkblue,
            ),
          ),

          const SizedBox(height: 20),

          CustomTextFormField(
            label: 'Nombre completo',
            keyboardType: TextInputType.emailAddress,
            controller: username,
          ),

          const SizedBox(height: 20),

          CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            controller: email,
          ),

          const SizedBox(height: 20),

          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            controller: password,
          ),

          const SizedBox(height: 20),

          CustomTextFormField(
            label: 'Repita la contraseña',
            obscureText: true,
            controller: confirmPassword,
          ),

          const SizedBox(height: 30),

          //Button to create user using email and password
          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Registrarse',
              buttonColor: AppColor.blue,
              //icon: MdiIcons.fromString("account-multiple-plus"),
              onPressed: () async {
                try {
                  await LoginGoogleUtils()
                      .createUserWithEmail(email.text, password.text);
                  if (FirebaseAuth.instance.currentUser != null) {
                    FirebaseAuth.instance.currentUser
                        ?.updateDisplayName(username.text);
                    addPeople(username.text, email.text, FirebaseAuth.instance.currentUser!.uid);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "Usuario registrado con éxito!",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                        ),
                      );
                      context.go("/Root");
                    }
                  }
                } catch (e) {
                  debugPrint("$e");
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          "Error al crear usuario. Inténtelo de nuevo.",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ),

          const SizedBox(height: 25),

          const Row(
            children: [
              Expanded(
                child: Divider(
                  thickness: 3,
                  color: AppColor.gray,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'O',
                  style: TextStyle(
                    color: AppColor.darkergray,
                    fontFamily: 'Outfit',
                    fontSize: 13,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 3,
                  color: AppColor.gray,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          //Login with Google Button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: "Registrarse con Google",
              buttonColor: AppColor.darker,
              icon: MdiIcons.fromString("google"),
              onPressed: () async {
                try {
                  await LoginGoogleUtils().signInWithGoogle();
                  //if is there a currentUser signed, we will go to the root
                  if (FirebaseAuth.instance.currentUser != null) {
                    if (context.mounted) {
                      context.go("/Root");
                    }
                  }
                } catch (e) {
                  debugPrint("$e");
                }
              },
            ),
          ),

          const SizedBox(height: 20),
          //const Spacer(flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Ya tienes cuenta?'),
              TextButton(
                onPressed: () {
                  context.go('/login');
                },
                child: const Text('Ingresa aquí'),
              ),
            ],
          ),
          const SizedBox(height: 30),
          //const Spacer(flex: 1),
        ],
      ),
    );
  }
}