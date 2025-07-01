import 'package:abcd/Logic/GoogleLogin/auth/auth_provider.dart';
import 'package:abcd/Logic/Unit/UnitModel.dart';
import 'package:abcd/Logic/Unit/UnitProvider.dart';
import 'package:abcd/Logic/post/postModel.dart';
import 'package:abcd/Logic/post/post_provider.dart';
import 'package:abcd/UI/TextUI.dart';
import 'package:abcd/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddPostPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddPostPage();
  }
}

class _AddPostPage extends ConsumerState<AddPostPage> {
  TextEditingController subjectName = TextEditingController();
  TextEditingController reports = TextEditingController();
  TextEditingController classes = TextEditingController();
  TextEditingController unit = TextEditingController();

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
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.brown.shade600,
          body: Stack(
            children: [
              // スクロール可能な本体フォーム
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 100),
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                      color: Color(0xFF2E5339),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextUI(
                          controller: subjectName,
                          hint: "数学1など",
                          label: "科目名",
                          textInputType: TextInputType.text,
                        ),
                        SizedBox(height: 25),
                        TextUI(
                          controller: reports,
                          hint: "12など",
                          label: "レポート数",
                          textInputType: TextInputType.number,
                          textInputFormatter: FilteringTextInputFormatter.digitsOnly,
                        ),
                        SizedBox(height: 25),
                        TextUI(
                          controller: classes,
                          hint: "3など",
                          label: "授業数",
                          textInputType: TextInputType.number,
                          textInputFormatter: FilteringTextInputFormatter.digitsOnly,
                        ),
                        SizedBox(height: 25),
                        TextUI(
                          controller: unit,
                          hint: "4など",
                          label: "単位数",
                          textInputType: TextInputType.number,
                          textInputFormatter: FilteringTextInputFormatter.digitsOnly,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Let's do our best today too!",
                          style: GoogleFonts.rockSalt(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 25),
                        ElevatedButton(
                          onPressed: () {

                            if (subjectName.text.isNotEmpty &&
                                reports.text.isNotEmpty &&
                                classes.text.isNotEmpty &&
                                unit.text.isNotEmpty) {
                              
                              
                              

                              final post = Post(
                                subjectName: subjectName.text,
                                classes: classes.text,
                                reports: reports.text,
                                unit: {'unit':int.parse(unit.text),'point':null},
                                uid:ref.read(userData)!.uid.toString(),
                                reportChecks:toListMap(List.filled(int.parse(reports.text), 0)) ,
                                classChecks: toListMap(List.filled(int.parse(classes.text), 0)),
                                check: false
                              );


                              ref.read(postRepositoryProvider).addPost(post);


                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => MyApp()));
                            } else {
                              showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.error(
                                  message:
                                  "入力漏れがあります！",
                                ),
                              );
                            }
                          },
                          child: Text("保存"),
                        ),

                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 40,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Color(0xFFD7A86E), // 木の色
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Container(
                                height: 40,
                                width: 8,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
