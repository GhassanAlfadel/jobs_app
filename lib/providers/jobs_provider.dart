import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobs_app/widgets/company_job_item.dart';
import 'package:jobs_app/widgets/job_item.dart';

class JobsProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firsStore = FirebaseFirestore.instance;

  bool isUser = true;
  List<CompanyJob> _companyjobs = [];

  List<CompanyJob> get companyjobs => _companyjobs;

  List<JobItem> _jobs = [];

  List<JobItem> get jobs => _jobs;
  Future addJob(String jobName, String jobDescription, String jobExperience,
      String jobLocation, String compabyName, String worktime) async {
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
        "joblocation": jobLocation,
        "worktime": worktime,
        "createdat": DateTime.now().toString()
      });

      await _firsStore.collection("jobs").add({
        "companyname": compabyName,
        "jobname": jobName,
        "jobdescription": jobDescription,
        "jobexperience": jobExperience,
        "joblocation": jobLocation,
        "worktime": worktime,
        "createdat": DateTime.now().toString()
      });
    } on FirebaseAuthException {}
  }

  Future deleteJob(String id) async {
    final user = _auth.currentUser;
    return await _firsStore
        .collection("companes")
        .doc(user!.uid)
        .collection("jobs")
        .doc(id)
        .delete();
  }

  Stream<List<CompanyJob>> fetchCompanyjobs() {
    final user = _auth.currentUser;

    _companyjobs = [];

    return _firsStore
        .collection("companes")
        .doc(user!.uid)
        .collection("jobs")
        .snapshots()
        .map((snapshot) {
      _companyjobs = <CompanyJob>[];
      for (var doc in snapshot.docs) {
        final job = CompanyJob.fromMap(doc.data());
        job.id = doc.id;
        _companyjobs.add(job);
      }
      return _companyjobs;
    });
  }

  Stream<List<JobItem>> fetchjobs() {
    _jobs = [];

    return _firsStore.collection("jobs").snapshots().map((snapshot) {
      _jobs = <JobItem>[];
      for (var doc in snapshot.docs) {
        final job = JobItem.fromMap(doc.data());

        _jobs.add(job);
      }

      return _jobs;
    });
  }
}
