import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String keyPeanutToken = 'PEANUT_TOKEN';
  static const String keyPartnerToken = 'PARTNER_TOKEN';
  static const String keyUserLogin = 'USER_LOGIN';
  static const String keyUserPassword = 'USER_PASSWORD';

  final SharedPreferences _prefs;

  TokenStorage(this._prefs);

  static Future<TokenStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return TokenStorage(prefs);
  }

  Future<void> saveTokens({
    required String peanutToken,
    required String partnerToken,
    required String login,
    String? password,
  }) async {
    await _prefs.setString(keyPeanutToken, peanutToken);
    await _prefs.setString(keyPartnerToken, partnerToken);
    await _prefs.setString(keyUserLogin, login);
    if (password != null) {
      await _prefs.setString(keyUserPassword, password);
    }
  }

  String? getPeanutToken() => _prefs.getString(keyPeanutToken);
  String? getPartnerToken() => _prefs.getString(keyPartnerToken);
  String? getUserLogin() => _prefs.getString(keyUserLogin);
  String? getUserPassword() => _prefs.getString(keyUserPassword);

  bool hasValidTokens() {
    final pToken = getPeanutToken();
    final ptToken = getPartnerToken();
    final login = getUserLogin();
    return pToken != null && pToken.isNotEmpty &&
           ptToken != null && ptToken.isNotEmpty &&
           login != null && login.isNotEmpty;
  }

  Future<void> clearAll() async {
    await _prefs.remove(keyPeanutToken);
    await _prefs.remove(keyPartnerToken);
    await _prefs.remove(keyUserLogin);
    await _prefs.remove(keyUserPassword);
  }
}
