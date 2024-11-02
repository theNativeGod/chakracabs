import 'package:flutter/material.dart';

class AuthPurposeText extends StatelessWidget {
  const AuthPurposeText({
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
            fontWeight: FontWeight.w700,
            color: const Color(0xffAF4B2F),
          ),
    );
  }
}
