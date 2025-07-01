import 'package:abcd/Logic/Unit/UnitModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../post/post_provider.dart';

class UnitProvider {

  final FirebaseFirestore firestore;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  UnitProvider({required this.firestore});

  Future<void> addUnit(UnitModel u,String id)async {
    await firestore.collection('unit').doc(id).set(u.toMap());
  }

  Future<void> updatePoint(String id,UnitModel u) async {
    await firestore.collection('unit').doc(id).update(u.toMap());
  }

  Future<List<UnitModel>> getPostsOnce() async {
    final snapshot = await firestore
        .collection('unit')
        .where('userId', isEqualTo: uid)
        .get(); // ← 一度だけ取得

    return snapshot.docs.map((doc) => UnitModel.fromJson(doc)).toList();
  }

}

final unitProvider = Provider((ref) {
  final firestore = ref.read(firestoreProvider);

  return UnitProvider(firestore: firestore);
});