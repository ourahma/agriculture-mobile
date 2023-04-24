part of 'data_graph_bloc.dart';

abstract class DataGraphEvent extends Equatable {
  const DataGraphEvent();

  @override
  List<Object> get props => [];
}

class StartEventDataGraph extends DataGraphEvent{}
