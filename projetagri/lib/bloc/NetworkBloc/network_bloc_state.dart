part of 'network_bloc_bloc.dart';

abstract class NetworkBlocState extends Equatable {
  const NetworkBlocState();
  
  @override
  List<Object> get props => [];
}

class NetworkBlocInitialState extends NetworkBlocState {}

class NetworkSuccessState extends NetworkBlocState {}


class NetworkFailureState extends NetworkBlocState {}
