import 'package:chakracabs/view_models/bottom_sheet_model.dart';
import 'package:chakracabs/view_models/location_view_model.dart';
import 'package:chakracabs/view_models/profile_provider.dart';
import 'package:chakracabs/view_models/ride_provider.dart';
import 'package:chakracabs/views/auth_screens/login_screen/login_screen.dart';
import 'package:chakracabs/views/home_screen/home_screen.dart';
import 'package:chakracabs/views/home_screen/utils/google_map_widget.dart';
import 'package:chakracabs/views/payment_choices/payment_choices_screen.dart';
import 'package:chakracabs/views/rate_your_driver/rate_your_driver.dart';
import 'package:chakracabs/views/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_models/map_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => BottomSheetModel()),
        ChangeNotifierProvider(
          create: (ctx) => MapViewModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => LocationViewModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => RideProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProfileProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Chakra Cabs',
        theme: ThemeData(
          fontFamily: 'Inter',
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff94341a)),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
