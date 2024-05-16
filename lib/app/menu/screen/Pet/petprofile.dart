import 'package:dismov_app/models/shelter_model.dart';
import 'package:flutter/material.dart';
import '../../../../config/theme/color.dart';
import '../../../../services/shelter_service.dart';

class PetProfilePage extends StatelessWidget {
  final Map<String, dynamic> pet;

  const PetProfilePage({required Key key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ShelterModel?>(
      future: ShelterService().getShelterById(pet['shelterId']), // Call the asynchronous function
      builder: (context, AsyncSnapshot<ShelterModel?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the future to resolve, return a loading indicator
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          print(snapshot);
          // If there's an error, display an error message
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          // Once the future has resolved, build the UI with the data
          var shelter = snapshot.data!;
          var shelterName = shelter.name ?? 'Unknown Shelter Name';
          String colorsString = pet['colors']?.join(',') ?? 'Unknown Color';
          return Scaffold(
            body: Stack(
              children: [
                // Background image
                Positioned.fill(
                  child: Image.network(
                    pet['imageURLs']?[0] ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
                // Container for pet information
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
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
                                '${pet['name']}',
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
                                    padding: EdgeInsets.only(left: 25),
                                    child: _buildInfoContainer(
                                      label: 'Edad',
                                      value: '${pet['ageInYears'] ?? 'Unknown Age'}',
                                    ),
                                  ),
                                  _buildInfoContainer(
                                    label: 'Sexo',
                                    value: '${pet['sex'] ?? 'Unknown Sex'}',
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
                                        shelter.image ?? '',
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
                                      Text(
                                        'Propietario',
                                        style: const TextStyle(
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
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(255, 227, 170, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 90.0,
                                      ),
                                      child: Text(
                                        'Adoptame',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  CircleAvatar(
                                    backgroundColor: AppColor.yellow,
                                    child: IconButton(
                                      icon: const Icon(Icons.chat),
                                      color: Colors.black,
                                      onPressed: () {},
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
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildInfoContainer({required String label, required String value}) {
    return Container(
      width: 70,
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
              color: AppColor.yellowCustom,
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
              color: AppColor.yellowCustom,
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
