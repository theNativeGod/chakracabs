import 'package:flutter/material.dart';

import 'export.dart';

class NearestCabHubs extends StatelessWidget {
  const NearestCabHubs({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    List<String> cabhubs = [
      'Ballygunge',
      'Sector V',
      'Newtown',
      'Ultadanga',
      'Alipore'
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // header text
              Text(
                'Nearest Cab Hubs',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              // know about this
              const Text('Know About This*')
            ],
          ),
        ),
        // choose your destination

        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
            height: height * .2,
            child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemCount: cabhubs.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  return CabHubsBox(
                    height: height,
                    width: width,
                    cabhub: cabhubs[i],
                  );
                }),
          ),
        ),
      ],
    );
  }
}
