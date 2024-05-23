import 'package:flutter/material.dart';
import 'package:dismov_app/models/location_model.dart';



class LocationProvider extends ChangeNotifier {
  late LocationModel? _location;
  LocationModel? get location => _location;

  // set user
  set location(LocationModel? location) {
    _location = location;
    notifyListeners();
  }

  // remove user
  void removeUser() {
    _location = null;
    notifyListeners();
  }
}