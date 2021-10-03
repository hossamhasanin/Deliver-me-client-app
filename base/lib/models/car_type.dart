import 'package:equatable/equatable.dart';

class CarType extends Equatable {

  final String id;
  final String name;
  final String icon;
  final double pricePerDistance;

  CarType({required this.id, required this.icon , required this.name, required this.pricePerDistance});


  @override
  List<Object?> get props => [
    id, name , pricePerDistance , icon
  ];

}