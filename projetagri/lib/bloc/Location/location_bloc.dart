import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../Reposistory/Geolocation/geolocationRepository.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  GeolocationRepository repo;
  LocationBloc(OnpressedLocationLoadingState initialLoading, this.repo)
      : super(OnpressedLocationLoadingState()) {
    on<LocationEvent>((event, emit) async {
      if (event is OnpressedLocationEvent) {
        emit(OnpressedLocationLoadingState());
        Position position = await  repo.determinePosition();
        List<Placemark> address= await repo.getLocation(position);
        if (position == LocationPermission.denied || position == LocationPermission.deniedForever) {
          print("Permission denied ");
          emit(OnpressedLocationErrorState(LocationPermission.denied.toString()));
        }else{
          emit(OnpressedLocationLoadedState(position,address ));
        } 
      }
    });
  }
}
