import 'package:cloud_firestore/cloud_firestore.dart';

class UnitModel {
  int point;
  String? id;
  String uid;
  int unit;

  UnitModel({required this.point,this.id,required this.uid, required this.unit});

  factory UnitModel.fromJson(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return UnitModel(point: data['point'],id: snap.id,uid: data['userId'],unit: data['unit']);

  }

  Map<String,dynamic> toMap() {

    return {
      'point':point,
      'userId':uid,
      'unit':unit
    };
  }
}