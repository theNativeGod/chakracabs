import 'package:chakracabs/view_models/ride_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../view_models/bottom_sheet_model.dart';
import 'export.dart';

class Bottom3 extends StatelessWidget {
  const Bottom3({
    super.key,
    required this.width,
  });

  final double width;
  // Pass the ride request ID to track its status

  @override
  Widget build(BuildContext context) {
    final String rideRequestId =
        Provider.of<RideProvider>(context).rideRequest.id;
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
              return CircularProgressIndicator();
            }

            // Extract the 'status' field
            var rideData = snapshot.data!.data() as Map<String, dynamic>;
            var status = rideData['status'] as String;

            // Update the UI based on the status
            if (status == 'confirmed') {
              return Column(
                children: [
                  Text(
                    'Driver Found!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Arriving shortly',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.green),
                  ),
                ],
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
        FullPrimaryButton(
          text: 'Cancel Ride',
          ontap: () {
            Provider.of<BottomSheetModel>(context, listen: false)
                .selectedIndex = 3;
          },
        ),
      ],
    );
  }
}
