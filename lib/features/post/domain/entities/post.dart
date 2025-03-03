import 'package:cloud_firestore/cloud_firestore.dart';

class CPost {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final String? imageId;
  final DateTime timestamp;
  final List<String> likes;

  CPost({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.imageUrl,
    required this.imageId,
    required this.timestamp,
    required this.likes,
  });

  CPost copyWith({String? imageUrl, String? imageId}) {
    return CPost(
      id: id,
      userId: userId,
      userName: userName,
      text: text,
      imageUrl: imageUrl ?? this.imageUrl,
      imageId: imageId ?? this.imageId,
      timestamp: timestamp,
      likes: likes
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
    } ;
  }

  factory CPost.fromJson(Map<String,dynamic> json) {
    return CPost(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      text: json['text'],
      imageUrl: json['imageUrl'],
      imageId: json['imageId'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      likes: json['likes'],
    );
  }
}