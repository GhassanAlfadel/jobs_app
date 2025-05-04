import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobs_app/widgets/job_item.dart';

class JobsProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firsStore = FirebaseFirestore.instance;

  bool isUser = true;
  final List<JobItem> _jobs = [];

  List<JobItem> get job => _jobs;

  Future addJob(
    String jobName,
    String jobDescription,
    String jobExperience,
    String jobLocation,
  ) async {
    try {
      final user = _auth.currentUser;
      await _firsStore
          .collection("companes")
          .doc(user!.uid)
          .collection("jobs")
          .add({
        "jobname": jobName,
        "jobdescription": jobDescription,
        "jobexperience": jobExperience,
        "joblocation": jobLocation
      });
    } on FirebaseAuthException {}
  }

  Future fetchCompanyjobs(String userId) async {
    try {
      final user = _auth.currentUser;

      _firsStore.collection("companes").doc(user!.uid).get();
    } on FirebaseAuthException {}
  }
}
