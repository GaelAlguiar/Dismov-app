import 'dart:io';
//import 'package:dismov_app/app/menu/screen/userSettingsPage/edit_user_settings_screen.dart';
import 'package:dismov_app/app/menu/screen/userSettingsPage/pick_image_edit.dart';
import 'package:dismov_app/config/router/app_router.dart';
import 'package:dismov_app/models/user_model.dart';
import 'package:dismov_app/services/user_service.dart';
import 'package:dismov_app/utils/ask_confirmation_to_continue.dart';
import 'package:dismov_app/utils/show_error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:dismov_app/config/config.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:dismov_app/utils/login_google_utils.dart';
import 'package:dismov_app/provider/auth_provider.dart';
import 'package:hive/hive.dart';
import 'package:dismov_app/utils/pick_image.dart';

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
    TextEditingController nameController = TextEditingController(text: ap.user!.name);
    TextEditingController descriptionController = TextEditingController(text: userBox.get('description', defaultValue: ''));
    return FutureBuilder(
      future: LoginGoogleUtils().isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          String name = ap.user?.name ?? '';
          String? profilePhoto = ap.user?.profilePicURL;
          String description = userBox.get('description', defaultValue: '');
          File? image;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              String name = nameController.text;
                              String description = descriptionController.text;

                              if (name.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('El nombre no puede estar vacío'),
                                  ),
                                );
                                return;
                              }

                              if (description.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('La descripción no puede estar vacía'),
                                  ),
                                );
                                return;
                              }

                              try
                              {
                                UserModel updateUser = UserModel(
                                  uid: ap.user!.uid,
                                  name: name,
                                  email: ap.user!.email ,
                                  profilePicURL: image != null
                                      ? await UserService().uploadProfilePic(image!, ap.user!.uid)
                                      : null,
                                );
                                UserService().updateUser(updateUser);

                              }catch(e)
                              {

                              }

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.blue,
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            ),
                            child: const Text(
                              'Guardar ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () async {
                          image = await pickImageEdit(context);
                          // change the image
                          if (image == null) return ;
                          if (!context.mounted) return;
                          if (ap.user == null) return;
                          late String? imageURL;
                          // save the image
                          try {
                            imageURL = await UserService().updateProfilePic(
                              image!,
                              ap.user!.uid,
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            imageURL = null;
                            showErrorSnackbar(context, e.toString());
                            return;
                          }
                          if (!context.mounted) return;
                          if (imageURL == null) return;
                          if (ap.user == null) return;
                          ap.user = UserModel(
                            uid: ap.user!.uid,
                            name: ap.user!.name,
                            email: ap.user!.email,
                            profilePicURL: imageURL,
                          );
                          setState(() {
                            profilePhoto = imageURL;
                          });
                        },
                        child: CircleAvatar(
                          radius: 80,
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
                              : colocarImagen(
                                  profilePhoto.toString(),
                                ),
                        ),
                      ),
                      const SizedBox(height: 34),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 57, 57, 57),
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 52, 143, 217),
                              width: 2,
                            ),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 46),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Descripcion',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 57, 57, 57),
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 52, 143, 217),
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        minLines: 3, // Número mínimo de líneas visibles
                        maxLines:
                            null, // Número máximo de líneas visibles (puedes poner null para ilimitadas)
                      ),
                      const SizedBox(height: 16),
                      /*TextFormField(
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
                      ),*/

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
                              bool confirm = await askConfirmationToContinue(
                                context,
                                '¿Estás seguro de que deseas eliminar tu cuenta?',
                              );
                              if (confirm) {
                                if (!context.mounted) return;
                                await UserService().signOutUser(context);
                              }
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
