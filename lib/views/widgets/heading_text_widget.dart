import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  const HeadingText({
    required this.text,
    super.key,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class SubHeadingText extends StatelessWidget {
  const SubHeadingText({
    required this.text,
    super.key,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontFamily: 'Epilogue',
          fontWeight: FontWeight.w600,
          color: const Color(0xffAF4B2F)),
    );
  }
}
