import 'dart:io';
import 'package:connect/features/profile/data/firebase_profile_repo.dart';
import 'package:connect/features/profile/presentation/cubits/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class CProfileCubit extends Cubit<CProfileState> {
  final CFirebaseProfileRepo profileRepo;

  CProfileCubit({required this.profileRepo}) : super(CProfileInitialState());

  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(CProfileLoadingState());
      final user = await profileRepo.fetchUserProfile(uid);
      if (user != null) {
        emit(CProfileLoadedState(user));
      } else {
        emit(CProfileErrorState("User Not Found"));
      }
    } catch (e) {
      emit(CProfileErrorState("Error fetching profile: ${e.toString()}"));
    }
  }

  Future<void> updateProfile({
    required String uid,
    String? newBio,
    File? newProfileImage,
  }) async {
    try {
      emit(CProfileLoadingState());

      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(CProfileErrorState("Failed to fetch user details"));
        return;
      }

      String updatedImageUrl = currentUser.profileImageUrl;

      if (newProfileImage != null) {
        File? compressedImage = await _convertToWebP(newProfileImage);
        if (compressedImage == null) {
          print("Image compression failed!");
          emit(CProfileErrorState("Failed to compress image"));
          return;
        }

        final uploadedImageUrl = await profileRepo.uploadProfileImage(compressedImage, uid);
        if (uploadedImageUrl != null) {
          updatedImageUrl = uploadedImageUrl;

          if (currentUser.profileImageUrl.isNotEmpty && currentUser.profileImageId != null) {
            await profileRepo.deleteProfileImage(currentUser.profileImageUrl, currentUser.profileImageId);
          }
        } else {
          emit(CProfileErrorState("Failed to upload profile image"));
          return;
        }
      }

      if (newBio == null && newProfileImage == null) {
        emit(CProfileLoadedState(currentUser));
        return;
      }

      final updatedProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: updatedImageUrl,
      );

      await profileRepo.updateProfile(updatedProfile);

      emit(CProfileLoadedState(updatedProfile));
    } catch (e) {
      emit(CProfileErrorState("Error updating profile: ${e.toString()}"));
    }
  }

  Future<File?> _convertToWebP(File imageFile) async {
    try {
      final directory = await getTemporaryDirectory();
      String targetPath = '${directory.path}/compressed.webp';

      var result = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        targetPath,
        format: CompressFormat.webp,
        quality: 80,
      );

      return result != null ? File(result.path) : null;
    } catch (e) {
      print("Compression Error: $e");
      return null;
    }
  }
}
