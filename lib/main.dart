import 'package:abcd/FirstLoginPage.dart';
import 'package:abcd/Logic/GoogleLogin/auth/auth_provider.dart';
import 'package:abcd/UI/PostUI.dart';
import 'package:abcd/UI/selectPage.dart';
import 'package:abcd/addPostPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'beans',
      theme: ThemeData(
        fontFamily: GoogleFonts.mPlusRounded1c().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      supportedLocales: const [
        Locale('en'),  // 英語
        Locale('ja'),  // 日本語
      ],
      locale: const Locale('ja'), // アプリ全体の言語を日本語に固定する場合

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // ここまで追加

      home: _MyHomePageState(),
    );
  }
}

class _MyHomePageState extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginData = ref.watch(authStateProvider);


    return SafeArea(
      child: Scaffold(
        floatingActionButton: ref.read(authStateProvider).value != null?FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AddPostPage()),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.lightBlueAccent.shade100,
        ):null,
        backgroundColor: Colors.black,
        body: loginData.when(
          data: (user) {
            if (user != null) {
              return Center(child: SelectPage());
            } else {
              return FirstLoginPage();
            }
          },
          error: (e, _) {
            return Center(child: Text("error $e"));
          },
          loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
