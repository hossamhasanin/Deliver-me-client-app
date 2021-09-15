import 'package:equatable/equatable.dart';

class Direction extends Equatable{

  final String distanceText;
  final String durationText;
  final String encodedDirections;
  final int distanceValue;
  final int durationValue;

  Direction(
      {required this.distanceText,
      required this.durationText,
      required this.distanceValue,
      required this.durationValue,
      required this.encodedDirections});

  @override
  List<Object?> get props => [
    distanceText,
    durationText,
    distanceValue,
    durationValue,
    encodedDirections
  ];

}