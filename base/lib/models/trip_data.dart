import 'package:base/models/location.dart';
import 'package:base/models/trip_states.dart';
import 'package:base/models/user.dart';
import 'package:equatable/equatable.dart';

class TripData extends Equatable {
  final String? id;
  final String? destinationAddress;
  final String? pickUpAddress;
  final String? distanceText;
  final int? distanceValue;
  final int? durationValue;
  final String? durationText;
  final String? encodedDirections;
  final Location? pickUpLocation;
  final Location? dropOffLocation;
  final Location? driverLocation;
  final User? driverPersonalData;
  final User? clintPersonalData;
  final TripStates? tripState;

  TripData(
      { this.id,
       this.destinationAddress,
       this.pickUpAddress,
       this.pickUpLocation,
       this.dropOffLocation,
       this.durationText,
       this.durationValue,
       this.distanceText,
       this.distanceValue,
       this.encodedDirections,
       this.driverLocation,
       this.driverPersonalData,
       this.clintPersonalData,
       this.tripState});

  @override
  List<Object?> get props => [
    id,
    destinationAddress,
    pickUpAddress,
    pickUpLocation,
    dropOffLocation,
    driverLocation,
    driverPersonalData,
    tripState,
    durationValue,
    durationText,
    distanceText,
    distanceValue,
    encodedDirections
  ];

  static TripData fromDocument(Map<String , dynamic> doc , Location? Function(Object?) geoPointToLocationAdapterFunction){
    return TripData(
        id: doc["id"],
        destinationAddress: doc["dropOffAddress"],
        pickUpAddress: doc["pickUpAddress"],
        pickUpLocation: geoPointToLocationAdapterFunction(doc["pickUpLocationMap"]["geopoint"]),
        dropOffLocation: geoPointToLocationAdapterFunction(doc["dropOffLocation"]),
        driverLocation: geoPointToLocationAdapterFunction(doc["driverLocation"]),
        driverPersonalData: doc["driverId"] == null ? null : User(
            id: doc["driverId"],
            name: doc["driverName"],
            email: doc["driverEmail"],
            phone: doc["driverPhone"],
            img: doc["driverImg"]),
        clintPersonalData: User(
            id: doc["clientId"],
            name: doc["clientName"],
            email: doc["clientEmail"],
            phone: doc["clientPhone"],
            img: doc["clientImg"]),
        tripState: TripStates.values[doc["tripState"]],
        distanceValue: doc["distanceValue"],
        distanceText: doc["distanceText"],
        durationText: doc["durationText"],
        durationValue: doc["durationValue"],
        encodedDirections: doc["encodedPolyLinePoints"]
    );
  }


}