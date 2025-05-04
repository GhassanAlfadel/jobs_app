import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firsStore = FirebaseFirestore.instance;
  bool logedin = false;

  bool isUser = false;
  bool isCompany = false;

  Future addUser(String name, String location, String phoneNumber) async {
    final user = FirebaseAuth.instance.currentUser;
    if (isUser) {
      await _firsStore.collection("users").doc(user!.uid).set(
          {"name": name, "location": location, "phonenumber": phoneNumber});
    } else {
      await _firsStore.collection("companes").doc(user!.uid).set(
          {"name": name, "location": location, "phonenumber": phoneNumber});
    }
  }

  Future signupuser(String email, password, String name, String location,
      String phoneNumber) async {
    final pref = await SharedPreferences.getInstance();
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      pref.setBool("logedin", true);
      if (isUser) {
        pref.setBool("isuser", true);
      } else {
        pref.setBool("iscompany", true);
      }
      logedin = true;
      notifyListeners();

      // addUser(name, location, phoneNumber);
    } on FirebaseAuthException {}
  }

  Future login(String email, password, BuildContext context) async {
    logedin = true;
    isUser = true;
    notifyListeners();

    final pref = await SharedPreferences.getInstance();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      pref.setBool("logedin", true);
      if (isUser) {
        await pref.setBool("isuser", true);
      } else if (isCompany) {
        await pref.setBool("iscompany", true);
      }
      notifyListeners();

      print(logedin);
    } on FirebaseAuthException {
      logedin = false;
    }
  }

  Future<bool> autologin() async {
    final pref = await SharedPreferences.getInstance();
    final bool authStatus = pref.containsKey("logedin");
    final bool isuser = pref.containsKey("isuser");
    final bool iscompany = pref.containsKey("iscompany");

    if (authStatus) {
      if (isuser) {
        isUser = true;
        isCompany = false;
        logedin = true;
        notifyListeners();
      } else if (iscompany) {
        isUser = false;
        isCompany = true;
        logedin = true;
        notifyListeners();
      }

      notifyListeners();
    } else {
      logedin = false;
    }

    return logedin;
  }

  void logout() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    logedin = false;
    isCompany = false;
    isUser = false;
    notifyListeners();
  }
}
