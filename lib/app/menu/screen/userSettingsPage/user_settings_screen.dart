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
                    Text(name.toString()),
                    colocarImagen(profilePhoto.toString()),
                    Text(email.toString()),
                    const SizedBox(
                      height: 25,
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
      'https://cdn-icons-png.flaticon.com/512/3541/3541871.png',
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