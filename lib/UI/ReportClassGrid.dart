import 'package:abcd/Logic/DateLogic/DateLogic.dart';
import 'package:abcd/Logic/post/post_provider.dart';
import 'package:abcd/SubjectListPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ReportClassGrid extends ConsumerStatefulWidget {
  List<Map<String, dynamic>> reports, classes;
  String id;

  ReportClassGrid({
    required this.reports,
    required this.classes,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ReportClassGrid();
  }
}

class _ReportClassGrid extends ConsumerState<ReportClassGrid> {

  List<Map<String,dynamic>> reports = [];

  List<Map<String,dynamic>> classes = [];




   DateTime? displayDate;

   @override
  void initState() {
    // TODO: implement initState
    super.initState();

    reports = widget.reports;
    classes = widget.classes;
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("授業数",style: TextStyle(fontSize: 30),overflow: TextOverflow.ellipsis,),

                SizedBox(height: 5,),

                SizedBox(
                  height: 170,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.0, // 正方形
                    ),
                    itemCount:classes.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = classes[index];
                      return GestureDetector(
                        child: data["key"] == 0
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue[100],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(child: Text("${index + 1}回目")),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue[100],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Lottie.asset("assets/check.json"),
                                    ),

                                    Text(
                                      data["date"] != null
                                          ? DateFormat("yyyy/MM/dd").format(
                                        data["date"] is Timestamp
                                            ? data["date"].toDate()
                                            : data["date"],
                                      )
                                          : "",
                                    ),
                                  ],
                                ),
                              ),

                        onTap: () async {
                          if (classes[index]["key"] == 1) {
                            setState(() {
                              classes[index]["key"] = 0;
                              classes[index]["date"] = null;
                            });
                            ref.read(selectedDateProvider.notifier).state =
                                null;
                          } else {
                            await selectDate(context, ref);
                            DateTime? selectedDate = ref.watch(selectedDateProvider);
                            if (selectedDate != null) {
                              setState(() {
                                ref.read(selectedDateProvider.notifier).state =
                                    selectedDate;
                                classes[index]["key"] = 1;
                                classes[index]["date"] = selectedDate;
                              });

                            }
                          }
                        },
                      );
                    },
                  ),
                ),

                Text("レポート数",style: TextStyle(fontSize: 30),overflow: TextOverflow.ellipsis,),

                SizedBox(height: 5,),

                SizedBox(
                  height: 170,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.0, // 正方形
                    ),
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> reportData = reports[index];
                      return GestureDetector(
                        child: reports[index]["key"] == 0
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(child: Text("${index + 1}回目")),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Lottie.asset("assets/check.json"),
                                    ),
                                    Text(
                                      reportData["date"] != null
                                          ? DateFormat("yyyy/MM/dd").format(
                                        reportData["date"] is Timestamp
                                            ? reportData["date"].toDate()
                                            : reportData["date"],
                                      )
                                          : "",
                                    ),
                                  ],
                                ),
                              ),

                        onTap: () async {
                          if (reports[index]["key"] == 1) {
                            setState(() {
                              reports[index]["key"] = 0;
                              reports[index]["date"] = null;
                            });
                            ref.read(selectedDateProvider.notifier).state =
                                null;
                          } else {
                            await selectDate(context, ref);
                            DateTime? selectedDate = ref.watch(selectedDateProvider);
                            if (selectedDate != null) {
                              setState(() {
                                ref.read(selectedDateProvider.notifier).state =
                                    selectedDate;
                                reports[index]["key"] = 1;
                                reports[index]["date"] = selectedDate;
                                print(reports[index]["date"]);
                              });
                            }
                          }
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    print(classes);
                    print(reports);

                    if(classes.every((e) => e["key"] == 1) && reports.every((e) => e["key"] == 1)) {
                      await ref
                          .read(postRepositoryProvider)
                          .updatePostC(classes, reports, widget.id,true);


                    }else {
                      await ref
                          .read(postRepositoryProvider)
                          .updatePostC(classes, reports, widget.id,false);

                    }


                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubjectListPage(),
                      ),
                    );
                  },
                  child: Lottie.asset("assets/save.json"),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SubjectListPage()),
        );
        return false;
      },
    );
  }
}
