import 'dart:convert';

import 'package:base/configs.dart';
import 'package:base/models/direction.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:set_destination/business_logic/data/set_destination_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:base/models/direction.dart';


class SetDestinationDataSourceImp implements SetDestinationDataSource{
  @override
  Future<Map<String, String>> getAddress(LatLng location) async {
    final endpoint =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}'
        '&key=$mapApiKey';

    final response = jsonDecode((await http.get(Uri.parse(endpoint),)).body);

    return {
      "placeId": response['results'][0]['place_id'],
      "address": response['results'][0]['formatted_address']
    };
  }

  @override
  Future<Direction> getDirection(double initialLatitude , double initialLongitude , double destinationLatitude , double destinationLongitude) async {
    final endpoint ="https://maps.googleapis.com/maps/api/directions/json?origin=$initialLatitude,$initialLongitude&destination=$destinationLatitude,$destinationLongitude&key=$mapApiKey";

    final response = jsonDecode((await http.get(Uri.parse(endpoint),)).body);

    return Direction(
    distanceText: response['routes'][0]['legs'][0]['distance']['text'],
    durationText: response['routes'][0]['legs'][0]['duration']['text'],
    distanceValue: response['routes'][0]['legs'][0]['distance']['value'],
    durationValue: response['routes'][0]['legs'][0]['duration']['value'],
    encodedDirections: response['routes'][0]['overview_polyline']['points']
    );
  }

}