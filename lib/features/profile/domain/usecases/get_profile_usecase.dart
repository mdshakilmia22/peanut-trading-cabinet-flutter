import '../../../../core/errors/failures.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../entities/account_info.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository _profileRepository;
  final AuthRepository _authRepository;

  GetProfileUseCase(this._profileRepository, this._authRepository);

  Future<AccountInfo> call() async {
    final tokens = _authRepository.getCachedTokens();
    if (tokens == null) {
      throw const AuthFailure('No active session found. Please log in.');
    }

    return _profileRepository.getAccountInformation(
      login: tokens.login,
      peanutToken: tokens.peanutToken,
    );
  }
}
