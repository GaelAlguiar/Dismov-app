import 'package:dismov_app/services/pet_service.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dismov_app/app/menu/screen/Pet/petprofile.dart';
import 'package:dismov_app/app/utils/data.dart';
import 'package:dismov_app/config/config.dart';
import 'package:dismov_app/shared/widgets/pet_item_horizontal.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

import '../../models/pet_model.dart';
import 'custom_image.dart';

class ShelterItem extends StatefulWidget {
  const ShelterItem({
    Key? key,
    required this.data,
    this.width = 350,
    this.height = 400,
    this.radius = 40,
    this.onTap,
    this.onFavoriteTap,
  }) : super(key: key);

  final Map<String, dynamic> data;
  final double width;
  final double height;
  final double radius;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onFavoriteTap;

  @override
  _ShelterItemState createState() => _ShelterItemState();
}

class _ShelterItemState extends State<ShelterItem> {
  late Future<List<PetModel>> _fetchPetsFuture;

  @override
  void initState() {
    super.initState();
    _fetchPetsFuture = PetService().getAllPets();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 100),
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        child: Stack(
          children: [
            FutureBuilder<List<PetModel>>(
              future: PetService().getAllPets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error fetching pets: ${snapshot.error}'),
                  );
                } else {
                  return _buildPets(context, snapshot.data!.cast<PetModel>());
                }
              },
            ),
            Positioned(
              bottom: 0,
              child: _buildInfoGlass(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPets(BuildContext context, List<PetModel> pets) {
    double height = 500;
    return Align(
      alignment: Alignment.center,
      child: CarouselSlider(
        options: CarouselOptions(
          height: height,
          enlargeCenterPage: true,
          disableCenter: true,
          viewportFraction: .9,
          scrollDirection: Axis.horizontal,
        ),
        items: pets.map((pet) {
          return Align(
            alignment: Alignment.center,
            child: PetItem(
              data: pet.toMap(), // Convert PetModel object to Map<String, dynamic>
              height: height,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PetProfilePage(
                      key: UniqueKey(),
                      pet: pet.toMap(),
                    ),
                  ),
                );
              },
              onFavoriteTap: () {},
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildInfoGlass() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColor.yellowCustom),
        blur: 10,
        opacity: 0.15,
        child: Container(
          width: widget.width,
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
      widget.data["location"],
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
            widget.data["name"],
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
      widget.data["image"],
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(widget.radius),
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
          widget.data["sex"],
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
