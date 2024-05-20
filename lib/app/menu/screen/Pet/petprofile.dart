
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismov_app/app/menu/screen/chat/chat_detail.dart';
import 'package:dismov_app/models/chat_model.dart';
import 'package:dismov_app/models/pet_model.dart';
import 'package:dismov_app/models/shelter_model.dart';
import 'package:dismov_app/models/user_model.dart';
import 'package:dismov_app/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../services/shelter_service.dart';
import 'package:dismov_app/services/chat_service.dart';


class PetProfilePage extends StatelessWidget {
  final PetModel pet;
  final ChatService _chatService = ChatService();

  PetProfilePage({required Key key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ShelterModel?>(
      future: ShelterService().getShelterById(pet.shelterId), // Call the asynchronous function
      builder: (context, AsyncSnapshot<ShelterModel?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the future to resolve, return a loading indicator
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // If there's an error, display an error message
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          // Once the future has resolved, build the UI with the data
          var shelter = snapshot.data!;
          var shelterName = shelter.name;
          String colorsString = pet.colors.join(',');
          return Scaffold(
            body: Stack(
              children: [
                // Background image
                Positioned.fill(
                  child: PageView.builder(
                    itemCount: pet.imageURLs.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        pet.imageURLs[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                // Container for pet information
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Show pet information
                              Text(
                                pet.name,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20.0), // Spacing between containers
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: _buildInfoContainer(
                                      label: 'Edad',
                                      value: '${pet.ageInYears ?? 'Unknown Age'}',
                                    ),
                                  ),
                                  _buildInfoContainer(
                                    label: 'Sexo',
                                    value: pet.sex,
                                  ),
                                  _buildInfoContainerColor(
                                    label: 'Color',
                                    value: colorsString,
                                  ),
                                ],
                              ),
                              // Owner information
                              const SizedBox(height: 20.0),
                              Row(
                                children: [
                                  ClipOval(
                                    child: SizedBox(
                                      height: 50.0,
                                      width: 50.0,
                                      child: Image.network(
                                        shelter.imageURL,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shelterName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                      const Text(
                                        'Propietario',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              // Action buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  ElevatedButton(
                                    onPressed: () async {
                                      goToChat(
                                          context: context,
                                          chatService: _chatService,
                                          shelter: shelter,
                                          pet: pet,
                                          user: FirebaseAuth.instance.currentUser!
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(11, 96, 151, 0.7),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                      minimumSize: Size(MediaQuery.of(context).size.width - 35, 50.0), // Set minimum width
                                    ),
                                    child: Row( // Use Row to arrange elements horizontally
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space them evenly
                                      children: [
                                    IconButton(
                                    icon: const Icon(Icons.chat),
                      color: Colors.white,  onPressed: () async {
                      goToChat(
                          context: context,
                          chatService: _chatService,
                          shelter: shelter,
                          pet: pet,
                          user: FirebaseAuth.instance.currentUser!
                      );
                    }, // This button won't have a separate action (optional)
                    )
                                        ,
                                        const Text(
                                          'Adoptame',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Back button positioned on top left
                Positioned(
                  top: 20.0,
                  left: 20.0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                    color: Colors.white
                    ,
                  ),
                ),
              ],
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
  // if exists, navigate to the chat screen
  // if not, create a new chat room and navigate to the chat screen
  ChatModel? chatRoom = await _chatService.checkChat(
    FirebaseAuth.instance.currentUser!.uid,
    pet.shelterId,
    pet.id
  );

  if (chatRoom != null && context.mounted) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => ChatDetailPage(chatData: chatRoom!)
        )
      );
  } else {
    final AuthenticationProvider _authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    UserModel user = _authProvider.user!;
    chatRoom = ChatModel(
      id: '',
      userId: user.uid,
      userImageURL: user.profilePicURL ?? '',
      userName: user.name,
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

  Widget _buildInfoContainer({required String label, required String value}) {
    return Container(
      margin: const EdgeInsets.only(right: 10.0),
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
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(	11	,96,	151,.99),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5.0),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildInfoContainerColor({required String label, required String value}) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 10.0),
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
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(	11	,96,	151,.99),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5.0),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
