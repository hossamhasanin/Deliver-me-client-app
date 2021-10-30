import 'package:base/base.dart';
import 'package:deliver_me/dependencies.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/ui/login_screen.dart';
import 'package:map/ui/map_screen.dart';
import 'package:set_destination/ui/set_destination_screen.dart';
import 'package:splash/ui/splash_screen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DeliverMe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: _initialization,
          builder: (context , state){
            if (state.hasError){
              return Scaffold(
                body: Center(
                  child: Text(state.error.toString()),
                ),
              );
            }

            if (state.connectionState == ConnectionState.done){
              inject();
              return const SplashScreen();
            }

            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
      }),
      getPages: [
        GetPage(name: SPLASH_SCREEN, page:()=> const SplashScreen()),
        GetPage(name: LOGIN_SCREEN, page:()=> const LoginScreen()),
        GetPage(name: MAP_SCREEN, page:()=> MapScreen()),
        GetPage(name: SET_DESTINATION_SCREEN, page:()=> const SetDestinationScreen())
      ],
    );
  }
}
