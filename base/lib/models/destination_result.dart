import 'package:base/models/address.dart';
import 'package:base/models/direction.dart';
import 'package:equatable/equatable.dart';

class DestinationResult extends Equatable{

  final Direction direction;
  final double pickUpLatitude;
  final double pickUpLongitude;
  final double dropOffLatitude;
  final double dropOffLongitude;
  final Address pickUpAddress;
  final Address dropOffAddress;

  DestinationResult(
      {required this.direction,
      required this.pickUpLatitude,
      required this.pickUpLongitude,
      required this.dropOffLatitude,
      required this.dropOffLongitude,
      required this.pickUpAddress,
      required this.dropOffAddress});

  @override
  List<Object?> get props => [
    direction,
    pickUpLatitude,
    pickUpLongitude,
    dropOffLatitude,
    dropOffLongitude,
    pickUpAddress,
    dropOffAddress
  ];

}