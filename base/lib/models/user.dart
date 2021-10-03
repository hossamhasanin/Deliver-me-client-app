import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? img;

  User({required this.id , required this.name, required this.email, required this.phone, required this.img});

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    img
  ];

}