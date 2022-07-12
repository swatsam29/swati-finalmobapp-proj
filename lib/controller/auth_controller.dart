import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firestore_controller.dart';

class AuthController {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static Future<User?> signIn(
      {required String email, required String password}) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> createAccount({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String department,
    required String designation,
    required String manager,
    required String phone,
    required String directreport,
    required bool editmode,
    User? user,
  }) async {
    if (editmode) {
      updateAccount(
      user: user!,
      name: name,
      department: department,
      designation: designation,
      manager: manager,
      phone: phone,
      directreport: directreport,
      context: context,
      
    );
    }else{

    UserCredential user =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    updateAccount(
      user: user.user!,
      name: name,
      department: department,
      designation: designation,
      manager: manager,
      phone: phone,
      directreport: directreport,
      context: context,
      
    );
    }
  }

  static Future<void> updateAccount({
    required User user,
    required String name,
    required String department,
    required String designation,
    required String manager,
    required String phone,
    required String directreport,
    required BuildContext context,
    String ? password,
  }) async {
    _firebaseAuth.currentUser?.updateDisplayName(name);
    _firebaseAuth.currentUser?.updatePassword(password!);
    _firebaseAuth.currentUser?.updateEmail(user.email!);
    _firebaseAuth.currentUser?.updatePhotoURL(user.photoURL ??
        "https://avatars.githubusercontent.com/u/37832937?v=4");

    await FirestoreController.updateProfile(
      user: user,
      context: context,
      name: name,
      department: department,
      designation: designation,
      phone: phone,
      manager: manager,
      directreport: directreport,
    );
  }

  static Future<void> deleteAccount({
    required User user,
    required BuildContext context,
  }) async {
    await FirestoreController.deleteProfile(
      user: user,
      context: context,
    );
    _firebaseAuth.currentUser!.delete();
  }
}
