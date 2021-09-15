import 'package:base/models/address.dart';

class LoadAddressWrapper{
  final Address address;
  final String error;
  final bool loading;

  LoadAddressWrapper({required this.address, required this.error, required this.loading});

  LoadAddressWrapper copy({
    Address? address,
    String? error,
    bool? loading,
  }){
    return LoadAddressWrapper(
        address: address ?? this.address,
        error: error ?? this.error,
        loading: loading ?? this.loading,
    );
  }
}