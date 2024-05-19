import 'package:flutter/material.dart';
import 'custom_image.dart';

class PetItem extends StatelessWidget {
  const PetItem(
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
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: FractionallySizedBox(
                widthFactor: 0.9,
                heightFactor: 0.9,
                child: CustomImage(
                  data["imageURLs"]![0],
                  borderRadius: BorderRadius.circular(10),
                  isShadow: false,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(11, 96, 151, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      (data['sex'] == "male")
                          ? const Icon(
                              Icons.male,
                              size: 25,
                              color: Color.fromRGBO(11, 96, 151, 1),
                            )
                          : const Icon(
                              Icons.female,
                              size: 25,
                              color: Color.fromRGBO(11, 96, 151, 1),
                            ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Edad: ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        data['ageInYears'].toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Raza: ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        data['breed'],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
