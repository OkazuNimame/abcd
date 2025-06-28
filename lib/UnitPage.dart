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
  List<UnitModel> data = [];

  List<Post> checkedSubjectData = [];

  List<Post> allData = [];

  int? allUnit, getUnit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }

  loadData() async {
    final newData = await ref.read(unitProvider).getPostsOnce();

    final newPdata = await ref.read(postRepositoryProvider).getPostsOnce();

    final newCData = newPdata.where((e) => e.check == true).toList();

    int NallUnit = newPdata.fold(
      0,
      (sum, item) => sum + int.parse(item.unit ?? "0"),
    );
    
    int NgetUnits = newData.where((e) => e.point >= 30).fold(0, (sum,item) => sum + item.unit);
    
    

    

    setState(() {
      data = newData;
      checkedSubjectData = newCData;
      allData = newPdata;
      allUnit = NallUnit;
      getUnit = NgetUnits;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController text = TextEditingController();
    return WillPopScope(
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
                          final unitData = data.isNotEmpty ? data[index] : null;

                          bool unitCheck = unitData == null
                              ? false
                              : unitData.point != null;

                          int allUnit = allData
                              .where((e) => e.unit.isNotEmpty)
                              .fold(
                                0,
                                (sum, item) => sum + int.parse(item.unit),
                              );

                          int getUnit = checkedSubjectData.fold(
                            0,
                            (sum, item) => sum + int.parse(item.unit),
                          );

                          print(allUnit);
                          print(getUnit);

                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.4),
                              ),
                              color: Colors.lightBlue.shade50,
                            ),
                            margin: EdgeInsets.only(top: 20),
                            child: ListTile(
                              title: unitCheck
                                  ? Text(
                                      unitData.point >= 30
                                          ? "${checkedSubjectData[index].subjectName}　合格！"
                                          : "${checkedSubjectData[index].subjectName}　不合格。。",
                                      style: unitData.point >= 30
                                          ? TextStyle(
                                              color: Colors.red,
                                              fontSize: 25,
                                            )
                                          : TextStyle(
                                              color: Colors.blue,
                                              fontSize: 25,
                                            ),
                                    )
                                  : Text(checkedSubjectData[index].subjectName),

                              subtitle: unitCheck == false || unitData == null
                                  ? Text(
                                      "点数を入力してください",
                                      style: TextStyle(fontSize: 20),
                                    )
                                  : Text(
                                      "テスト${unitData.point}点",
                                      style: TextStyle(fontSize: 20),
                                    ),
                              onTap: () {
                                unitData == null
                                    ? DialogUi().showCustomInputDialog(
                                        context,
                                        text,
                                        () async {
                                          if (text.text.trim().isNotEmpty) {
                                            await ref
                                                .read(unitProvider)
                                                .addUnit(
                                                  UnitModel(
                                                    point: int.parse(text.text),
                                                    uid:
                                                        checkedSubjectData[index]
                                                            .uid,
                                                    unit: int.parse(checkedSubjectData[index].unit)
                                                  ),
                                                );

                                            final newData = await ref
                                                .read(unitProvider)
                                                .getPostsOnce();
                                            
                                                

                                            setState(() {
                                              data = newData;
                                              loadData();
                                            });
                                          } else {
                                            showTopSnackBar(
                                              Overlay.of(context),
                                              CustomSnackBar.error(
                                                message: "入力が不適切です",
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    : DialogUi().showCustomInputDialog(
                                        context,
                                        text,
                                        () async {
                                          if (text.text.trim().isNotEmpty) {
                                            await ref
                                                .read(unitProvider)
                                                .updatePoint(
                                                  unitData.id!,
                                                  UnitModel(
                                                    point: int.parse(text.text),
                                                    uid:
                                                        checkedSubjectData[index]
                                                            .uid,
                                                    unit: int.parse(checkedSubjectData[index].unit)
                                                  ),
                                                );

                                            final newData = await ref
                                                .read(unitProvider)
                                                .getPostsOnce();

                                            setState(() {
                                              data = newData;
                                              loadData();
                                            });
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
                        "$getUnit / $allUnit",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ],
                )
              : Center(child: Text("NO DATA")),
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
