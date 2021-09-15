import 'package:get/get.dart';
import 'package:login/business_logic/usecases/login_usecase.dart';
import 'package:login/business_logic/usecases/validation_usecase.dart';
import 'package:login/business_logic/view_state.dart';
import 'package:login/data/login_datasource.dart';

class LoginController extends GetxController{

  Rx<ViewState> viewState = ViewState(
      loading: false,
      done: false,
      error: null,
      emailError: null,
      passwordError: null).obs;

  ValidationUseCase _validationUseCase = ValidationUseCase();
  late LoginUseCase _loginUseCase;

  LoginController(LoginDataSource dataSource){
    _loginUseCase = LoginUseCase(dataSource);
  }


  validateEmail(String email){
    String emailError = _validationUseCase.validateEmail(email);

    viewState.value = viewState.value.copy(emailError: emailError);
  }

  validatePassword(String password){
    String passwordError = _validationUseCase.validatePassword(password);

    viewState.value = viewState.value.copy(passwordError: passwordError);
  }

  login(String email , String password) async {
    viewState.value = viewState.value.copy(loading: true);
    viewState.value = await _loginUseCase.login(email, password, viewState.value);
  }

}