import 'package:base/models/user.dart';
import 'package:flutter/material.dart';

class DriverDataWidget extends StatelessWidget {

  final User driverPersonalData;

  const DriverDataWidget({Key? key , required this.driverPersonalData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(driverPersonalData.img!),
            radius: 35.0,
          ),
          const SizedBox(width: 15.0,),
          Column(
            children: [
              Text(driverPersonalData.name! , style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0
              ),),
              const SizedBox(height: 10.0,),
              Text(driverPersonalData.email! , style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0
              ))
            ],
          )
        ],
      ),
    );
  }
}
