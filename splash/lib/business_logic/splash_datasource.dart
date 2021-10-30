import 'package:base/models/trip_data.dart';

abstract class SplashDataSource{
  Future<TripData?> isThereAssignedTrip();
  Future<bool> isLoggedIn();
}