import 'package:chakracabs/views/home_screen/utils/full_primary_button.dart';
import 'package:flutter/material.dart';

class RateYourDriver extends StatelessWidget {
  const RateYourDriver({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
            child: Center(
          child: Column(
            children: [
              Text(
                'Rate Your Driver',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 48,
              ),
              const SizedBox(height: 8),
              Text(
                'Anmol Roy',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Swift Dzire . WB 25985A6AS',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 44),
                child: Text(
                  'How was your trip with Anmol Roy?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
                child: Divider(color: Colors.grey),
              ),
              Text(
                'Overall Rating',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      size: 40,
                      shadows: index == 4
                          ? const [
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
                            ]
                          : [],
                      color: index == 4 ? Colors.white : Colors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Divider(color: Colors.grey.shade500),
              ),
              const SizedBox(height: 8),
              Text(
                'Add Detailed Review',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    hintText: 'Your Message',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              FullPrimaryButton(
                text: 'Submit',
                ontap: () {},
              ),
            ],
          ),
        )),
      ),
    );
  }
}
