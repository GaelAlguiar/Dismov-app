import 'package:dismov_app/config/config.dart';
import 'package:dismov_app/models/user_model.dart';
import 'package:dismov_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:dismov_app/config/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:dismov_app/services/user_service.dart';
import 'package:dismov_app/utils/snackbar.dart';

// LoginScreen
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Icon Banner
                  IconButton(
                    icon: Image.asset(
                      'assets/images/image.png',
                      width: 220,
                      height: 170,
                    ),
                    onPressed: () => {},
                  ),
                  //const SizedBox(height: 5),
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
                    height: MediaQuery.of(context).size.height - 260,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: _LoginForm(),
                  ),
                ],
              ),
            ),
          ],
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
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 50),
          const Text(
            'Iniciar Sesión',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: AppColor.darkblue,
            ),
          ),

          const SizedBox(height: 50),

          //FORMS
          CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            controller: email,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            controller: password,
          ),

          const SizedBox(height: 30),

          //INGRESAR
          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Ingresar',
              buttonColor: AppColor.blue,
              onPressed: () async {
                try {
                  await UserService()
                      .signInUser(context, email.text, password.text);
                  if (context.mounted) {
                    UserModel user = Provider.of<AuthenticationProvider>(
                            context,
                            listen: false)
                        .user!;
                    showSuccessSnackbar(context, "Bienvenido ${user.name}!");
                    context.go('/Root');
                  }
                } catch (e) {
                  print(context);
                  print(e);
                  debugPrint("$e");
                  if (context.mounted) {
                    showErrorSnackbar(
                      context,
                      "Datos incorrectos",
                    );
                  }
                }
              },
            ),
          ),

          const SizedBox(height: 25),

          // NO ACCOUNT
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿No tienes cuenta?'),
              TextButton(
                onPressed: () => context.go('/register'),
                child: const Text('Regístrate'),
              ),
            ],
          ),
          //const Spacer(flex: 1),
        ],
      ),
    );
  }
}
