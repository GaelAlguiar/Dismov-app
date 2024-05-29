import 'package:dismov_app/app/menu/screen/Pet/petprofile.dart';
import 'package:dismov_app/app/menu/screen/userSettingsPage/user_settings_screen.dart';
import 'package:dismov_app/provider/auth_provider.dart';
import 'package:dismov_app/services/pet_service.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dismov_app/models/pet_model.dart';
import 'package:flutter/widgets.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  _RecommendationsPageState createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  List<PetModel> recommendedPets = [];
  
  String loadingState = "loading";

  @override
  void initState() {
    super.initState();
    // getRecommendations();
  }

  // void getRecommendations() async {
  //   try {
  //     List<PetModel> recommendationResults = await PetService().getRecommendations(FirebaseAuth.instance.currentUser!.uid);
  //     setState(() {
  //       recommendedPets = recommendationResults;
  //       loadingState = recommendedPets.isEmpty ? "empty" : "loaded";
  //     });
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     setState(() {
  //       loadingState = "error";
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: PetService().getStreamRecommendations(FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),);
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: buildAppBar(),
            body: buildErrorState(),
            );
        } else {
          List<PetModel> recommendations = snapshot.data as List<PetModel>;
          recommendedPets = recommendations;
          if (recommendations.isEmpty) {
            return Scaffold(
              appBar: buildAppBar(),
              body: buildStillNoPreferences(),
            );
          } else {
            return Scaffold(
              appBar: buildAppBar(),
              body: buildRecommendations(),
            );
          }
        }
      },
          );
    
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      title: const Text("Recomendaciones", style: TextStyle(color: Colors.white),),
      backgroundColor: const Color.fromRGBO(11, 96, 151, 1),
    );
  }

  Widget buildErrorState() {
    return const Center(
      child: Text("Ha ocurrido un error"),
    );
  }

  Widget buildEmptyState() {
    return const Center(
      child: Text("Aún no tienes recomendaciones"),
    );
  }

  Widget buildStillNoPreferences() {
    return  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Image.asset(
            "assets/images/empty_box.png",
            width: MediaQuery.of(context).size.width / 2,
            ),
          const Text("Aún no tienes recomendaciones", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text("Por favor, selecciona tus preferencias en la sección de ajustes", style:TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
          ),
          // imagen de cajita vacia
          const SizedBox(height: 20),
          //const Text('O de lo contrario, puedes llenar el cuestionario para obtener recomendaciones personalizadas', style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
           ElevatedButton( onPressed: () {
              // change to settings page
              Navigator.push(context, MaterialPageRoute(builder: (context) => const UserSettingsScreen()));
            },
            child: const Text("Ir a ajustes"),
          ),
          // ElevatedButton(onPressed: 
          // () {
          //   // Navigator.pushNamed(context, '/questionnaire');
          // }
          
          // , child: const Text('Llenar cuestionario'))

          ],
          
          )
        ],
      );
  }

  Widget buildRecommendations() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text("Estas son tus recomendaciones", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Expanded(
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
                        itemCount: recommendedPets
                            .length, // Número de elementos en el grid
                        itemBuilder: (context, index) {
                          return PetItem(
                            data: recommendedPets[index].toMap(),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PetProfilePage(
                                    key: UniqueKey(),
                                    pet: recommendedPets[index],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  )
      ],
    );
  }
}
