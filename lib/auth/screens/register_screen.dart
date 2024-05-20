// import 'package:dismov_app/Json/users.dart';
// import 'package:dismov_app/auth/db/sqlite.dart';
import 'dart:io';
import 'package:dismov_app/models/user_model.dart';
import 'package:dismov_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dismov_app/config/config.dart';
import 'package:dismov_app/services/user_service.dart';
import 'package:dismov_app/utils/pick_image.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:dismov_app/utils/snackbar.dart';
import 'package:provider/provider.dart';

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
                  minHeight: MediaQuery.of(context).size.height - 400,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
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
                      ],
                    ),

                    const Text('PawtnerUp',
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
  File? image;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 50),
          GestureDetector(
            onTap: () async {
              image = await pickImage(context);
              setState(() {});
            },
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColor.darkblue,
              child: image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        image!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.add_a_photo,
                      size: 50,
                      color: Colors.white,
                    ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Crear Cuenta',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: AppColor.darkblue,
            ),
          ),

          const SizedBox(height: 30),

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
                if (!areFieldsValid()) return;
                registerUser();
              },
            ),
          ),

          const SizedBox(height: 25),

          // const Row(
          //   children: [
          //     Expanded(
          //       child: Divider(
          //         thickness: 3,
          //         color: AppColor.gray,
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 15.0),
          //       child: Text(
          //         'O',
          //         style: TextStyle(
          //           color: AppColor.darkergray,
          //           fontFamily: 'Outfit',
          //           fontSize: 13,
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: Divider(
          //         thickness: 3,
          //         color: AppColor.gray,
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 25),
          // //Login with Google Button
          // SizedBox(
          //   width: double.infinity,
          //   height: 60,
          //   child: CustomFilledButton(
          //     text: "Registrarse con Google",
          //     buttonColor: AppColor.darker,
          //     icon: MdiIcons.fromString("google"),
          //     onPressed: () async {
          //       try {
          //         await LoginGoogleUtils().signInWithGoogle();
          //         //if is there a currentUser signed, we will go to the root
          //         if (FirebaseAuth.instance.currentUser != null) {
          //           if (context.mounted) {
          //             context.go("/Root");
          //           }
          //         }
          //       } catch (e) {
          //         debugPrint("$e");
          //       }
          //     },
          //   ),
          // ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 200),
        ],
      ),
    );
  }

  void registerUser() async {
    try {
      UserModel newUser = await UserService()
          .createUser(username.text, email.text, password.text, image, context);
      if (mounted) {
        AuthenticationProvider authProvider =
            Provider.of<AuthenticationProvider>(context, listen: false);
        authProvider.user = newUser;
        showSuccessSnackbar(context, "Usuario registrado con éxito!");
        context.go("/Root");
      }
    } catch (e) {
      debugPrint("$e");
      if (mounted) {
        showErrorSnackbar(
            context, "Error al crear usuario. Inténtelo de nuevo.");
      }
    }
  }

  bool areFieldsValid() {
    if (username.text.isEmpty) {
      showErrorSnackbar(context, "Por favor, ingrese su nombre completo.");
      return false;
    }
    if (email.text.isEmpty) {
      showErrorSnackbar(context, "Por favor, ingrese su correo.");
      return false;
    }
    if (password.text.isEmpty) {
      showErrorSnackbar(context, "Por favor, ingrese su contraseña.");
      return false;
    }
    if (confirmPassword.text.isEmpty) {
      showErrorSnackbar(context, "Por favor, repita su contraseña.");
      return false;
    }
    if (password.text != confirmPassword.text) {
      showErrorSnackbar(context, "Las contraseñas no coinciden.");
      return false;
    }
    return true;
  }
}
