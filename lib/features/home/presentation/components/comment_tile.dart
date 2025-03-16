import 'package:connect/features/post/domain/entities/comment.dart';
import 'package:connect/features/post/presentation/cubits/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CCommentTile extends StatelessWidget {
  final CComment comment;
  final String currentUserId; // Pass current user ID
  final String postId; // Post ID is needed to delete the comment

  const CCommentTile({
    super.key,
    required this.comment,
    required this.currentUserId,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Name
        Text(comment.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),

        // Comment Text
        Text(comment.text),

        // Delete Button (only visible if the current user is the author)
        if (comment.userId == currentUserId)
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              context.read<CPostCubit>().deleteComment(postId, comment.id);
            },
          ),
      ],
    );
  }
}
