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
// Importar la página de perfil de la mascota

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
      appBar: AppBar(
        title: Text(
          nameToShow,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color.fromRGBO(11, 96, 151, 1),
        actions: [
          IconButton(
            onPressed: () => _showSearch(context),
            icon: const Icon(Icons.search_rounded),
          )
        ],
      ),
      body: const _MenuView(),
    );
  }

  void _showSearch(BuildContext context) {
    showSearch(context: context, delegate: PetSearchDelegate());
  }
}

class PetSearchDelegate extends SearchDelegate<String> {
  final List<PetModel> _filteredPets = [];

  @override
  String get searchFieldLabel => 'Buscar Mascotas';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          _updateFilteredPets('');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return FutureBuilder<List<PetModel>>(
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
        } else {
          final List<PetModel> allPets = snapshot.data!;
          _updateFilteredPets(query, allPets);

          return ListView.builder(
            itemCount: _filteredPets.length,
            itemBuilder: (context, index) {
              final PetModel pet = _filteredPets[index];
              return ListTile(
                title: Text(pet.name),
                onTap: () {
                  // Navegar a la página de perfil de la mascota cuando se hace clic en la mascota
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PetProfilePage(
                        key: UniqueKey(),
                        pet: pet,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  void _updateFilteredPets(String query, [List<PetModel>? allPets]) {
    if (allPets == null) return;

    _filteredPets.clear();

    if (query.isEmpty) {
      _filteredPets.addAll(allPets);
    } else {
      _filteredPets.addAll(allPets.where(
        (pet) => pet.name.toLowerCase().contains(query.toLowerCase()),
      ));
    }
  }
}

class _MenuView extends StatefulWidget {
  const _MenuView();
  @override
  __MenuViewState createState() => __MenuViewState();
}

class __MenuViewState extends State<_MenuView> {
  String ubicacion = "Ubicacion Desconocida";

  void obtenerYActualizarUbicacion() async {
    String ubi = await LocationUtils().obtenerLocalizacion();
    setState(() {
      ubicacion = ubi;
    });
  }

  @override
  void initState() {
    super.initState();
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
                      size: 23,
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
          height: 15,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "¡Escoge a tu Mejor Amigo!",
            style: TextStyle(
              color: AppColor.textColor,
              fontWeight: FontWeight.w500,
              fontSize: 25,
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
      padding: const EdgeInsets.only(bottom: 20, left: 10),
      child: Row(children: lists),
    );
  }

  _buildPets() {
    double height = MediaQuery.of(context).size.height * 0.70;
    return FutureBuilder<List<PetModel>>(
      future: PetService().getAllPets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          print(snapshot);
          return Center(
            child: Text('Error pets: ${snapshot.error}'),
          );
        } else {
          final List<PetModel> pets = snapshot.data!;
          List<PetModel> filteredPets = [];

          if (_selectedCategory == 0) {
            // Mostrar todas las mascotas
            filteredPets.addAll(pets);
          } else if (_selectedCategory == 1) {
            // Mostrar solo perros
            filteredPets.addAll(pets.where((pet) => pet.type == 'dog'));
          } else if (_selectedCategory == 2) {
            // Mostrar solo gatos
            filteredPets.addAll(pets.where((pet) => pet.type == 'cat'));
          }

          return Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 10),
            child: Align(
              alignment: Alignment.center,
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  height: height,
                  enlargeCenterPage: true,
                  disableCenter: true,
                  viewportFraction: .40,
                  scrollDirection: Axis.vertical,
                ),
                itemCount: (filteredPets.length / 2).ceil(),
                itemBuilder: (context, index, realIndex) {
                  final int firstIndex = index * 2;
                  final int secondIndex = firstIndex + 1;
                  return Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: PetItem(
                            data: filteredPets[firstIndex].toMap(),
                            height: height,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PetProfilePage(
                                    key: UniqueKey(),
                                    pet: filteredPets[firstIndex],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 15,
                          ),
                          child: PetItem(
                            data: filteredPets[secondIndex].toMap(),
                            height: height,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PetProfilePage(
                                    key: UniqueKey(),
                                    pet: filteredPets[secondIndex],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
