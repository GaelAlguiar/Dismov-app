import 'package:dismov_app/config/config.dart';
import 'package:dismov_app/shared/widgets/box_favorite.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:dismov_app/shared/widgets/pet_item_horizontal.dart';
import 'package:dismov_app/app/utils/data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dismov_app/app/menu/screen/Pet/petprofile.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';

import 'custom_image.dart';

class ShelterItem extends StatelessWidget {
   const ShelterItem(
      {super.key,
        required this.data,
        this.width = 350,
        this.height = 400,
        this.radius = 40,
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
            _buildPets(context),
            Positioned(
              bottom: 0,
              child: _buildInfoGlass(),
            ),
          ],
        ),
      ),
    );
  }

//Widget to build list of pets
  _buildPets(BuildContext context) {
    double height = 500;
    return Align(
      alignment: Alignment.center,
      child: CarouselSlider(
        options: CarouselOptions(
          height: height,
          enlargeCenterPage: true,
          disableCenter: true,
          viewportFraction: .9,
          scrollDirection:
          Axis.horizontal, // Configura la dirección del desplazamiento
        ),
        items: List.generate(
          pets.length,
              (index) => Align(
            alignment: Alignment.center,
            child: PetItem(
              data: pets[index],
              height: height,
              onTap: (){
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => PetProfilePage(
                        key: UniqueKey(), pet: pets[index]),
                  ),
                );
              }

              /*() {
                String name = pets[index]["name"];
                String location = pets[index]["location"];

                context.goNamed("sample", queryParameters: {'name': name, 'location': location});

              },*/,

              onFavoriteTap: () {

              },
            ),
          ),
        ),
      ),
    );
  }
//End of widget to build list of pets
  Widget _buildInfoGlass() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColor.yellowCustom),
        blur: 10,
        opacity: 0.15,
        child: Container(
          width: width,
          height: 120,
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          decoration: BoxDecoration(
            color: AppColor.blue,
            borderRadius: BorderRadius.circular(25),
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
              _buildInfo(),
              const SizedBox(
                height: 5,
              ),
              _buildLocation(),
              const SizedBox(
                height: 20,
              ),
              _buildAttributes(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocation() {
    return Text(
      data["location"],
      textAlign: TextAlign.left,
      maxLines: 1,

      style: const TextStyle(
        color: AppColor.glassLabelColor,
        fontSize: 13,
      ),
    );
  }

  Widget _buildInfo() {
    return Row(
      children: [
        Expanded(
          child: Text(
            data["name"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColor.glassTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _buildImage(),
      ],
    );
  }

  Widget _buildImage() {
    return CustomImage(
      data["image"],
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(radius),
        bottom: Radius.zero,
      ),
      isShadow: false,
      width: 30,
      height: 30,
    );
  }


  Widget _buildAttributes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _getAttribute(
          Icons.gps_fixed,
          data["sex"],
        ),
      ],
    );
  }

  Widget _getAttribute(IconData icon, String info) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          info,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColor.textColor, fontSize: 13),
        ),
      ],
    );
  }
}