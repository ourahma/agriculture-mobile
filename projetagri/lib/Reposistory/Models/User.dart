class User {
  final String email;
  final String password;

  User(this.email, this.password);

/*factory User.fromJson(Map<String,dynamic> json){
    return User(
      email:json['email'],
      password:json['password'],
    );
  }*/

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {'email': email, 'password': password};
    return map;
  }
}

class SignupUser {
  //SignupUser sg= SignupUser(event.role , event.firstname,event.lastname,  event.phone,  event.email, event.password, );

  final String role;
  final String firstname;
  final String lastname;
  final String phone;
  final String email;
  final String password;

  SignupUser(this.role, this.firstname, this.lastname, this.phone, this.email, this.password);
}
