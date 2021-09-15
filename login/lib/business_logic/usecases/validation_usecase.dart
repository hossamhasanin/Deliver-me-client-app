class ValidationUseCase {

  RegExp emailReg = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  String validateEmail(String email){

    if (email.isEmpty){
      return "You have to write an email";
    }

    if (email.length < 5){
      return "This is so short bro";
    }

    if (!emailReg.hasMatch(email)){
      return "Buddy this is not an email";
    }

    return "";
  }

  String validatePassword(String password){

    if (password.isEmpty){
      return "You have to write the password";
    }

    if (password.length < 5){
      return "This is so short bro";
    }

    return "";
  }

}