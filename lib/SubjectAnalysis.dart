import 'package:abcd/Logic/post/post_provider.dart';
import 'package:abcd/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Logic/post/postModel.dart';

class SubjectAnalysis extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SubjectAnalysis();
  }
}

class _SubjectAnalysis extends ConsumerState<SubjectAnalysis> {
  List<Post> data = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    List<Post> newData = await ref.read(postRepositoryProvider).getPostsOnce();
    setState(() {
      data = newData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              data.isNotEmpty
                  ? Expanded(

                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          int classesCheck = data[index].classChecks
                              .where((e) => e["key"] == 1)
                              .length;
                          int reportsCheck = data[index].reportChecks
                              .where((e) => e["key"] == 1)
                              .length;
                          return Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Card(
                              color: data[index].check == false
                                  ? Colors.blue[100]
                                  : Colors.yellowAccent[100],
                              elevation: 10,
                              shadowColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,

                                    child: data[index].check == false
                                        ? Text(
                                            "${data[index].subjectName}",
                                            style: TextStyle(fontSize: 30),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        : Text(
                                            "${data[index].subjectName} 完了！",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 30,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                  ),

                                  Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text(
                                          "授業の残り　$classesCheck / ${data[index].classChecks.length}",
                                          style: TextStyle(fontSize: 25),overflow: TextOverflow.ellipsis,
                                        ),

                                        SizedBox(height: 5),

                                        Text(
                                          "レポートの残り $reportsCheck / ${data[index].reportChecks.length}",
                                          style: TextStyle(fontSize: 25),overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text(
                        "NO DATA",
                        style: TextStyle(fontSize: 45),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
        return false;
      },
    );
  }
}
