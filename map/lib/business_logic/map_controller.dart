import 'package:base/models/address.dart';
import 'package:base/models/destination_result.dart';
import 'package:base/models/direction.dart';
import 'package:get/get.dart';
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

  final Rx<PagesState> viewState = PagesState(
        loading: false,
        error: "",
        page: 0,
        carTypes: [],
      ).obs;

  final Rx<DataCarrier> dataCarrier = DataCarrier(
    selectedCarType: null,
    paymentMethod: null
  ).obs;

  final Rx<DriverData> driverData = DriverData(
      location: null,
      driverPersonalData: null
  ).obs;

  final Rx<DestinationResult?> destinationResult = Rx(null);

  final Rx<TripStates?> tripState = Rx(null);

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
    _listenToTheTrip();
  }

  _listenToTheTrip(){
    _useCase.listenToTheTrip(driverData , tripState , viewState);
  }

}