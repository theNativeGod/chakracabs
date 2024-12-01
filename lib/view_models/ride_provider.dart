import 'package:chakracabs/views/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/place_model.dart';
import '../models/ride_request.dart';

class RideProvider with ChangeNotifier {
  Place? _pickup;
  Place? _dest;
  String? _rideType = 'Mini';
  String? _userId =
      'bPKTdvKSMchwNfVwNrlC'; // Set the user ID when the user logs in
  RideRequest? _rideRequest;

  Place? get pickup => _pickup;
  Place? get dest => _dest;
  String? get rideType => _rideType;
  String? get userId => _userId;
  RideRequest? get rideRequest => _rideRequest;

  set pickup(Place? value) {
    _pickup = value;
    notifyListeners();
  }

  set dest(Place? value) {
    _dest = value;
    notifyListeners();
  }

  set rideType(String? value) {
    _rideType = value;
    notifyListeners();
  }

  set userId(String? value) {
    _userId = value;
    notifyListeners();
  }


  // Method to book a ride and upload it to Firestore
  Future<void> bookRide(BuildContext context) async {
    if (_pickup == null ||
        _dest == null ||
        _rideType == null ||
        _userId == null) {
      print("Please complete all ride details.");
      return;
    }

    print('here');
    final rideRequest = RideRequest(
      id: '', // Firestore will auto-generate this ID
      pickup: _pickup!,
      destination: _dest!,
      rideType: _rideType!,
      userId: _userId!,
      timestamp: Timestamp.now(),
      rideOtp: RideRequest.generateOtp(),
    );
    print('here2');
    try {
      // Upload ride request to Firestore
      final docRef = await FirebaseFirestore.instance
          .collection('rideRequests')
          .add(rideRequest.toMap());

      showSnackbar(
          "Ride request created with ID: ${docRef.id}", Colors.green, context);

      // Update ride request with generated Firestore ID if needed
      rideRequest.id = docRef.id;
      _rideRequest = rideRequest;
      notifyListeners();
    } catch (e) {
      print("Failed to book ride: $e");
    }
  }

  // Method to cancel the ride and reset values to default
  void cancelRide(BuildContext context) async {
    if (_rideRequest != null && _rideRequest!.id.isNotEmpty) {
      try {
        // Update the ride request status in Firestore
        await FirebaseFirestore.instance
            .collection('rideRequests')
            .doc(_rideRequest!.id)
            .update({'status': 'cancelled'});

        print("Ride status updated to cancelled in Firestore.");

        // Show success snackbar
        showSnackbar("Ride cancelled successfully.", Colors.green, context);
      } catch (e) {
        print("Failed to update ride status: $e");

        // Show error snackbar
        showSnackbar(
            "Failed to cancel the ride. Try again.", Colors.red, context);
      }
    } else {
      // Show snackbar for invalid cancel attempt
      showSnackbar("No active ride to cancel.", Colors.orange, context);
    }

    // Reset local values to default
    _pickup = null;
    _dest = null;
    _rideType = 'Mini'; // Default ride type
    _rideRequest = null;

    notifyListeners();
  }
}
