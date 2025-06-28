import 'package:abcd/Logic/Message/messageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreP = Provider((ref) => FirebaseFirestore.instance);

final messageFirestore = Provider((ref) {
  final firestore = ref.read(firestoreP);

  return MessageSave(firestore);
});

class MessageSave {
  final FirebaseFirestore firestore;

  MessageSave(this.firestore);

  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> addPost(MessageModel m) async {
    await firestore.collection('message').add(m.toMap());
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await FirebaseFirestore.instance
          .collection('message')
          .doc(messageId)
          .delete();
      print('削除成功');
    } catch (e) {
      print('削除エラー: $e');
    }
  }

  Future<void> updateMyMessage(String, massageId, String text) async {
    try {
      await firestore.collection("message").doc(massageId).update({
        'text': text,
      });
    } catch (e) {
      print("error $e");
    }
  }
}
