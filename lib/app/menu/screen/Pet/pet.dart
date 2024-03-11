import 'package:dismov_app/app/utils/data.dart'; // Assuming data.dart has getData function
import 'package:dismov_app/shared/shared.dart'; // Assuming shared.dart has PetItem widget
import 'package:flutter/material.dart';
import 'package:dismov_app/app/menu/screen/Pet/petprofile.dart';
import '../../../../config/theme/color.dart';


class PetPage extends StatelessWidget {
  const PetPage({super.key});

  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pets'),
        backgroundColor: AppColor.yellow,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const SearchPets(),
    );
  }
}


class SearchPets extends StatefulWidget {
  const SearchPets({super.key});

  @override
  State<SearchPets> createState() => _SearchPetsState();
}

class _SearchPetsState extends State<SearchPets> {
  List<dynamic> petsSelected = [];
  String searchText = "";
  List<String> selectedSpecies = [];
  List<String> selectedSizes = [];

  @override
  void initState() {
    super.initState();
    petsSelected = pets; // Assign pets from data.dart
  }
  void filterPets(String searchText, List<String> selectedSpecies, List<String> selectedSizes) {
    setState(() {
      pets = pets.where((pet) =>
      pet.name.contains(searchText) &&
          (selectedSpecies.isEmpty || selectedSpecies.contains(pet.species)) &&
          (selectedSizes.isEmpty || selectedSizes.contains(pet.size))
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buscar Mascotas"),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (text) {
              searchText = text;
              filterPets(searchText, selectedSpecies, selectedSizes);
            },
          ),
          // Implement widgets for species and size filters (Checkbox/DropdownButton)
          Expanded(
            child: ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                return Center(
                  child: GestureDetector(
                    onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PetProfilePage(key: UniqueKey(), pet: pets[index]),
                    ),
                  );
                },
                    child: PetItem(
                      data: pets[index],
                      height: 300,
                      width:380, // Adjust width as needed
                      onTap: null,
                      onFavoriteTap: () {
                        setState(() {
                          pets[index].isFavorited = !pets[index].isFavorited;
                        });
                  },
                )));
              },
            ),
          ),
        ],
      ),
    );
  }
}

