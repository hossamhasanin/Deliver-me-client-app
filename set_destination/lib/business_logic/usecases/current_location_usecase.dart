import 'package:base/models/address.dart';
import 'package:base/models/direction.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:set_destination/business_logic/data/set_destination_datasource.dart';
import 'package:set_destination/business_logic/viewstate.dart';

class CurrentLocationUseCase{

  final SetDestinationDataSource _dataSource;

  CurrentLocationUseCase(this._dataSource);

  Future<ViewState> getCurrentLocation(ViewState viewState) async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    print("koko current location > "+ position.latitude.toString() + " , " + position.longitude.toString());
    return viewState.copy(currentPosition: LatLng(position.latitude, position.longitude) , cameraPosition: LatLng(position.latitude, position.longitude) , currentPickedAddressWrapper: viewState.currentPickedAddressWrapper.copy(loading: true));
  }

  Future<ViewState> getAddress(ViewState viewState) async{

    try{
      if (viewState.isPickingCurrentLocation!){
        Map<String , String> values = await _dataSource.getAddress(viewState.currentPosition);
        Address address = Address(name: values["address"]!, id: values["placeId"]!);

        return viewState.copy(currentPickedAddressWrapper: viewState.currentPickedAddressWrapper.copy(address: address , loading: false));
      } else {
        Map<String , String> values = await _dataSource.getAddress(viewState.destinationPosition!);
        Address address = Address(name: values["address"]!, id: values["placeId"]!);

        return viewState.copy(destinationPickedAddressWrapper: viewState.destinationPickedAddressWrapper.copy(address: address , loading: false));
      }
    } catch(e){
      print("koko error getting the address > "+ e.toString());
      if (viewState.isPickingCurrentLocation!){
        return viewState.copy(currentPickedAddressWrapper: viewState.currentPickedAddressWrapper.copy(error: e.toString() , loading: false));
      } else {
        return viewState.copy(destinationPickedAddressWrapper: viewState.destinationPickedAddressWrapper.copy(error: e.toString() , loading: false));
      }
    }
  }


  Future<ViewState> getDirections(ViewState viewState) async {
    try{
      Direction direction = await _dataSource.getDirection(viewState.currentPosition.latitude, viewState.currentPosition.longitude, viewState.destinationPosition!.latitude, viewState.destinationPosition!.longitude);
      return viewState.copy(direction: direction);
    }catch(e){
      print("koko error distination" + e.toString());
      return viewState;
    }
  }

}