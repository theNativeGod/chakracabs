import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/cabhub.dart';
import '../../../models/place_model.dart';
import '../../../view_models/location_view_model.dart';
import '../../../view_models/map_view_model.dart';
import 'export.dart';

class NearestCabHubs extends StatefulWidget {
  const NearestCabHubs({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  State<NearestCabHubs> createState() => _NearestCabHubsState();
}

class _NearestCabHubsState extends State<NearestCabHubs> {
  int? selectedIndex = 0;

  final List<CabHub> cabhubs = [
    CabHub(
      place: Place(
        address: '123 Ballygunge Rd',
        name: 'Ballygunge',
        lat: 22.52,
        lng: 88.36,
      ),
      cars: 19,
      distance: '15 Km away',
    ),
    CabHub(
      place: Place(
        address: 'Sector V, Kolkata',
        name: 'Sector V',
        lat: 22.57,
        lng: 88.42,
      ),
      cars: 25,
      distance: '12 Km away',
    ),
    CabHub(
      place: Place(
        address: 'Newtown, Kolkata',
        name: 'Newtown',
        lat: 22.59,
        lng: 88.49,
      ),
      cars: 22,
      distance: '10 Km away',
    ),
    CabHub(
      place: Place(
        address: 'Ultadanga, Kolkata',
        name: 'Ultadanga',
        lat: 22.61,
        lng: 88.39,
      ),
      cars: 15,
      distance: '8 Km away',
    ),
    CabHub(
      place: Place(
        address: 'Alipore, Kolkata',
        name: 'Alipore',
        lat: 22.53,
        lng: 88.33,
      ),
      cars: 18,
      distance: '14 Km away',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final mapViewModel = Provider.of<MapViewModel>(context);
    final locationViewModel = Provider.of<LocationViewModel>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearest Cab Hubs',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              const Text('Know About This*'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
            height: widget.height * .2,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemCount: cabhubs.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return CabHubsBox(
                  height: widget.height,
                  width: widget.width,
                  cabhub: cabhubs[index],
                  isSelected: selectedIndex == index,
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    final selectedHub = cabhubs[index];
                    final LatLng hubPosition = LatLng(
                      selectedHub.place.lat,
                      selectedHub.place.lng,
                    );

                    // If current location exists, draw the route
                    if (locationViewModel.currentLatLng != null) {
                      mapViewModel.drawRoute(
                        locationViewModel.currentLatLng!,
                        hubPosition,
                      );
                    }
                    // Animate map camera to the selected hub
                    mapViewModel.animateToPosition(hubPosition);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
