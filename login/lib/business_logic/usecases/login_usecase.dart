import 'package:login/business_logic/view_state.dart';
import 'package:login/data/login_datasource.dart';

class LoginUseCase{
  final LoginDataSource _dataSource;

  LoginUseCase(this._dataSource);

  Future<ViewState> login(String email , String password , ViewState viewState) async{

    try {
      await _dataSource.login(email, password);
      return Future.value(viewState.copy(loading: false , error: null , done: true));
    }catch(e){
      return Future.value(viewState.copy(loading: false , error: e.toString()));
    }

  }

}