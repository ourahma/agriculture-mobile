
import 'package:equatable/equatable.dart';
abstract class AuthentificationEvent extends Equatable {
  const AuthentificationEvent();
  @override
  List<Object> get props => [];
}
class StartEvent extends AuthentificationEvent{}

class LoginButtonPressed extends AuthentificationEvent{
  //final LoginUser LoginUser = LoginUser() ;
  final String email ;
  final String password ;
  LoginButtonPressed({required this.email,required this.password});
}

class SignupButtonPressed extends AuthentificationEvent{
  final String role ;
  final String firstname ;
  final String lastname ;
  final String phone;
  final String email ;
  final String password ;
  SignupButtonPressed({required this.role,required this.firstname,required this.lastname,required this.phone,required this.email,required this.password});
}


class LogoutButtonPressed extends AuthentificationEvent{

  LogoutButtonPressed();
}