// import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:platableapp/models/PlatableUser.dart';
import 'dart:io' show Platform;

import 'package:platableapp/services/userService.dart';

class Authentication {
  static User? getUser () {
    return FirebaseAuth.instance.currentUser;
  }

  static Future<User?> signInWithGoogle({required BuildContext context, required bool isSignUp}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    bool doesUserExist = false;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);

        user = userCredential.user;


        if (user != null) {
          final PlatableUser? platableUser = await UserService().searchUser(user.uid);
          if(platableUser == null && isSignUp) {
            final userData = PlatableUser(
                userName: user?.displayName,
                userId: user.uid,
                phoneNumber: user?.phoneNumber,
                email: user?.email,
                profileUrl: user?.photoURL
            );

            UserService().addUser(userData);
            doesUserExist = true;
          } else if(platableUser != null && !isSignUp) {
            doesUserExist = true;
          } else if (platableUser != null && isSignUp) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account already exists, Please SignIn")));
          } else if (platableUser == null && !isSignUp) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account not found, Please SignUp")));
          }
        }

        if (!doesUserExist) {
          FirebaseAuth.instance.signOut();
        }


      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here

        }
        else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }

    return doesUserExist ? user : null;
  }

  static Future<void> signOutWithGoogle() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}