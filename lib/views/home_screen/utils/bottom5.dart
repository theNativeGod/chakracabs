import 'package:chakracabs/views/helper.dart';
import 'package:chakracabs/views/rate_your_driver/rate_your_driver.dart';
import 'package:flutter/material.dart';

import 'export.dart';

class bottom5 extends StatelessWidget {
  const bottom5({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Arrived At Your Destination',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Image.asset('assets/images/destination_pin.png'),
        const SizedBox(height: 8),
        Text(
          'Stesalit Tower, E-2-3, GP B....',
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        const Text('Ride time 1hr 35min'),
        const SizedBox(height: 8),
        FullPrimaryButton(
          text: 'Pay with Google Pay ₹450',
          ontap: () {
            push(context, RateYourDriver());
          },
        ),
      ],
    );
  }
}
