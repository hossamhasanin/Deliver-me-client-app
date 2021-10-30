import 'package:base/models/user.dart';
import 'package:deliver_me/data/user/user_provider.dart';

class UserProviderImp implements UserProvider{
  @override
  Stream<User?> userData() {
    return Stream.value(User(
        id: "userId",
        name: "user",
        email: "user@koko.com",
        phone: "123456789",
        img: "https://www.volvotrucks.com/content/dam/volvo-trucks/markets/master/home/services-updates/driver-support/driver-development/driver-support-steering-wheel.jpg"
    )).asBroadcastStream();
  }

  @override
  Future<bool> isLoggedIn() async {
    User? user = await userData().last;
    return user != null;
  }

}