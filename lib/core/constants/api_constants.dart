class ApiConstants {
  // Base URLs
  static const String peanutBaseUrl = 'https://peanut.ifxdb.com/api/ClientCabinetBasic';
  static const String partnerBaseUrl = 'https://client-api.contentdatapro.com';
  static const String promoWsdlUrl = 'https://api-forexcopy.contentdatapro.com/Services/CabinetMicroService.svc';

  // Endpoints
  static const String peanutAuthEndpoint = '$peanutBaseUrl/IsAccountCredentialsCorrect';
  static const String peanutAccountInfoEndpoint = '$peanutBaseUrl/GetAccountInformation';
  static const String peanutLastFourPhoneEndpoint = '$peanutBaseUrl/GetLastFourNumbersPhone';

  static const String partnerAuthEndpoint = '$partnerBaseUrl/api/Authentication/RequestMoblieCabinetApiToken';
  static const String partnerSignalsEndpoint = '$partnerBaseUrl/clientmobile/GetAnalyticSignals';

  // Domains
  static const String originalPromoImageDomain = 'forex-images.instaforex.com';
  static const String replacePromoImageDomain = 'forex-images.ifxdb.com';

  // Test Account Credentials
  static const String testLogin = '20234561';
  static const String testPassword = 'ladevi31';

  // Available Test Currency Pairs
  static const List<String> defaultCurrencyPairs = [
    'EURUSD',
    'GBPUSD',
    'USDJPY',
    'USDCHF',
    'USDCAD',
    'AUDUSD',
    'NZDUSD',
  ];
}
