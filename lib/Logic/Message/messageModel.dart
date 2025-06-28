import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String userId;
  final String text;
  final String? id;
  final String? photoURL;
  final String? userName;

  MessageModel({
    required this.userId,
    required this.text,
    this.id,
    this.photoURL,
    this.userName,
  });

  factory MessageModel.fromJson(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return MessageModel(
      userId: data["userId"],
      text: data["text"],
      id:snap.id,
      photoURL: data['photo'],
      userName: data['userName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'text': text,
      'photo': photoURL,
      'userName': userName,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
