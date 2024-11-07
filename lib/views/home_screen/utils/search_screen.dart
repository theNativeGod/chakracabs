// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';
// import 'package:provider/provider.dart';

// import '../../../view_models/location_view_model.dart';

// class SearchScreen extends StatelessWidget {
//   const SearchScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GooglePlaceAutoCompleteTextField(
//               googleAPIKey: 'YOUR_API_KEY',
//               textEditingController: TextEditingController(),
//               inputDecoration: InputDecoration(
//                 hintText: 'Enter Location',
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide.none,
//                 ),
//                 prefixIcon: const Icon(Icons.search, color: Colors.black),
//               ),
//               debounceTime: 600,
//               isLatLngRequired: true,
//               getPlaceDetailWithLatLng: (Prediction prediction) {
//                 if (prediction.lat != null && prediction.lng != null) {
//                   final latLng = LatLng(
//                       prediction.lat! as double, prediction.lng! as double);
//                   Provider.of<LocationViewModel>(context, listen: false)
//                       .updateCurrentPosition(latLng);

//                   _mapController?.animateCamera(
//                     CameraUpdate.newLatLng(latLng),
//                   );

//                   Navigator.pop(context);
//                 }
//               },
//             ),
//     );
//   }
// }