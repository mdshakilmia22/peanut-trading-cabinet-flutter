import '../entities/account_info.dart';

abstract class ProfileRepository {
  Future<AccountInfo> getAccountInformation({
    required String login,
    required String peanutToken,
  });
}
