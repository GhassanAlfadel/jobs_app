// ignore_for_file: use_build_context_synchronously, empty_catches

import 'dart:developer';

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
  String userId = "";
  String companyname = "";
  bool isloading = false;

  Future addUser(
      String name, String location, String phoneNumber, String email) async {
    final user = FirebaseAuth.instance.currentUser;
    if (isUser) {
      await _firsStore.collection("users").doc(user!.uid).set({
        "id": user.uid,
        "name": name,
        "email": email,
        "location": location,
        "phonenumber": phoneNumber
      });
    } else {
      companyname = name;
      notifyListeners();
      await _firsStore.collection("companies").doc(user!.uid).set(
          {"name": name, "location": location, "phonenumber": phoneNumber});
    }
  }

  Future getcompanyname() async {
    final user = FirebaseAuth.instance.currentUser;
    if (isCompany) {
      final companyData =
          await _firsStore.collection("companies").doc(user!.uid).get();

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
        .collection(isUser ? "companies" : "users")
        .doc(user!.uid)
        .get();
    if (userdata.exists) {
      logout(context);
      log("not exist");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isUser ? "انت لست مستخدم" : "انت لست شركه")));
    }
  }

  Future<void> signupuser(String email, password, String name, String location,
      String phoneNumber, BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    isloading = true;
    notifyListeners();
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      logedin = true;
      userId = _auth.currentUser!.uid;

      if (isUser) {
        isUser = true;
        await pref.setBool("isuser", true);

        addUser(name, location, phoneNumber, email);
      } else {
        isCompany = true;
        await pref.setBool("iscompany", true);
        addUser(name, location, phoneNumber, email);
      }
      await pref.setBool("logedin", true);

      await addUser(name, location, phoneNumber, email);
      isloading = false;
      notifyListeners();

      Navigator.pushReplacementNamed(
          context, isUser ? "/jobs_applications" : "/company_jobs");
    } on FirebaseAuthException catch (e) {
      isloading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("حدث خطأ ما الرجاء المحاوله مره اخرى")));
    }
  }


  Future<void> login(String email, password, BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    isloading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await checkuserrole(context);
      userId = _auth.currentUser!.uid;

      if (isUser) {
        isCompany = false;
        await pref.setBool("isuser", true);
      } else if (isCompany) {
        isUser = false;
        await pref.setBool("iscompany", true);
      }

      await pref.setBool("logedin", true);
      logedin = true;
      await getcompanyname();

      isloading = false;
      notifyListeners();

      Navigator.pushReplacementNamed(
          context, isUser ? "/jobs_applications" : "/company_jobs");
    } on FirebaseAuthException catch (e) {
      isloading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل تسجيل الدخول حاول مره اخرى")));
    }
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


  Future<void> logout(BuildContext context) async {
    logedin = false;
    isUser = false;
    isCompany = false;
    isloading = false;
    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    await _auth.signOut();
    await pref.clear();

    Navigator.pushReplacementNamed(context, "/home_screen");
  }

  Future<Map<String, String>?> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    final userData = await _firsStore.collection("users").doc(user.uid).get();
    print(userData.data());

    final data = userData.data();

    if (data == null) return null;

    // Safely cast only entries with String keys and String values
    return data.map((key, value) {
      if (value is String) {
        return MapEntry(key, value);
      } else {
        return MapEntry(key,
            value.toString());
      }
    });
  }
}
