import 'package:dio/dio.dart';
import '../errors/exceptions.dart';

class SoapApiService {
  final Dio _dio;

  SoapApiService(this._dio);

  Future<String> requestSoap({
    required String url,
    required String soapEnvelope,
    required String soapAction,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: soapEnvelope,
        options: Options(
          headers: {
            'Content-Type': 'text/xml; charset=utf-8',
            'SOAPAction': soapAction,
          },
          responseType: ResponseType.plain,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data.toString();
      } else {
        throw ServerException(
          message: 'SOAP server error (${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException(message: 'Request timed out. Please try again.');
      }
      throw NetworkException(message: 'Network error: ${e.message}');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'SOAP call failed: $e');
    }
  }
}
