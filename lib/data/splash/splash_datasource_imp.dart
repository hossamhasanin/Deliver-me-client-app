import 'package:base/collections.dart';
import 'package:base/models/location.dart';
import 'package:base/models/trip_data.dart';
import 'package:base/models/trip_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_me/data/user/user_provider.dart';
import 'package:splash/splash.dart';

class SplashDataSourceImp implements SplashDataSource{
  final UserProvider _userProvider;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  SplashDataSourceImp(this._userProvider);

  @override
  Future<TripData?> isThereAssignedTrip() async {
    var query = _firestore.collection(ASSIGN_CAR).where("clientId" , isEqualTo: (await _userProvider.userData().last)!.id).where("tripState" , isLessThan: TripStates.endTrip.index);

    var request = await query.get();

    print("koko "+request.size.toString());

    if (request.size == 0){
      return null;
    }

    return TripData.fromDocument(request.docs[0].data(), (Object? geoPoint) {
      if (geoPoint == null) return null;
      return Location(latitude: (geoPoint as GeoPoint).latitude, longitude: geoPoint.longitude);
    });
  }

  @override
  Future<bool> isLoggedIn() async {
    return (await _userProvider.userData().last) != null;
  }

}
