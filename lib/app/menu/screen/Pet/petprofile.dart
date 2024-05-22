
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismov_app/app/menu/screen/chat/chat_detail.dart';
import 'package:dismov_app/models/chat_model.dart';
import 'package:dismov_app/models/pet_model.dart';
import 'package:dismov_app/models/shelter_model.dart';
import 'package:dismov_app/models/user_model.dart';
import 'package:dismov_app/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../services/shelter_service.dart';
import 'package:dismov_app/services/chat_service.dart';

import '../../../../shared/widgets/custom_image.dart';
import '../../../../utils/location_utils.dart';
import '../chat/chat.dart';


class PetProfilePage extends StatefulWidget {
  final PetModel pet;
  PetProfilePage({super.key, required this.pet});

  @override
  _PetProfilePageState createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {

  final ChatService _chatService = ChatService();
  String petAdress = "";
  Position? ubicacion = null;
  @override
  void initState() {
    super.initState();
    obtenerYActualizarUbicacion();
  }
  String getAdress(double lat, double long)
  {
    petAdress = LocationUtils().getAdressFromLatLong(lat, long);
    return petAdress;
  }
  static const double R = 6371000; // Radio de la Tierra en metros

  static double _degToRad(double degrees) {
    return degrees * pi / 180;
  }

  static String calcularKilometros(double lat1, double lon1, double lat2, double lon2) {
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) * cos(_degToRad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distanceInMeters = R * c; // Distancia en metros

    if (distanceInMeters < 1000) {
      return distanceInMeters.toStringAsFixed(2) + 'm';
    } else {
      double distanceInKm = distanceInMeters / 1000;
      return distanceInKm.toStringAsFixed(2) + 'Km';
    }
  }
  void obtenerYActualizarUbicacion() async {
    var location = await LocationUtils().getCurrentLocation();
    setState(() {
      ubicacion = location;
    });
  }





  @override

  Widget build(BuildContext context) {
    String imgFondo = widget.pet.imageURLs[0];
    return FutureBuilder<ShelterModel?>(

      future: ShelterService().getShelterById(widget.pet.shelterId),

      builder: (context, AsyncSnapshot<ShelterModel?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {

          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          var shelter = snapshot.data!;
          var shelterName = shelter.name;
          String colorsString = widget.pet.colors.join(',');
          //petAdress = getAdress(shelter.latitude, shelter.longitude);



          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children:
                [
                  Container(
                    constraints: BoxConstraints(maxHeight: 300),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/fondoblue.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                        children: [
                          Container(
                            child: PageView.builder(
                              itemCount: widget.pet.imageURLs.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Image.network(
                                            widget.pet.imageURLs[index],
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Image.network(
                                    widget.pet.imageURLs[index],
                                    fit: BoxFit.fitHeight,
                                  ),
                                );
                              },
                            ),
                          ),

                          Positioned(
                            top: 40,
                            left: 15,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                              color: Colors.white,
                            ),
                          ),
                        ]
                    ),
                  ),
                  //Info de la mascota
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.pet.name,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(11, 96, 151, 1), // Color azul personalizado
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on, // Icono de ubicación
                                    color: Color.fromRGBO(11, 96, 151, 1), // Color azul personalizado
                                  ),
                                  Text(
                                      (ubicacion!=null)?calcularKilometros(shelter.latitude, shelter.longitude, ubicacion!.latitude, ubicacion!.longitude):"NA",

                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(11, 96, 151, 1), // Color azul personalizado
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildInfoContainer(
                                  label: 'Edad',
                                  value: '${widget.pet.ageInYears ?? 'Unknown Age'}',
                                ),
                                _buildInfoContainer(
                                  label: 'Sexo',
                                  value: widget.pet.sex,
                                ),
                                _buildInfoContainer(
                                  label: 'Tamaño',
                                  value: widget.pet.size,
                                ),
                                _buildInfoContainer(
                                  label: 'Raza',
                                  value: widget.pet.breed,
                                ),
                                _buildInfoContainerColor(
                                  label: 'Color',
                                  value: colorsString,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                              [

                                Text("Descripción",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.pet.story!,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text("Ubicación",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(shelter.address,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text("Características",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                Wrap(
                                  children: widget.pet.features.map((feature) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10, bottom: 0),
                                      child: ChoiceChip(
                                        label: Text(
                                          feature,
                                          style: TextStyle(
                                            color: Color(0xFF084065),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        selected: false,
                                        onSelected: null,
                                        side: BorderSide(
                                          color: Color(0xFF084065),
                                          width: 1,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],

                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Info del refugio
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomImage(
                                      shelter.imageURL,
                                      borderRadius: BorderRadius.circular(50),
                                      isShadow: true,
                                      width: 60,
                                      height: 60,
                                    ),
                                    SizedBox(width: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          shelter.name,
                                          style: TextStyle(
                                            fontSize: 20, // Tamaño de letra 20
                                            fontWeight: FontWeight.bold, // Negrita
                                            color: Color(0xFF084065), // Color #084065
                                          ),
                                        ),

                                        Text(
                                          "Ver Perfil",
                                          style: TextStyle(
                                            fontSize: 16, // Tamaño de letra 16
                                            color: Colors.blue, // Color azul
                                          ),
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: const Color.fromRGBO(	11	,96,	151,.7),
                                child: IconButton(
                                  icon: const Icon(Icons.chat),
                                  color: Colors.white,
                                  onPressed: () async {
                                    goToChat(
                                        context: context,
                                        chatService: _chatService,
                                        shelter: shelter,
                                        pet: widget.pet,
                                        user: FirebaseAuth.instance.currentUser!);
                                  },
                                ),
                              ),


                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              ElevatedButton(
                                onPressed: () async {
                                  goToChat(
                                      context: context,
                                      chatService: _chatService,
                                      shelter: shelter,
                                      pet: widget.pet,
                                      user: FirebaseAuth.instance.currentUser!
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromRGBO(	11	,96,	151,.7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 50.0,
                                  ),
                                  child: Text(
                                    'Adoptame',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  void goToChat(
      {required BuildContext context,
      required ChatService chatService,
      required ShelterModel shelter,
      required PetModel pet,
      required User user}) async {
    ChatModel? chatRoom = await _chatService.checkChat(
        FirebaseAuth.instance.currentUser!.uid, pet.shelterId, pet.id);

    if (chatRoom != null && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailPage(chatData: chatRoom!)
          )
        );
    } else {
      User user = FirebaseAuth.instance.currentUser!;
      chatRoom = ChatModel(
        id: '',
        userId: user.uid,
        userImageURL: user.photoURL ?? '',
        userName: user.displayName ?? '',
        shelterImageURL: shelter.imageURL,
        shelterName: shelter.name,
        shelterId: pet.shelterId,
        petId: pet.id,
        petName: pet.name,
        petImageURL: pet.imageURLs[0],
        recentMessageContent: null,
        recentMessageTime: null,
        recentMessageSenderId: null,
        conversationStatus: 'intento de adopción',
      );

      DocumentReference newChatDoc = await _chatService.createChat(chatRoom);
      chatRoom.id = newChatDoc.id;
      if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatDetailPage(chatData: chatRoom!)
          )
        );
      }
    }
  }
  Widget _buildInfoContainerColor(
      {required String label, required String value}) {
    return Container(
      width: 150, // Ajustar el ancho del contenedor
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.32),
        borderRadius: BorderRadius.circular(7.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            offset: const Offset(2.0, 2.0),
            blurRadius: 4.0,
            spreadRadius: 0.0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [


          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.grey,

            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(	11	,96,	151,.99),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  Widget _buildInfoContainer({required String label, required String value}) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.32),
        borderRadius: BorderRadius.circular(7.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            offset: const Offset(2.0, 2.0),
            blurRadius: 4.0,
            spreadRadius: 0.0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [


          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),const SizedBox(height: 5.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(11, 96, 151, .99),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
