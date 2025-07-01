import 'package:abcd/Logic/Unit/UnitModel.dart';
import 'package:abcd/Logic/Unit/UnitProvider.dart';
import 'package:abcd/Logic/post/postModel.dart';
import 'package:abcd/Logic/post/post_provider.dart';
import 'package:abcd/UI/DialogUI.dart';
import 'package:abcd/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UnitPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UnitPage();
  }
}

class _UnitPage extends ConsumerState<UnitPage> {
  List<Post> checkedSubjectData = [];
  List<Post> allData = [];

  int? allUnit, getUnit;
  final TextEditingController text = TextEditingController(); // ← build外で定義

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final newPdata = await ref.read(postRepositoryProvider).getPostsOnce();
    final newCData = newPdata.where((e) => e.check == true).toList();

    final passed = newCData.where((e) {
      final point = e.unit['point'];
      return point != null && point is int && point >= 30;
    }).toList();

    int NallUnit = 0;

    int NgetUnit = 0;


    for(final post in newPdata) {
      final point = post.unit['unit'];

      if(point != null && point is int) {
        NallUnit += point;
      }
    }

    for(final post in passed) {
      final unit = post.unit['unit'];

      if(unit != null && unit is int){
        NgetUnit += unit;
      }
    }




    setState(() {
      checkedSubjectData = newCData;
      allData = newPdata;
      allUnit = NallUnit;
      getUnit = NgetUnit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: checkedSubjectData.isNotEmpty
              ? Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: checkedSubjectData.length,
                  itemBuilder: (context, index) {
                    final post = checkedSubjectData[index];
                    final unit = post.unit;
                    final point = unit['point'];

                    final isSet = point != null;

                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.4),
                        ),
                        color: Colors.lightBlue.shade50,
                      ),
                      margin: EdgeInsets.only(top: 20),
                      child: ListTile(
                        title: isSet
                            ? Text(
                          point >= 30
                              ? "${post.subjectName}　合格！"
                              : "${post.subjectName}　不合格。。",
                          style: TextStyle(
                            color: point >= 30
                                ? Colors.red
                                : Colors.blue,
                            fontSize: 25,
                          ),
                        )
                            : Text(post.subjectName),
                        subtitle: isSet
                            ? Text(
                          "テスト${point}点",
                          style: TextStyle(fontSize: 20),
                        )
                            : Text(
                          "点数を入力してください",
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap: () {
                          DialogUi().showCustomInputDialog(
                            context,
                            text,
                                () async {
                              if (text.text.trim().isNotEmpty) {
                               
                                  await ref
                                      .read(postRepositoryProvider)
                                      .updatePoint({
                                    'unit':checkedSubjectData[index].unit['unit'],
                                    'point':int.parse(text.text)
                                  }, post.id!);

                                  text.clear(); // 入力をクリア
                                  await loadData(); // データを再取得
                                

                               
                              } else {
                                showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.error(
                                    message: "入力が不適切です",
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Text(
                  "取得単位：$getUnit / すべての単位：$allUnit",
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ],
          )
              : Center(child: Text("NO DATA")),
        ),
      ),
    );
  }
}
