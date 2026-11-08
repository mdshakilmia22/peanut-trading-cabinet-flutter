import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import '../errors/exceptions.dart';

class ApiClient {
  late final http.Client _client;

  ApiClient({http.Client? client}) {
    if (client != null) {
      _client = client;
    } else {
      final ioClient = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) {
              if (host.contains('contentdatapro.com') ||
                  host.contains('ifxdb.com')) {
                return true;
              }
              return true;
            }
        ..connectionTimeout = const Duration(seconds: 15);
      _client = IOClient(ioClient);
    }
  }

  Future<dynamic> postJson(
    String url, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...?headers,
      };

      final response = await _client
          .post(
            Uri.parse(url),
            headers: requestHeaders,
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on SocketException catch (e) {
      throw NetworkException(
        message: 'Network connection failed: ${e.message}',
      );
    } on TimeoutException {
      throw NetworkException(message: 'Request timed out. Please try again.');
    } catch (e) {
      if (e is ServerException || e is AuthException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'Unexpected network error: $e');
    }
  }

  Future<dynamic> getJson(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParameters);
      }

      final requestHeaders = {'Accept': 'application/json', ...?headers};

      final response = await _client
          .get(uri, headers: requestHeaders)
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on SocketException catch (e) {
      throw NetworkException(
        message: 'Network connection failed: ${e.message}',
      );
    } on TimeoutException {
      throw NetworkException(message: 'Request timed out. Please try again.');
    } catch (e) {
      if (e is ServerException || e is AuthException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'Unexpected network error: $e');
    }
  }

  Future<String> postSoap(
    String url, {
    required String soapEnvelope,
    required String soapAction,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'text/xml; charset=utf-8',
              'SOAPAction': soapAction,
            },
            body: soapEnvelope,
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        throw ServerException(
          message: 'SOAP Server error (${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } on SocketException catch (e) {
      throw NetworkException(
        message: 'Network connection failed: ${e.message}',
      );
    } on TimeoutException {
      throw NetworkException(message: 'Request timed out.');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'SOAP request failed: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        return json.decode(response.body);
      } catch (_) {
        return response.body; // Primitive string responses (like token strings)
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException(
        message:
            'Authorization failed or session expired (${response.statusCode})',
      );
    } else {
      throw ServerException(
        message: 'Server error (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }
  }
}
