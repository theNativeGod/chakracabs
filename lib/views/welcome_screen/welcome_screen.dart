import 'package:chakracabs/views/auth_screens/login_screen/login_screen.dart';
import 'package:chakracabs/views/helper.dart';
import 'package:flutter/material.dart';

import '../widgets/export.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = mediaQueryData.size;
    double height = size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  Text(
                    'Welcome to',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const HeadingText(text: 'Chakra Cabs!'),
                  const SizedBox(height: 16),
                  const SubHeadingText(text: 'Revolutionizing Urban Mobility'),
                  SizedBox(height: height * .05),
                  const PrimaryButton(text: 'Get Started'),
                ],
              ),
              SizedBox(height: height * .06),
              Container(
                height: height * .55,
                width: double.infinity,
                alignment: Alignment.center,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Transform.scale(
                  scale: 1.1,
                  child: Image.asset('assets/images/welcm_img.png',
                      fit: BoxFit.fitWidth),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.text,
    super.key,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => replace(context, LoginScreen()),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -6,
            bottom: -6,
            child: Container(
              height: 44,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Container(
            height: 44,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor,
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
