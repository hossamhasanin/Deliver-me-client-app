import 'dart:io';

import 'package:base/models/destination_result.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:map/business_logic/data/data_carrier.dart';
import 'package:map/business_logic/data/driver_data.dart';
import 'package:map/business_logic/data/map_datasource.dart';
import 'package:map/business_logic/pages_state.dart';
import 'package:base/models/car_type.dart';
import 'package:base/models/trip_data.dart';
import 'package:base/models/trip_states.dart';

class MapUseCase{

  final MapDataSource _dataSource;

  MapUseCase(this._dataSource);

  Future<PagesState> getCarTypes(PagesState viewState) async {
    try{
      print("usecase yes getting them");
      List<CarType> carTypes = await _dataSource.getCarTypes();
      print("get "+ carTypes.length.toString());
      return viewState.copy(carTypes: carTypes , loading: false , error: "");
    } catch(e){
      return viewState.copy(error: e.toString() , loading: false);
    }
  }

  Future<PagesState> assignCar(PagesState viewState , DataCarrier dataCarrier , DestinationResult destinationResult) async {
    try{
      await _dataSource.assignCar(dataCarrier.selectedCarType!, destinationResult , dataCarrier.paymentMethod!);
      return viewState;
    } on SocketException catch (e){
      print(e);
      return viewState.copy(error: "Error with network" , loading: false);
    }
  }

  // tripState.value = tripData.tripState;
  // viewState.value = viewState.value.copy(loading: false);
  // driverData.value = driverData.value.copy(driverPersonalData: tripData.driverPersonalData , location: tripData.driverLocation);

  Future<Stream<List>> listenToTheTrip(DriverData driverData , TripStates tripState , PagesState viewState) async {
    print("koko trip usecase");
    return (await _dataSource.listenToTheTrip()).where((trip) => trip != null ? (trip.driverLocation != driverData.location || tripState != trip.tripState!) : false).map((TripData? tripData) {
      print("koko usecase tripstate "+tripData!.tripState.toString());
      return [tripData.tripState ,
        viewState.copy(loading: false) ,
        driverData.copy(driverPersonalData: tripData.driverPersonalData ,
            location: tripData.driverLocation)
      ];
    });
  }

}