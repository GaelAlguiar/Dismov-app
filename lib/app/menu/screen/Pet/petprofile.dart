import 'dart:ui';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismov_app/app/menu/screen/chat/chat_detail.dart';
import 'package:dismov_app/models/chat_model.dart';
import 'package:dismov_app/models/pet_model.dart';
import 'package:dismov_app/models/shelter_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dismov_app/provider/location_provider.dart';
import 'package:dismov_app/services/shelter_service.dart';
import 'package:dismov_app/services/chat_service.dart';
import 'package:dismov_app/shared/widgets/custom_image.dart';
import 'package:dismov_app/utils/location_utils.dart';
import 'package:dismov_app/app/menu/screen/chat/chat.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class PetProfilePage extends StatefulWidget {
  final PetModel pet;
  const PetProfilePage({super.key, required this.pet});

  @override
  State<PetProfilePage> createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    String imgFondo = widget.pet.imageURLs[0];
    int providerBool = 0;
    double prueba = 0;
    //Comprueba si se puede acceder el provider, es decir, si sí se puede usar el gps.
    LocationProvider lp = Provider.of<LocationProvider>(context, listen: false);
    try {
      prueba = lp.location!.ubicacion!.latitude;
      providerBool = 3;
    } catch (e) {
      providerBool = 2;
    }
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
          String colorsString = widget.pet.colors.join(',');
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    constraints: const BoxConstraints(maxHeight: 300),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/fondoblue.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(children: [
                      PageView.builder(
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
                      Positioned(
                        top: 40,
                        left: 15,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                          color: Colors.white,
                        ),
                      ),
                    ]),
                  ),
                  //Info de la mascota
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.pet.name ,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(11, 96, 151, 1),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on, // Icono de ubicación
                                  color: Color.fromRGBO(11, 96, 151, 1), // Color azul personalizado
                                ),
                                Text(
                                  (providerBool == 3)?LocationUtils().calcularKilometros(shelter.latitude, shelter.longitude, lp.location!.ubicacion!.latitude,lp.location!.ubicacion!.longitude):"NA",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(11, 96, 151, 1), // Color azul personalizado
                                  ),
                                ),

                              ],
                            ),
                          ]
                        ),
                        const SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildInfoContainer(
                                label: 'Edad',
                                value:
                                    '${widget.pet.ageInYears ?? 'Unknown Age'} años',
                              ),

                              const SizedBox(width: 20),
                              _buildInfoContainer(
                                label: 'Sexo',
                                value: widget.pet.sex,
                              ),
                              const SizedBox(width: 20),
                              _buildInfoContainer(
                                label: 'Tamaño',
                                value: widget.pet.size,
                              ),
                              const SizedBox(width: 20),
                              _buildInfoContainer(
                                label: 'Raza',
                                value: widget.pet.breed,
                              ),
                              const SizedBox(width: 20),
                              _buildInfoContainerColor(
                                label: 'Color',
                                value: colorsString,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Descripción",
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
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Ubicación",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              shelter.address,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Características",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            Wrap(
                              children: widget.pet.features.map((feature) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, bottom: 0),
                                  child: ChoiceChip(
                                    label: Text(
                                      feature,
                                      style: const TextStyle(
                                        color: Color(0xFF084065),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    selected: false,
                                    onSelected: null,
                                    side: const BorderSide(
                                      color: Color(0xFF084065),
                                      width: 1,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //Info del refugio
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ShelterDetailPage(shelter: shelter),
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
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            shelter.name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF084065),
                                            ),
                                          ),
                                          const Text(
                                            "Ver Perfil",
                                            style: TextStyle(
                                              fontSize: 16, // Tamaño de letra 16
                                              color: Colors.blue, // Color azul
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              goToChat(
                                context: context,
                                chatService: _chatService,
                                shelter: shelter,
                                pet: widget.pet,
                                user: FirebaseAuth.instance.currentUser!,
                              );
                            },
                            icon: const Icon(
                              Icons.chat,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Adoptame',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(11, 96, 151, .7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                          ),
                        ),
                      ],
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
              builder: (context) => ChatDetailPage(chatData: chatRoom!)));
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
        conversationStatus: 'En Proceso',
      );

      DocumentReference newChatDoc = await _chatService.createChat(chatRoom);
      chatRoom.id = newChatDoc.id;
      if (context.mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatDetailPage(chatData: chatRoom!)));
      }
    }
  }

  Widget _buildInfoContainerColor(
      {required String label, required String value}) {
    return Container(
      width: 170,
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
          const SizedBox(height: 10.0), // Espacio más grande entre los textos
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

  Widget _buildInfoContainer({required String label, required String value}) {
    return Container(
      width: 170,
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
          const SizedBox(height: 10.0), // Espacio más grande entre los textos
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
