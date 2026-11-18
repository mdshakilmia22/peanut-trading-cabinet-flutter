import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/get_cached_tokens_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCachedTokensUseCase _getCachedTokensUseCase;

  AuthBloc(
    this._loginUseCase,
    this._checkAuthStatusUseCase,
    this._logoutUseCase,
    this._getCachedTokensUseCase,
  ) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<LogoutSubmittedEvent>(_onLogoutSubmitted);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final isAuthenticated = await _checkAuthStatusUseCase();
    if (isAuthenticated) {
      final tokens = _getCachedTokensUseCase();
      if (tokens != null) {
        emit(Authenticated(tokens));
        return;
      }
    }
    emit(const Unauthenticated());
  }

  Future<void> _onLoginSubmitted(
    LoginSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final tokens = await _loginUseCase(
        login: event.login.trim(),
        password: event.password.trim(),
      );
      emit(Authenticated(tokens));
    } on Failure catch (failure) {
      emit(AuthError(failure.message));
    } catch (e) {
      emit(AuthError('Authentication error: $e'));
    }
  }

  Future<void> _onLogoutSubmitted(
    LogoutSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await _logoutUseCase();
    emit(const Unauthenticated(message: 'Successfully logged out.'));
  }
}
