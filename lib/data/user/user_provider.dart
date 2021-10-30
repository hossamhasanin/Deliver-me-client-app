
import 'package:base/models/user.dart';

abstract class UserProvider{
  Stream<User?> userData();

  Future<bool> isLoggedIn();
}