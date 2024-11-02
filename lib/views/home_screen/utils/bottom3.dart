import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_models/bottom_sheet_model.dart';
import 'export.dart';

class Bottom3 extends StatelessWidget {
  const Bottom3({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: 8),
        OfferAd(width: width),
        FullPrimaryButton(
            text: 'Cancel Ride',
            ontap: () {
              Provider.of<BottomSheetModel>(context, listen: false)
                  .selectedIndex = 3;
            }),
      ],
    );
  }
}
