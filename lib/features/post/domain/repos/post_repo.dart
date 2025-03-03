import 'package:connect/features/post/domain/entities/post.dart';

abstract class CPostRepo {
  Future<List<CPost>> fetchAllPosts();
  Future<void> createPost(CPost post);
  Future<void> deletePost(String postId);
  Future<List<CPost>> fetchPostsByUserId(String userId);
  Future<String?> uploadPostImage(String pid, dynamic file);
  Future<void> deletePostImage(String imageUrl, String? imageId);
  Future<void> toggleLikePosts(String postId, String userId);
}