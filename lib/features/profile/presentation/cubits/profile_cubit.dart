import 'package:connect/features/profile/data/firebase_profile_repo.dart';
import 'package:connect/features/profile/presentation/cubits/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CProfileCubit extends Cubit<CProfileState> {
  final CFirebaseProfileRepo profileRepo;
  CProfileCubit({required this.profileRepo}) : super(CProfileInitialState());

  // fetch profile using repo
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(CProfileLoadingState());
      final user = await profileRepo.fetchUserProfile(uid);
      if(user != null){
        emit(CProfileLoadedState(user));
      }
      else {
        emit(CProfileErrorState("User Not Found"));
      }
    } catch(e) {
        emit(CProfileErrorState(e.toString()));
    }
  }
  // update bio and or profile picture.
  Future<void> updateProfile({
    required String uid,
    String? newBio,
  }) async {
      emit(CProfileLoadingState());

      try {
        // fetch the current profile first
        final currentUser = await profileRepo.fetchUserProfile(uid);

        if(currentUser == null) {
          emit(CProfileErrorState("Failed to fetch the user details"));
          return;
        }

        // TODO:update profile picture

        // update new profile
        final updatedProfile = currentUser.copyWith(newBio: newBio ?? currentUser.bio);

        // update in the repostiory
        await profileRepo.updateProfile(updatedProfile);
        // re-fetch the updated profile
        await fetchUserProfile(uid);
      }
      catch(e) {
          emit(CProfileErrorState("Error updating the user details: $e"));
      }
  }
}