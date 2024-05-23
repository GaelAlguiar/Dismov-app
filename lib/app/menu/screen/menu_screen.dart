// Debes eliminar esta importación
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:dismov_app/config/config.dart';
//Location
import 'package:dismov_app/utils/location_utils.dart';

//Data
import 'package:dismov_app/app/utils/data.dart';
import 'package:dismov_app/provider/auth_provider.dart';
import 'package:dismov_app/services/pet_service.dart';
import 'package:geolocator/geolocator.dart';
import '../../../models/location_model.dart';
import '../../../models/pet_model.dart';
import 'package:dismov_app/app/menu/screen/Pet/petprofile.dart';
import 'package:provider/provider.dart';

import '../../../provider/location_provider.dart';
import '../../../services/location_service.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationProvider authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    String nameToShow = "Hola!";
    String name = "";
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        String? fullName = authProvider.user?.name;
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
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color.fromRGBO(11, 96, 151, 1),

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
  Position? location = null;
  LocationProvider? lp = null;
  void obtenerYActualizarUbicacion() async {
    await LocationService().defineLocation(context);

    LocationModel loc = Provider.of<LocationProvider>(
        context,
        listen: false)
        .location!;
    String ubi = await LocationUtils().getAdressFromCoordinates(loc.ubicacion);
    setState(() {
      location = loc.ubicacion;
      ubicacion = ubi;
    });
    //Forma inicial de obtener ubicación
    //String ubi = await LocationUtils().obtenerLocalizacion();
  }

  @override
  void initState() {
    super.initState();
    obtenerYActualizarUbicacion();
  }

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          _buildAppBar(ubicacion),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  scrollDirection: Axis.horizontal,
                  child: _categoriesWidget(),
                ),
              ),
            ],
          ),
          FutureBuilder<List<PetModel>>(
              future: PetService().getAllPets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No hay mascotas a mostrar'),
                  );
                } else {
                  final List<PetModel> pets = snapshot.data!;
                  List<PetModel> filteredPets = [];

                  if (_selectedCategory == 0) {
                    filteredPets.addAll(pets);
                  } else if (_selectedCategory == 1) {
                    filteredPets.addAll(pets.where((pet) => pet.type == 'dog'));
                  } else if (_selectedCategory == 2) {
                    filteredPets.addAll(pets.where((pet) => pet.type == 'cat'));
                  }
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: filteredPets
                            .length, // Número de elementos en el grid
                        itemBuilder: (context, index) {
                          return PetItem(
                            data: filteredPets[index].toMap(),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PetProfilePage(
                                    key: UniqueKey(),
                                    pet: filteredPets[index],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }

  int _selectedCategory = 0;
  Widget _categoriesWidget() {
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        categories.length,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 8.0), // Espaciado vertical entre elementos
          child: CategoryItem(
            data: categories[index],
            selected: index == _selectedCategory,
            onTap: () {
              setState(() {
                _selectedCategory = index;
              });
            },
          ),
        ),
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
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.place_outlined,
                      color: AppColor.labelColor,
                      size: 30,
                    ),
                    const SizedBox(
                      height: 10,
                      width: 5,
                    ),
                    Text(
                      location,
                      style: const TextStyle(
                        color: AppColor.textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Encuentra mascotas",
                          style: TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          "increibles",
                          style: TextStyle(
                            color: AppColor.blue,
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
