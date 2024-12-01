import 'package:google_maps_flutter/google_maps_flutter.dart';

class Driver {
  final String driverId;
  final String firstName;
  final String lastName;
  final String email;
  final String fullPhoneNumber;
  final String car;
  final String carNumber;
  final String cabStation;
  final LatLng latLng; // Added location field for the driver's position

  Driver({
    required this.driverId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.fullPhoneNumber,
    required this.car,
    required this.carNumber,
    required this.cabStation,
    required this.latLng, // Initialize LatLng parameter
  });

  // Convert Firestore data (JSON) to Driver object
  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      driverId: json['driverId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      fullPhoneNumber: json['fullPhoneNumber'] ?? '',
      car: json['car'] ?? '',
      carNumber: json['carNumber'] ?? '',
      cabStation: json['cabStation'] ?? '',
      latLng: LatLng(
        json['latLng']['latitude'], // Fetch latitude from Firestore
        json['latLng']['longitude'], // Fetch longitude from Firestore
      ),
    );
  }

  // Convert Driver object to Firestore data (JSON)
  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'fullPhoneNumber': fullPhoneNumber,
      'car': car,
      'carNumber': carNumber,
      'cabStation': cabStation,
      'latLng': {
        'latitude': latLng.latitude, // Convert LatLng to Firestore format
        'longitude': latLng.longitude, // Convert LatLng to Firestore format
      },
    };
  }
}
