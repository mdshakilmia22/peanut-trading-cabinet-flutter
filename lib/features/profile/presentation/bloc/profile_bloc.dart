import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfileUseCase;

  ProfileBloc(this._getProfileUseCase) : super(ProfileInitial()) {
    on<FetchProfileEvent>(_onFetchProfile);
    on<RefreshProfileEvent>(_onRefreshProfile);
  }

  Future<void> _onFetchProfile(
    FetchProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final accountInfo = await _getProfileUseCase();
      emit(ProfileLoaded(accountInfo));
    } on Failure catch (failure) {
      emit(ProfileError(failure.message));
    } catch (e) {
      emit(ProfileError('Error loading profile: $e'));
    }
  }

  Future<void> _onRefreshProfile(
    RefreshProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final accountInfo = await _getProfileUseCase();
      emit(ProfileLoaded(accountInfo));
    } on Failure catch (failure) {
      emit(ProfileError(failure.message));
    } catch (e) {
      emit(ProfileError('Error refreshing profile: $e'));
    }
  }
}
