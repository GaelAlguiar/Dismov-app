import 'package:dismov_app/Json/users.dart';
import 'package:dismov_app/auth/db/sqlite.dart';
import 'package:dismov_app/config/config.dart';
import 'package:dismov_app/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dismov_app/shared/shared.dart';

import 'package:firebase_auth/firebase_auth.dart';
//Utils for Google Login
import 'package:dismov_app/utils/loginGoogleUtils.dart';


// RegisterScreen
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                const SizedBox(height: 80),
                // Icon Banner
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: IconButton(
                        onPressed: () {
                          context.go("/login");
                        },
                        icon: const Icon(Icons.arrow_back_rounded,
                            size: 40, color: Colors.white),
                      ),
                    ),
                    const Spacer(flex: 1),
                    Text(
                      'Crear cuenta',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
                const SizedBox(height: 50),
                Container(
                  height: MediaQuery.of(context).size.height - 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                    ),
                  ),
                  child: const _RegisterForm(),
                ),
              ],
            ),
          ),
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
          const SizedBox(height: 50),
          const SizedBox(height: 50),
          CustomTextFormField(
            label: 'Nombre completo',
            keyboardType: TextInputType.emailAddress,
            controller: username,
          ),
          const SizedBox(height: 30),
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
          CustomTextFormField(
            label: 'Repita la contraseña',
            obscureText: true,
            controller: confirmPassword,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
                text: 'Crear',
                buttonColor: AppColor.yellowCustom,
                onPressed: () async {
                  await LoginGoogleUtils().createUserWithEmail(email.text,password.text);
                  if (FirebaseAuth.instance.currentUser != null) {
                    FirebaseAuth.instance.currentUser?.updateDisplayName(username.text);
                    addPeople(username.text, email.text);
                    context.go("/Root");
                  }
                },),
          ),
          const Spacer(flex: 2),
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
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
