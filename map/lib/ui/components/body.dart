import 'dart:async';

import 'package:base/base.dart';
import 'package:base/configs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:base/models/destination_result.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Completer<GoogleMapController> _mainMapCompleter = Completer();
  GoogleMapController? _googleMapController;


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController mapController){
            _mainMapCompleter.complete(mapController);
            _googleMapController = mapController;
          },
        ),

        Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              height: 300.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, -3.0),
                      blurRadius: 5.0
                  )
                ]
              ),
              child: SingleChildScrollView(
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
                        DestinationResult? result = await Get.toNamed(SET_DESTINATION_SCREEN);
                        if (result != null){

                        }
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
              ),
            )
        )
      ],
    );
  }
}
