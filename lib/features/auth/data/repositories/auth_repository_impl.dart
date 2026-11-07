import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required TokenStorage tokenStorage,
  })  : _remoteDataSource = remoteDataSource,
        _tokenStorage = tokenStorage;

  @override
  Future<AuthTokens> login({
    required String login,
    required String password,
  }) async {
    try {
      final tokens = await _remoteDataSource.authenticate(
        login: login,
        password: password,
      );

      await _tokenStorage.saveTokens(
        peanutToken: tokens.peanutToken,
        partnerToken: tokens.partnerToken,
        login: tokens.login,
        password: password,
      );

      return tokens;
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerFailure('Authentication failed: $e');
    }
  }

  @override
  Future<bool> checkAuthStatus() async {
    return _tokenStorage.hasValidTokens();
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.clearAll();
  }

  @override
  AuthTokens? getCachedTokens() {
    final peanutToken = _tokenStorage.getPeanutToken();
    final partnerToken = _tokenStorage.getPartnerToken();
    final login = _tokenStorage.getUserLogin();

    if (peanutToken != null && partnerToken != null && login != null) {
      return AuthTokens(
        peanutToken: peanutToken,
        partnerToken: partnerToken,
        login: login,
      );
    }
    return null;
  }
}
