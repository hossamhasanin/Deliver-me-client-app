import 'package:base/models/car_type.dart';
import 'package:map/business_logic/payment_methods.dart';

class DataCarrier{
  final CarType? selectedCarType;
  final PaymentMethods? paymentMethod;

  DataCarrier({required this.selectedCarType , required this.paymentMethod});

  DataCarrier copy({
    CarType? selectedCarType,
    PaymentMethods? paymentMethod
  }){
    return DataCarrier(
        selectedCarType: selectedCarType ?? this.selectedCarType,
        paymentMethod: paymentMethod ?? this.paymentMethod
    );
  }

}