import 'package:connect/features/post/domain/entities/post.dart';

abstract class CPostState {}

// initial
class CPostsInitialState extends CPostState {}

// loading...
class CPostsLoadingState extends CPostState {}

// uploading
class CPostsUploadingState extends CPostState {}

// error
class CPostsErrorState extends CPostState {
  final String message;
  CPostsErrorState(this.message);
}

// loaded
class CPostsLoadedState extends CPostState {
  final List<CPost> posts;
  CPostsLoadedState(this.posts);
}
class CPostLoadedState extends CPostState {}