import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Reposistory/Models/User.dart';
import '../../Reposistory/auth_repo.dart';
import 'authentification_event.dart';


part 'authentification_state.dart';

class AuthentificationBloc extends Bloc<AuthentificationEvent, AuthentificationState> {
  AuthReposistory repo ;
  AuthentificationBloc( AuthentificationState initialState, this.repo ) : super(initialState) {

    on<AuthentificationEvent>((event, emit) async {
      if (event is LoginButtonPressed) {
        if (event.email.isEmpty || event.password.isEmpty) {
          emit(const LoginErrorState(message: 'Error'));
        } else {
          emit(LoginLoadingState());
          var data = await repo.login(event.email, event.password);
            if(data=="User does not exist."){
              emit(const LoginErrorState(message: 'User does not exist.'));
            }else if(data=="Incorrect password."){
              emit(const LoginErrorState(message: 'Incorrect password.'));
            }else {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("token",data);
              emit(UserLoginSuccess());
            }
        }
      }else if(event is SignupButtonPressed){
        if (event.email.isEmpty || event.password.isEmpty || event.phone.isEmpty) {
          emit(const SignupErrorState(message: 'Error'));
        }else{
          emit(SignupLoadingState());
          await Future.delayed(const Duration(seconds: 2),() async{
            SignupUser sg= SignupUser(event.role , event.firstname,event.lastname,  event.phone,  event.email, event.password, );
            var data = await repo.signUp(sg);
            emit(UserSignupSuccess());
          });
        }
      }else if(event is LogoutButtonPressed){
        debugPrint('emitting LOG OUT Loading state');
        emit(LogoutLoadingState());
        await repo.logout();
        emit(LogoutSucessState());}
    });



    /*@override
    Stream<AuthentificationState> mapEventToState(
        AuthentificationEvent event) async* {
      var pref = await SharedPreferences.getInstance();
      if (event is StartEvent) {
        yield AuthentificationInitial();
      } else if (event is LoginButtonPressed) {
        yield LoginLoadingState();
        var data = await repo.login(event.email, event.password);
        if (data['roles']['name'] == "ROLE_USER") {
          pref.setString("email", data['email']);
          yield UserLoginSuccess();
        } else if (data['roles']['name'] == "ROLE_ADMIN") {
          yield AdminLoginSuccessState();
        } else {
          yield LoginErrorState(message: "Auth error");
        }
      }
    }*/





  }
  }
