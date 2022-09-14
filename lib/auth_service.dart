
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/widgets.dart';


class auth_service with ChangeNotifier {

  Future<Future<UserCredential>> signup(String email, String password) async {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<Future<UserCredential>> login(String email, String password) async {
    return FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }
}
