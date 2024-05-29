import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismov_app/app/menu/screen/userSettingsPage/edit_user_settings_screen.dart';
import 'package:dismov_app/models/user_preferences_model.dart';
import 'package:dismov_app/services/user_service.dart';
import 'package:dismov_app/services/user_preferences_service.dart';
import 'package:dismov_app/utils/show_error_snackbar.dart';
import 'package:dismov_app/utils/show_success_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:dismov_app/shared/shared.dart';
import 'package:dismov_app/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:dismov_app/utils/login_google_utils.dart';
import 'package:dismov_app/provider/auth_provider.dart';
import 'package:hive/hive.dart';

class PetPreferences extends StatelessWidget {
  const PetPreferences({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Preferencias',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.blue,
      ),
      body: const _UserSettingsView(),
    );
  }
}

class _UserSettingsView extends StatefulWidget {
  const _UserSettingsView();

  @override
  __UserSettingsState createState() => __UserSettingsState();
}

class __UserSettingsState extends State<_UserSettingsView> {
  late Box userBox;
  bool isCatSelected = false;
  bool isDogSelected = true;
  int selectedAge = 1; // 1 for 1-6m, 2 for 6-12m, 3 for 1+ years
  int selectedSize = 1; // 1 for small, 2 for medium, 3 for large
  List<String> selectedPersonality = [];
  String? documentId;
  final TextEditingController breedController = TextEditingController();
  
  final UserPreferencesService userPreferencesService = UserPreferencesService();
  late final AuthenticationProvider authProvider;
  Map<String, dynamic> userPreferences = {
    'type': {
      'cat': {
        'isSelected': false,
        'display': 'Gato',
      },
      'dog': {
        'isSelected': false,
        'display': 'Perro',
      }
    },
    'colors': [
      {
        'name': 'Blanco',
        'isSelected': false,
      },
      {
        'name': 'Negro',
        'isSelected': false,
      },
      {
        'name': 'Café',
        'isSelected': false
      },
      {
        'name': 'Dorado',
        'isSelected': false
      }
    ],
    'features': [
      // hardcoded features set to isSelected false
      {
        'value': 'activo',
        'isSelected': false
      },
      {
        'value': 'tranquilo',
        'isSelected': false
      },
      {
        'value': 'sereno',
        'isSelected': false,
      },
      {
        'value': 'curioso',
        'isSelected': false
      },
      {
        'value': 'amoroso',
        'isSelected': false,
      },
      {
        'value': 'inteligente',
        'isSelected': false,
      },
      {
        'value': 'obediente',
        'isSelected': false
      },
      {
        'value': 'protector',
        'isSelected': false,
      },
    ],
    'size': {
      'small': {
        'displayName': 'pequeño',
        'isSelected': false
      },
      'medium': {
        'displayName': 'mediano',
        'isSelected': false
      },
      'large': {
        'displayName': 'grande',
        'isSelected': false
      },
    },
    'sex': {
      'male': {
        'displayName': 'macho',
        'isSelected': false,
      },
      'female': {
        'displayName': 'hembra',
        'isSelected': false,
      }
    },
    'breed': '',
  };

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    getUserPreferences();
    userBox = Hive.box('userBox');
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    AuthenticationProvider ap = Provider.of<AuthenticationProvider>(context, listen: false);
    String useruid = ap.user!.uid;
    UserPreferencesModel? preferences = await UserPreferencesService().getUserPreferencesById(useruid);

    if (preferences != null) {
      var data = preferences;
      documentId = preferences.id;

      setState(() {
        isCatSelected = data.type == 'cat';
        isDogSelected = data.type == 'dog';
        selectedSize = data.size == 'small' ? 1 : data.size == 'medium' ? 2 : 3;
        selectedPersonality = data.features != null ? data.features! : [];

        userPreferences['type']['cat']['isSelected'] = data.type == 'cat';
        userPreferences['type']['dog']['isSelected'] = data.type == 'dog';
        userPreferences['sex']['female']['isSelected'] = data.sex == 'female';
        userPreferences['sex']['male']['isSelected'] = data.sex == 'male';

        userPreferences['size']['small']['isSelected'] = selectedSize == 1;
        userPreferences['size']['medium']['isSelected'] = selectedSize == 2;
        userPreferences['size']['large']['isSelected'] = selectedSize == 3;

       
        userPreferences['breed'] = data.breed;
        breedController.text = data.breed ?? '';

        userPreferences['colors'].forEach((element) {
          element['isSelected'] = data.colors != null && data.colors!.contains(element['name']);
        });

        userPreferences['features'].forEach((element) {
          element['isSelected'] = selectedPersonality.contains(element['value']);
        });

      });
    }
  }


  void getUserPreferences() async {
    print('User preferences: >>>>>>>.');
    if (authProvider.user == null) {
      debugPrint('User is null in preferences screen');
      return;
    }
    final userPreferences = await userPreferencesService.getUserPreferencesById(authProvider.user!.uid);
    print('User preferences: $userPreferences>>>>>>>.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildBody(),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Row(
                  children: [
                    SizedBox(
                      height: 0,
                      width: 5,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void togglePersonality(String personality) {
    setState(() {
      if (selectedPersonality.contains(personality)) {
        selectedPersonality.remove(personality);
      } else {
        selectedPersonality.add(personality);
      }
    });
  }

  Widget buildChip(String label) {
    final isSelected = selectedPersonality.contains(label);
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => togglePersonality(label),
    );
  }

  @override
  void dispose() {

    super.dispose();
  }




  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('¿Qué tipo de mascota prefieres?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  userPreferences['type'].length,
                  (index) {
                    final type = userPreferences['type'].values.elementAt(index);
                    return ChoiceChip(
                      label: Text(type['display']),
                      selected: type['isSelected'],
                      onSelected: (selected) {
                        setState(() {
                          userPreferences['type'].values.forEach((element) {
                            element['isSelected'] = false;
                          });
                          type['isSelected'] = true;
                        });
                      },
                    );
                  },
                ),
            
              ),
              const Text('¿Qué género prefieres en tu mascota?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  userPreferences['sex'].length,
                  (index) {
                    final sex = userPreferences['sex'].values.elementAt(index);
                    return ChoiceChip(
                      label: Text(sex['displayName']),
                      selected: sex['isSelected'],
                      onSelected: (selected) {
                        setState((){
                          userPreferences['sex'].values.forEach((element) {
                            element['isSelected'] = false;
                          });
                          sex['isSelected'] = true;
                        });
                      },
                    );
                  }
                ),
              ),
              const SizedBox(height: 20),
              const Text('¿De qué tamaño prefieres a tu mascota?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  userPreferences['size'].length,
                  (index) {
                    final size = userPreferences['size'].values.elementAt(index);
                    return ChoiceChip(
                      label: Text(size['displayName']),
                      selected: size['isSelected'],
                      onSelected: (selected) {
                        setState(() {
                          userPreferences['size'].values.forEach((element) {
                            element['isSelected'] = false;
                          });
                          size['isSelected'] = true;
                        });
                      },
                    );
                  },
                )
              ),
              const SizedBox(height: 20),
              const Text('¿Hay alguna raza de mascota que te interese?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                )
              ),
              // Allow breed to be entered manually with a text field
              TextField(
                controller: breedController,
                decoration: const InputDecoration(
                  hintText: 'Raza de la mascota',
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    userPreferences['breed'] = value;
                  });
                },

              ),
              const SizedBox(height: 20),
              const Text('¿Qué colores prefieres en tu mascota?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                )
              ),

              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: List.generate(
                  userPreferences['colors'].length,
                  (index) {
                    final color = userPreferences['colors'].elementAt(index);
                    return ChoiceChip(
                      label: Text(color['name']),
                      selected: color['isSelected'],
                      onSelected: (selected) {
                        setState(() {
                          color['isSelected'] = !color['isSelected'];
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text('¿Con qué personalidad prefieres a tu mascota?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                )
              ),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  for (final feature in userPreferences['features'])
                    buildChip(feature['value']),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
                  child: SizedBox(
                    width: 200,
                    height: 47,
                    child: CustomFilledButton(
                      text: "Guardar cambios",
                      buttonColor: AppColor.blue,
                      onPressed: () async {
                        AuthenticationProvider ap =
                        Provider.of<AuthenticationProvider>(context, listen: false);
                        String useruid = ap.user!.uid;

                        String? petType = userPreferences['type']['cat']['isSelected'] ? 'cat' : userPreferences['type']['dog']['isSelected'] ? 'dog' : null;
                        String size;
                        switch (selectedSize) {
                          case 1:
                            size = 'small';
                            break;
                          case 2:
                            size = 'medium';
                            break;
                          case 3:
                            size = 'big';
                            break;
                          default:
                            size = 'medium';
                        }

                        bool isFemaleSelected = userPreferences['sex']['female']['isSelected'];
                        bool isMaleSelected = userPreferences['sex']['male']['isSelected'];
                        String? selectedSex = isFemaleSelected ? 'female' : isMaleSelected ? 'male' : null;
                        List<String> selectedColors = userPreferences.entries
                            .where((element) => element.key == 'colors')
                            .map((e) => e.value)
                            .expand((element) => element)
                            .where((element) => element['isSelected'])
                            .map((e) => e['name'] as String)
                            .toList();
                        

                        UserPreferencesModel preferencesData = UserPreferencesModel(
                          userId: useruid,
                          type: petType,
                          size: size,
                          features: selectedPersonality,
                          breed: breedController.text,
                        colors: selectedColors,
                          sex: selectedSex
                            
                        );

                        try {
                          if (documentId != null) {
                            // Update existing document
                            await UserPreferencesService().updateUserPreferences(preferencesData);
                          } else {
                            // Create a new document
                            await UserPreferencesService().addUserPreferences(preferencesData);
                          }
                          if (!mounted) return;
                          Navigator.pop(context);
                          showSuccessSnackbar(context, 'Preferencias guardadas');
                        } catch (e) {
                          if (!mounted) return;
                          showErrorSnackbar(context, 'Error guardando las preferencias');
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditDescriptionDialog extends StatefulWidget {
  const _EditDescriptionDialog();

  @override
  __EditDescriptionDialogState createState() => __EditDescriptionDialogState();
}

class __EditDescriptionDialogState extends State<_EditDescriptionDialog> {
  late TextEditingController _descriptionController;
  late Box userBox;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box('userBox');
    _descriptionController = TextEditingController(
      text: userBox.get(
        'description',
        defaultValue: '',
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar descripción'),
      content: SingleChildScrollView(
        child: TextField(
          controller: _descriptionController,
          maxLines: null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop;
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            userBox.put('description', _descriptionController.text);
            Navigator.of(context).pop();
            setState(() {});
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

colocarImagen(String url) {
  if (url == 'null') {
    return Image.network(
      'https://cdn-icons-png.flaticon.com/512/3541/3541871.png',
      width: 190,
      height: 190,
    );
  } else {
    return Container(
      width: 190,
      height: 190,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 52, 143, 217),
          width: 3,
        ),
        borderRadius: BorderRadius.circular(17.8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          url,
          width: 190,
          height: 190,
          fit: BoxFit.cover,
        ),
      ),
    );
  }



  

}

