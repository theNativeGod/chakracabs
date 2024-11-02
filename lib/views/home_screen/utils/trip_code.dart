import 'package:flutter/material.dart';

import 'export.dart';

class TripCode extends StatelessWidget {
  const TripCode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Divider(
            thickness: 1.5,
            color: Colors.grey.shade500,
          ),
        ),
        Text(
          'Trip Code',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CodeBox(
              code: '3',
            ),
            CodeBox(code: '6'),
            CodeBox(code: '9'),
            CodeBox(code: '1'),
          ],
        ),
      ],
    );
  }
}
