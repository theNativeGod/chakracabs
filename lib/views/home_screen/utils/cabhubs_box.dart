import 'package:flutter/material.dart';

class CabHubsBox extends StatefulWidget {
  CabHubsBox({
    super.key,
    required this.height,
    required this.width,
    required this.cabhub,
  });

  final double height;
  final double width;
  final String cabhub;

  @override
  State<CabHubsBox> createState() => _CabHubsBoxState();
}

class _CabHubsBoxState extends State<CabHubsBox> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selected = !selected;
        setState(() {});
      },
      child: Container(
        height: widget.height * .2,
        width: widget.width * .34,
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: widget.width * .06,
              backgroundColor: selected ? Colors.white : Colors.grey.shade900,
              child: SizedBox(
                height: 25,
                width: 25,
                child: Image.asset(
                    'assets/images/${selected ? 'cabhub' : 'cabhub_white'}.png'),
              ),
            ),
            Text(
              widget.cabhub,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: selected ? Colors.white : Colors.black,
                  ),
            ),
            Column(
              children: [
                Text(
                  '19 Cars',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: selected ? Colors.white : Colors.black,
                      ),
                ),
                Text(
                  '15 Km away',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: selected ? Colors.white : Colors.black,
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
