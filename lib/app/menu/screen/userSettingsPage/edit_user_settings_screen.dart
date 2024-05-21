import 'package:dismov_app/app/menu/screen/userSettingsPage/edit_user_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:dismov_app/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:dismov_app/utils/login_google_utils.dart';
import 'package:dismov_app/provider/auth_provider.dart';
import 'package:hive/hive.dart';

class EditUserSettingsScreen extends StatelessWidget {
  const EditUserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColor.blue,
        actions: [
          ElevatedButton(
            onPressed: () {
              // Acción a realizar cuando se presiona el botón
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.blue,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
            child: Text(
              'Guardar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          )
        ],
      ),
      body: const _UserSettingsView(),
    );
  }
}

class _UserSettingsView extends StatefulWidget {
  const _UserSettingsView();

  @override
  __UserSettingsState createState() => __UserSettingsState();
}

class __UserSettingsState extends State<_UserSettingsView> {
  late Box userBox;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box('userBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildBody(),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Row(
                  children: [
                    SizedBox(
                      height: 0,
                      width: 5,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    AuthenticationProvider ap =
        Provider.of<AuthenticationProvider>(context, listen: false);
    return FutureBuilder(
      future: LoginGoogleUtils().isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          String email = ap.user?.email ?? '';
          String name = ap.user?.name ?? '';
          String? profilePhoto = ap.user?.profilePicURL;
          String description = userBox.get('description', defaultValue: '');

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      colocarImagen(profilePhoto.toString()),
                      const SizedBox(height: 4),
                      IconButton(
                        onPressed: () {

                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 7),
                      
                      TextFormField(
                        //controller: _nombreController,
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 57, 57, 57),
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 52, 143, 217),
                              width: 2,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        //controller: _nombreController,
                        decoration: InputDecoration(
                          labelText: 'Descripcion',
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 57, 57, 57),
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 52, 143, 217),
                              width: 2,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        //controller: _correoController,
                        keyboardType: TextInputType
                            .emailAddress, // Establece el tipo de teclado como email
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 57, 57, 57),
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 52, 143, 217),
                              width: 2,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        //controller: _passwordController,
                        obscureText: true, // Establece el texto como oculto
                        keyboardType: TextInputType
                            .phone, // El tipo de teclado predeterminado es adecuado para contraseñas
                        decoration: InputDecoration(
                          labelText: 'Telefono',
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 57, 57, 57),
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 52, 143, 217),
                              width: 2,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
                        child: SizedBox(
                          width: 200,
                          height: 47,
                          child: CustomFilledButton(
                            text: "Eliminar Cuenta",
                            buttonColor: const Color.fromARGB(255, 228, 14, 39),
                            onPressed: () async {

                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class _EditDescriptionDialog extends StatefulWidget {
  const _EditDescriptionDialog();

  @override
  __EditDescriptionDialogState createState() => __EditDescriptionDialogState();
}

class __EditDescriptionDialogState extends State<_EditDescriptionDialog> {
  late TextEditingController _descriptionController;
  late Box userBox;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box('userBox');
    _descriptionController = TextEditingController(
      text: userBox.get(
        'description',
        defaultValue: '',
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar descripción'),
      content: SingleChildScrollView(
        child: TextField(
          controller: _descriptionController,
          maxLines: null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop;
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            userBox.put('description', _descriptionController.text);
            Navigator.of(context).pop();
            setState(() {});
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

colocarImagen(String url) {
  if (url == 'null') {
    return Image.network(
      'https://cdn-icons-png.flaticon.com/512/3541/3541871.png',
      width: 190,
      height: 190,
    );
  } else {
    return Container(
      width: 190,
      height: 190,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 52, 143, 217),
          width: 3,
        ),
        borderRadius: BorderRadius.circular(17.8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          url,
          width: 190,
          height: 190,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
