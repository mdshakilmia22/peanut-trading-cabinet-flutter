import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/partner_api_service.dart';
import '../../../../core/network/peanut_api_service.dart';
import '../models/auth_tokens_dto.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokensDto> authenticate({
    required String login,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final PeanutApiService _peanutApiService;
  final PartnerApiService _partnerApiService;

  AuthRemoteDataSourceImpl(this._peanutApiService, this._partnerApiService);

  @override
  Future<AuthTokensDto> authenticate({
    required String login,
    required String password,
  }) async {
    final body = {'login': login, 'password': password};

    final results = await Future.wait([
      _authenticatePeanut(body),
      _authenticatePartner(body),
    ]);

    final peanutToken = results[0];
    final partnerToken = results[1];

    if (peanutToken.isEmpty || partnerToken.isEmpty) {
      throw AuthException(message: 'Failed to retrieve authorization tokens.');
    }

    return AuthTokensDto(
      peanutToken: peanutToken,
      partnerToken: partnerToken,
      login: login,
    );
  }

  Future<String> _authenticatePeanut(Map<String, dynamic> body) async {
    try {
      final response = await _peanutApiService.checkCredentials(body);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final bool result = data['result'] ?? false;
        final String? token = data['token'];
        if (result && token != null && token.isNotEmpty) {
          return token;
        }
      }
      throw AuthException(message: 'Invalid credentials for Peanut Service.');
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(message: 'Peanut authentication error: $e');
    }
  }

  Future<String> _authenticatePartner(Map<String, dynamic> body) async {
    try {
      final response = await _partnerApiService.requestMobileCabinetApiToken(
        body,
      );
      final data = response.data;
      if (data is String && data.isNotEmpty) {
        return data.replaceAll('"', '').trim();
      } else if (data is Map<String, dynamic> && data['token'] != null) {
        return data['token'].toString();
      }
      throw AuthException(message: 'Invalid credentials for Partner Service.');
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(message: 'Partner authentication error: $e');
    }
  }
}
