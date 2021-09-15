import 'package:base/base.dart';
import 'package:deliver_me/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/ui/login_screen.dart';
import 'package:map/ui/map_screen.dart';
import 'package:set_destination/ui/set_destination_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    inject();
    return GetMaterialApp(
      title: 'DeliverMe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SetDestinationScreen(),
      getPages: [
        GetPage(name: LOGIN_SCREEN, page:()=> const LoginScreen()),
        GetPage(name: MAP_SCREEN, page:()=> const MapScreen()),
        GetPage(name: SET_DESTINATION_SCREEN, page:()=> const SetDestinationScreen())
      ],
    );
  }
}
