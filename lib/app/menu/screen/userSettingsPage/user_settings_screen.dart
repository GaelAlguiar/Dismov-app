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
        title: const Text('User Profile'),
        backgroundColor: AppColor.yellow,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
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
  bool mostrarFavoritos = false;
  bool mostrarPreferencias = false;
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
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    SizedBox(
                      height: 10,
                      width: 5,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 3,
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
          /*String? email = FirebaseAuth.instance.currentUser?.email;
          String? name = FirebaseAuth.instance.currentUser?.displayName;
          String? profilePhoto = FirebaseAuth.instance.currentUser?.photoURL;
<<<<<<< HEAD:lib/app/menu/screen/userSettingsPage/userSettingsScreen.dart
            Future<List> users = getUser(email);*/
            return SingleChildScrollView(

              child: Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, children: [
                  /*Text(name.toString()),
                  colocarImagen(profilePhoto.toString()),
                  Text(email.toString()),*/
                  ListView(
                    children: [
                      ExpansionPanelList(
                        elevation: 1,
                        expansionCallback: (int index, bool isExpanded){
                          
                        },
                      )
                    ],
                  ),

                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 25),
                    child: CustomFilledButton(
                      text: "Cerrar Sesión",
                      buttonColor: AppColor.darker,
                      onPressed: () async {
                        await LoginGoogleUtils().signOutGoogle();
                        await LoginGoogleUtils().singOutWithEmail();
                        if (FirebaseAuth.instance.currentUser == null) {
                          context.go("/login");
                        }
                      },
=======
          // Future<List> users = getUser(email);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(name.toString()),
                    colocarImagen(profilePhoto.toString()),
                    Text(email.toString()),
                    const SizedBox(
                      height: 25,
>>>>>>> 45c41cbc7122b9c738b08c0a7039f2499960d501:lib/app/menu/screen/userSettingsPage/user_settings_screen.dart
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
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
      'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png',
      width: 100,
      height: 100,
    );
  } else {
    return Image.network(
      url,
      width: 100,
      height: 100,
    );
  }
}
