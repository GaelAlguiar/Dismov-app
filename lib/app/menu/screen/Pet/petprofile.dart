// import 'package:dismov_app/app/utils/data.dart'; // Assuming data.dart has getData function
// import 'package:dismov_app/shared/shared.dart'; // Assuming shared.dart has PetItem widget
import 'package:flutter/material.dart';

import '../../../../config/theme/color.dart';
// import 'package:dismov_app/app/menu/screen/Pet/pet.dart';
// import '../../../../config/theme/color.dart';

class PetProfilePage extends StatelessWidget {
  final Map<String, dynamic> pet;

  const PetProfilePage({required Key key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Expanded image
          Positioned.fill(
              child: Positioned(
            height: 100,
            child: Image.network(
              pet['image'],
              fit: BoxFit.cover,
            ),
          )),
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
                padding: const EdgeInsets.all(15),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show pet information
                    Text(
                      '${pet['name']}',
                      style: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20.0), // Spacing between containers
                    Center(
                      child: Row(
                        children: [
                          const SizedBox(
                              width: 20.0), // Spacing between containers

                          Container(
                            height: 100.0, // Adjust as needed
                            width: 100.0,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.32),
                              borderRadius: BorderRadius.circular(7.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.07),
                                  offset: const Offset(2.0, 2.0),
                                  blurRadius: 4.0,
                                  spreadRadius: 0.0,
                                )
                              ],
                              // Ensure square dimensions
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text with value from pet data
                                Text(
                                  '${pet['age']}', // Access data from your pet structure
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                        FontWeight.bold, // Make text bold
                                    color: AppColor.yellowCustom,
                                  ),
                                  textAlign: TextAlign
                                      .center, // Center text horizontally
                                ),
                                const SizedBox(
                                    height: 10.0), // Add spacing between texts
                                // Text for "Edad"
                                const Text(
                                  "Edad",
                                  style: TextStyle(
                                    fontSize: 16, // Adjust font size as needed
                                    fontWeight: FontWeight
                                        .normal, // Adjust font weight if desired
                                    color:
                                        Colors.grey, // Adjust color if desired
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                              width: 10.0), // Spacing between containers
                          Container(
                            height: 100.0, // Adjust as needed
                            width: 100.0,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.32),
                              borderRadius: BorderRadius.circular(7.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.07),
                                  offset: const Offset(2.0, 2.0),
                                  blurRadius: 4.0,
                                  spreadRadius: 0.0,
                                )
                              ],
                              // Ensure square dimensions
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text with value from pet data
                                Text(
                                  '${pet['sex']}', // Access data from your pet structure
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                        FontWeight.bold, // Make text bold
                                    color: AppColor.yellowCustom,
                                  ),
                                  textAlign: TextAlign
                                      .center, // Center text horizontally
                                ),
                                const SizedBox(
                                    height: 5.0), // Add spacing between texts
                                // Text for "Edad"
                                const Text(
                                  "Sexo",
                                  style: TextStyle(
                                    fontSize: 16, // Adjust font size as needed
                                    fontWeight: FontWeight
                                        .normal, // Adjust font weight if desired
                                    color:
                                        Colors.grey, // Adjust color if desired
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                              width: 10.0), // Spacing between containers
                          Container(
                            height: 100.0, // Adjust as needed
                            width: 100.0,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.32),
                              borderRadius: BorderRadius.circular(7.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.07),
                                  offset: const Offset(2.0, 2.0),
                                  blurRadius: 4.0,
                                  spreadRadius: 0.0,
                                )
                              ],
                              // Ensure square dimensions
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Text with value from pet data
                                Text(
                                  '${pet['color']}', // Access data from your pet structure
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                        FontWeight.bold, // Make text bold
                                    color: AppColor.yellowCustom,
                                  ),
                                  textAlign: TextAlign
                                      .center, // Center text horizontally
                                ),
                                const SizedBox(
                                    height: 5.0), // Add spacing between texts
                                // Text for "Edad"
                                const Text(
                                  "Color",
                                  style: TextStyle(
                                    fontSize: 16, // Adjust font size as needed
                                    fontWeight: FontWeight
                                        .normal, // Adjust font weight if desired
                                    color:
                                        Colors.grey, // Adjust color if desired
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                const SizedBox(height: 20.0),
                                Positioned(
                                  // Adjust top and left positions as needed
                                  top: 10.0, // Adjust top position
                                  left: 10.0, // Adjust left position
                                  child: ClipOval(
                                    child: SizedBox(
                                      height:
                                          50.0, // Adjust image size (width will be the same)
                                      width:
                                          50.0, // Adjust image size (height will be the same)
                                      child: Image.network(
                                        pet['owner_photo'],
                                        fit: BoxFit
                                            .cover, // Maintain aspect ratio within the circle
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                    style: const TextStyle(
                                      fontSize:
                                          16, // Adjust font size as needed
                                      fontWeight: FontWeight
                                          .normal, // Adjust font weight if desired
                                      color: Colors.black,
                                    ),
                                    '${pet['owner_name']}'),
                              ],
                            ),
                            Row(
                              children: [
                                Positioned(
                                  child: Container(
                                    height: 50.0,
                                    width: 180.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: AppColor
                                          .yellow, // Set the background color to yellow
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Adoptame',
                                        style: TextStyle(
                                          fontSize: 20.0, // Increase font size
                                          fontWeight: FontWeight
                                              .bold, // Make the text bold
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width: 12.0), // Spacing between containers
                                Positioned(
                                  top: 10.0,
                                  left: 10.0,
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor
                                          .yellow, // Set the background color to yellow
                                    ),
                                    child: const Center(
                                      // Center the icon within the circle
                                      child: Icon(
                                        Icons
                                            .chat, // Use the built-in chat icon
                                        color: Colors
                                            .black, // Set the icon color (optional)
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    )
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
