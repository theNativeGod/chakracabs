import 'package:flutter/material.dart';
import '../../../models/cabhub.dart';
import 'export.dart';

class CabHubsBox extends StatelessWidget {
  const CabHubsBox({
    super.key,
    required this.height,
    required this.width,
    required this.cabhub,
    required this.isSelected,
    required this.onTap,
  });

  final double height;
  final double width;
  final CabHub cabhub;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height * .2,
        width: width * .34,
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: width * .06,
              backgroundColor: isSelected ? Colors.white : Colors.grey.shade900,
              child: SizedBox(
                height: 25,
                width: 25,
                child: Image.asset(
                  'assets/images/${isSelected ? 'cabhub' : 'cabhub_white'}.png',
                ),
              ),
            ),
            Text(
              cabhub.place.name,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
            ),
            Column(
              children: [
                Text(
                  '${cabhub.cars} Cars',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                ),
                Text(
                  cabhub.distance,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
