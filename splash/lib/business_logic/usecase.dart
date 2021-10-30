import 'package:base/models/trip_data.dart';
import 'package:splash/business_logic/event_streamer.dart';
import 'package:splash/business_logic/splash_datasource.dart';

class SplashUseCase{
  final SplashDataSource _dataSource;

  SplashUseCase(this._dataSource);

  Future<EventStreamer> isThereTripAssigned(EventStreamer eventStreamer) async {
    try{
      TripData? tripData =  await _dataSource.isThereAssignedTrip();
      print("koko usecase "+ tripData.toString());
      return eventStreamer.copy(assignedTrip: tripData , done: true);
    }catch(e){
      print("koko "+ e.toString());
      return eventStreamer.copy(error: e.toString() , done: true);
    }
  }

  Future<EventStreamer> isLoggedIn(EventStreamer eventStreamer) async {
    return eventStreamer.copy(isLoggedIn: await _dataSource.isLoggedIn());
  }

}