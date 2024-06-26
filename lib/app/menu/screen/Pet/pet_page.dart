import 'package:carousel_slider/carousel_slider.dart';
import 'package:dismov_app/app/utils/data.dart';
import 'package:flutter/material.dart';
import 'package:dismov_app/config/config.dart';
import 'package:dismov_app/shared/widgets/shelter_item.dart';
//Location
import 'package:dismov_app/utils/location_utils.dart';
import 'package:dismov_app/app/menu/screen/chat/chat.dart';

class PetScreen extends StatelessWidget {
  const PetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final scaffoldKey = GlobalKey<ScaffoldState>();
    String nameToShow = "Refugios";

    return Scaffold(
      // drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: Text(
          nameToShow,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color.fromRGBO(	11	,96,	151,1),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _PetView(),
    );
  }
}

class _PetView extends StatefulWidget {
  const _PetView();
  @override
  __PetViewState createState() => __PetViewState();
}

class __PetViewState extends State<_PetView> {
  //Comprueba Ubicacion
  String ubicacion = "Ubicacion Desconocida";
  void obtenerYActualizarUbicacion() async {
    String ubi = await LocationUtils().obtenerLocalizacion();
    setState(() {
      ubicacion = ubi; // Actualiza la ubicación una vez que se resuelve el Future
    });
  }
  @override
  void initState() {
    super.initState();
    // Llama al método para actualizar la ubicación al entrar en el menu screen
    obtenerYActualizarUbicacion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColor.appBarColor,
            pinned: true,
            snap: true,
            floating: true,
            title: _buildAppBar(ubicacion),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildBody(),
              childCount: 1,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAppBar(String location) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.place_outlined,
                      color: AppColor.labelColor,
                      size: 20,
                    ),
                    SizedBox(
                      height: 10,
                      width: 5,
                    ),
                    Text(
                      "Tú Ubicación",
                      style: TextStyle(
                        color: AppColor.labelColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                location,
                style: const TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.only(
              left: 30), // Ajusta el relleno interno según sea necesario
          child: Text(
            "Refugios Cerca de ti",
            style: TextStyle(
              color: AppColor.textColor,
              fontWeight: FontWeight.w500,
              fontSize: 25,
            ),
          ),
        ),
        _buildShelters(),
      ]),
    );
  }

  //Widget to build list of shelters
  _buildShelters() {
    double height = MediaQuery.of(context).size.height * .80;

    return Align(
      alignment: Alignment.center,
      child: CarouselSlider(
        options: CarouselOptions(
          height: height,
          enlargeCenterPage: true,
          disableCenter: true,
          viewportFraction: .9,
          scrollDirection:
            Axis.vertical, // Configura la dirección del desplazamiento
        ),
        items: List.generate(
          shelters.length,
              (index) => Align(
            alignment: Alignment.center,
            child: ShelterItem(
              data: shelters[index],
              height: height,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShelterDetailPage(
                        key: UniqueKey(),
                        shelter: shelters[index],
                    ),
                  ),
                );
              },
              onFavoriteTap: () {
                setState(() {
                  shelters[index]["is_favorited"] = !shelters[index]["is_favorited"];
                });
              },
            ),
          ),
        ),
      ),
    );
  }
//End of widget to build list of pets

}
