import 'dart:io';
import 'dart:typed_data';

import 'package:connect/features/post/data/firebase_post_repo.dart';
import 'package:connect/features/post/data/imagekit_post_repo.dart';
import 'package:connect/features/post/domain/entities/post.dart';
import 'package:connect/features/post/presentation/cubits/post_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class CPostCubit extends Cubit<CPostState> {
  final CFirebasePostRepo postRepo;
  final ImageKitPostRepo imageKitPostRepo;

  CPostCubit({
    required this.postRepo,
    required this.imageKitPostRepo,
  }) : super(CPostsInitialState());

  // create a new post
  Future<void> createPost(
    CPost post, {
    File? newPostImage,
    Uint8List? webPostImage,
  }) async {
    emit(CPostsLoadingState());
    try {
      String? imageUrl;
      String? imageId;

      if (newPostImage != null) {
        final compressedImage = await _convertToWebP(newPostImage);
        if (compressedImage != null) {
          final uploadResult =
              await imageKitPostRepo.uploadImage(compressedImage, post.id);
          imageUrl = uploadResult?["url"];
          imageId = uploadResult?["fileId"];
        }
      } else if (webPostImage != null) {
        final compressedImage = await _convertUint8ListToWebP(webPostImage);
        final uploadResult =
            await imageKitPostRepo.uploadImage(compressedImage, post.id);
        imageUrl = uploadResult?["url"];
        imageId = uploadResult?["fileId"];
      }

      final newPost = post.copyWith(imageUrl: imageUrl, imageId: imageId);
      await postRepo.createPost(newPost);
      emit(CPostLoadedState());
    } catch (e) {
      emit(CPostsErrorState(e.toString()));
    }
  }

  //delete post
  Future<void> deletePost(String postId) async {
    emit(CPostsLoadingState());
    try {
      final post = await postRepo.fetchAllPosts();
      final postToDelete = post.firstWhere((p) => p.id == postId);

      if (postToDelete.imageUrl.isNotEmpty && postToDelete.imageId != null) {
        await imageKitPostRepo.deleteImage(postToDelete.imageId!);
      }
      await postRepo.deletePost(postId);
      emit(CPostLoadedState());
    } catch (e) {
      emit(CPostsErrorState(e.toString()));
    }
  }

  //fetch all posts
  Future<void> fetchAllPosts() async {
    emit(CPostsLoadingState());
    try {
      final posts = await postRepo.fetchAllPosts();
      emit(CPostsLoadedState(posts));
    } catch (e) {
      emit(CPostsErrorState(e.toString()));
    }
  }
  // Fetch posts created by a specific user
    Future<void> fetchUserPosts(String userId) async {
      emit(CPostsLoadingState());
      try {
        final posts = await postRepo.fetchAllPosts();
        final userPosts = posts.where((post) => post.userId == userId).toList();
        emit(CPostsLoadedState(userPosts));
      } catch (e) {
        emit(CPostsErrorState(e.toString()));
      }
    }

  // mobile compression
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

  // web compression
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

  // toggle like on a post
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePosts(postId, userId);
    } catch(e){
      emit(CPostsErrorState('Falied to toggle like: $e'));
    }
  }
}
