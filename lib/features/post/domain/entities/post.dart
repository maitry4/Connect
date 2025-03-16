import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/features/post/domain/entities/comment.dart';

class CPost {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final String? imageId;
  final DateTime timestamp;
  final List<String> likes;
  final List<CComment> comments;
  final bool private;

  CPost({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.imageUrl,
    required this.imageId,
    required this.timestamp,
    required this.likes,
    required this.comments,
    required this.private,
  });

  CPost copyWith({String? imageUrl, String? imageId, List<String>? likes, List<CComment>? comments}) {
    return CPost(
      id: id,
      userId: userId,
      userName: userName,
      text: text,
      imageUrl: imageUrl ?? this.imageUrl,
      imageId: imageId ?? this.imageId,
      timestamp: timestamp,
      likes: likes ?? this.likes,
      comments: comments?? this.comments,
      private: private
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'userId':userId,
      'userName':userName,
      'text':text,
      'imageUrl':imageUrl,
      'imageId':imageId,
      'timestamp':Timestamp.fromDate(timestamp),
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'private':private
    } ;
  }

  factory CPost.fromJson(Map<String,dynamic> json) {
    final List<CComment> comments = (json['comments'] as List<dynamic>?)?.map((commentJson)=> CComment.fromJson(commentJson)).toList()??[];
    
    return CPost(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      text: json['text'],
      imageUrl: json['imageUrl'],
      imageId: json['imageId'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      likes: List<String>.from(json['likes'] ?? []),
      comments: comments,
      private: json['private'],
    );
  }
}