import 'package:base/models/location.dart';
import 'package:base/models/trip_states.dart';
import 'package:base/models/user.dart';
import 'package:equatable/equatable.dart';

class TripData extends Equatable {
  final String? id;
  final String? destinationAddress;
  final String? pickUpAddress;
  final Location? pickUpLocation;
  final Location? dropOffLocation;
  final Location? driverLocation;
  final User? driverPersonalData;
  final User? clintPersonalData;
  final TripStates? tripState;

  TripData(
      {required this.id,
      required this.destinationAddress,
      required this.pickUpAddress,
      required this.pickUpLocation,
      required this.dropOffLocation,
      required this.driverLocation,
      required this.driverPersonalData,
      required this.clintPersonalData,
      required this.tripState});

  @override
  List<Object?> get props => [
    id,
    destinationAddress,
    pickUpAddress,
    pickUpLocation,
    dropOffLocation,
    driverLocation,
    driverPersonalData,
    tripState
  ];

  static TripData fromDocument(Map<String , dynamic> doc , Location? Function(Object?) geoPointToLocationAdapterFunction){
    return TripData(
        id: doc["id"],
        destinationAddress: doc["destinationAddress"],
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
    );
  }


}