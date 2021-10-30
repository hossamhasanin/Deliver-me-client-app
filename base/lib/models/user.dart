import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? img;

  User({this.id , this.name, this.email, this.phone, this.img});

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    img
  ];

}