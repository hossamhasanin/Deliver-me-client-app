import 'package:base/destinations.dart';
import 'package:base/models/destination_result.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class PickDestination extends StatelessWidget {

  final Function() pickDestination;

  const PickDestination({Key? key , required this.pickDestination}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top:15.0 , bottom: 5.0),
            child: Text(
              "Where to ?",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
              ),
            ),
          ),
          // Search box
          GestureDetector(
            onTap: () async{
              pickDestination();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey)
                ),
                child: Row(
                  children: const [
                    SizedBox(width: 10.0),
                    Icon(Icons.search_rounded , color: Colors.black),
                    SizedBox(width: 10.0),
                    Text("choose your destination")
                  ],
                ),
              ),
            ),
          ),
          const Divider(),

          // Home location item
          Row(
            children: [
              const SizedBox(width: 10.0,),
              Container(
                height: 50.0,
                width: 50.0,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepOrangeAccent
                ),
                child: const Center(
                  child: Icon(Icons.home , color: Colors.white),
                ),
              ),
              const SizedBox(width: 20.0),
              const Text("Your home location")
            ],
          ),
          const Divider(),
          // Work location item
          Row(
            children: [
              const SizedBox(width: 10.0,),
              Container(
                height: 50.0,
                width: 50.0,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepOrangeAccent
                ),
                child: const Center(
                  child: Icon(Icons.work_outline , color: Colors.white),
                ),
              ),
              const SizedBox(width: 20.0),
              const Text("Your work location")
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
