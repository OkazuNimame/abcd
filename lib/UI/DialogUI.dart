import 'package:abcd/UI/TextUI.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class DialogUi {
  dialog(BuildContext context, String title, String desc, VoidCallback v) {
    return AwesomeDialog(
      context: context,
      animType: AnimType.bottomSlide,
      dialogType: DialogType.noHeader,
      customHeader: Lottie.asset("assets/delete.json"),
      title: '$title',
      desc: '$desc',
      btnOkOnPress: () => v(),
    ).show();
  }

  void showCustomInputDialog(
    BuildContext context,
    TextEditingController text,
    VoidCallback v,
  ) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      title: '入力してね',
      body: Column(
        children: [
          Text('点数を入力してください'),
          SizedBox(height: 10),
          TextUI(
            controller: text,
            hint: "ここに入力",
            label: "テスト結果",
            textInputType: TextInputType.number,
            textInputFormatter: FilteringTextInputFormatter.digitsOnly,
          ),
        ],
      ),
      btnOkOnPress: () => v(),
      btnCancelOnPress: () {},
    ).show();
  }
}
