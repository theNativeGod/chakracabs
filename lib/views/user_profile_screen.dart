import 'package:chakracabs/models/customer.dart';
import 'package:chakracabs/view_models/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var pageProvider = Provider.of<ProfileProvider>(context);
    CustomerModel? customer = pageProvider.customer;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pageProvider.customer.firstName +
                    " " +
                    pageProvider.customer.lastName,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text('Email: ${pageProvider.customer.email}'),
              Text('Phone Number: ${pageProvider.customer.phoneNumber}'),
            ],
          ),
        ),
      ),
    );
  }
}
