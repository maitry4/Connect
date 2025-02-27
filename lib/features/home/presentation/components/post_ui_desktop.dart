import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect/features/post/domain/entities/post.dart';
import 'package:flutter/material.dart';

class CPostUiDesktop extends StatefulWidget {
  final CPost post;
  const CPostUiDesktop({super.key, required this.post});

  @override
  State<CPostUiDesktop> createState() => _CPostUiDesktopState();
}

class _CPostUiDesktopState extends State<CPostUiDesktop> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:8.0, right:8.0),
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
              IconButton(onPressed: (){}, icon: const Icon(Icons.delete))
            ]
          ),
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(height:200),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          const Padding(
            padding:  EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(Icons.favorite_border),
                Text("0"),
            
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