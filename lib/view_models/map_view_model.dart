import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapViewModel extends ChangeNotifier {
  GoogleMapController? mapController;
  final Set<Polyline> _polylines = {};
  int _polylineIdCounter = 1;
  String distance = '';
  String duration = '';

  Set<Polyline> get polylines => _polylines;

  void setMapController(GoogleMapController controller) {
    mapController = controller;
    notifyListeners();
  }

  Future<void> drawRoute(LatLng start, LatLng end) async {
    final routeInfo = await _getRouteCoordinates(start, end);

    if (routeInfo['polylineCoordinates'].isNotEmpty) {
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route_${_polylineIdCounter++}'),
          points: routeInfo['polylineCoordinates'],
          color: Colors.green,
          width: 5,
        ),
      );

      distance = routeInfo['distance'];
      duration = routeInfo['duration'];

      // Center the map to the midpoint of the route
      animateToPosition(_calculateMidpoint(start, end));

      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> _getRouteCoordinates(
      LatLng start, LatLng end) async {
    const String apiKey = 'AIzaSyDlhLBOy0MZ10uITSTClB0SMneFG5Glrcg';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final route = data['routes'][0]['legs'][0];
      final polylinePoints = data['routes'][0]['overview_polyline']['points'];

      return {
        'polylineCoordinates': _decodePolyline(polylinePoints),
        'distance': route['distance']['text'],
        'duration': route['duration']['text'],
      };
    } else {
      throw Exception('Failed to fetch directions');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int b;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dLat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dLat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dLng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dLng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }

  /// Animates the map to the specified position
  void animateToPosition(LatLng position) {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 14, // Adjust zoom level as needed
          ),
        ),
      );
    }
  }

  /// Calculates the midpoint between two LatLng positions
  LatLng _calculateMidpoint(LatLng start, LatLng end) {
    final midLat = (start.latitude + end.latitude) / 2;
    final midLng = (start.longitude + end.longitude) / 2;
    return LatLng(midLat, midLng);
  }
}
