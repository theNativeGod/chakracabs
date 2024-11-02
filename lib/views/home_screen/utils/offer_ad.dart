import 'package:flutter/material.dart';

class OfferAd extends StatelessWidget {
  const OfferAd({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: width - 16,
      margin: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade800,
      ),
    );
  }
}
