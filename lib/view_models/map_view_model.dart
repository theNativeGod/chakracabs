import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewModel extends ChangeNotifier {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  LatLng initialPosition =
      LatLng(22.5726, 88.3639); // Initial position (example)

  void setMapController(GoogleMapController controller) {
    mapController = controller;
    notifyListeners();
  }

  void addMarker(LatLng position, String markerId, String title) {
    markers.add(Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(title: title),
    ));
    notifyListeners();
  }

  void animateToPosition(LatLng position) {
    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
    }
  }

  void loadCabStations() {
    List<LatLng> cabStations = [
      LatLng(22.5726, 88.3639), // Example cab station 1
      LatLng(22.5645, 88.3439), // Example cab station 2
    ];

    for (var station in cabStations) {
      addMarker(station, station.toString(), "Cab Station");
    }
  }
}
