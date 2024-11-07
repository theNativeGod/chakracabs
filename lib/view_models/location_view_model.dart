import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationViewModel extends ChangeNotifier {
  LatLng? currentLatLng;
  Marker? currentLocationMarker;

  void updateCurrentPosition(LatLng newPosition) {
    currentLatLng = newPosition;
    currentLocationMarker = Marker(
      markerId: MarkerId('currentLocation'),
      position: newPosition,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    notifyListeners();
  }
}
