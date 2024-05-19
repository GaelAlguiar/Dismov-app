import 'package:carousel_slider/carousel_slider.dart';
import 'package:dismov_app/app/menu/screen/chat/chat_detail.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:dismov_app/shared/widgets/chat_item.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dismov_app/services/chat_service.dart';
import 'package:dismov_app/models/chat_model.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../config/theme/color.dart';
import '../../../../models/pet_model.dart';
import '../../../../models/shelter_model.dart';
import '../../../../services/pet_service.dart';
import '../../../../shared/widgets/custom_image.dart';
import '../Pet/petprofile.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // instance of chat serviice
  final ChatService _chatService = ChatService();
  List<ChatModel> chats = [];

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text("No user found"),
        ),
      );
    }
    return StreamBuilder(
        stream: _chatService.getChatsByUserIdStream(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error cargando los chats del usuario"),
            );
          }
          chats = snapshot.data as List<ChatModel>;
          return Scaffold(
            body: getBody(context),
          );
        });
  }

  getBody(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          _buildChats(context),
        ],
      ),
    );
  }

  _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(15, 60, 15, 5),
      child: Column(
        children: [
          Text(
            "Chats",
            style: TextStyle(
              fontSize: 28,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15),
          CustomTextBox(
            hint: "Buscar",
            prefix: Icon(Icons.search, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  _buildChats(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      children: List.generate(
        chats.length,
        (index) => ChatItem(
          chats[index],
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatDetailPage(chatData: chats[index]),
            ));
          },
        ),
      ),
    );
  }
}

class ShelterDetailPage extends StatelessWidget {
  final ShelterModel shelter;

  const ShelterDetailPage({super.key, required this.shelter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImage(
                  shelter.imageURL,
                  borderRadius: BorderRadius.circular(50),
                  isShadow: true,
                  width: 120,
                  height: 120,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    IntrinsicWidth(
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (shelter.website != null) {
                                _launchURL(shelter.website!);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(11, 96, 151, 1),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Sitio Web',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Add spacing between buttons
                          ElevatedButton(
                            onPressed: () {
                              if (shelter.adoptionFormURL != null) {
                                _launchURL(shelter.adoptionFormURL!);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(11, 96, 151, 1),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Link de adopción',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 13.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Wrap(
                          children: [
                            const Icon(Icons.location_pin,
                                color: AppColor.blue),
                            Container(
                              width:
                                  195, // Set a fixed width or use MediaQuery to get the available width
                              child: Text(
                                shelter.address,
                                style: const TextStyle(color: Colors.black),
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      shelter.name,
                      style: const TextStyle(
                        fontSize: 32,
                        color: AppColor.blue,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      shelter.description,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      softWrap: true,
                    ),
                    const SizedBox(height: 10),
                    /*Text(
                    'Email: ${shelter.email}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Phone: ${shelter.phone}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  */
                    // You can add more information here if needed
                  ],
                ),
              ),
            ),
            FutureBuilder<List<PetModel>>(
                future: PetService().getPetsByShelterId(shelter.uid),
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

                    filteredPets.addAll(pets);
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
      ),
      // TODO: Mostrar un widget con la ubicación del refugio
    );
  }
}

void _launchURL(String? url) async {
  if (url != null) {
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  }
}

_buildPets(BuildContext context, String shelterId) {
  double height = MediaQuery.of(context).size.height * 0.4;
  return FutureBuilder<List<PetModel>>(
    future: PetService().getPetsByShelterId(shelterId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error pets: ${snapshot.error}'),
        );
      } else {
        final List<PetModel> pets = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.only(left: 0.0, top: 10),
          child: Align(
            alignment: Alignment.center,
            child: CarouselSlider.builder(
              options: CarouselOptions(
                height: height,
                enlargeCenterPage: false,
                disableCenter: false,
                viewportFraction: .40,
                scrollDirection: Axis.vertical,
              ),
              itemCount: (pets.length / 2).ceil(),
              itemBuilder: (context, index, realIndex) {
                final int firstIndex = index * 2;
                final int secondIndex = firstIndex + 1;
                return Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: PetItemShelter(
                          data: pets[firstIndex].toMap(),
                          height: height,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PetProfilePage(
                                  key: UniqueKey(),
                                  pet: pets[firstIndex],
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
                        child: PetItemShelter(
                          data: pets[secondIndex].toMap(),
                          height: height,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PetProfilePage(
                                  key: UniqueKey(),
                                  pet: pets[secondIndex],
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

class PetItemShelter extends StatelessWidget {
  const PetItemShelter(
      {super.key,
      required this.data,
      this.width = 150,
      this.height = 200,
      this.radius = 20,
      this.onTap,
      this.onFavoriteTap});
  final Map<String, dynamic> data;
  final double width;
  final double height;
  final double radius;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Stack(
          children: [
            _buildImageShelter(),
            Positioned(
              bottom:
                  -60, // Ajustar la posición del texto para que se vea centrado
              left: 0, // Alinear el texto a la izquierda
              right: 0,
              child: _buildInfoGlassShelter(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoGlassShelter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: const Color.fromRGBO(11, 96, 151, 1)),
        blur: 10,
        opacity: 0.15,
        child: Container(
          width: width,
          height: height * 0.1,
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
            boxShadow: [
              BoxShadow(
                color: AppColor.shadowColor.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoShelter(),
              const SizedBox(
                height: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationShelter() {
    return Text(
      data["breed"],
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color.fromRGBO(11, 80, 151, 1),
        fontSize: 8,
      ),
    );
  }

  Widget _buildInfoShelter() {
    return Row(
      children: [
        Expanded(
          child: Text(
            data["name"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color.fromRGBO(11, 96, 151, 1),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        /*FavoriteBox(
          isFavorited: data["is_favorited"],
          onTap: onFavoriteTap,
        )*/
      ],
    );
  }

  Widget _buildImageShelter() {
    return CustomImage(
      data["imageURLs"][0],
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(5),
        bottom: Radius.zero,
      ),
      isShadow: false,
      width: width,
      height: height - (height * 0.1),
    );
  }

  Widget _buildAttributesShelter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _getAttribute(
          Icons.transgender,
          data["sex"],
        ),
        _getAttribute(
          Icons.color_lens_outlined,
          data["colors"].join(', '),
        ),
        _getAttribute(
          Icons.query_builder,
          data["ageInYears"].toString(),
        ),
      ],
    );
  }

  Widget _getAttribute(IconData icon, String info) {
    return Row(
      children: [
        Icon(
          icon,
          size: 10,
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          info,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black, fontSize: 8),
        ),
      ],
    );
  }
}
