import 'package:flutter/material.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:dismov_app/config/config.dart';
import 'package:dismov_app/utils/location_utils.dart';
import 'package:dismov_app/services/shelter_service.dart';
import 'package:dismov_app/models/shelter_model.dart';
import 'package:dismov_app/shared/widgets/custom_image.dart';
import 'package:geolocator/geolocator.dart';

import '../chat/chat.dart';

class ShelterScreen extends StatelessWidget {
  const ShelterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String nameToShow = "Refugios";

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _SheltersView(),
    );
  }
}

class _SheltersView extends StatefulWidget {
  const _SheltersView();
  @override
  __SheltersViewState createState() => __SheltersViewState();
}

class __SheltersViewState extends State<_SheltersView> {
  String ubicacion = "Ubicacion Desconocida";
  Position? ubication = null;
  List<ShelterModel> _shelters = [];
  List<ShelterModel> _filteredShelters = [];
  String _searchText = "";

  void obtenerYActualizarUbicacion() async {
    String ubi = await LocationUtils().obtenerLocalizacion();
    ubication = await LocationUtils().getCurrentLocation();
    setState(() {
      ubicacion = ubi;
    });
  }

  @override
  void initState() {
    super.initState();
    obtenerYActualizarUbicacion();
  }

  void _filterShelters(String searchText) {
    setState(() {
      _searchText = searchText;
      _filteredShelters = _shelters
          .where((shelter) =>
          shelter.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
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
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.place_outlined,
                      color: AppColor.labelColor,
                      size: 30,
                    ),
                    const SizedBox(width: 5),
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text(
                  "Refugios",
                  style: TextStyle(
                    color: AppColor.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                  ),
                ),
                Text(
                  " Cerca de ti",
                  style: TextStyle(
                    color: AppColor.textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            CustomTextBox(
              hint: "Search",
              prefix: Icon(Icons.search, color: Colors.grey),
              onChanged: (text) => _filterShelters(text),
            ),
            const SizedBox(height: 10),
            _buildShelters(),
          ],
        ),
      ),
    );
  }

  Widget _buildShelters() {
    return FutureBuilder<List<ShelterModel>>(
      future: ShelterService().getAllShelters(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            (ubicacion != "Ubicacion Desconocida" && ubication == null)) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print(snapshot);
          return Center(
              child: Text('Error in getting Shelters: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No shelters available'));
        } else {
          _shelters = snapshot.data!;
          _filteredShelters = _searchText.isEmpty
              ? _shelters
              : _shelters
              .where((shelter) => shelter.name
              .toLowerCase()
              .contains(_searchText.toLowerCase()))
              .toList();

          if (ubication != null) {
            _filteredShelters.sort((a, b) {
              double distanceA = Geolocator.distanceBetween(
                ubication!.latitude,
                ubication!.longitude,
                a.latitude,
                a.longitude,
              );
              double distanceB = Geolocator.distanceBetween(
                ubication!.latitude,
                ubication!.longitude,
                b.latitude,
                b.longitude,
              );
              return distanceA.compareTo(distanceB);
            });
          }

          return Align(
            alignment: Alignment.center,
            child: Column(
              children: _filteredShelters.map((shelter) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShelterDetailPage(shelter: shelter),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 3),
                        )
                      ],
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        CustomImage(
                          shelter.imageURL,
                          borderRadius: BorderRadius.circular(50),
                          isShadow: true,
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      shelter.name,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColor.blue,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    (ubication != null)
                                        ? LocationUtils().calcularKilometros(
                                        shelter.latitude,
                                        shelter.longitude,
                                        ubication!.latitude,
                                        ubication!.longitude)
                                        : "NA",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColor.blue,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                shelter.address,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
