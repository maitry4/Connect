import 'package:flutter/material.dart';

class CFollowButton extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onPressed;
  const CFollowButton({
    super.key,
    required this.isFollowing,
    required this.onPressed,
    });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      
      child: Text(
        isFollowing?"Unfollow":"Follow",
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}