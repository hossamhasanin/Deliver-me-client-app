import 'package:equatable/equatable.dart';

class Location extends Equatable {

  final double? latitude;
  final double? longitude;

  Location({required this.latitude, required this.longitude});

  @override
  // TODO: implement props
  List<Object?> get props => [
    latitude , longitude
  ];

}