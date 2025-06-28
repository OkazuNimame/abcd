import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Logic/GoogleLogin/auth/auth_provider.dart';

class PostUI extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.read(userData)?.displayName ?? '名前なし';
    final image = ref.read(userData)?.photoURL;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return SizedBox(
          width: width * 0.9, // 親の幅の90%
          height: height * 0.6, // 親の高さの60%
          child: Card(
            color: Colors.black38,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: image != null
                          ? Image.network(
                              image,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.no_accounts_outlined, size: 48),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        left: 20,
                        right: 20,
                      ),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                        color: Colors.white,
                      ),

                      child: Text(
                        name,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: width * 0.8,
                    height: height * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              "Hello! World",
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            SizedBox(height: 5,),

                            Container(
                              width: width * 0.8 * 0.4,
                              height: height * 0.4 * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.greenAccent.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            )
                          ],
                        )
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
