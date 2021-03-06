import 'dart:async';

import 'package:base/models/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:set_destination/business_logic/data/load_address_wrapper.dart';
import 'package:set_destination/business_logic/set_destination_controller.dart';
import 'package:base/models/destination_result.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  Completer<GoogleMapController> _mainMapCompleter = Completer();
  GoogleMapController? _googleMapController;

  final SetDestinationController _setDestinationController = Get.find();

  CameraPosition _selectedPosition = CameraPosition(target: LatLng(37.42796133580664, -122.085749655962) , zoom: 14);
  CameraPosition? _initPosition;


  final PolylinePoints polylinePoints = PolylinePoints();

  final PolylineId polylineTripId = const PolylineId("tripRoute");
  final MarkerId pickUpMarkerId = const MarkerId("pickUpMarker");
  final MarkerId dropOffMarkerId = const MarkerId("dropOffMarker");


  late Polyline polyline;
  late Marker pickUpMarker;
  late Marker dropOffMarker;
  late Circle pickUpCircle;
  late Circle dropOffCircle;
  List<LatLng> coordinates = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initPosition = _selectedPosition;

    polyline = Polyline(
        polylineId: polylineTripId,
        color: Colors.red,
        jointType: JointType.round,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true
    );

    pickUpMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      markerId: pickUpMarkerId,
      infoWindow: InfoWindow(title: _setDestinationController.viewState.value.currentPickedAddressWrapper.address.name , snippet: "My location"),
    );

    dropOffMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      markerId: dropOffMarkerId,
      infoWindow: InfoWindow(title: _setDestinationController.viewState.value.destinationPickedAddressWrapper.address.name , snippet: "Drop off location"),
    );

    pickUpCircle = const Circle(
        circleId: CircleId("pickUp"),
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.red,
        fillColor: Colors.red
    );

    dropOffCircle = const Circle(
        circleId: CircleId("dropOff"),
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.blue,
        fillColor: Colors.blue
    );


    _setDestinationController.getCurrentPosition();

    ever(_setDestinationController.eventState , (_){
      if (_setDestinationController.eventState.value.goToCurrentPosition){
        _googleMapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _setDestinationController.viewState.value.currentPosition , zoom: 14)));
      }

      if (_setDestinationController.eventState.value.goToDestinationPosition){
        _googleMapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _setDestinationController.viewState.value.destinationPosition! , zoom: 14)));
      }

      if (_setDestinationController.eventState.value.setZoomBoundsForDirection){
        LatLngBounds latLngBounds;

        if (_setDestinationController.viewState.value.currentPosition.latitude > _setDestinationController.viewState.value.destinationPosition!.latitude &&
            _setDestinationController.viewState.value.currentPosition.longitude > _setDestinationController.viewState.value.destinationPosition!.longitude){
          latLngBounds = LatLngBounds(southwest: _setDestinationController.viewState.value.destinationPosition!, northeast: _setDestinationController.viewState.value.currentPosition);
        } else if (_setDestinationController.viewState.value.currentPosition.longitude > _setDestinationController.viewState.value.destinationPosition!.longitude){
          latLngBounds = LatLngBounds(southwest: LatLng(_setDestinationController.viewState.value.currentPosition.latitude , _setDestinationController.viewState.value.destinationPosition!.longitude), northeast: LatLng(_setDestinationController.viewState.value.destinationPosition!.latitude , _setDestinationController.viewState.value.currentPosition.longitude));
        } else if (_setDestinationController.viewState.value.currentPosition.latitude > _setDestinationController.viewState.value.destinationPosition!.latitude){
          latLngBounds = LatLngBounds(southwest: LatLng(_setDestinationController.viewState.value.destinationPosition!.latitude, _setDestinationController.viewState.value.currentPosition.longitude), northeast: LatLng(_setDestinationController.viewState.value.currentPosition.latitude , _setDestinationController.viewState.value.destinationPosition!.longitude));
        } else {
          latLngBounds = LatLngBounds(southwest: _setDestinationController.viewState.value.currentPosition, northeast: _setDestinationController.viewState.value.destinationPosition!);
        }

        _googleMapController?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

      }
    });

    ever(_setDestinationController.viewState , (_){
      if (_setDestinationController.viewState.value.direction.distanceText.isNotEmpty){
        coordinates = polylinePoints.decodePolyline(_setDestinationController.viewState.value.direction.encodedDirections)
            .map((point) => LatLng(point.latitude, point.longitude)).toList();
        polyline = polyline.copyWith(pointsParam: coordinates);
        pickUpMarker = pickUpMarker.copyWith(positionParam: _setDestinationController.viewState.value.currentPosition);
        dropOffMarker = dropOffMarker.copyWith(positionParam: _setDestinationController.viewState.value.destinationPosition!);
        pickUpCircle = pickUpCircle.copyWith(centerParam: _setDestinationController.viewState.value.currentPosition);
        dropOffCircle = dropOffCircle.copyWith(centerParam: _setDestinationController.viewState.value.destinationPosition!);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return GetX<SetDestinationController>(builder: (_){
      return Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            polylines: _setDestinationController.viewState.value.direction.distanceText.isNotEmpty ? {polyline} : {},
            markers: _setDestinationController.viewState.value.direction.distanceText.isNotEmpty ? {pickUpMarker , dropOffMarker} : {},
            circles: _setDestinationController.viewState.value.direction.distanceText.isNotEmpty ? {pickUpCircle , dropOffCircle} : {},
            initialCameraPosition: _initPosition!,
            onMapCreated: (GoogleMapController mapController){
              _mainMapCompleter.complete(mapController);
              _googleMapController = mapController;
            },
            onCameraMove: (CameraPosition cameraPosition){
              _selectedPosition = cameraPosition;
            },
            onCameraIdle: () async {
              await _setDestinationController.updatePosition(
                  _selectedPosition.target);
            },
          ),

          pin(),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Column(
              children: [
                locationCard("Pick up from :" , _setDestinationController.viewState.value.currentPickedAddressWrapper ,
                    _setDestinationController.viewState.value.stopPicking ? false : _setDestinationController.viewState.value.isPickingCurrentLocation! ,
                    (){
                      if (_setDestinationController.viewState.value.isPickingCurrentLocation != null){
                        if (_setDestinationController.viewState.value.isPickingCurrentLocation! &&
                            !_setDestinationController.viewState.value.stopPicking){
                          return;
                        }
                      }

                      _setDestinationController.changePicking(true);
                    }),
                locationCard("Drop off :" , _setDestinationController.viewState.value.destinationPickedAddressWrapper ,
                    _setDestinationController.viewState.value.stopPicking ? false : !_setDestinationController.viewState.value.isPickingCurrentLocation!,
                    (){
                      if (_setDestinationController.viewState.value.isPickingCurrentLocation != null){
                        if (!_setDestinationController.viewState.value.isPickingCurrentLocation! &&
                            !_setDestinationController.viewState.value.stopPicking){
                          return;
                        }
                      }

                      _setDestinationController.changePicking(false);
                    }),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await _setDestinationController.setDirections();
                      },
                      child: const Text("Set route"),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if(_setDestinationController.viewState.value.isEveryThingValidToReturn()){
                          DestinationResult result = DestinationResult(
                              direction: _setDestinationController.viewState.value.direction,
                              pickUpLatitude: _setDestinationController.viewState.value.currentPosition.latitude,
                              pickUpLongitude: _setDestinationController.viewState.value.currentPosition.longitude,
                              dropOffLatitude: _setDestinationController.viewState.value.destinationPosition!.latitude,
                              dropOffLongitude: _setDestinationController.viewState.value.destinationPosition!.longitude,
                              pickUpAddress: _setDestinationController.viewState.value.currentPickedAddressWrapper.address,
                              dropOffAddress: _setDestinationController.viewState.value.destinationPickedAddressWrapper.address,
                              polyLinePoints: coordinates
                          );
                          Get.back(result: result);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: _setDestinationController.viewState.value.isEveryThingValidToReturn() ? Colors.green :
                                Colors.grey
                      ),
                      child: const Text("Done"),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      );
    });
  }

  Widget pin() {
    return IgnorePointer(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.place, size: 56),
            Container(
              decoration: const ShapeDecoration(
                shadows: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.black38,
                  ),
                ],
                shape: CircleBorder(
                  side: BorderSide(
                    width: 4,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 56),
          ],
        ),
      ),
    );
  }

  Widget locationCard(String title , LoadAddressWrapper addressWrapper , bool isPicking , Function() pickDone) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 20,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 10.0,),
                  addressWrapper.loading ? const CircularProgressIndicator():
                  addressWrapper.error.isNotEmpty? Text("Error: "+ addressWrapper.error):
                  Text(addressWrapper.address.name),
                ])
            ),
            const Spacer(),
            FloatingActionButton(
              onPressed: pickDone,
              backgroundColor: isPicking ? Colors.white : Colors.blue,
              child: isPicking? const Icon(Icons.downloading , color: Colors.blue) :
              const Text(
                "pick",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
