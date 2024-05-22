//Utils for location
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationUtils {
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;

  Future<Position> getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      const Text("Service location disable");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition();
  }

  getAdressFromCoordinates(Position? ubicacionActual) async {
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(
          ubicacionActual!.latitude, ubicacionActual.longitude);
      Placemark place = placemark[0];
      String currentAdress = "${place.locality}, ${place.country}";
      return currentAdress;
    } catch (e) {
      debugPrint("$e");
    }
  }
  getAdressFromLatLong(double latitude, double longitud) async {
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(
          latitude, longitud);
      Placemark place = placemark[0];
      String currentAdress = "${place.locality}, ${place.country}";
      return currentAdress;
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<String> obtenerLocalizacion() async {
    String ubicacion = "";
    _currentLocation = await getCurrentLocation();
    ubicacion = await getAdressFromCoordinates(_currentLocation);
    return ubicacion;
  }
}
