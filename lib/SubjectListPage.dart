import 'package:abcd/Logic/post/post_provider.dart';
import 'package:abcd/UI/DialogUI.dart';
import 'package:abcd/UI/ReportClassGrid.dart';
import 'package:abcd/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Logic/post/postModel.dart';

class SubjectListPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SubjectListPage();
  }
}

class _SubjectListPage extends ConsumerState<SubjectListPage> {
  List<Post> data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    final posts = await ref.read(postRepositoryProvider).getPostsOnce();
    setState(() {
      data = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          body: data.isNotEmpty
              ? ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    String subject = data[index].subjectName;
                    bool check = data[index].check;
                    int reports = int.parse(data[index].reports);
                    int classes = int.parse(data[index].classes);
                    int unit = int.parse(data[index].unit);

                    return Container(
                      margin: EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: 15,
                        right: 15,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.greenAccent.withOpacity(0.7),
                        ),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.greenAccent.shade100],
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: ListTile(
                          title: check == false
                              ? Text(
                                  "$subject",
                                  style: TextStyle(fontSize: 35),
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Text(
                                  "$subject 完了！",
                                  style: TextStyle(color: Colors.red,fontSize: 35),
                                  overflow: TextOverflow.ellipsis,
                                ),
                          subtitle: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              "授業数：$classes, レポート数：$reports, 単位数：$unit",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),

                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (contect) => ReportClassGrid(
                                  reports: data[index].reportChecks,
                                  classes: data[index].classChecks,
                                  id: data[index].id!,
                                ),
                              ),
                            );
                          },
                          onLongPress: () {
                            DialogUi().dialog(context, data[index].subjectName, "削除しますか？", (){
                              ref.read(postRepositoryProvider).deletePost(data[index].id!);
                              loadData();
                            });
                          },
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "NO SUBJECT DATA !",
                    style: TextStyle(fontSize: 45),
                  ),
                ),
        ),
      ),

      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (contect) => MyApp()),
        );
        return false;
      },
    );
  }
}
