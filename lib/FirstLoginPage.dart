import 'package:abcd/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import 'Logic/GoogleLogin/auth/auth_provider.dart';

class FirstLoginPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FirstLoginPage();
  }

}

class _FirstLoginPage extends ConsumerState<FirstLoginPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final login = ref.read(googleAuthServiceProvider);
    return Scaffold(
      body: PageView(
        controller: _controller,

        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },

        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  child: Lottie.asset("assets/welcome.json"),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),

                Text("Self Management App", style: TextStyle(fontSize: 30)),
              ],
            ),
          ),

          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  child: Lottie.asset("assets/subject.json"),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),

                Text("Let's Record!", style: TextStyle(fontSize: 30)),
              ],
            ),
          ),

          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  child: Lottie.asset("assets/go.json"),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),

                Text("Let's GO!!", style: TextStyle(fontSize: 30)),

                SizedBox(height: 20,),

                ElevatedButton(
                  onPressed: () async {
                    await login.signIn();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Lottie.asset("assets/google.json"),
                    ),
                  )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
