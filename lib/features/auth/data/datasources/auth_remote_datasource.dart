import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/auth_tokens.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokens> authenticate({
    required String login,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<AuthTokens> authenticate({
    required String login,
    required String password,
  }) async {
    final body = {
      'login': login,
      'password': password,
    };

    // Authenticate with both Peanut & Partner services in parallel
    final results = await Future.wait([
      _authenticatePeanut(body),
      _authenticatePartner(body),
    ]);

    final peanutToken = results[0];
    final partnerToken = results[1];

    if (peanutToken.isEmpty || partnerToken.isEmpty) {
      throw AuthException(message: 'Failed to retrieve authorization tokens.');
    }

    return AuthTokens(
      peanutToken: peanutToken,
      partnerToken: partnerToken,
      login: login,
    );
  }

  Future<String> _authenticatePeanut(Map<String, dynamic> body) async {
    final response = await _apiClient.postJson(
      ApiConstants.peanutAuthEndpoint,
      body: body,
    );

    if (response is Map<String, dynamic>) {
      final bool result = response['result'] ?? false;
      final String? token = response['token'];

      if (result && token != null && token.isNotEmpty) {
        return token;
      }
    }
    throw AuthException(message: 'Invalid credentials for Peanut Service.');
  }

  Future<String> _authenticatePartner(Map<String, dynamic> body) async {
    final response = await _apiClient.postJson(
      ApiConstants.partnerAuthEndpoint,
      body: body,
    );

    if (response is String && response.isNotEmpty) {
      return response.replaceAll('"', '').trim();
    } else if (response is Map<String, dynamic> && response['token'] != null) {
      return response['token'].toString();
    }
    throw AuthException(message: 'Invalid credentials for Partner Service.');
  }
}
