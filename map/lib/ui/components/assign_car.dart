
import 'package:flutter/material.dart';
import 'package:map/business_logic/data/driver_data.dart';

import 'driver_data.dart';

class AssignCar extends StatelessWidget {

  final DriverData driverData;
  final String durationTillDriverCome;

  const AssignCar({Key? key , required this.driverData , required this.durationTillDriverCome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return driverData.location.latitude == 0.0 ? waiting() : Container(
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0,),
          Padding(
            padding: const EdgeInsets.only(left: 20.0 , top: 5.0),
            child: Text("Driver is " + durationTillDriverCome + " away, you can see him on the map .",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                        ),),
          ),
          const SizedBox(height: 10.0,),
          DriverDataWidget(driverPersonalData: driverData.driverPersonalData,),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: (){},
                      child: const Text("Call"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green
                    ),
                  ),
                  const SizedBox(width: 20.0,),
                  ElevatedButton(
                      onPressed: (){},
                      child: const Text("Chat"),
                  ),
                  const SizedBox(width: 20.0,),
                  ElevatedButton(
                      onPressed: (){},
                      child: const Text("Cancel"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget waiting(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              CircularProgressIndicator(),
              Text("Just a second there is a car for you coming")
            ],
          ),
          SizedBox(height: 15.0,),
          ElevatedButton(
              onPressed: (){},
              child: Text("Want to cancel now ?"),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
          ),
        ],
      ),
    );
  }
}
