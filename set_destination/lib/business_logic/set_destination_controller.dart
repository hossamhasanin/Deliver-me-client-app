import 'package:base/models/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:set_destination/business_logic/data/load_address_wrapper.dart';
import 'package:set_destination/business_logic/data/set_destination_datasource.dart';
import 'package:set_destination/business_logic/usecases/current_location_usecase.dart';
import 'package:set_destination/business_logic/viewstate.dart';

class SetDestinationController extends GetxController{

  final LatLng _initPosition = const LatLng(37.42796133580664, -122.085749655962);

  late Rx<ViewState> viewState;

  late final CurrentLocationUseCase _currentLocationUseCase;

  final PolylinePoints polylinePoints = PolylinePoints();

  final PolylineId polylineTripId = const PolylineId("tripRoute");
  final MarkerId pickUpMarkerId = const MarkerId("pickUpMarker");
  final MarkerId dropOffMarkerId = const MarkerId("dropOffMarker");

  SetDestinationController(SetDestinationDataSource dataSource){
    viewState = ViewState(
        currentPosition: _initPosition,
        destinationPosition: null,
        currentPickedAddressWrapper: LoadAddressWrapper(
            address: Address(name: "Getting your position", id: ""),
            error: "",
            loading: false
        ),
        destinationPickedAddressWrapper: LoadAddressWrapper(
            address: Address(name: "Nothing selected yet", id: ""),
            error: "",
            loading: false
        ),
        isPickingCurrentLocation: true,
        direction: null,
        polyLines: {},
        markers: {},
        circles: {},
        stopPicking: false
    ).obs;

    _currentLocationUseCase = CurrentLocationUseCase(dataSource);
  }

  Future getCurrentPosition() async{
    viewState.value = await _currentLocationUseCase.getCurrentLocation(viewState.value);
    viewState.value = await _currentLocationUseCase.getAddress(viewState.value);
  }

  Future updatePosition(LatLng position) async {

    if (viewState.value.stopPicking){
      return;
    }

    if (viewState.value.isPickingCurrentLocation!){
      if (position.latitude == viewState.value.currentPosition.latitude &&
          position.longitude == viewState.value.currentPosition.longitude){
        return;
      }
      viewState.value = viewState.value.copy(currentPosition: position , currentPickedAddressWrapper: viewState.value.currentPickedAddressWrapper.copy(loading: true));
      // viewState.value = await _currentLocationUseCase.getAddress(viewState.value);
    } else {

      if (viewState.value.destinationPosition != null){
        if (position.latitude == viewState.value.destinationPosition!.latitude &&
            position.longitude == viewState.value.destinationPosition!.longitude){
          return;
        }
      }

      viewState.value = viewState.value.copy(destinationPosition: position , destinationPickedAddressWrapper: viewState.value.destinationPickedAddressWrapper.copy(loading: true));

    }

    viewState.value = await _currentLocationUseCase.getAddress(viewState.value);

    // if (viewState.value.destinationPosition != null){
    //
    //   if (position.latitude == viewState.value.currentPosition.latitude &&
    //       position.longitude == viewState.value.currentPosition.longitude){
    //     return;
    //   }
    //
    //   if (position.latitude == viewState.value.destinationPosition!.latitude &&
    //       position.longitude == viewState.value.destinationPosition!.longitude){
    //     return;
    //   }
    //
    //
    // }

  }

  Future setDirections() async {
    viewState.value = await _currentLocationUseCase.getDirections(viewState.value);
    List<LatLng> coordinates = polylinePoints.decodePolyline(viewState.value.direction!.encodedDirections)
        .map((point) => LatLng(point.latitude, point.longitude)).toList();

    Polyline polyline = Polyline(
        polylineId: polylineTripId,
        points: coordinates,
        color: Colors.red,
        jointType: JointType.round,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true
    );

    Marker pickUpMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        markerId: pickUpMarkerId,
        infoWindow: InfoWindow(title: viewState.value.currentPickedAddressWrapper.address.name , snippet: "My location"),
        position: viewState.value.currentPosition
    );

    Marker dropOffMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        markerId: dropOffMarkerId,
        infoWindow: InfoWindow(title: viewState.value.destinationPickedAddressWrapper.address.name , snippet: "Drop off location"),
        position: viewState.value.destinationPosition!
    );

    Circle pickUpCircle = Circle(
        circleId: CircleId("pickUp"),
        center: viewState.value.currentPosition,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.red,
        fillColor: Colors.red
    );

    Circle dropOffCircle = Circle(
        circleId: CircleId("dropOff"),
        center: viewState.value.destinationPosition!,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.blue,
        fillColor: Colors.blue
    );

    viewState.value = viewState.value.copy(polyLines: {polyline} , markers: {pickUpMarker , dropOffMarker} , circles: {pickUpCircle , dropOffCircle} , stopPicking: true , isPickingCurrentLocation: null);
  }

  changePicking(bool current){
    viewState.value = viewState.value.copy(isPickingCurrentLocation: current , stopPicking: false , markers: {} , circles: {} , polyLines: {});
  }

}