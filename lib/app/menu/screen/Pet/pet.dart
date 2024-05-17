import 'package:dismov_app/services/pet_service.dart';
import 'package:dismov_app/shared/shared.dart'; // Assuming shared.dart has PetItem widget
import 'package:flutter/material.dart';
import 'package:dismov_app/app/menu/screen/Pet/petprofile.dart';
import '../../../../config/theme/color.dart';

class PetPage extends StatelessWidget {
  const PetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pets'),
        backgroundColor: AppColor.yellow,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
          ),
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
  late List<dynamic> petsSelected = [];
  String searchText = "";
  List<String> selectedSpecies = [];
  List<String> selectedSizes = [];

  @override
  void initState() {
    super.initState();
    PetService().getAllPets().then((pets) {
      setState(() {
        petsSelected = pets;
      });
    });
  }

  void filterPets(String searchText, List<String> selectedSpecies,
      List<String> selectedSizes) {
    setState(() {
      petsSelected = petsSelected
          .where((pet) =>
      pet["name"].contains(searchText) &&
          (selectedSpecies.isEmpty ||
              selectedSpecies.contains(pet["species"])) &&
          (selectedSizes.isEmpty || selectedSizes.contains(pet["size"])))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscar Mascotas"),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (text) {
              setState(() {
                searchText = text;
              });
              filterPets(searchText, selectedSpecies, selectedSizes);
            },
          ),
          // Implement widgets for species and size filters (Checkbox/DropdownButton)
          Expanded(
            child: ListView.builder(
              itemCount: petsSelected.length,
              itemBuilder: (context, index) {
                return Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetProfilePage(
                            key: UniqueKey(),
                            pet: petsSelected[index],
                          ),
                        ),
                      );
                    },
                    child: PetItem(
                      data: petsSelected[index],
                      height: 300,
                      width: 380, // Adjust width as needed
                      onTap: null,
                      onFavoriteTap: () {
                        setState(() {
                          petsSelected[index]["is_favorited"] =
                          !petsSelected[index]["is_favorited"];
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}