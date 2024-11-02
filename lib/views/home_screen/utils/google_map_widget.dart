import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  final LatLng initialPosition;

  const GoogleMapWidget({super.key, required this.initialPosition});

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    // Optionally load markers or any setup needed
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
        // Move the camera to the initial position
        mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(widget.initialPosition, 15));
      },
      initialCameraPosition: CameraPosition(
        target: widget.initialPosition,
        zoom: 10,
      ),
      markers: {/* Your markers logic */},
    );
  }
}
