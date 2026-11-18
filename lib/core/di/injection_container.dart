import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_client.dart';
import '../network/partner_api_service.dart';
import '../network/peanut_api_service.dart';
import '../network/soap_api_service.dart';
import '../storage/token_storage.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../features/auth/domain/usecases/get_cached_tokens_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';

import '../../features/signals/data/datasources/signals_remote_datasource.dart';
import '../../features/signals/data/repositories/signals_repository_impl.dart';
import '../../features/signals/domain/repositories/signals_repository.dart';
import '../../features/signals/domain/usecases/get_signals_usecase.dart';
import '../../features/signals/presentation/bloc/signals_bloc.dart';

import '../../features/promo/data/datasources/promo_remote_datasource.dart';
import '../../features/promo/data/repositories/promo_repository_impl.dart';
import '../../features/promo/domain/repositories/promo_repository.dart';
import '../../features/promo/domain/usecases/get_promo_materials_usecase.dart';
import '../../features/promo/presentation/bloc/promo_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);
  getIt.registerLazySingleton<TokenStorage>(() => TokenStorage(getIt()));

  final dio = createDioClient();
  getIt.registerLazySingleton<Dio>(() => dio);

  // Retrofit & Network Services
  getIt.registerLazySingleton<PeanutApiService>(
    () => PeanutApiService(getIt()),
  );
  getIt.registerLazySingleton<PartnerApiService>(
    () => PartnerApiService(getIt()),
  );
  getIt.registerLazySingleton<SoapApiService>(() => SoapApiService(getIt()));

  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<SignalsRemoteDataSource>(
    () => SignalsRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<PromoRemoteDataSource>(
    () => PromoRemoteDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt(), tokenStorage: getIt()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<SignalsRepository>(
    () => SignalsRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<PromoRepository>(
    () => PromoRepositoryImpl(getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton<CheckAuthStatusUseCase>(
    () => CheckAuthStatusUseCase(getIt()),
  );
  getIt.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton<GetCachedTokensUseCase>(
    () => GetCachedTokensUseCase(getIt()),
  );

  getIt.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(getIt(), getIt()),
  );

  getIt.registerLazySingleton<GetSignalsUseCase>(
    () => GetSignalsUseCase(getIt(), getIt()),
  );

  getIt.registerLazySingleton<GetPromoMaterialsUseCase>(
    () => GetPromoMaterialsUseCase(getIt()),
  );

  // BLoCs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(getIt(), getIt(), getIt(), getIt()),
  );

  getIt.registerFactory<ProfileBloc>(() => ProfileBloc(getIt()));

  getIt.registerFactory<SignalsBloc>(() => SignalsBloc(getIt()));

  getIt.registerFactory<PromoBloc>(() => PromoBloc(getIt()));
}
