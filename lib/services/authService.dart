import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_mobile/constant/constant.dart';
import 'package:projeto_mobile/model/userModel.dart';
import 'package:projeto_mobile/view/authScreens/loginScreen.dart';
import 'package:projeto_mobile/view/authScreens/registerScreen.dart';
import 'package:projeto_mobile/view/mainScreen.dart';
import 'package:projeto_mobile/view/authScreens/signInLogicScreen.dart';

class AuthServices {
  static Future<void> registerUserData(
      {required UserModel userData, required BuildContext context}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userData.email, password: userData.password);

      await realTimeDatabaseRef
          .child('Users/${userCredential.user!.uid}')
          .set(userData.toMap());

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInLogicScreen()),
          (route) => false);
    } catch (error) {
      print("Error: $error");
    }
  }

  static bool checkAuth() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  static Future<bool> userIsRegistered() async {
    try {
      final snapshot = await realTimeDatabaseRef
          .child('Users/${FirebaseAuth.instance.currentUser!.uid}')
          .get();

      return snapshot.exists;
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  static Future<void> checkAuthAndRegister(BuildContext context) async {
    if (checkAuth()) {
      bool userRegistered = await userIsRegistered();
      if (userRegistered) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const RegisterScreen()),
            (route) => false);
      }
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}