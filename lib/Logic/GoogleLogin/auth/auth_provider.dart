import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../login.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final userData = Provider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).currentUser;
});

final googleAuthServiceProvider = Provider<Login>((ref) {
  return Login();
});

// ユーザーのログイン状態を監視
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});
