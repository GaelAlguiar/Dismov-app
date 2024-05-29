import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismov_app/app/menu/screen/userSettingsPage/edit_user_settings_screen.dart';
import 'package:dismov_app/services/user_service.dart';
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

  @override
  void initState() {
    super.initState();
    userBox = Hive.box('userBox');
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    AuthenticationProvider ap = Provider.of<AuthenticationProvider>(context, listen: false);
    String useruid = ap.user!.uid;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('preferences')
        .where('useruid', isEqualTo: useruid)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var data = snapshot.docs.first.data() as Map<String, dynamic>;
      documentId = snapshot.docs.first.id;

      setState(() {
        isCatSelected = data['type'] == 'cat';
        isDogSelected = data['type'] == 'dog';
        selectedAge = data['age'] == 0.5 ? 1 : data['age'] == 1 ? 2 : 3;
        selectedSize = data['size'] == 'small' ? 1 : data['size'] == 'medium' ? 2 : 3;
        selectedPersonality = List<String>.from(data['features']);
      });
    }
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

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tipo de mascota',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
              ),
              Row(
                children: [
                  ChoiceChip(
                    label: Text('Gato'),
                    selected: isCatSelected,
                    onSelected: (selected) {
                      setState(() {
                        isCatSelected = selected;
                        isDogSelected = !selected;
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  ChoiceChip(
                    label: Text('Perro'),
                    selected: isDogSelected,
                    onSelected: (selected) {
                      setState(() {
                        isDogSelected = selected;
                        isCatSelected = !selected;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Edad',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
              ),
              Row(
                children: [
                  ChoiceChip(
                    label: Text('1 - 6 m'),
                    selected: selectedAge == 1,
                    onSelected: (selected) {
                      setState(() {
                        selectedAge = 1;
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  ChoiceChip(
                    label: Text('6 - 12 m'),
                    selected: selectedAge == 2,
                    onSelected: (selected) {
                      setState(() {
                        selectedAge = 2;
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  ChoiceChip(
                    label: Text('1+ años'),
                    selected: selectedAge == 3,
                    onSelected: (selected) {
                      setState(() {
                        selectedAge = 3;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Tamaño',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
              ),
              Row(
                children: [
                  ChoiceChip(
                    label: Text('Pequeño'),
                    selected: selectedSize == 1,
                    onSelected: (selected) {
                      setState(() {
                        selectedSize = 1;
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  ChoiceChip(
                    label: Text('Mediano'),
                    selected: selectedSize == 2,
                    onSelected: (selected) {
                      setState(() {
                        selectedSize = 2;
                      });
                    },
                  ),
                  SizedBox(width: 10),
                  ChoiceChip(
                    label: Text('Grande'),
                    selected: selectedSize == 3,
                    onSelected: (selected) {
                      setState(() {
                        selectedSize = 3;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Personalidad',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
              ),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  buildChip('Activo'),
                  buildChip('Perezoso'),
                  buildChip('Curioso'),
                  buildChip('Inteligente'),
                  buildChip('Cariñoso'),
                  buildChip('Independiente'),
                  buildChip('Juguetón'),
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

                        String petType = isCatSelected ? 'cat' : 'dog';
                        double age;
                        switch (selectedAge) {
                          case 1:
                            age = 0.5;
                            break;
                          case 2:
                            age = 1;
                            break;
                          case 3:
                            age = 1.5;
                            break;
                          default:
                            age = 0.5;
                        }
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

                        Map<String, dynamic> preferencesData = {
                          'useruid': useruid,
                          'type': petType,
                          'age': age,
                          'size': size,
                          'features': selectedPersonality,
                        };

                        try {
                          if (documentId != null) {
                            // Update existing document
                            await FirebaseFirestore.instance
                                .collection('preferences')
                                .doc(documentId)
                                .update(preferencesData);
                          } else {
                            // Create a new document
                            await FirebaseFirestore.instance.collection('preferences').add(preferencesData);
                          }
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Preferences saved successfully')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to save preferences: $e')),
                          );
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

