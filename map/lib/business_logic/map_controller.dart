import 'dart:async';

import 'package:base/models/address.dart';
import 'package:base/models/destination_result.dart';
import 'package:base/models/direction.dart';
import 'package:base/models/location.dart';
import 'package:base/models/trip_data.dart';
import 'package:base/models/user.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/business_logic/data/data_carrier.dart';
import 'package:map/business_logic/data/driver_data.dart';
import 'package:map/business_logic/data/map_datasource.dart';
import 'package:map/business_logic/payment_methods.dart';
import 'package:map/business_logic/usecases/map_usecase.dart';
import 'package:map/business_logic/pages_state.dart';
import 'package:base/models/car_type.dart';
import 'package:map/ui/components/payment_method.dart';
import 'package:base/models/trip_states.dart';

class MapController extends GetxController{

  late final MapUseCase _useCase;

  final Rx<PagesState> viewState = PagesState.initState().obs;

  final Rx<DataCarrier> dataCarrier = DataCarrier(
    selectedCarType: null,
    paymentMethod: null
  ).obs;

  final Rx<DriverData> driverData = DriverData.init().obs;

  final Rx<DestinationResult?> destinationResult = Rx(null);

  final Rx<TripStates?> tripState = Rx(null);

  StreamSubscription? _tripListener;

  MapController(MapDataSource dataSource){

    _useCase = MapUseCase(dataSource);
  }

  Future getCarTypes() async {
    print("cpntroller get cars data");
    viewState.value = viewState.value.copy(loading: true , page: 1);
    viewState.value = await _useCase.getCarTypes(viewState.value);
  }

  setDestination(DestinationResult destinationResult){
    print(destinationResult);
    this.destinationResult.value = destinationResult;
  }

  selectCarType(CarType carType){
    dataCarrier.value = dataCarrier.value.copy(selectedCarType: carType);
  }

  getToPaymentMethod(){
    viewState.value = viewState.value.copy(loading: false , page: 2);
  }

  selectPayment(PaymentMethods paymentMethod){
    dataCarrier.value = dataCarrier.value.copy(paymentMethod: paymentMethod);
  }

  goToDriverAssigning() async {
    viewState.value = viewState.value.copy(loading: true , page: 3);
    viewState.value = await _useCase.assignCar(viewState.value, dataCarrier.value, destinationResult.value!);
    tripState.value = TripStates.noDriverAssigned;
    _listenToTheTrip();
  }

  _listenToTheTrip() async {
    if (_tripListener != null){
      _tripListener!.cancel();
    }
    _tripListener = (await _useCase.listenToTheTrip(driverData.value , tripState.value! , viewState.value)).listen((results) {
      tripState.value = results[0] as TripStates;
      viewState.value = results[1] as PagesState;
      driverData.value = results[2] as DriverData;
    });
  }

  endTrip(){
    viewState.value = PagesState.initState();
    tripState.value = null;
    driverData.value = DriverData.init();
    destinationResult.value = null;

    _tripListener!.cancel();
  }

  setTheAcceptedTrip(TripData tripData){
    var polyLineMaker = PolylinePoints();
    var polyLinePoints = polyLineMaker.decodePolyline(tripData.encodedDirections!)
        .map((point) => LatLng(point.latitude, point.longitude)).toList();
    destinationResult.value = DestinationResult(
        direction: Direction(
            distanceText: tripData.distanceText!,
            durationText: tripData.durationText!,
            durationValue: tripData.durationValue!,
            distanceValue: tripData.distanceValue!,
            encodedDirections: tripData.encodedDirections!
        ),
        pickUpLatitude: tripData.pickUpLocation!.latitude!,
        pickUpLongitude: tripData.pickUpLocation!.longitude!,
        dropOffLatitude: tripData.dropOffLocation!.latitude!,
        dropOffLongitude: tripData.dropOffLocation!.longitude!,
        pickUpAddress: Address(name: tripData.pickUpAddress!, id: ""),
        dropOffAddress: Address(name: tripData.destinationAddress!, id: ""),
        polyLinePoints: polyLinePoints);

    tripState.value = tripData.tripState;

    driverData.value = DriverData(
      driverPersonalData: tripData.driverPersonalData ?? User(),
      location: tripData.driverLocation ?? Location(latitude: 0.0, longitude: 0.0)
    );

    viewState.value = viewState.value.copy(
      page: 3
    );

    _listenToTheTrip();
  }

  @override
  void onClose() {
    if (_tripListener != null){
      _tripListener!.cancel();
    }
    super.onClose();
  }

}