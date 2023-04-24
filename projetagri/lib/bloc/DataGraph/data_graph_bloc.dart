import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../Reposistory/Geolocation/geolocationRepository.dart';
import '../../Reposistory/Models/historicdatamodel.dart';

part 'data_graph_event.dart';
part 'data_graph_state.dart';

class DataGraphBloc extends Bloc<DataGraphEvent, DataGraphState> {
  GeolocationRepository repo;
  DataGraphBloc(this.repo) : super(StartEventLoadingState()) {
    on<DataGraphEvent>((event, emit) async {
      if(event is StartEventDataGraph){
        print("event iiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
        emit(StartEventLoadingState());
        var data = await repo.getCurrentdata() ;
        //List<HistoricalDataModel>
        var his = await repo.getHistoricdata();
        if(data !=null && his !=null){
          emit(StartEventLoadedState(data ,his ));
        }else{
          emit(StartEventErrorState('Error loading Data'));
        }
      }
    });
  }
}
