import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import './network_info.dart';
import '../utils/app_logger.dart';

/// Implementation of NetworkInfo using connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();

  NetworkInfoImpl(this.connectivity) {
    // Listen to connectivity changes
    connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final isConnected = results.isNotEmpty &&
          results.any((result) => result != ConnectivityResult.none);

      AppLogger.info(
        isConnected ? 'Network connected' : 'Network disconnected',
        category: 'NETWORK',
      );

      _connectivityController.add(isConnected);
    });
  }

  @override
  Future<bool> get isConnected async {
    final results = await connectivity.checkConnectivity();
    return results.isNotEmpty &&
        results.any((result) => result != ConnectivityResult.none);
  }

  @override
  Stream<bool> get onConnectivityChanged => _connectivityController.stream;

  void dispose() {
    _connectivityController.close();
  }
}
