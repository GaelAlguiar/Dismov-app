import 'package:dismov_app/app/menu/screen/userSettingsPage/user_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  _RecommendationsPageState createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recomendaciones", style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: const Color.fromRGBO(11, 96, 151, 1),
        foregroundColor: Colors.white,
    
      ),
      body: buildStillNoPreferences(),
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
          const Text('o de lo contrario, puedes llenar el cuestionario para obtener recomendaciones personalizadas', style: TextStyle(fontSize: 16, color: Colors.grey)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
           ElevatedButton( onPressed: () {
              // change to settings page
              Navigator.push(context, MaterialPageRoute(builder: (context) => const UserSettingsScreen()));
            },
            child: const Text("Ir a ajustes"),
          ),
          ElevatedButton(onPressed: 
          () {
            // Navigator.pushNamed(context, '/questionnaire');
          }
          
          , child: const Text('Llenar cuestionario'))

          ],
          
          )
        ],
      );
  }
}
