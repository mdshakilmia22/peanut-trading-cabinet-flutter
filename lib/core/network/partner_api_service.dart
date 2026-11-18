import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'partner_api_service.g.dart';

@RestApi(baseUrl: 'https://client-api.contentdatapro.com')
abstract class PartnerApiService {
  factory PartnerApiService(Dio dio, {String baseUrl}) = _PartnerApiService;

  @POST('/api/Authentication/RequestMoblieCabinetApiToken')
  Future<HttpResponse<dynamic>> requestMobileCabinetApiToken(
    @Body() Map<String, dynamic> body,
  );

  @GET('/clientmobile/GetAnalyticSignals/{login}')
  Future<HttpResponse<dynamic>> getAnalyticSignals(
    @Path('login') String login,
    @Header('passkey') String passkey,
    @Query('tradingsystem') String tradingSystem,
    @Query('pairs') String pairs,
    @Query('from') int from,
    @Query('to') int to,
  );
}
