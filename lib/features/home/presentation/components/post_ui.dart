import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect/features/post/domain/entities/post.dart';
import 'package:connect/features/post/presentation/cubits/post_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CPostUi extends StatefulWidget {
  final CPost post;
  const CPostUi({super.key, required this.post});

  @override
  State<CPostUi> createState() => _CPostUiState();
}

class _CPostUiState extends State<CPostUi> {
  late String currentUserId;
  late final CPostCubit postCubit;

  @override
  void initState() {
    super.initState();
    // Get current user's ID from Firebase Auth
    currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
    postCubit = context.read<CPostCubit>();
    postCubit.fetchAllPosts();
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
              Row(
                children: [
          SizedBox(width: 8.0,),
                  const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
          SizedBox(width: 5.0,),
              Text(widget.post.userName),
                ],
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
            padding:  EdgeInsets.all(20.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: toggleLikePost,
                  child: Icon(
                    widget.post.likes.contains(currentUserId)?Icons.favorite:Icons.favorite_border,
                    color:widget.post.likes.contains(currentUserId)? Colors.red: Colors.black)
                  ),
                Text(widget.post.likes.length.toString()),
            
                 SizedBox(width:20),
                Icon(Icons.comment),
                Text("0")
              ],
            ),
          )
        ],
      ),
    );
  }
}