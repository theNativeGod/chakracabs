import 'package:chakracabs/views/widgets/export.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_models/bottom_sheet_model.dart';
import 'export.dart';

class Bottom4 extends StatelessWidget {
  const Bottom4({
    super.key,
    required this.width,
    required this.driverName,
    required this.car,
    required this.carNumber,
    required this.phoneNumber,
    required this.otp,
  });

  final double width;
  final String driverName;
  final String car;
  final String carNumber;
  final String phoneNumber;
  final String otp;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Meet at the Pickup Spot',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.black),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8)),
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: const Text('5 min Away'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            color: Colors.grey.shade200,
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 32,
                      top: -32,
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            driverName,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 32,
                      child: Column(
                        children: [
                          const SizedBox(height: 4),
                          // RatingsWidget(),
                          Text(
                            'OTP: $otp',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(carNumber),
                          const SizedBox(height: 8),
                          Text(
                            car,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // TripCode(),
              const TripDetails(),
              const SizedBox(height: 8),
              Container(
                width: width - 16,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Details Regarding Your Journey',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                        Icon(
                          Icons.more_horiz,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            'assets/images/gpay.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '₹450',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width * .7,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 2),
                          blurRadius: 2,
                          spreadRadius: 2,
                          color: Colors.grey.shade300,
                        )
                      ]),
                      margin: const EdgeInsets.all(8),
                      child: TextFormField(
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Your Message',
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              offset: const Offset(0, 2),
                              spreadRadius: 2,
                              blurRadius: 2,
                            )
                          ],
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).primaryColor),
                      child: const Icon(Icons.phone, color: Colors.white),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              offset: const Offset(0, 2),
                              spreadRadius: 2,
                              blurRadius: 2,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).primaryColor),
                      child: const Icon(Icons.phone, color: Colors.white),
                    ),
                  ],
                ),
              ),
              CancelButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }
}

class RatingsWidget extends StatelessWidget {
  const RatingsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          5,
          (index) => Icon(
            Icons.star,
            size: 24,
            shadows: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(.5, .5),
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black,
                offset: Offset(-.5, -.5),
                spreadRadius: 1,
              ),
            ],
            color: index == 4 ? Colors.white : Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
