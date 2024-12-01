import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomerModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  LatLng latLng; // LatLng parameter to hold location
  Timer? _timer;

  CustomerModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.latLng,
  });

  // Method to start tracking the location every 3 seconds
  void startTrackingLocation(Function(LatLng) updateLocation) {
    _timer = Timer.periodic(Duration(seconds: 3), (_) async {
      // Get the current location
      Position position = await _getCurrentLocation();

      // Update latLng with the new location
      latLng = LatLng(position.latitude, position.longitude);

      // Call the updateLocation callback to reflect the new position
      updateLocation(latLng);
    });
  }

  // Method to stop tracking location
  void stopTrackingLocation() {
    _timer?.cancel();
  }

  // Method to get the current location
  Future<Position> _getCurrentLocation() async {
    // Check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled");
    }

    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied");
      }
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return position;
  }

  // Convert Firestore data to CustomerModel
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      uid: json['uid'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      latLng: LatLng(
        json['latLng']['latitude'],
        json['latLng']['longitude'],
      ),
    );
  }

  // Convert CustomerModel to Firestore data
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'latLng': {
        'latitude': latLng.latitude,
        'longitude': latLng.longitude,
      },
    };
  }
}
