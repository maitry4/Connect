import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:connect/features/home/presentation/components/comment_tile.dart';
import 'package:connect/features/post/domain/entities/comment.dart';
import 'package:connect/features/post/domain/entities/post.dart';
import 'package:connect/features/post/presentation/cubits/post_cubit.dart';
import 'package:connect/features/post/presentation/cubits/post_states.dart';
import 'package:connect/features/profile/presentation/components/bio_input_field.dart';
import 'package:connect/features/profile/presentation/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CPostUi extends StatefulWidget {
  final CPost post;
  final String profileImageUrl;
  const CPostUi({super.key, required this.post, required this.profileImageUrl});

  @override
  State<CPostUi> createState() => _CPostUiState();
}

class _CPostUiState extends State<CPostUi> {
  late String currentUserId;
  late String ccurrentUserId;
  late String currentUserName;
  late final CPostCubit postCubit;
  final commentController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Get current user's ID from Firebase Auth
    currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
    postCubit = context.read<CPostCubit>();
    
    final authCubit = context.read<CAuthCubit>();
    final user = authCubit.currentUser;
    ccurrentUserId = user?.uid ?? "";
    currentUserName = user?.name ?? "Anonymous";
  }
  void openNewCommentBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: CBioInputField(
                bioController: commentController,
                text: "Type a Comment",
              ),
              actions: [
                // cancel
                TextButton(
                    child:  Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
                    onPressed: () => Navigator.of(context).pop()),
                // save
                TextButton(
                    onPressed: () {
                      addComment();
                      Navigator.of(context).pop();
                    },
                    child:  Text("Save", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary))),
              ],
            ));
  }

  void addComment() {
    // make a comment
    final newComment = CComment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postId: widget.post.id,
        userId: currentUserId,
        userName: currentUserName,
        text: commentController.text,
        timestamp: DateTime.now());

    // add comment using cubit
    if (commentController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  void showAllCommentsDialog(List<CComment> comments) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("All Comments"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return CCommentTile(
                comment: comment,
                currentUserId: currentUserId,
                postId: widget.post.id,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }
  void toggleLikePost() {
    // get current like status:
    final isLiked = widget.post.likes.contains(currentUserId);

    // like and update UI
    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUserId); //unlike
      } else {
        widget.post.likes.add(currentUserId); //like
      }
    });

    // update like status. and revert the previos change if error occurs
    postCubit.toggleLikePost(widget.post.id, currentUserId).catchError((error) {
      setState(() {
        if (isLiked) {
          widget.post.likes.remove(currentUserId); //revert to unlike
        } else {
          widget.post.likes.add(currentUserId); //revert to like
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom:8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CProfilePage(uid: widget.post.userId, fromHome: true,currentUserId: currentUserId)),
                );
              },
                child:Row(
                children: [
                  const SizedBox(width: 8.0),
                  CircleAvatar(
                    backgroundImage: widget.profileImageUrl.isNotEmpty
                        ? CachedNetworkImageProvider(widget.profileImageUrl)
                        : null,
                    radius: 20,
                    child: widget.profileImageUrl.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(width: 5.0),
                  Text(widget.post.userName),
                ],
              ),
              ),
               if (widget.post.userId == currentUserId)
                IconButton(
                  onPressed: () {
                    context.read<CPostCubit>().deletePost(widget.post.id);
                  },
                  icon: const Icon(Icons.delete),
                ),
            ]
          ),
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.contain,
            placeholder: (context, url) => const SizedBox(height:200),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          Padding(
            padding:  const EdgeInsets.all(20.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: toggleLikePost,
                  child: Icon(
                    widget.post.likes.contains(currentUserId)?Icons.favorite:Icons.favorite_border,
                    color:widget.post.likes.contains(currentUserId)? Colors.red: Colors.black)
                  ),
                Text(widget.post.likes.length.toString()),
            
                 const SizedBox(width:20),
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: const Icon(Icons.comment)),
                Text(widget.post.comments.length.toString())
              ],
            ),
          ),
          // Caption
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Row(
              children: [
                Text(
                  widget.post.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(widget.post.text)
              ],
                       ),
           ),
          // comment section
          BlocBuilder<CPostCubit, CPostState>(builder: (context, state) {
          if (state is CPostsLoadedState) {
            final post = state.posts.firstWhere((p) => p.id == widget.post.id);
            if (post.comments.isNotEmpty) {
              int commentCount = post.comments.length;

              int showCommentCount = post.comments.length;
              if(showCommentCount >1) {
                showCommentCount = 1;
              } // Show only first 

              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: showCommentCount,
                    itemBuilder: (context, index) {
                      final comment = post.comments[index];
                       return CCommentTile(
                        comment: comment,
                        currentUserId: currentUserId,
                        postId: widget.post.id,
                      );
                    },
                  ),
                  if (commentCount > 1) 
                    TextButton(
                      onPressed: () => showAllCommentsDialog(post.comments),
                      child: Text("Read More", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
                    ),
                ],
              );
            }
          }
          return const SizedBox();
        }),
        

        ],
      ),
    );
  }
}