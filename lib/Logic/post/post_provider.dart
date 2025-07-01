import 'package:abcd/Logic/GoogleLogin/auth/auth_provider.dart';
import 'package:abcd/Logic/post/postModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final postRepositoryProvider = Provider((ref) {
  final firestore = ref.read(firestoreProvider);
  return PostRepository(firestore);
});

class PostRepository {
  final FirebaseFirestore firestore;
  PostRepository(this.firestore);

  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> addPost(Post post) async {
    await firestore.collection('posts').add(post.toJson());
  }


  Future<List<Post>> getPostsOnce() async {
    final snapshot = await firestore
        .collection('posts')
        .where('uid', isEqualTo: uid)
        .get(); // ← 一度だけ取得

    return snapshot.docs.map((doc) => Post.fromJson(doc)).toList();
  }

  Future<void> updatePost(List<Map<String,dynamic>> classChecks,List<Map<String,dynamic>> reportChecks,String id) async {
    await firestore.collection('posts').doc(id).update({
      'classChecks':classChecks,
      'reportChecks':reportChecks
    });
  }

  Future<void> updatePoint(Map<String,dynamic> data,String id) async {
    await firestore.collection('posts').doc(id).update({
      'unit':data
    });
  }

  Future<void> updatePostC(List<Map<String,dynamic>> classChecks,List<Map<String,dynamic>> reportChecks,String id,bool check) async {
    await firestore.collection('posts').doc(id).update({
      'classChecks':classChecks,
      'reportChecks':reportChecks,
      'check':check
    });
  }

  Future<void> deletePost(String id) async {
    await firestore.collection("posts").doc(id).delete();
    await firestore.collection('unit').doc(id).delete();
  }

}
