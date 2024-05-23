import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismov_app/models/location_model.dart'; // Asegúrate de importar el modelo aquí
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:dismov_app/provider/location_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../app/utils/location.dart';


class LocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> defineLocation(context) async {
    Position? _currentLocation = await LocationUtils().getCurrentLocation();
    LocationModel? location = await getActualLocation(_currentLocation);

    Provider.of<LocationProvider>(context, listen: false).location = location;
  }

  // Método para obtener un usuario por su email
  Future<LocationModel?> getActualLocation(Position? localizacion) async {
      return LocationModel.fromGPS(localizacion);
  }
}
