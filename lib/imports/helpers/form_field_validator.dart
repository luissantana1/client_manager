emailValidator({required email}) {
  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(pattern);

  if ( email == null || email == '' ) {
    return "Email field can't be empty";

  } else if ( regExp.hasMatch(email) == false ) {
    return  "Email format is not valid";
  } 
  return null; //a validator must return a null if no problem is found to avoid problems
}

passwordValidator({required password}) {
  if ( password == null || password == '' ) {
    return "Passsword field can't be empty";
  } 
  return null;
}

confirmPasswordValidator({required password, required confirmPassword}) {
  if ( confirmPassword == null || confirmPassword == '' ) {
    return "Confirm password field can't be empty";

  } else if ( password != confirmPassword ) {
    return "Password fields must match";
  }
  return null; 
}
