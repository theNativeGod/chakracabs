import 'package:chakracabs/models/place_model.dart';
import 'package:chakracabs/view_models/bottom_sheet_model.dart';
import 'package:chakracabs/view_models/ride_provider.dart';
import 'package:chakracabs/views/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'export.dart';

class DraggableBottomSheet extends StatefulWidget {
  const DraggableBottomSheet({
    super.key,
  });

  @override
  State<DraggableBottomSheet> createState() => _DraggableBottomSheetState();
}

class _DraggableBottomSheetState extends State<DraggableBottomSheet> {
  double _bottomSheetHeight = 300;
  int index = 0;
  @override
  Widget build(BuildContext context) {
    index = Provider.of<BottomSheetModel>(context).selectedIndex;
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    double _minheight = 300;
    // double _maxheight = height * .7;

    double _maxheight = index == 0 ? height * .65 : height * .7;
    var bottomSheetProvider = Provider.of<BottomSheetModel>(context);
    _bottomSheetHeight = bottomSheetProvider.bottomSheetHeight;

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          bottomSheetProvider.bottomSheetHeight -= details.delta.dy;
          if (_bottomSheetHeight < _minheight) {
            bottomSheetProvider.bottomSheetHeight = _minheight;
          } else if (_bottomSheetHeight > _maxheight) {
            bottomSheetProvider.bottomSheetHeight = _maxheight;
          }
        });
      },
      child: Container(
        height: _bottomSheetHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          // color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24.0),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 36),
          physics: index == 0 && _bottomSheetHeight >= height * .65 ||
                  index == 1 && _bottomSheetHeight >= height * .7
              ? const ClampingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: width * .3,
                height: 8,
                margin: const EdgeInsets.only(top: 12, bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              bottomSheetProvider.bottomWidget(index, context),
              //,
              // Bottom3(width: width),
              // bottom5(),
            ],
          ),
        ),
      ),
    );
  }
}

class TripDetails extends StatelessWidget {
  const TripDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var rideProvider = Provider.of<RideProvider>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            'Dropping by 5:30 PM',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_pin, color: Theme.of(context).primaryColor),
              Text(
                rideProvider.dest!.name,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CodeBox extends StatelessWidget {
  const CodeBox({
    required this.code,
    super.key,
  });

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 40,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/trip_code.png'),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Text(
        code,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

class RideType extends StatelessWidget {
  const RideType({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    var rideProvider = Provider.of<RideProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildRideTypeSection(
            context: context,
            title: 'Economy',
            rideOptions: [
              {'type': 'Mini', 'price': '₹199', 'capacity': '3 seats capacity'},
              {
                'type': 'Sedan',
                'price': '₹229',
                'capacity': '3 seats capacity'
              },
            ],
            rideProvider: rideProvider,
          ),
          _buildRideTypeSection(
            context: context,
            title: 'Premium',
            rideOptions: [
              {
                'type': 'Premium',
                'price': '₹299',
                'capacity': '3 seats capacity'
              },
              {
                'type': 'Premium Suv',
                'price': '₹329',
                'capacity': '3 seats capacity'
              },
            ],
            rideProvider: rideProvider,
          ),
          const SizedBox(height: 16),
          BookRide(rideProvider: rideProvider),
        ],
      ),
    );
  }

  Widget _buildRideTypeSection({
    required BuildContext context,
    required String title,
    required List<Map<String, String>> rideOptions,
    required RideProvider rideProvider,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: rideOptions.map((rideOption) {
              String type = rideOption['type']!;
              String price = rideOption['price']!;
              String capacity = rideOption['capacity']!;

              bool isSelected = rideProvider.rideType == type;

              return GestureDetector(
                onTap: () => rideProvider.rideType = type,
                child: Container(
                  width: (width - 28) / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('5 min away'),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            type,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            price,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            capacity,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class BookRide extends StatefulWidget {
  const BookRide({
    super.key,
    required this.rideProvider,
  });

  final RideProvider rideProvider;

  @override
  State<BookRide> createState() => _BookRideState();
}

class _BookRideState extends State<BookRide> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : FullPrimaryButton(
            text: 'Book A Ride',
            ontap: () async {
              isLoading = true;
              setState(() {});
              await widget.rideProvider.bookRide(context);
              isLoading = false;
              setState(() {});
              Provider.of<BottomSheetModel>(context, listen: false)
                  .selectedIndex = 2;
            },
          );
  }
}

class RideDetails extends StatelessWidget {
  const RideDetails({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    var rideProvider = Provider.of<RideProvider>(context);
    Place? pickup = rideProvider.pickup;
    Place? dest = rideProvider.dest;
    print('pickup ${pickup!.name}');
    print('dest: ${dest!.name}');
    return Column(
      children: [
        Container(
          width: width - 16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.gps_fixed,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(pickup!.address,
                        softWrap: true,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 32.0, right: 8),
                child: Divider(),
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_pin,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(dest!.address,
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Container(
        //   width: width - 16,
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   padding: const EdgeInsets.all(8),
        //   child: Row(
        //     children: [
        //       Icon(
        //         Icons.access_time_filled,
        //         color: Theme.of(context).primaryColor,
        //       ),
        //       const SizedBox(width: 8),
        //       Text('Now', style: Theme.of(context).textTheme.bodyLarge),
        //       const Spacer(),
        //       const Icon(Icons.keyboard_arrow_down)
        //     ],
        //   ),
        // ),
        // const SizedBox(height: 8),
        // Container(
        //   width: width - 16,
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   padding: const EdgeInsets.all(8),
        //   child: Row(
        //     children: [
        //       Icon(
        //         Icons.directions_car,
        //         color: Theme.of(context).primaryColor,
        //       ),
        //       const SizedBox(width: 8),
        //       Text('Sector V', style: Theme.of(context).textTheme.bodyLarge),
        //       const SizedBox(width: 8),
        //       Text(
        //         '(19 Cars)',
        //         style: Theme.of(context)
        //             .textTheme
        //             .titleSmall!
        //             .copyWith(color: Colors.grey.shade500),
        //       ),
        //       const Spacer(),
        //       const Icon(Icons.keyboard_arrow_down)
        //     ],
        //   ),
        // ),
        // const SizedBox(height: 8),
      ],
    );
  }
}
