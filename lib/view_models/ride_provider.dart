import 'package:chakracabs/models/place_model.dart';
import 'package:flutter/material.dart';

class RideProvider with ChangeNotifier {
  Place? _pickup;
  Place? _dest;

  get pickup => _pickup;

  get dest => _dest;

  set pickup(value) {
    _pickup = value;
    notifyListeners();
  }

  set dest(value) {
    _dest = value;
    notifyListeners();
  }
}
