import 'package:cloud_firestore/cloud_firestore.dart';

class CComment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;

  CComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.text,
    required this.timestamp,
  });

  // comment to json
  Map<String,dynamic> toJson() {
    return {
      'id':id,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'text':text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // json to comment
  factory CComment.fromJson(Map<String, dynamic> json) {
    return CComment(
      id: json['id'], 
      postId: json['postId'], 
      userId: json['userId'], 
      userName: json['userName'], 
      text: json['text'], 
      timestamp: (json['timestamp'] as Timestamp).toDate()
    );
  }
}