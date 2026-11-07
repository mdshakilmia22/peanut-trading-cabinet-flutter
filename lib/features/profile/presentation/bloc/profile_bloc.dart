import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(ProfileInitial()) {
    on<FetchProfileEvent>(_onFetchProfile);
    on<RefreshProfileEvent>(_onRefreshProfile);
  }

  Future<void> _onFetchProfile(
    FetchProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final accountInfo = await _profileRepository.getAccountInformation(
        login: event.login,
        peanutToken: event.peanutToken,
      );
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
      final accountInfo = await _profileRepository.getAccountInformation(
        login: event.login,
        peanutToken: event.peanutToken,
      );
      emit(ProfileLoaded(accountInfo));
    } on Failure catch (failure) {
      emit(ProfileError(failure.message));
    } catch (e) {
      emit(ProfileError('Error refreshing profile: $e'));
    }
  }
}
