import 'dart:io';

import 'package:dismov_app/app/menu/screen/userSettingsPage/edit_user_settings_screen.dart';
import 'package:dismov_app/app/menu/screen/userSettingsPage/pet_preferences.dart';
import 'package:dismov_app/app/menu/screen/userSettingsPage/pick_image_edit.dart';
import 'package:dismov_app/models/user_model.dart';
import 'package:dismov_app/services/user_service.dart';
import 'package:dismov_app/utils/ask_confirmation_to_continue.dart';
import 'package:dismov_app/utils/show_error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:dismov_app/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:dismov_app/utils/login_google_utils.dart';
import 'package:dismov_app/provider/auth_provider.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

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
          SliverAppBar(
            backgroundColor: AppColor.appBarColor,
            pinned: true,
            snap: true,
            floating: true,
            title: _buildAppBar(),
          ),
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
          File? image;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                      const SizedBox(height: 34),
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
                            showErrorSnackbar(context, 'Error al subir la imagen.');
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
                                    image,
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
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const _EditDescriptionDialog();
                        },
                      ).then((_) {
                        setState(() {});
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.12,
                      decoration: BoxDecoration(
                        color: description.isEmpty
                            ? Colors.grey[200]
                            : Colors.white,
                        border: Border.all(
                          color: const Color.fromARGB(255, 52, 143, 217),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            description.isNotEmpty
                                ? description
                                : 'Añade una descripción...',
                            style: TextStyle(
                              fontSize: 17,
                              color: description.isNotEmpty
                                  ? Colors.black
                                  : Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Preferencias de mascota',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PetPreferences(),
                          ));
                        },
                      ),
                    ],
                  ),
                  FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('preferences')
                        .where('useruid', isEqualTo: ap.user!.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error al cargar preferencias');
                      } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const SizedBox.shrink();
                      } else {
                        var preferences = snapshot.data!.docs[0].data() as Map<String, dynamic>;
                        String type = preferences['type'] ?? '';
                        List<dynamic> features = preferences['features'] ?? [];
                        String size = preferences['size'] ?? '';

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (type.isNotEmpty)
                              Chip(label: Text(type)),
                            if (features.isNotEmpty)
                              Chip(label: Text(features[0])),
                            if (size.isNotEmpty)
                              Chip(label: Text(size)),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
                    child: SizedBox(
                      width: 200,
                      height: 47,
                      child: CustomFilledButton(
                        text: "Cerrar Sesión",
                        buttonColor: AppColor.blue,
                        onPressed: () async {
                          bool answer = await askConfirmationToContinue(context,
                              '¿Estás seguro de que quieres cerrar sesión?');
                          if (!answer) return;
                          await LoginGoogleUtils().signOutGoogle();
                          await LoginGoogleUtils().singOutWithEmail();
                          if (FirebaseAuth.instance.currentUser == null) {
                            if (context.mounted) {
                              context.go("/login");
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
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
