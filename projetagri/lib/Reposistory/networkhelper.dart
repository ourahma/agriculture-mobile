import 'package:connectivity_plus/connectivity_plus.dart';

import '../bloc/NetworkBloc/network_bloc_bloc.dart';
class NetworkHelper{

  static void observeNetwork(){
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result){
      if(result == ConnectivityResult.none){
        NetworkBlocBloc().add(NetworkNotifyEvent());
      }else {
        NetworkBlocBloc().add(NetworkNotifyEvent(isConnected:true));
      }
    });
  }
}