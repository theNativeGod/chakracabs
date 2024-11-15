import 'package:chakracabs/models/place_model.dart';
import 'package:chakracabs/view_models/bottom_sheet_model.dart';
import 'package:chakracabs/view_models/ride_provider.dart';
import 'package:chakracabs/views/helper.dart';
import 'package:chakracabs/views/home_screen/utils/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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
  final Set<Marker> _markers = {};
  BitmapDescriptor? _userLocationIcon;
  BitmapDescriptor? _cabHubIcon;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _loadCustomMarkers();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose(); // Dispose to free resources
    super.dispose();
  }

  Future<void> _loadCustomMarkers() async {
    // Load custom images for user location and cab hubs with increased size
    _userLocationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(64, 64)), // Increase size
      'assets/images/user_location.png',
    );

    _cabHubIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(64, 64)), // Increase size
      'assets/images/hub.png',
    );

    // Initialize cab hub markers after icons are loaded
    _initializeCabHubMarkers();
    // Move map to user's current location
    _moveToUserLocation();
  }

  void _initializeCabHubMarkers() {
    // Fixed cab hub locations with names and coordinates
    final cabHubLocations = {
      'Ballygunge': LatLng(22.5285, 88.3722),
      'Sector V': LatLng(22.5738, 88.4334),
      'Newtown': LatLng(22.5958, 88.4814),
      'Ultadanga': LatLng(22.6034, 88.3928),
      'Alipore': LatLng(22.5329, 88.3378),
    };

    // Add markers for each cab hub location
    cabHubLocations.forEach((name, latLng) {
      _markers.add(
        Marker(
          markerId: MarkerId(name),
          position: latLng,
          infoWindow: InfoWindow(title: name),
          icon:
              _cabHubIcon ?? BitmapDescriptor.defaultMarker, // Use custom icon
        ),
      );
    });
  }

  Future<void> _moveToUserLocation() async {
    // Get user's current location
    final position = await _determinePosition();
    if (position != null) {
      final latLng = LatLng(position.latitude, position.longitude);

      // Reverse geocode to get the address as a string
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        // Check if placemarks are available
        if (placemarks.isNotEmpty) {
          String address =
              "${placemarks.first.name}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}";

          // Update the RideProvider's pickup with the obtained location details
          Provider.of<RideProvider>(context, listen: false).pickup = Place(
            address: address,
            name: placemarks.first.name ?? "Your Location",
            lat: position.latitude,
            lng: position.longitude,
          );

          // Add user's location marker with custom icon
          setState(() {
            _markers.add(
              Marker(
                markerId: const MarkerId('userLocation'),
                position: latLng,
                icon: _userLocationIcon ?? BitmapDescriptor.defaultMarker,
                infoWindow: InfoWindow(title: address),
              ),
            );
          });

          // Move the camera to the user's location
          _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
        } else {
          // If placemarks list is empty, show a fallback message
          showSnackbar("Unable to retrieve address, please try again.",
              Colors.red, context);
        }
      } catch (e) {
        print("Failed to get address: $e");
        showSnackbar("Failed to get address", Colors.red, context);
      }
    }
  }

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
                  LatLng initialPosition = locationVM.currentLatLng ??
                      const LatLng(37.7749, -122.4194);

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * .8,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: initialPosition,
                        zoom: 14.0,
                      ),
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      markers: _markers,
                    ),
                  );
                },
              ),
              Provider.of<BottomSheetModel>(context).selectedIndex != 0
                  ? Positioned(
                      top: 8,
                      left: 8,
                      child: InkWell(
                        onTap: () {
                          Provider.of<BottomSheetModel>(context, listen: false)
                              .selectedIndex = Provider.of<BottomSheetModel>(
                                      context,
                                      listen: false)
                                  .selectedIndex -
                              1;
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              Provider.of<BottomSheetModel>(context).selectedIndex == 0
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        cursorColor: Colors.transparent,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white60,
                          prefixIcon: const Icon(Icons.search, size: 30),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.my_location, size: 30),
                            onPressed: () async {
                              final position = await _determinePosition();
                              if (position != null) {
                                final latLng = LatLng(
                                    position.latitude, position.longitude);
                                Provider.of<LocationViewModel>(context,
                                        listen: false)
                                    .updateCurrentPosition(latLng);

                                _mapController?.animateCamera(
                                  CameraUpdate.newLatLng(latLng),
                                );
                              }
                            },
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Select Your Destination',
                          hintStyle: Theme.of(context).textTheme.bodyLarge,
                        ),
                        onTap: () => showGooglePlacesAutocomplete(context),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  void showGooglePlacesAutocomplete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Positioned(
              top: 0,
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                contentPadding: EdgeInsets.zero,
                content: SizedBox(
                  height: 60,
                  child: GooglePlaceAutoCompleteTextField(
                    googleAPIKey: 'AIzaSyDlhLBOy0MZ10uITSTClB0SMneFG5Glrcg',
                    textEditingController: _textEditingController,
                    inputDecoration: InputDecoration(
                      hintText: 'Enter Destination',
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
                    getPlaceDetailWithLatLng: (postalCodeResponse) {
                      try {
                        print(
                            'this is the postal code response: ${postalCodeResponse.structuredFormatting!.mainText}');
                        final lat = double.tryParse(postalCodeResponse.lat!);
                        final lng = double.tryParse(postalCodeResponse.lng!);
                        if (lat != null && lng != null) {
                          final latLng = LatLng(lat, lng);

                          // Update location and animate the map to the new location

                          Provider.of<RideProvider>(context,
                                      listen: false)
                                  .dest =
                              Place(
                                  address: postalCodeResponse.description!,
                                  name:
                                      '${postalCodeResponse.structuredFormatting!.mainText}',
                                  lat: lat,
                                  lng: lng);
                          Provider.of<LocationViewModel>(context, listen: false)
                              .updateCurrentPosition(latLng);

                          _mapController
                              ?.animateCamera(CameraUpdate.newLatLng(latLng));
                          Provider.of<BottomSheetModel>(context, listen: false)
                              .selectedIndex = 1;
                          Navigator.pop(
                              ctx); // Close the dialog after successful selection
                        }
                      } catch (e) {
                        print(e);
                        showSnackbar('$e', Colors.red, context);
                      }
                    },
                    itemClick: (Prediction? prediction) async {
                      // print('here');
                      print("Prediction: ${prediction!.toJson()}");
                      try {
                        print('here');
                        print("Prediction: ${prediction!.toJson()}");
                        if (prediction != null) {
                          if (prediction.lat != null &&
                              prediction.lng != null) {
                            final lat = double.tryParse(prediction.lat!);
                            final lng = double.tryParse(prediction.lng!);

                            if (lat != null && lng != null) {
                              final latLng = LatLng(lat, lng);

                              // Update location and animate the map to the new location
                              // Provider.of<LocationViewModel>(context, listen: false)
                              //     .updateCurrentPosition(latLng);

                              // _mapController
                              //     ?.animateCamera(CameraUpdate.newLatLng(latLng));

                              Navigator.pop(
                                  context); // Close the dialog after successful selection
                            } else {
                              // Log parsing issues
                              print(
                                  "Parsing error: Could not parse latitude and longitude values.");
                            }
                          } else {
                            print(
                                "Prediction error: lat or lng is unexpectedly null.");
                          }
                        } else {
                          print("Prediction error: Prediction object is null.");
                        }
                      } catch (e) {
                        print("Error during prediction selection: $e");
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
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
