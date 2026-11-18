import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'peanut_api_service.g.dart';

@RestApi(baseUrl: 'https://peanut.ifxdb.com/api/ClientCabinetBasic')
abstract class PeanutApiService {
  factory PeanutApiService(Dio dio, {String baseUrl}) = _PeanutApiService;

  @POST('/IsAccountCredentialsCorrect')
  Future<HttpResponse<dynamic>> checkCredentials(
    @Body() Map<String, dynamic> body,
  );

  @POST('/GetAccountInformation')
  Future<HttpResponse<dynamic>> getAccountInformation(
    @Body() Map<String, dynamic> body,
  );

  @POST('/GetLastFourNumbersPhone')
  Future<HttpResponse<dynamic>> getLastFourNumbersPhone(
    @Body() Map<String, dynamic> body,
  );
}
