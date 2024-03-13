// import 'package:dismov_app/Json/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dismov_app/config/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dismov_app/shared/shared.dart';

//Utils for Google Login
import 'package:dismov_app/utils/login_google_utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// LoginScreen
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: LoginGoogleUtils().isUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.data == true) {
              context.go("/Root");
              return Container();
            } else {
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
        });
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
/*
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
*/
  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text(
            'Iniciar Sesión',
            style: textStyles.titleLarge,
          ),
          const SizedBox(height: 70),
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
              icon: MdiIcons.fromString("account"),
              onPressed: () async {
                try {
                  UserCredential? credentials = await LoginGoogleUtils()
                      .loginUserWithEmail(username.text, password.text);
                  if (credentials.user != null) {
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
          const SizedBox(height: 10),
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
