part of 'connectivity_cubit.dart';

enum ConnectionStatus { checking, online, offline }

class ConnectivityState extends Equatable {
  const ConnectivityState(this.status);
  final ConnectionStatus status;
  @override
  List<Object> get props => [status];
}
