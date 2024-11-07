import 'package:chakracabs/models/place_model.dart';

class CabHub {
  final Place place;
  final int cars;
  final String distance;

  CabHub({
    required this.cars,
    required this.place,
    required this.distance,
  });
}
