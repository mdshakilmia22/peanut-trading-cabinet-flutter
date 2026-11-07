import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/profile/data/datasources/profile_remote_datasource.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/promo/data/datasources/promo_remote_datasource.dart';
import 'features/promo/data/repositories/promo_repository_impl.dart';
import 'features/promo/presentation/bloc/promo_bloc.dart';
import 'features/signals/data/datasources/signals_remote_datasource.dart';
import 'features/signals/data/repositories/signals_repository_impl.dart';
import 'features/signals/presentation/bloc/signals_bloc.dart';
import 'main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Core Services & Local Token Storage
  final tokenStorage = await TokenStorage.create();
  final apiClient = ApiClient();

  // Initialize Repositories
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(apiClient),
    tokenStorage: tokenStorage,
  );

  final profileRepository = ProfileRepositoryImpl(
    ProfileRemoteDataSourceImpl(apiClient),
  );

  final signalsRepository = SignalsRepositoryImpl(
    SignalsRemoteDataSourceImpl(apiClient),
  );

  final promoRepository = PromoRepositoryImpl(
    PromoRemoteDataSourceImpl(apiClient),
  );

  runApp(
    CabinetApp(
      authRepository: authRepository,
      profileRepository: profileRepository,
      signalsRepository: signalsRepository,
      promoRepository: promoRepository,
    ),
  );
}

class CabinetApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final ProfileRepositoryImpl profileRepository;
  final SignalsRepositoryImpl signalsRepository;
  final PromoRepositoryImpl promoRepository;

  const CabinetApp({
    super.key,
    required this.authRepository,
    required this.profileRepository,
    required this.signalsRepository,
    required this.promoRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepository: authRepository)..add(CheckAuthStatusEvent()),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(profileRepository: profileRepository),
        ),
        BlocProvider<SignalsBloc>(
          create: (_) => SignalsBloc(signalsRepository: signalsRepository),
        ),
        BlocProvider<PromoBloc>(
          create: (_) => PromoBloc(promoRepository: promoRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Client Cabinet & Trading Signals',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const MainScreen();
        } else if (state is Unauthenticated || state is AuthError) {
          return const LoginPage();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
