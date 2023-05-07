import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../Reposistory/Geolocation/geolocationRepository.dart';

part 'data_graph_event.dart';
part 'data_graph_state.dart';

class DataGraphBloc extends Bloc<DataGraphEvent, DataGraphState> {
  GeolocationRepository repo;
  DataGraphBloc(this.repo) : super(StartEventLoadingState()) {
    on<DataGraphEvent>((event, emit) async {
      if(event is StartEventDataGraph){
      
        emit(StartEventLoadingState());
        var data = await repo.getCurrentdata() ;
        //List<HistoricalDataModel>
        
        if(data.isNotEmpty){
          emit(StartEventLoadedState(data));
        }else{
          emit(StartEventErrorState('Error loading Data'));
        }
      }
    });
  }
}
