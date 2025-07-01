import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String subjectName;
  final String classes;
  final String reports;
  final Map<String,dynamic> unit;
  final String uid;
  final List<Map<String,dynamic>> reportChecks,classChecks;
  final String? id;
  final bool check;

  Post({
    required this.subjectName,
    required this.classes,
    required this.reports,
    required this.unit,
    required this.uid,
    required this.reportChecks,
    required this.classChecks,
    this.id,
    required this.check
  });

  factory Post.fromJson(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // dynamicなListをintのListに変換
    List<Map<String,dynamic>> reportChecks = (data['reportChecks'] as List<dynamic>).map((e) => e as Map<String,dynamic>).toList();
    List<Map<String,dynamic>> classChecks = (data['classChecks'] as List<dynamic>).map((e) => e as Map<String,dynamic>).toList();




    return Post(
      subjectName: data['subjectName'],
      classes: data['classes'],
      reports: data['reports'],
      unit: data['unit'],
      uid: data['uid'],
      reportChecks: reportChecks,
      classChecks: classChecks,
      id: doc.id,
      check: data["check"],
    );
  }





  Map<String, dynamic> toJson()  {


    return
    {'subjectName':subjectName,
    'classes':classes,
    'reports':reports,
    'unit':unit,
    'uid':uid,
    'reportChecks':reportChecks,
    'classChecks':classChecks,
      'check':check
    };
  }


}
List<Map<String,dynamic>> toListMap(List<int> data){
  List<Map<String,dynamic>> newData = [];

  for(int i = 0; i < data.length; i ++) {
    newData.add({"key":data[i],"date":null});
  }

  return newData;
}