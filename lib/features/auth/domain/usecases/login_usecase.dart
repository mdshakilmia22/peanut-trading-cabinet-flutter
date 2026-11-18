import '../entities/auth_tokens.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<AuthTokens> call({required String login, required String password}) {
    return _repository.login(login: login, password: password);
  }
}
