import 'package:base/models/trip_states.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:map/business_logic/map_controller.dart';

class MapAppBar extends StatelessWidget {
  final MapController _controller = Get.find();

  MapAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3)
      ),
      child: Obx((){
        String title = "";

        if (_controller.tripState.value == null){
          title = "Book a trip";
        } else {
          if (_controller.tripState.value! == TripStates.noDriverAssigned){
            title = "Wait a little";
          } else if (_controller.tripState.value! == TripStates.driverNotHere){
            title = "Driver on the way";
          } else if (_controller.tripState.value! == TripStates.driverArrived){
            title = "Taking the trip";
          } else if (_controller.tripState.value! == TripStates.endTrip){
            title = "Thank you";
          }
        }
        return Row(
          children: [
            IconButton(
                onPressed: (){
                  Scaffold.of(context).openDrawer();
                },
                icon:const Icon(Icons.menu)
            ),
            const SizedBox(width: 20.0,),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black
              ),
            ),
          ],
        );
      }),
    );
  }
}
