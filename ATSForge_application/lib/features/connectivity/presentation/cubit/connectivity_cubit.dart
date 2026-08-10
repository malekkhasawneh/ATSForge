import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_client.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit(this.connectivity, this.client)
      : super(const ConnectivityState(ConnectionStatus.checking));
  final Connectivity connectivity;
  final ApiClient client;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Future<void> start() async {
    _subscription = connectivity.onConnectivityChanged.listen((_) => check());
    await check();
  }

  Future<void> check() async {
    emit(const ConnectivityState(ConnectionStatus.checking));
    final networks = await connectivity.checkConnectivity();
    if (networks.every((item) => item == ConnectivityResult.none)) {
      emit(const ConnectivityState(ConnectionStatus.offline));
      return;
    }
    try {
      await client.dio.get<dynamic>('/health',
          options: Options(receiveTimeout: const Duration(seconds: 6)));
      emit(const ConnectivityState(ConnectionStatus.online));
    } catch (_) {
      emit(const ConnectivityState(ConnectionStatus.offline));
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
