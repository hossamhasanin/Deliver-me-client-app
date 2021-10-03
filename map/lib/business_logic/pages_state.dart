import 'package:base/models/car_type.dart';
import 'package:base/models/destination_result.dart';
import 'package:map/business_logic/payment_methods.dart';

class PagesState{
  final int page;
  final List<CarType> carTypes;
  final bool loading;
  final String error;

  PagesState({required this.loading  , required this.error , required this.page,
    required this.carTypes});

  PagesState copy({
    int? page,
    List<CarType>? carTypes,
    DestinationResult? destinationResult,
    bool? loading,
    String?  error
  }){
    return PagesState(
        page: page ?? this.page,
        carTypes: carTypes ?? this.carTypes,
        loading: loading ?? this.loading,
        error: error ?? this.error
    );
  }

}