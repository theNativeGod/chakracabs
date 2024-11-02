import 'package:chakracabs/views/home_screen/utils/export.dart';
import 'package:flutter/material.dart';

class BottomSheetModel with ChangeNotifier {
  int _selectedIndex = 0;
  double _bottomSheetHeight = 300;

  get selectedIndex => _selectedIndex;
  get bottomSheetHeight => _bottomSheetHeight;

  bottomWidget(value, context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Widget bottom = Bottom1(height: height, width: width);

    switch (value) {
      case 0:
        return Bottom1(height: height, width: width);
      case 1:
        return Bottom2(width: width);
      case 2:
        return Bottom3(width: width);
      case 3:
        return Bottom4(width: width);
      case 4:
        return bottom5();
    }
  }

  set selectedIndex(value) {
    _selectedIndex = value;
    notifyListeners();
  }

  set bottomSheetHeight(value) {
    _bottomSheetHeight = value;
    notifyListeners();
  }
}
