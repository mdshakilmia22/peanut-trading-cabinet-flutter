import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

class GetCachedTokensUseCase {
  final AuthRepository _repository;

  GetCachedTokensUseCase(this._repository);

  AuthTokens? call() {
    return _repository.getCachedTokens();
  }
}
