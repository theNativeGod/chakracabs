import 'package:chakracabs/view_models/ride_provider.dart';
import 'package:chakracabs/views/helper.dart';
import 'package:chakracabs/views/home_screen/home_screen.dart';
import 'package:chakracabs/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../view_models/bottom_sheet_model.dart';
import '../../widgets/export.dart';
import 'export.dart';

class Bottom3 extends StatelessWidget {
  const Bottom3({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    final String rideRequestId =
        Provider.of<RideProvider>(context).rideRequest!.id;

    return Column(
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('rideRequests')
              .doc(rideRequestId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const CircularProgressIndicator();
            }

            // Extract the ride data
            var rideData = snapshot.data!.data() as Map<String, dynamic>;
            var status = rideData['status'] as String;
            var driverId = rideData['driverId'] as String?;
            var rideOtp = rideData['rideOtp'].toString();

            if (status == 'confirmed' && driverId != null) {
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('drivers')
                    .doc(driverId)
                    .snapshots(),
                builder: (context, driverSnapshot) {
                  if (driverSnapshot.hasError) {
                    return Text('Error: ${driverSnapshot.error}');
                  }
                  if (!driverSnapshot.hasData || !driverSnapshot.data!.exists) {
                    return const CircularProgressIndicator();
                  }

                  // Extract driver details
                  var driverData =
                      driverSnapshot.data!.data() as Map<String, dynamic>;
                  var driverName =
                      '${driverData['firstName']} ${driverData['lastName']}';
                  var car = driverData['car'];
                  var carNumber = driverData['carNumber'];
                  var phoneNumber = driverData['fullPhoneNumber'];

                  return Bottom4(
                    width: width,
                    driverName: driverName,
                    car: car,
                    carNumber: carNumber,
                    phoneNumber: phoneNumber,
                    otp: rideOtp,
                  );

                  // return Column(
                  //   children: [
                  //     Text(
                  //       'Driver Found!',
                  //       style: Theme.of(context).textTheme.titleLarge,
                  //     ),
                  //     const SizedBox(height: 8),
                  //     Text(
                  //       'Driver: $driverName',
                  //       style: Theme.of(context).textTheme.titleMedium,
                  //     ),
                  //     const SizedBox(height: 4),
                  //     Text(
                  //       'Car: $car ($carNumber)',
                  //       style: Theme.of(context).textTheme.bodyLarge,
                  //     ),
                  //     const SizedBox(height: 4),
                  //     Text(
                  //       'Phone: $phoneNumber',
                  //       style: Theme.of(context).textTheme.bodyMedium,
                  //     ),
                  //     const SizedBox(height: 8),
                  //     Text(
                  //       'Arriving shortly',
                  //       style: Theme.of(context)
                  //           .textTheme
                  //           .titleMedium!
                  //           .copyWith(color: Colors.green),
                  //     ),
                  // ],
                  // );
                },
              );
            } else {
              return Column(
                children: [
                  Text(
                    'Discovering Your Perfect Driver',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Expected by 3:30 PM',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: width - 16,
                      height: 8,
                      child: LinearProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 8),
        OfferAd(width: width),
        CancelButton(),
      ],
    );
  }
}
