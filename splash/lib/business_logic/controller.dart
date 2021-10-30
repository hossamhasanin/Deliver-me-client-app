import 'package:base/models/trip_data.dart';
import 'package:get/get.dart';
import 'package:splash/business_logic/event_streamer.dart';
import 'package:splash/business_logic/splash_datasource.dart';
import 'package:splash/business_logic/usecase.dart';

class SplashController extends GetxController{

  late final SplashUseCase _useCase;

  Rx<EventStreamer> eventStreamer = EventStreamer(
      assignedTrip: null,
      isLoggedIn: true,
      error: "",
      done: false
  ).obs;

  SplashController(SplashDataSource dataSource){
    _useCase = SplashUseCase(dataSource);
  }

  Future isThereATripAssigned() async {
    eventStreamer.value = await _useCase.isThereTripAssigned(eventStreamer.value);
    // eventStreamer.value = eventStreamer.value.copy(done: false);
  }

  Future isLoggedIn() async {
    eventStreamer.value = await _useCase.isLoggedIn(eventStreamer.value);
  }

  @override
  void onClose() {
    eventStreamer.close();
    super.onClose();
  }

}