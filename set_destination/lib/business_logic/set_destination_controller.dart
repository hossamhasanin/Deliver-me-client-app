import 'package:base/models/address.dart';
import 'package:base/models/direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:set_destination/business_logic/data/load_address_wrapper.dart';
import 'package:set_destination/business_logic/data/set_destination_datasource.dart';
import 'package:set_destination/business_logic/eventstate.dart';
import 'package:set_destination/business_logic/usecases/current_location_usecase.dart';
import 'package:set_destination/business_logic/viewstate.dart';

class SetDestinationController extends GetxController{

  final LatLng _initPosition = const LatLng(37.42796133580664, -122.085749655962);

  late Rx<ViewState> viewState;

  late final CurrentLocationUseCase _currentLocationUseCase;

  Rx<EventState> eventState = EventState(
      goToCurrentPosition: false,
      goToDestinationPosition: false,
      setZoomBoundsForDirection: false
  ).obs;

  SetDestinationController(SetDestinationDataSource dataSource){
    viewState = ViewState(
        cameraPosition: _initPosition,
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
        direction: Direction(distanceText: "", durationText: "", distanceValue: 0, durationValue: 0, encodedDirections: ""),
        stopPicking: false
    ).obs;

    _currentLocationUseCase = CurrentLocationUseCase(dataSource);
  }

  Future getCurrentPosition() async{
    viewState.value = await _currentLocationUseCase.getCurrentLocation(viewState.value);
    viewState.value = await _currentLocationUseCase.getAddress(viewState.value);
    moveCameraToCurrentLocation();
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
      viewState.value = viewState.value.copy(currentPosition: position , cameraPosition: position , currentPickedAddressWrapper: viewState.value.currentPickedAddressWrapper.copy(loading: true));
      // viewState.value = await _currentLocationUseCase.getAddress(viewState.value);
    } else {

      if (viewState.value.destinationPosition != null){
        if (position.latitude == viewState.value.destinationPosition!.latitude &&
            position.longitude == viewState.value.destinationPosition!.longitude){
          return;
        }
      }

      viewState.value = viewState.value.copy(destinationPosition: position , cameraPosition: position , destinationPickedAddressWrapper: viewState.value.destinationPickedAddressWrapper.copy(loading: true));

    }

    viewState.value = await _currentLocationUseCase.getAddress(viewState.value);


  }

  Future setDirections() async {

    if (viewState.value.destinationPosition == null || viewState.value.direction.distanceText.isNotEmpty){
      return;
    }

    viewState.value = await _currentLocationUseCase.getDirections(viewState.value);


    viewState.value = viewState.value.copy(stopPicking: true , isPickingCurrentLocation: null);
    setTheZoomForDestination();
  }

  changePicking(bool current){
    viewState.value = viewState.value.copy(isPickingCurrentLocation: current , stopPicking: false , direction: Direction(distanceText: "", durationText: "", distanceValue: 0, durationValue: 0, encodedDirections: ""));
    if (current){
      if (viewState.value.cameraPosition.latitude != viewState.value.currentPosition.latitude &&
          viewState.value.cameraPosition.longitude != viewState.value.currentPosition.longitude){
        moveCameraToCurrentLocation();
      }
    } else {
      if (viewState.value.destinationPosition != null){
        if (viewState.value.cameraPosition.latitude != viewState.value.destinationPosition!.latitude &&
            viewState.value.cameraPosition.longitude != viewState.value.destinationPosition!.longitude){
          moveCameraToDestinationLocation();
        }
      }
    }
  }

  moveCameraToCurrentLocation(){
    eventState.value = eventState.value.copy(
        goToCurrentPosition: true
    );
    eventState.value = eventState.value.copy(
        goToCurrentPosition: false
    );
  }

  moveCameraToDestinationLocation(){
    eventState.value = eventState.value.copy(
        goToDestinationPosition: true
    );
    eventState.value = eventState.value.copy(
        goToDestinationPosition: false
    );
  }

  setTheZoomForDestination(){
    eventState.value = eventState.value.copy(
        setZoomBoundsForDirection: true
    );
    eventState.value = eventState.value.copy(
        setZoomBoundsForDirection: false
    );
  }

}