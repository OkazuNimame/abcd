import 'package:abcd/Logic/GoogleLogin/auth/auth_provider.dart';
import 'package:abcd/Logic/Message/messageModel.dart';
import 'package:abcd/Logic/Message/message_provider.dart';
import 'package:abcd/UI/DialogUI.dart';
import 'package:abcd/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MessagePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MessagePage();
  }
}

class _MessagePage extends ConsumerState<MessagePage> {
  TextEditingController textMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true, // ← これが重要
          body: SafeArea(
            child: Column(
              children: [
                // メッセージリスト部分
                Expanded(
                  child: StreamBuilder(
                    stream: ref
                        .read(firestoreP)
                        .collection('message')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: Text("読み込み中..."));
                      final messages = snapshot.data!.docs;

                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final data = messages[index].data();
                          final id = messages[index].id;
                          final isMe =
                              data['userId'] == ref.read(userData)!.uid;
                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? Colors.green[100]
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child:Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:isMe ? Colors.green[100]:Colors.grey,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: GestureDetector(
                                  onLongPress: () async{

                                  isMe ?  DialogUi().dialog(context, "${data['text']}を削除しますか？", "復元はできません", ()async{
                                      await ref.read(messageFirestore).deleteMessage(id);
                                    }):null;

                                  },
                                  child: Column(
                                    children: [
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(data['userName'],style: TextStyle(fontSize: 23)),
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(100),
                                                child: SizedBox(
                                                  height: 40,
                                                  width: 40,
                                                  child: Image.network(data['photo']),
                                                ),
                                              ),
                                            ],
                                          )
                                      ),

                                      SizedBox(height: 3),

                                      Align(
                                        alignment: Alignment.center,

                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(100)
                                          ),


                                          child: Text(
                                            data['text'],
                                            style: TextStyle(fontSize: 25),
                                            softWrap: true,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              )

                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // 入力欄
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textMessage,
                          decoration: InputDecoration(
                            hintText: "メッセージを入力...",
                            border: OutlineInputBorder(),
                          ),
                          maxLines: null, // 複数行OK
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async {
                          if (textMessage.text.trim().isNotEmpty) {
                            await ref
                                .read(messageFirestore)
                                .addPost(
                                  MessageModel(
                                    userId: ref.read(userData)!.uid,
                                    text: textMessage.text,
                                    photoURL: ref.read(userData)!.photoURL,
                                    userName: ref.read(userData)!.displayName
                                  ),
                                );
                            textMessage.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
