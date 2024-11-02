import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String _phoneNumber = '1234567890';
  String _countryCode = '+91';

  get phoneNumber => _phoneNumber;

  get countryCode => _countryCode;

  set phoneNumber(value) {
    _phoneNumber = value;
    notifyListeners();
  }

  set countryCode(value) {
    _countryCode = value;
    notifyListeners();
  }
}
