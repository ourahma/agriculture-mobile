part of 'network_bloc_bloc.dart';

abstract class NetworkBlocEvent /*extends Equatable*/ {
}

class NetworkObserveEvent extends NetworkBlocEvent{}

class NetworkNotifyEvent extends NetworkBlocEvent{
  bool isConnected;

  NetworkNotifyEvent({this.isConnected=false});
}


