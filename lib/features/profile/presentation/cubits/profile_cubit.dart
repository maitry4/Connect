import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

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
    Uint8List? webImage,
  }) async {
    try {
      emit(CProfileLoadingState());

      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(CProfileErrorState("Failed to fetch user details"));
        return;
      }

      String updatedImageUrl = currentUser.profileImageUrl;
      dynamic compressedImage;

      if (newProfileImage != null) {
        compressedImage = await _convertToWebP(newProfileImage);
      } else if (webImage != null) {
        compressedImage = await _convertUint8ListToWebP(webImage);
      }

      if (compressedImage != null) {
        final uploadedImageUrl = await profileRepo.uploadProfileImage(uid,compressedImage);
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

  Future<Uint8List> _convertUint8ListToWebP(Uint8List uint8list) async {
  try {
    final img.Image? image = img.decodeImage(uint8list);
    if (image == null) return uint8list; // Return original if decoding fails

    final jpgData = img.encodeJpg(image, quality: 70);
    return Uint8List.fromList(jpgData); // Return compressed image
  } catch (e) {
    print("WebP Conversion Error: $e");
    return uint8list; // Return original file in case of failure
  }
}

}
