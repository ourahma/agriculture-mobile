import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../Reposistory/networkhelper.dart';

part 'network_bloc_event.dart';
part 'network_bloc_state.dart';

class NetworkBlocBloc extends Bloc<NetworkBlocEvent, NetworkBlocState> {
  NetworkBlocBloc._() : super(NetworkBlocInitialState()) {

    on<NetworkObserveEvent>(_observe);
    on<NetworkNotifyEvent>(_notifyStatus);
  }


  static final NetworkBlocBloc _instance=NetworkBlocBloc._();

  factory NetworkBlocBloc()=>_instance;

  void _observe(event,emit){
    NetworkHelper.observeNetwork();
  }

  void _notifyStatus(NetworkNotifyEvent event,emit){
    event.isConnected ? emit(NetworkSuccessState()): emit(NetworkFailureState());
  }
}
