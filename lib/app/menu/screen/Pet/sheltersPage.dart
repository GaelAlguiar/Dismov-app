import 'package:carousel_slider/carousel_slider.dart';
import 'package:dismov_app/app/utils/data.dart'; // Debes eliminar esta importación
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:dismov_app/config/config.dart';
import 'package:dismov_app/shared/widgets/shelter_item.dart';
import 'package:dismov_app/app/menu/screen/Pet/petprofile.dart';
//Location
import 'package:dismov_app/utils/location_utils.dart';
import 'package:dismov_app/app/menu/screen/chat/chat.dart';
import 'package:dismov_app/services/shelter_service.dart'; // Importa tu servicio de refugios

import '../../../../models/shelter_model.dart';
import '../../../../shared/widgets/custom_image.dart';

class ShelterScreen extends StatelessWidget {
  const ShelterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final scaffoldKey = GlobalKey<ScaffoldState>();
    String nameToShow = "Refugios";

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
        backgroundColor:Color.fromRGBO(	11	,96,	151,1),
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
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.place_outlined,
                      color: AppColor.labelColor,
                      size: 30,
                    ),
                    SizedBox(
                      height: 10,
                      width: 5,
                    ),
                    Text(
                      location,
                      style: TextStyle(
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

            ],
          ),
        ),
      ],
    );
  }

  _buildBody() {
    return SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20), // Margen a los lados de 20
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
              SizedBox(height: 10,),
              CustomTextBox(
                hint: "Search",
                prefix: Icon(Icons.search, color: Colors.grey),
              ),
              SizedBox(height: 10,),
              _buildShelters(),
            ],
          ),
        )

    );
  }

  //Widget to build list of shelters
  _buildShelters() {
    double height = MediaQuery.of(context).size.height * .80;

    return FutureBuilder<List<ShelterModel>>(
      future: ShelterService().getAllShelters(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final List<ShelterModel> shelters = snapshot.data!;
          return Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: shelters.map((shelter) => Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShelterDetailPage(shelter: shelter),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 3),
                            ),
                          ],
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            CustomImage(
                              shelter.image,
                              borderRadius: BorderRadius.circular(50),
                              isShadow: true,
                              width: 80,
                              height: 80,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shelter.name,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColor.blue,
                                    ),
                                  ),
                                  Text(
                                    shelter.address,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )).toList(),
            ),
          );
        }
      },
    );
  }}