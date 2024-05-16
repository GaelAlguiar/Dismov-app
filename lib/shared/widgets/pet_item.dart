import 'package:dismov_app/config/config.dart';
import 'package:dismov_app/shared/widgets/box_favorite.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

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
        width: width,
        height: height,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Stack(
          children: [
            _buildImage(),
            Positioned(
              bottom: -60, // Ajustar la posición del texto para que se vea centrado
              left: 0, // Alinear el texto a la izquierda
              right: 20,
              child: _buildInfoGlass(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoGlass() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color:Color.fromRGBO(	11	,96,	151,1)),
        blur: 10,
        opacity: 0.15,
        child: Container(
          width: width,
          height: 65,
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
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
                height: 1,
              ),
              _buildLocation(),
              const SizedBox(
                height: 5,
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
      data["breed"],
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color.fromRGBO(	11	,80,	151,1),
        fontSize: 8,
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
              color: Color.fromRGBO(	11	,96,	151,1),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        /*FavoriteBox(
          isFavorited: data["is_favorited"],
          onTap: onFavoriteTap,
        )*/
      ],
    );
  }

  Widget _buildImage() {
    return CustomImage(
      data["imageURLs"][0],
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(radius),
        bottom: Radius.zero,
      ),
      isShadow: false,
      width: width,
      height: height-60,
    );
  }

  Widget _buildAttributes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _getAttribute(
          Icons.transgender,
          data["sex"],
        ),
        _getAttribute(
          Icons.color_lens_outlined,
          data["colors"].join(', '),
        ),
        _getAttribute(
          Icons.query_builder,
          data["ageInYears"].toString(),
        ),
      ],
    );
  }

  Widget _getAttribute(IconData icon, String info) {
    return Row(
      children: [
        Icon(
          icon,
          size: 10,
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          info,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black, fontSize: 8),
        ),
      ],
    );
  }
}
