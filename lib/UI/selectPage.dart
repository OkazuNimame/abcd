import 'package:abcd/Logic/GoogleLogin/auth/auth_provider.dart';
import 'package:abcd/MessagePage.dart';
import 'package:abcd/SubjectAnalysis.dart';
import 'package:abcd/SubjectListPage.dart';
import 'package:abcd/UI/cardUI.dart';
import 'package:abcd/UnitPage.dart';
import 'package:abcd/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.read(userData)!.displayName;
    final photoUrl = ref.read(userData)!.photoURL;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          height: height,
          width: width,

          child: Image.asset("assets/school.jpg", fit: BoxFit.cover),
        ),

        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black12,
                Colors.black26,
                Colors.black38,
                Colors.black54,
                Colors.black87,
                Colors.black,
              ],
              begin: Alignment.center,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: photoUrl != null
                            ? Image.network(photoUrl)
                            : Icon(Icons.school_outlined),
                      ),
                    ),

                    SizedBox(width: 10),

                    Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: Colors.white.withOpacity(0.9),
                      ),
                      child: Text(
                        "$name",
                        style: TextStyle(fontSize: 25),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              CardUI(
                color: Colors.blueAccent,
                height: height * 0.25,
                width: width * 0.9,
                centerText: "学習状況",
                buttomText: "＋ボタンを押して科目を登録！",

                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SubjectListPage()),
                  );
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CardUI(
                    color: Colors.orange,
                    height: height * 0.25,
                    width: width * 0.45,
                    centerText: "協力",
                    buttomText: "ユーザーたちと協力しよう！",

                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MessagePage()),
                      );
                    },
                  ),

                  SizedBox(width: 5),

                  CardUI(
                    color: Colors.green,
                    height: height * 0.25,
                    width: width * 0.45,
                    centerText: "残り",
                    buttomText: "登録科目の進捗状況を確認しよう！",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (contect) => SubjectAnalysis(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              SizedBox(height: 5),

              CardUI(
                color: Colors.amber,
                height: height * 0.28,
                width: width * 0.9,
                centerText: "結果",
                buttomText: "テストの結果を記録しよう！",

                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => UnitPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
