import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationViewModel extends ChangeNotifier {
  LatLng? currentLatLng;

  void updateCurrentPosition(LatLng newPosition) {
    currentLatLng = newPosition;
    notifyListeners();
  }
}
