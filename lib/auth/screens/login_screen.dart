import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:dismov_app/auth/db/db.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    final DatabaseHelper dbHelper = DatabaseHelper();

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
                    'assets/images/logo_Blanco.png',
                    width: 150,
                    height: 150,
                  ),
                  onPressed: () => {},
                ),
                const SizedBox(height: 45),

                Container(
                  height:
                      size.height - 260, // 80 los dos sizebox y 100 el ícono
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
                  child: _LoginForm(dbHelper: dbHelper),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final DatabaseHelper dbHelper;

  const _LoginForm({required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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
            controller: usernameController,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            controller: passwordController,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Ingresar',
              buttonColor: Colors.purple[900],
              onPressed: () {
                _handleLogin(
                    context, usernameController.text, passwordController.text);
              },
            ),
          ),
          const Spacer(flex: 2),
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

  void _handleLogin(
      BuildContext context, String username, String password) async {
    List<Map<String, dynamic>> users = await dbHelper.getUsers();
    bool isAuthenticated = false;

    for (var user in users) {
      if (user['username'] == username && user['password'] == password) {
        isAuthenticated = true;
        break;
      }
    }

    BuildContext scaffoldContext = context;

    if (isAuthenticated) {
      if (scaffoldContext.mounted) {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          const SnackBar(
            content: Text(
              'Sesión iniciada exitosamente',
              style: TextStyle(fontSize: 14),
            ),
            backgroundColor: Color.fromARGB(255, 25, 158, 60),
          ),
        );
        GoRouter.of(scaffoldContext).go('/');
      }
    } else {
      if (scaffoldContext.mounted) {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          const SnackBar(
            content: Text(
              'Información Incorrecta',
              style: TextStyle(fontSize: 14),
            ),
            backgroundColor: Color.fromARGB(255, 158, 34, 25),
          ),
        );
      }
    }
  }
}
