import 'package:base/models/address.dart';
import 'package:base/models/direction.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:set_destination/business_logic/data/load_address_wrapper.dart';

class ViewState{
  final LatLng cameraPosition;
  final LatLng currentPosition;
  final LatLng? destinationPosition;
  final LoadAddressWrapper currentPickedAddressWrapper;
  final LoadAddressWrapper destinationPickedAddressWrapper;
  final bool? isPickingCurrentLocation;
  final Direction direction;
  final bool stopPicking;

  ViewState({required this.cameraPosition , required this.stopPicking , required this.direction , required this.destinationPosition , required this.isPickingCurrentLocation , required this.destinationPickedAddressWrapper , required this.currentPosition, required this.currentPickedAddressWrapper});


  ViewState copy({
    LatLng? cameraPosition,
    LatLng? currentPosition,
    LatLng? destinationPosition,
    LoadAddressWrapper? currentPickedAddressWrapper,
    LoadAddressWrapper? destinationPickedAddressWrapper,
    bool? isPickingCurrentLocation,
    bool? stopPicking,
    Direction? direction,
    Set<Polyline>? polyLines,
    Set<Marker>? markers,
    Set<Circle>? circles,
  }){
    return ViewState(
        cameraPosition: cameraPosition ?? this.cameraPosition,
        currentPosition: currentPosition ?? this.currentPosition,
        destinationPosition: destinationPosition ?? this.destinationPosition,
        currentPickedAddressWrapper: currentPickedAddressWrapper?? this.currentPickedAddressWrapper,
        destinationPickedAddressWrapper: destinationPickedAddressWrapper?? this.destinationPickedAddressWrapper,
        isPickingCurrentLocation: isPickingCurrentLocation?? this.isPickingCurrentLocation,
        direction: direction ?? this.direction,
        stopPicking: stopPicking ?? this.stopPicking
    );
  }

  bool isEveryThingValidToReturn(){
    return destinationPosition != null &&
           currentPickedAddressWrapper.address.id.isNotEmpty &&
           destinationPickedAddressWrapper.address.id.isNotEmpty &&
           direction.distanceText.isNotEmpty;
  }

}