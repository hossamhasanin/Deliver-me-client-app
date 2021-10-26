import 'dart:collection';
import 'dart:ffi';

import 'package:base/models/address.dart';
import 'package:base/models/car_type.dart';
import 'package:base/models/destination_result.dart';
import 'package:base/models/location.dart';
import 'package:base/models/trip_data.dart';
import 'package:base/models/trip_states.dart';
import 'package:base/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:map/business_logic/data/map_datasource.dart';
import 'package:base/collections.dart';
import 'package:map/business_logic/payment_methods.dart';

class MapDataSourceImp extends MapDataSource{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future assignCar(CarType carType, DestinationResult destinationResult , PaymentMethods paymentMethod) {
    CollectionReference query = _firestore.collection(ASSIGN_CAR);
    GeoFirePoint pickUpLocation = GeoFirePoint(destinationResult.pickUpLatitude, destinationResult.pickUpLongitude);

    var map = {
      // "id" : _auth.currentUser.uid
      // TODO: Replace that with the auth user id
      "id" : "userId1",
      "carTypeId" : carType.id,
      "carTypeName" : carType.name,
      "carTypePrice" : carType.pricePerDistance,
      "dropOffLocation" : GeoPoint(destinationResult.dropOffLatitude, destinationResult.dropOffLongitude),
      // "pickUpLocation" : GeoPoint(destinationResult.pickUpLatitude, destinationResult.pickUpLongitude),
      "pickUpLocationMap": pickUpLocation.data,
      "pickUpAddress" : destinationResult.pickUpAddress.name,
      "dropOffAddress" : destinationResult.dropOffAddress.name,
      "encodedPolyLinePoints" : destinationResult.direction.encodedDirections,
      "distanceText" : destinationResult.direction.distanceText,
      "distanceValue" : destinationResult.direction.distanceValue,
      "durationText" : destinationResult.direction.durationText,
      "durationValue" : destinationResult.direction.durationValue,
      "paymentMethod" : paymentMethod.toString(),
      "tripState" : TripStates.noDriverAssigned.index,

      "driverLocation" : const GeoPoint(31.006384, 31.383271),
      "driverId": "koko",
      "driverName": "koko",
      "driverEmail" : "koko",
      "driverPhone" : "1223456789",
      "driverImg": "https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8ZHJpdmluZ3xlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80"
    };

    return query.doc("userId1").set(map);
  }

  @override
  Future<List<CarType>> getCarTypes() async {
    Query query = _firestore.collection(CAR_TYPES);

    QuerySnapshot<Object?> documentReference = await query.get();

    List<CarType> l = documentReference.docs.map((doc) {
      print("cars "+doc.get("name"));
      return CarType(
          id: doc.id,
          icon: doc.get("icon"),
          name: doc.get("name"),
          pricePerDistance: double.parse(doc.get("pricePerDistance").toString())
      );
    }).toList();



    print("source "+l.length.toString());

    return l;
  }

  @override
  Stream<TripData?> listenToTheTrip() {
    // TODO: Replace userId with the actual user auth id

    DocumentReference<Map<String, dynamic>> query = _firestore.collection(ASSIGN_CAR).doc("userId1");
    return query.snapshots().map((snapshot) {
      if (snapshot.exists){
          print(snapshot.data());
          // GeoPoint pickUpLocation = snapshot.data()!["pickUpLocation"];
          // GeoPoint dropOffLocation = snapshot.data()!["dropOffLocation"];
          // GeoPoint? driverLocation = snapshot.data()!["driverLocation"];
          // return TripData(
          //     id: snapshot.id,
          //     destinationAddress: snapshot.data()!["dropOffAddress"],
          //     pickUpAddress: snapshot.data()!["pickUpAddress"],
          //     pickUpLocation: Location(latitude: pickUpLocation.latitude , longitude: pickUpLocation.longitude),
          //     dropOffLocation: Location(latitude: dropOffLocation.latitude , longitude: dropOffLocation.longitude),
          //     driverLocation: driverLocation == null ? null : Location(latitude: driverLocation.latitude , longitude: driverLocation.longitude),
          //     driverPersonalData: driverLocation == null ? null : User(
          //         id: snapshot.data()!["driverId"],
          //         name: snapshot.data()!["driverName"],
          //         email: snapshot.data()!["driverEmail"],
          //         phone: snapshot.data()!["driverPhone"],
          //         img: snapshot.data()!["driverImg"]),
          //     clintPersonalData: User(
          //         id: snapshot.data()!["clientId"],
          //         name: snapshot.data()!["clientName"],
          //         email: snapshot.data()!["clientEmail"],
          //         phone: snapshot.data()!["clientPhone"],
          //         img: snapshot.data()!["clientImg"]),
          //     tripState: TripStates.values[snapshot.data()!["tripState"]]);
          return TripData.fromDocument(snapshot.data()!, (Object? geoPoint) {
            if (geoPoint == null) return null;
            return Location(latitude: (geoPoint as GeoPoint).latitude, longitude: geoPoint.longitude);
          });
      } else {
        return null;
      }
    });
  }

}