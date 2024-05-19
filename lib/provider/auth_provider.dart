import 'package:flutter/material.dart';  
import 'package:dismov_app/models/user_model.dart';


class AuthenticationProvider extends ChangeNotifier {
  late UserModel? _user;
  UserModel? get user => _user;

  // set user 
  set user(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  // remove user
  void removeUser() {
    _user = null;
    notifyListeners();
  }
}