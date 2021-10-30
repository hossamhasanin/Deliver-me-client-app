import 'package:base/destinations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splash/business_logic/controller.dart';
import 'package:splash/business_logic/event_streamer.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  final SplashController _controller = Get.find();
  Worker? worker;
  @override
  void initState() {
    super.initState();

    worker = ever(_controller.eventStreamer, (EventStreamer event){
      print("here");
      if (event.done){
        Get.offNamed(MAP_SCREEN , arguments: event.assignedTrip);
      }

      if (!event.isLoggedIn){
        Get.offNamed(LOGIN_SCREEN);
      }
    });

    _controller.isLoggedIn().then((_) {
      if (_controller.eventStreamer.value.isLoggedIn){
        _controller.isThereATripAssigned();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/automobile.png" , width: 150.0,height: 150.0,),
          const SizedBox(height: 10.0,),
          const SizedBox(width: 25.0,height: 25.0 ,  child: CircularProgressIndicator())
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    worker!.dispose();
    super.dispose();
  }
}
