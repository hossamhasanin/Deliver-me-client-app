class ViewState{
  final String? emailError;
  final String? passwordError;
  final bool loading;
  final String? error;
  final bool done;

  ViewState({required this.done, required this.loading, required this.error,required this.emailError, required this.passwordError});


  ViewState copy({
    String? emailError,
    String? passwordError,
    bool? loading,
    bool? done,
    String? error
}){
    return ViewState(
        loading: loading ?? this.loading ,
        done: done ?? this.done ,
        error: error ?? this.error,
        emailError: emailError ?? this.emailError,
        passwordError: passwordError ?? this.passwordError);
  }

  bool isEveryThingValid(){
    if (passwordError != null && emailError != null){
        return passwordError!.isEmpty && emailError!.isEmpty;
    }
    return false;
  }

}