import 'package:chakracabs/view_models/bottom_sheet_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'export.dart';

class Bottom1 extends StatelessWidget {
  const Bottom1({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // nearest cab hubs
        NearestCabHubs(height: height, width: width),
        // button
        FullPrimaryButton(
          text: 'Choose Your Destination',
          ontap: () {
            Provider.of<BottomSheetModel>(context, listen: false)
                .bottomSheetHeight = 300.0;
            Provider.of<BottomSheetModel>(context, listen: false)
                .selectedIndex = 1;
          },
        ),
        // offers
        OfferAd(width: width),
        Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 36),
        )
      ],
    );
  }
}
