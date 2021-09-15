import 'package:login/data/login_datasource.dart';

class LoginDataSourceImp extends LoginDataSource{
  @override
  Future login(String email, String password) {
    return Future.delayed(const Duration(seconds: 3));
  }

}