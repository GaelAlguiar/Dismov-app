//Utils for location
import 'dart:math';

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

  //Devuelve distancia en KM o metros
  static const double R = 6371000; // Radio de la Tierra en metros

  static double _degToRad(double degrees) {
    return degrees * pi / 180;
  }

  String calcularKilometros(double lat1, double lon1, double lat2, double lon2) {
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) * cos(_degToRad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distanceInMeters = R * c; // Distancia en metros

    if (distanceInMeters < 1000) {
      return distanceInMeters.toStringAsFixed(2) + 'm';
    } else {
      double distanceInKm = distanceInMeters / 1000;
      return distanceInKm.toStringAsFixed(2) + 'Km';
    }
  }
}
