part of 'location_bloc.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class OnpressedLocationLoadingState extends LocationState {}

class OnpressedLocationLoadedState extends LocationState {
  final Position position;
  final List<Placemark> address;
  OnpressedLocationLoadedState(this.position,this.address);
}

class OnpressedLocationErrorState extends LocationState {
  final String message;

  OnpressedLocationErrorState(this.message);
}
