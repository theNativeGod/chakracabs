import 'package:chakracabs/views/home_screen/utils/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../view_models/location_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        bottomSheet: DraggableBottomSheet(),
        body: SafeArea(
          child: Stack(
            children: [
              Consumer<LocationViewModel>(
                builder: (context, locationVM, child) {
                  LatLng initialPosition =
                      locationVM.currentLatLng ?? LatLng(37.7749, -122.4194);

                  // Move the camera to current position when it updates
                  if (_mapController != null &&
                      locationVM.currentLatLng != null) {
                    _mapController!.animateCamera(
                      CameraUpdate.newLatLng(locationVM.currentLatLng!),
                    );
                  }

                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: initialPosition,
                      zoom: 14.0,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white60,
                    prefixIcon: const Icon(Icons.search, size: 30),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.my_location, size: 30),
                      onPressed: () async {
                        final position = await _determinePosition();
                        if (position != null) {
                          final latLng =
                              LatLng(position.latitude, position.longitude);
                          Provider.of<LocationViewModel>(context, listen: false)
                              .updateCurrentPosition(latLng);

                          // Move the camera to the user's current position
                          _mapController?.animateCamera(
                            CameraUpdate.newLatLng(latLng),
                          );
                        }
                      },
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Select Your Location',
                    hintStyle: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: () => showGooglePlacesAutocomplete(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showGooglePlacesAutocomplete(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: GooglePlaceAutoCompleteTextField(
            googleAPIKey: 'YOUR_GOOGLE_API_KEY',
            textEditingController: TextEditingController(),
            inputDecoration: InputDecoration(
              hintText: 'Enter Location',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.black),
            ),
            debounceTime: 600,
            isLatLngRequired: true,
            getPlaceDetailWithLatLng: (Prediction prediction) {
              if (prediction.lat != null && prediction.lng != null) {
                final latLng = LatLng(
                    prediction.lat! as double, prediction.lng! as double);
                Provider.of<LocationViewModel>(context, listen: false)
                    .updateCurrentPosition(latLng);

                _mapController?.animateCamera(
                  CameraUpdate.newLatLng(latLng),
                );

                Navigator.pop(context); // Close dialog after selecting location
              }
            },
          ),
        );
      },
    );
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
