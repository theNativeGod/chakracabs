import 'package:flutter/material.dart';

import 'export.dart';

class Bottom2 extends StatelessWidget {
  const Bottom2({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RideDetails(width: width),

        // Ride Type
        RideType(width: width),
      ],
    );
  }
}
