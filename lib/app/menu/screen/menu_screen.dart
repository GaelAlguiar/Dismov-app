// Debes eliminar esta importación
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:dismov_app/config/config.dart';
//Location
import 'package:dismov_app/utils/location_utils.dart';
import 'package:dismov_app/app/menu/screen/chat/chat.dart';
import 'package:dismov_app/services/shelter_service.dart'; // Importa tu servicio de refugios
import 'package:flutter/widgets.dart';
import '../../../../models/shelter_model.dart';
import '../../../../shared/widgets/custom_image.dart';
//no se
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dismov_app/app/utils/data.dart';
import 'package:dismov_app/provider/auth_provider.dart';
import 'package:dismov_app/services/pet_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:dismov_app/config/config.dart';
import 'package:dismov_app/utils/location_utils.dart';
import '../../../models/pet_model.dart';
import 'package:dismov_app/app/menu/screen/Pet/petprofile.dart';

import 'package:provider/provider.dart';


class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationProvider authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
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
        backgroundColor:const Color.fromRGBO(	11	,96,	151,1),
        actions: [

        ],
      ),
      body: _MenuView(),
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
      ubicacion = ubi; // Actualiza la ubicación una vez que se resuelve el Future
    });
  }

  @override
  void initState() {
    super.initState();
    // Llama al método para actualizar la ubicación al entrar en el menu screen
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
                } else if(!snapshot.hasData)
                {
                  return const Center(
                    child: Text('No hay mascotas a mostrar'),
                  );
                }
                else {
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: filteredPets.length, // Número de elementos en el grid
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
              }
          ),
        ],
      ),
    );
  }
  int _selectedCategory = 0;
  Widget _categoriesWidget(){
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
          padding: const EdgeInsets.symmetric(vertical: 8.0), // Espaciado vertical entre elementos
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: const Column(
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
                  const SizedBox(height: 10,),

                ],
              ),

            ],
          ),
        ),
      ],
    );
  }


}