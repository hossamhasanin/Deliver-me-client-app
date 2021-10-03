import 'package:base/models/user.dart';
import 'package:base/models/location.dart';

class DriverData {
  final Location? location;
  final User? driverPersonalData;

  DriverData({required this.location, required this.driverPersonalData});

  DriverData copy({
    Location? location,
    User? driverPersonalData
  }){
    return DriverData(
        location: location ?? this.location,
        driverPersonalData: driverPersonalData ?? this.driverPersonalData
    );
  }

}