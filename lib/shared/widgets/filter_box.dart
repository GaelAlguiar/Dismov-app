import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/theme/color.dart';

class FilterItem extends StatelessWidget {
  const FilterItem({
    super.key,
    required this.data,
    this.selected = false,
    this.onTap,
  });

  final Map<String, dynamic> data;
  final bool selected;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
        margin: const EdgeInsets.only(right: 10),
        width: 100,
        height:70,
        decoration: BoxDecoration(
          color: selected ? Color(0xFF8DD3FF): AppColor.cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xFF8DD3FF),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1),
              spreadRadius: .5,
              blurRadius: .5,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            (data["value"] == "EN CURSO")?
            Icon(Icons.access_time,
              color: Colors.blue,):
            (data["value"]== "ADOPTADO")?
            Icon(Icons.pets,
              color: Colors.green,):
            Icon(Icons.cancel,
              color: Colors.red,),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: Text(
                data["value"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.white : AppColor.textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
