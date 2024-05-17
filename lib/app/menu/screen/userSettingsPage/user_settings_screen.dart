// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:dismov_app/app/utils/data.dart';
// import 'package:dismov_app/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:dismov_app/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
//Utils for Google Login
import 'package:dismov_app/utils/login_google_utils.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: AppColor.yellow,
        actions: [
          IconButton(
            onPressed: () {

            }, 
            icon: const Icon(Icons.edit)
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
          )
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

  _buildBody() {
    return FutureBuilder(
      future: LoginGoogleUtils().isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          String? email        = FirebaseAuth.instance.currentUser?.email;
          String? name         = FirebaseAuth.instance.currentUser?.displayName;
          String? profilePhoto = FirebaseAuth.instance.currentUser?.photoURL;
          // Future<List> users = getUser(email);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Text(name.toString()),
                    colocarImagen(profilePhoto.toString()),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      name.toString(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      email.toString(),
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: 350,
                      height: 80,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color.fromARGB(255, 52, 143, 217), 
                            width: 2, 
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Dog lover.\n21 years old.',
                              style: TextStyle(
                              fontSize: 17,
                            ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Preferencias de mascota',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Acción de editar preferencias
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Chip(
                          label: Text('Pequeño'),
                        ),
                        SizedBox(width: 8),
                        Chip(
                          label: Text('Activo'),
                        ),
                        SizedBox(width: 8),
                        Chip(
                          label: Text('Perro'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),


                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
                      child: SizedBox(
                        width: 200,
                        height: 47,
                        child: CustomFilledButton(
                          text: "Cerrar Sesión",
                          buttonColor: AppColor.darker,
                          onPressed: () async {
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
                    /*Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
                      child: CustomFilledButton(
                        text: "Editar perfil",
                          buttonColor: AppColor.darker,
                          onPressed: () async {
                            
                          },
                      ),
                    )*/
                  ]),
            ),
          );
        }
      },
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
    return Image.network(
      url,
      width: 190,
      height: 190,
    );
  }
}