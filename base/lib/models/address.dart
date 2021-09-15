import 'package:equatable/equatable.dart';

class Address extends Equatable{
  final String name;
  final String id;

  Address({required this.name, required this.id});

  @override
  List<Object?> get props => [name , id];
}