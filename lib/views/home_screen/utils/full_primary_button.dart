import 'package:flutter/material.dart';

class FullPrimaryButton extends StatelessWidget {
  const FullPrimaryButton({
    required this.text,
    required this.ontap,
    super.key,
  });
  final String text;
  final ontap;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 24;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 24),
      child: InkWell(
        onTap: ontap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -6,
              bottom: -6,
              child: Container(
                height: 52,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            Container(
              height: 52,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              alignment: Alignment.center,
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
