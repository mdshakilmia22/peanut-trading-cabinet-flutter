import '../entities/auth_tokens.dart';

abstract class AuthRepository {
  Future<AuthTokens> login({required String login, required String password});
  Future<bool> checkAuthStatus();
  Future<void> logout();
  AuthTokens? getCachedTokens();
}
