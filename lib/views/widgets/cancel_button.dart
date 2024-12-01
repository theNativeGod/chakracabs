import 'package:chakracabs/view_models/bottom_sheet_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/ride_provider.dart';
import '../helper.dart';
import '../home_screen/utils/export.dart';
import '../main_screen.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FullPrimaryButton(
      text: 'Cancel Ride',
      ontap: () {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  content:
                      const Text('Are you sure you want to cancel this ride?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Provider.of<RideProvider>(context, listen: false)
                            .cancelRide(context);
                        Provider.of<BottomSheetModel>(context, listen: false)
                            .selectedIndex = 0;
                        Provider.of<BottomSheetModel>(context, listen: false)
                            .bottomSheetHeight = 300;
                        0;
                        replace(context, const MainScreen());
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text('No'),
                    ),
                  ],
                ));
      },
    );
  }
}
