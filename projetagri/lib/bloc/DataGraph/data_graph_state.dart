part of 'data_graph_bloc.dart';

abstract class DataGraphState extends Equatable {
  const DataGraphState();

  @override
  List<Object> get props => [];
}

class StartEventLoadingState extends DataGraphState {}

class StartEventLoadedState extends DataGraphState {
  var datacurrent;
  //List<HistoricalDataModel> datahis ;

  StartEventLoadedState(this.datacurrent);
}

class StartEventErrorState extends DataGraphState {
  final String message;

  StartEventErrorState(this.message);
}
