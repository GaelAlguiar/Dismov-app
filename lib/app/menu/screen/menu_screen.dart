import 'package:carousel_slider/carousel_slider.dart';
import 'package:dismov_app/app/utils/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:dismov_app/config/config.dart';

//Location
import 'package:dismov_app/utils/location_utils.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final scaffoldKey = GlobalKey<ScaffoldState>();
    String nameToShow = "Hola!";
    String name = "";
    //Agrega el nombre del usuario al menu inicial
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        String? fullName = FirebaseAuth.instance.currentUser?.displayName;
        if (fullName != null) {
          List<String> nameParts = fullName.split(" ");
          name = nameParts.first;
        }

        nameToShow = "$nameToShow $name";
      }
    } catch (e) {
      nameToShow = "Ha ocurrido un problema, reinicia la aplicación";
    }

    return Scaffold(
      // drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: Text(
          nameToShow,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColor.yellow,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _MenuView(),
    );
  }
}

class _MenuView extends StatefulWidget {
  const _MenuView();

  @override
  __MenuViewState createState() => __MenuViewState();
}

class __MenuViewState extends State<_MenuView> {
  //Comprueba Ubicacion
  String ubicacion = "Ubicacion Desconocida";
  void obtenerYActualizarUbicacion() async {
    String ubi = await LocationUtils().obtenerLocalizacion();
    setState(() {
<<<<<<< HEAD
      ubicacion = ubi; // Actualiza la ubicación una vez que se resuelve el Future
    });
=======
      ubicacion =
          ubi; // Actualiza la ubicación una vez que se resuelve el Future
    }); // Actualiza la ubicación una vez que se resuelve el Future
>>>>>>> b7d8bce45d9e3d2e5fd8d257e5f53edee910114c
  }

  @override
  void initState() {
    super.initState();
    // Llama al método para actualizar la ubicación al entrar en el menu screen
    obtenerYActualizarUbicacion();
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
            title: _buildAppBar(ubicacion),
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

  Widget _buildAppBar(String location) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.place_outlined,
                      color: AppColor.labelColor,
                      size: 20,
                    ),
                    SizedBox(
                      height: 10,
                      width: 5,
                    ),
                    Text(
                      "Locación",
                      style: TextStyle(
                        color: AppColor.labelColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                location,
                style: const TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 10,
        ),
        _buildCategories(),
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.only(
              left: 30), // Ajusta el relleno interno según sea necesario
          child: Text(
            "Adóptame",
            style: TextStyle(
              color: AppColor.textColor,
              fontWeight: FontWeight.w500,
              fontSize: 30,
            ),
          ),
        ),
        _buildPets(),
      ]),
    );
  }

  int _selectedCategory = 0;
  _buildCategories() {
    List<Widget> lists = List.generate(
      categories.length,
      (index) => CategoryItem(
        data: categories[index],
        selected: index == _selectedCategory,
        onTap: () {
          setState(() {
            _selectedCategory = index;
          });
        },
      ),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 10, left: 10),
      child: Row(children: lists),
    );
  }

  _buildPets() {
    double height = MediaQuery.of(context).size.height * .70;
    return Align(
      alignment: Alignment.center,
      child: CarouselSlider(
        options: CarouselOptions(
          height: height,
          enlargeCenterPage: true,
          disableCenter: true,
          viewportFraction: .9,
          scrollDirection:
              Axis.vertical, // Configura la dirección del desplazamiento
        ),
        items: List.generate(
          pets.length,
          (index) => Align(
            alignment: Alignment.center,
            child: PetItem(
              data: pets[index],
              height: height,
              onTap: null,
              onFavoriteTap: () {
                setState(() {
                  pets[index]["is_favorited"] = !pets[index]["is_favorited"];
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
