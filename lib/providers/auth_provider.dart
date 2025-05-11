// ignore_for_file: use_build_context_synchronously, empty_catches

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobs_app/screens/company_jobs.dart';
import 'package:jobs_app/screens/jobs_applications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firsStore = FirebaseFirestore.instance;
  bool logedin = false;

  bool isUser = false;
  bool isCompany = false;
  String userId = "";
  String companyname = "";

  Future addUser(String name, String location, String phoneNumber) async {
    final user = FirebaseAuth.instance.currentUser;
    if (isUser) {
      await _firsStore.collection("users").doc(user!.uid).set(
          {"name": name, "location": location, "phonenumber": phoneNumber});
    } else {
      companyname = name;
      notifyListeners();
      await _firsStore.collection("companes").doc(user!.uid).set(
          {"name": name, "location": location, "phonenumber": phoneNumber});
    }
  }

  Future getcompanyname() async {
    final user = FirebaseAuth.instance.currentUser;
    if (isCompany) {
      final companyData =
          await _firsStore.collection("companes").doc(user!.uid).get();

      if (companyData.data()?["name"] == null) {
        return;
      } else {
        companyname = companyData.data()!["name"];
        notifyListeners();
      }
    } else {
      return;
    }
  }

  Future checkuserrole(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    final userdata = await _firsStore
        .collection(isUser ? "companes" : "users")
        .doc(user!.uid)
        .get();
    if (userdata.exists) {
      log("not exist");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isUser ? "انت لست شركة" : "انت لست مستخدم")));
      logout();
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

        notifyListeners();
      }
      logedin = true;
      notifyListeners();

      addUser(name, location, phoneNumber);
    } on FirebaseAuthException {}
  }

  Future login(String email, password, BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    getcompanyname();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      logedin = true;
      userId = _auth.currentUser!.uid;
      notifyListeners();
      pref.setBool("logedin", true);
      if (isUser) {
        await pref.setBool("isuser", true);
      } else if (isCompany) {
        await pref.setBool("iscompany", true);
      }

      if (isUser) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const JobsApplications(),
          ),
          (Route<dynamic> route) => false,
        );
      } else if (isCompany) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const CompanyJobs()),
          (Route<dynamic> route) => false,
        );
      }
    } on FirebaseAuthException {}
  }

  Future<bool> autologin(BuildContext context) async {
    print("autologin");
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

    notifyListeners();
  }
}
