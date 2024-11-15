import 'package:chakracabs/models/customer.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  CustomerModel? _customer;

  get customer => _customer;

  set customer(value) {
    _customer = value;
    notifyListeners();
  }
}
