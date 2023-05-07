part of 'authentification_bloc.dart';

  class AuthentificationState extends Equatable {
  const AuthentificationState();
  
  @override
  List<Object> get props => [];
}

class AuthentificationInitial extends AuthentificationState {}

class LoginLoadingState extends AuthentificationState {}
class UserLoginSuccess extends AuthentificationState{}

class SignupLoadingState extends AuthentificationState {}
class UserSignupSuccess extends AuthentificationState{}


class AdminLoginSuccessState extends AuthentificationState{}
class LoginErrorState extends AuthentificationState{
  final String message ;
  const LoginErrorState({required this.message}) ;
}
class SignupErrorState extends AuthentificationState{
  final String message ;
  const SignupErrorState({required this.message}) ;
}



class LogoutLoadingState extends AuthentificationState{

    const LogoutLoadingState();
}
class LogoutErrorState extends AuthentificationState{}


class LogoutSucessState extends AuthentificationState{}



class StartLoadingState extends AuthentificationState{}

class StartLoadedState extends AuthentificationState{}

class StartErrorState extends AuthentificationState{}


