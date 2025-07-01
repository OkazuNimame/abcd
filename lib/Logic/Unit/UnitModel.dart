import 'package:cloud_firestore/cloud_firestore.dart';

class UnitModel {
  int point;
  String uid;
  int unit;
  String? id;

  UnitModel({required this.point,required this.uid,this.id, required this.unit});

  factory UnitModel.fromJson(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return UnitModel(point: data['point'],id: snap.id,uid: data['userId'],unit: data['unit']);

  }

  Map<String,dynamic> toMap() {

    return {
      'point':point,
      'userId':uid,
      'unit':unit,
    };
  }
}