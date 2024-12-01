import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'place_model.dart';

class RideRequest {
  String id;
  final Place pickup;
  final Place destination;
  final String rideType;
  final String userId;
  final String? driverId; // Nullable, assigned later
  final String status; // Can be 'requested', 'confirmed', 'cancelled'
  final Timestamp timestamp;
  final String? hub; // Optional parameter for the hub
  final int rideOtp; // 4-digit ride OTP

  RideRequest({
    required this.id,
    required this.pickup,
    required this.destination,
    required this.rideType,
    required this.userId,
    this.driverId,
    this.status = 'requested', // Default to 'requested'
    required this.timestamp,
    this.hub, // Optional, can be null
    required this.rideOtp, // Ride OTP is required
  });

  // Convert a RideRequest to a Firestore document
  Map<String, dynamic> toMap() {
    return {
      'pickup': {
        'name': pickup.name,
        'address': pickup.address,
        'lat': pickup.lat,
        'lng': pickup.lng,
      },
      'destination': {
        'name': destination.name,
        'address': destination.address,
        'lat': destination.lat,
        'lng': destination.lng,
      },
      'rideType': rideType,
      'userId': userId,
      'driverId': driverId,
      'status': status,
      'timestamp': timestamp,
      'hub': hub, // Include hub in the map
      'rideOtp': rideOtp, // Include rideOtp in the map
    };
  }

  // Create a RideRequest from a Firestore document snapshot
  factory RideRequest.fromMap(String id, Map<String, dynamic> map) {
    return RideRequest(
      id: id,
      pickup: Place(
        name: map['pickup']['name'],
        address: map['pickup']['address'],
        lat: map['pickup']['lat'],
        lng: map['pickup']['lng'],
      ),
      destination: Place(
        name: map['destination']['name'],
        address: map['destination']['address'],
        lat: map['destination']['lat'],
        lng: map['destination']['lng'],
      ),
      rideType: map['rideType'],
      userId: map['userId'],
      driverId: map['driverId'],
      status: map['status'],
      timestamp: map['timestamp'],
      hub: map['hub'], // Parse hub from the map, can be null
      rideOtp: map['rideOtp'], // Parse rideOtp from the map
    );
  }

  // Generate a random 4-digit OTP
  static int generateOtp() {
    final random = Random();
    return 1000 + random.nextInt(9000); // Random number between 1000 and 9999
  }
}
