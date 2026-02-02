import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../error/failures.dart';
import '../utils/app_logger.dart';
import '../constants/constants.dart';
import './network_client.dart';

/// Implementation of [NetworkClient] using the [http] package.
/// Includes centralized logging and common error handling.
class HttpNetworkClient implements NetworkClient {
  final http.Client client;
  final String baseUrl;

  HttpNetworkClient({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<NetworkResponse> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);
    return _handleRequest(
      () => client.get(uri, headers: headers ?? ApiConstants.headers),
      method: 'GET',
      endpoint: endpoint,
    );
  }

  @override
  Future<NetworkResponse> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final uri = _buildUri(endpoint);
    return _handleRequest(
      () => client.post(
        uri,
        headers: headers ?? ApiConstants.headers,
        body: body is Map || body is List ? json.encode(body) : body,
      ),
      method: 'POST',
      endpoint: endpoint,
      data: body,
    );
  }

  @override
  Future<NetworkResponse> patch(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final uri = _buildUri(endpoint);
    return _handleRequest(
      () => client.patch(
        uri,
        headers: headers ?? ApiConstants.headers,
        body: body is Map || body is List ? json.encode(body) : body,
      ),
      method: 'PATCH',
      endpoint: endpoint,
      data: body,
    );
  }

  @override
  Future<NetworkResponse> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(endpoint);
    return _handleRequest(
      () => client.delete(uri, headers: headers ?? ApiConstants.headers),
      method: 'DELETE',
      endpoint: endpoint,
    );
  }

  /// Builds the full URL for the request
  Uri _buildUri(String endpoint, [Map<String, dynamic>? queryParameters]) {
    final url = '$baseUrl$endpoint';
    if (queryParameters == null || queryParameters.isEmpty) {
      return Uri.parse(url);
    }

    // Add query parameters manually if needed or use Uri.parse with query
    final queryString = queryParameters.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    return Uri.parse('$url?$queryString');
  }

  /// Centralized request handler with logging and error checking
  Future<NetworkResponse> _handleRequest(
    Future<http.Response> Function() request, {
    required String method,
    required String endpoint,
    dynamic data,
  }) async {
    AppLogger.api(endpoint, method, data: data);

    try {
      final response = await request().timeout(ApiConstants.connectionTimeout);

      AppLogger.api(endpoint, method, statusCode: response.statusCode);

      final networkResponse = NetworkResponse(
        statusCode: response.statusCode,
        body: response.body,
        headers: response.headers,
      );

      if (!networkResponse.isSuccess) {
        _handleError(networkResponse, endpoint);
      }

      return networkResponse;
    } on TimeoutException {
      AppLogger.error('$method $endpoint - Timeout', category: 'NETWORK');
      throw ServerFailure('Connection timeout');
    } catch (e) {
      AppLogger.error('$method $endpoint - Failed',
          category: 'NETWORK', error: e);
      if (e is ServerFailure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  /// Centralized error handling based on status codes
  void _handleError(NetworkResponse response, String endpoint) {
    String message;
    try {
      final errorData = response.jsonBody;
      message = errorData['message'] ?? 'Request failed';
    } catch (_) {
      message = 'Request failed with status: ${response.statusCode}';
    }

    throw ServerFailure(message);
  }
}
