import 'dart:convert';

/// Abstract class defined as a contract for all network operations.
abstract class NetworkClient {
  Future<NetworkResponse> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<NetworkResponse> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  });

  Future<NetworkResponse> patch(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  });

  Future<NetworkResponse> delete(
    String endpoint, {
    Map<String, String>? headers,
  });
}

/// Generic network response model
class NetworkResponse {
  final int statusCode;
  final String body;
  final Map<String, String> headers;

  NetworkResponse({
    required this.statusCode,
    required this.body,
    required this.headers,
  });

  dynamic get jsonBody => json.decode(body);

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
