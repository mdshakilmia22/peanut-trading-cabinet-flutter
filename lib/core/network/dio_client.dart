import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

Dio createDioClient() {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) {
        if (host.contains('contentdatapro.com') || host.contains('ifxdb.com')) {
          return true;
        }
        return true;
      };
      return client;
    },
  );

  return dio;
}
