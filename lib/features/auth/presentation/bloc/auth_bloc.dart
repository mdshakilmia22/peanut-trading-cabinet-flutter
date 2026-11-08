import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required this._authRepository}) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<LogoutSubmittedEvent>(_onLogoutSubmitted);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final isAuthenticated = await _authRepository.checkAuthStatus();
    if (isAuthenticated) {
      final tokens = _authRepository.getCachedTokens();
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
      final tokens = await _authRepository.login(
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
    await _authRepository.logout();
    emit(const Unauthenticated(message: 'Successfully logged out.'));
  }
}
