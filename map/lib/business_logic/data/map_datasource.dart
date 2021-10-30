import 'package:base/models/car_type.dart';
import 'package:base/models/destination_result.dart';
import 'package:base/models/trip_data.dart';
import 'package:map/business_logic/payment_methods.dart';

abstract class MapDataSource{
  Future<List<CarType>> getCarTypes();

  Future assignCar(CarType carType , DestinationResult destinationResultv , PaymentMethods paymentMethod);

  Future<Stream<TripData?>> listenToTheTrip();
}