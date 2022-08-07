// Back-end authentication service that communicates with Firebase Auth and
// Cloud Firestore to register and log in users.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WaterAuth {
  static Future<User?> registerUsingEmailPassword({
    required Map<String, String> userInfo,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      // Register credentials in Firebase Auth
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: userInfo["email"]!, password: userInfo["password"]!);
      user = userCredential.user;
      await user!.updateDisplayName(
          '${userInfo["firstName"]} ${userInfo["lastName"]}');

      // Send email verification to the user
      user.sendEmailVerification();

      // Store all of the other user data in Firestore (except password)

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'firstName': userInfo["firstName"],
        'lastName': userInfo["lastName"],
        'email': userInfo["email"],
      });
    } catch (e) {
      rethrow;
    }
    return user;
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } catch (e) {
      rethrow;
    }
    return user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
