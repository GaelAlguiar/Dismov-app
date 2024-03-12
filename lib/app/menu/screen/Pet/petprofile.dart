// import 'package:dismov_app/app/utils/data.dart'; // Assuming data.dart has getData function
// import 'package:dismov_app/shared/shared.dart'; // Assuming shared.dart has PetItem widget
import 'package:flutter/material.dart';
// import 'package:dismov_app/app/menu/screen/Pet/pet.dart';
// import '../../../../config/theme/color.dart';

class PetProfilePage extends StatelessWidget {
  final pet;

  const PetProfilePage({required Key key, this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Expanded image
          Positioned(
            child: Image.network(
              pet['image'],
              fit: BoxFit.cover,
            ),
          ),
          // Container for pet information
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show pet information
                    Text(
                      '${pet['name']}',
                      style: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 1.0), // Border configuration
                            borderRadius: BorderRadius.circular(
                                5.0), // Rounded corners (optional)
                            boxShadow: [
                              BoxShadow(
                                // Shadow definition
                                color: Colors.grey.withOpacity(
                                    0.5), // Shadow color (with transparency)
                                offset: const Offset(2.0,
                                    2.0), // Shadow offset (horizontal, vertical)
                                blurRadius: 4.0, // Shadow blur radius
                                spreadRadius:
                                    0.0, // Shadow spread radius (optional)
                              )
                            ],
                          ),
                          child: Text(
                            'Edad: ${pet['age']}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                            width: 10.0), // Add spacing between containers
                        DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 0.5), // Border configuration
                            borderRadius: BorderRadius.circular(
                                5.0), // Rounded corners (optional)
                            boxShadow: [
                              BoxShadow(
                                // Shadow definition
                                color: Colors.grey.withOpacity(
                                    0.05), // Shadow color (with transparency)
                                offset: const Offset(2.0,
                                    2.0), // Shadow offset (horizontal, vertical)
                                blurRadius: 4.0, // Shadow blur radius
                                spreadRadius:
                                    0.0, // Shadow spread radius (optional)
                              )
                            ],
                          ),
                          child: Text(
                            'Raza: ${pet['breed']}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        )
                      ],
                    ),

                    // Add more details as needed
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
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
