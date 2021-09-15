import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:base/models/direction.dart';

abstract class SetDestinationDataSource{
  Future<Map<String, String>> getAddress(LatLng location);
  Future<Direction> getDirection(double initialLatitude , double initialLongitude , double destinationLatitude , double destinationLongitude);
}