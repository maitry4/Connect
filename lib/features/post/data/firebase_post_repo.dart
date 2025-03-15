import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/features/post/data/imagekit_post_repo.dart';
import 'package:connect/features/post/domain/entities/comment.dart';
import 'package:connect/features/post/domain/entities/post.dart';
import 'package:connect/features/post/domain/repos/post_repo.dart';

class CFirebasePostRepo implements CPostRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final ImageKitPostRepo imageKitRepo = ImageKitPostRepo();

  //Store posts in a separate collection called 'posts'
  final CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(CPost post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch(e) {
      throw Exception('Error creating post: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await postsCollection.doc(postId).delete();
  }

  @override
  Future<List<CPost>> fetchAllPosts() async {
    try {
      //get all the posts most recent should be on top
      final postSnapshot = await postsCollection.orderBy('timestamp', descending:true).get();

      // convert the json data to post format for each post in the list
      final List<CPost> allPosts = postSnapshot.docs.map((doc) => CPost.fromJson(doc.data()as Map<String, dynamic>)).toList();

      return allPosts;
    } catch (e) {
      throw Exception('Error Fetching Posts: $e');
    }
  }

  @override
  Future<List<CPost>> fetchPostsByUserId(String userId) async {
    try {
      //get all the posts of a specific user most recent should be on top
      final postSnapshot = await postsCollection.where('userId', isEqualTo: userId).get();

      // convert the json data to post format for each post in the list
      final List<CPost> userPosts = postSnapshot.docs.map((doc) => CPost.fromJson(doc.data()as Map<String, dynamic>)).toList();

      return userPosts;
    } catch (e) {
      throw Exception('Error Fetching User\'s Posts: $e');
    }
  }
  @override
  Future<String?> uploadPostImage(String pid, dynamic file) async {
  if (file == null) return null; // Ensure there's an image to upload
  
  try {
    final imageUrl = await imageKitRepo.uploadImage(file, pid);
    if (imageUrl == null || imageUrl['url'] == null) {
      print("Failed to upload image.");
      return null;
    }

    final imageId = await imageKitRepo.getFileId(imageUrl['url']!);
    if (imageId != null) {
      await firebaseFirestore.collection('posts').doc(pid).update({
        'imageUrl': imageUrl['url'],
        'imageId': imageId,
      });
    }
    
    return imageUrl['url'];
  } catch (e) {
    print("Post Image Upload Error: $e");
    return null;
  }
}
@override
 Future<void> deletePostImage(String imageUrl, String? imageId) async {
    try {
      if (imageId == null) {
        print("No Image ID found for deletion.");
        return;
      }
      await imageKitRepo.deleteImage(imageId);
      print("Post image deleted successfully.");
    } catch (e) {
      print("Error deleting Post image: $e");
      throw Exception("Failed to delete Post image.");
    }
  }
  
  @override
  Future<void> toggleLikePosts(String postId, String userId) async {
    try //try to like or dislike
    {
      // get the post
      final postDoc = await postsCollection.doc(postId).get();
      // check if the post exists
      if (postDoc.exists) {
        // get the post data in json format
        final post = CPost.fromJson(postDoc.data() as Map<String, dynamic>);

        // check if user has already liked the post
        final hasLiked = post.likes.contains(userId);

        // update(like/dislike) based of the case
        if(hasLiked){
          post.likes.remove(userId);
        } else{
          post.likes.add(userId);
        }

        // update the post doc
        await postsCollection.doc(postId).update({'likes':post.likes});
      }
      // throw error if you cannot get the post
      else{
        throw Exception('Post not found');
      }
    } // throw error if unable to like or dislike
    catch (e) {
      throw Exception('Error toggling like: $e');
    }
  }

  @override
  Future<void> addComment(String postId, CComment comment) async {
    try {
      // get the post doc
      final postDoc = await postsCollection.doc(postId).get();

      if(postDoc.exists) {
        // json to object
        final post = CPost.fromJson(postDoc.data() as Map<String, dynamic>);

        // add the comment
        post.comments.add(comment);

        // update in firebase
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList()
        });
      }
      else {
        throw Exception("Post not Found");
      }
    }
    catch (e) {
      throw Exception("Error adding comment: $e");
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      // get the post doc
      final postDoc = await postsCollection.doc(postId).get();

      if(postDoc.exists) {
        // json to object
        final post = CPost.fromJson(postDoc.data() as Map<String, dynamic>);

        // add the comment
        post.comments.removeWhere((comment) => comment.id == commentId);

        // update in firebase
        await postsCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toJson()).toList()
        });
      }
      else {
        throw Exception("Post not Found");
      }
    }
    catch (e) {
      throw Exception("Error deleting comment: $e");
    }
  }

}