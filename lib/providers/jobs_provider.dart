import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jobs_app/widgets/application_item.dart';
import 'package:jobs_app/widgets/company_job_item.dart';
import 'package:jobs_app/widgets/job_item.dart';
import 'package:path/path.dart' as path;

class JobsProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firsStore = FirebaseFirestore.instance;

  bool isUser = true;
  bool uploading = false;
  String jobid = "";
  List<CompanyJob> _companyjobs = [];

  List<CompanyJob> get companyjobs => _companyjobs;

  List<JobItem> _jobs = [];

  List<JobItem> get jobs => _jobs;

  List<ApplicationItem> _applications = [];

  List<ApplicationItem> get applications => _applications;
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
      }).then((value) {
        jobid = value.id;
      });

      await _firsStore.collection("jobs").add({
        "companyid": user.uid,
        "jobid": jobid,
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
      print(jobs);
      return _jobs;
    });
  }

  // Future<void> pickAndUploadPDF() async {
  //   final user = FirebaseAuth.instance.currentUser;

  //   final result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom, allowedExtensions: ['pdf'], withData: true);
  //   uploading = true;
  //   notifyListeners();

  //   if (result != null && result.files.single.path != null) {
  //     final file = result.files.single;
  //     final fileName = path.basename(file.path!);

  //     try {
  //       final ref = FirebaseStorage.instance.ref().child('pdfs/$fileName');
  //       await ref.putData(file.bytes!).then((onValue) {
  //         uploading = false;
  //       });

  //       final url = await ref.getDownloadURL();
  //       print(url);
  //       await _firsStore.collection("users").doc(user!.uid).update({"cv": url});
  //       notifyListeners();
  //     } on FirebaseException catch (e) {
  //       log(e.code);
  //     }
  //   }
  // }

  Future<void> pickAndUploadPDF() async {
    uploading = true;
    notifyListeners();

    try {
      final result = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: ['pdf'], withData: true);

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        final fileName = path.basename(file.path!);
        final ref = FirebaseStorage.instance.ref().child('pdfs/$fileName');
        await ref.putData(file.bytes!);

        final url = await ref.getDownloadURL();
        final user = FirebaseAuth.instance.currentUser;
        await _firsStore.collection("users").doc(user!.uid).update({"cv": url});
      }
    } catch (e) {
      log("Upload error: $e");
    } finally {
      // Always reset the flag
      uploading = false;
      notifyListeners();
    }
  }

  Future jopApplication(
      String comapnyid,
      String jobid,
      String userid,
      String username,
      String companyname,
      String jobtitle,
      String loaction,
      String cvlink) async {
    final user = _auth.currentUser;

    // await _firsStore
    //     .collection("companes")
    //     .doc(comapnyid)
    //     .collection("jobs")
    //     .doc(jobid)
    //     .collection("applications")
    //     .add({
    //   "userid": userid,
    //   "name": username,
    //   "location": loaction,
    //   'cv': cvlink
    // });

    try {
      await _firsStore.collection("applications").add({
        "userid": user!.uid,
        "jobid": jobid,
        "name": username,
        "location": loaction,
        "status": "تحت المراجعه",
        "rejectreson": "",
        "cv": cvlink
      });
    } on FirebaseException catch (e) {}
  }

  Future<List<ApplicationItem>> getJopApplications(
    String jobid,
  ) async {
    _applications = [];
    try {
      final applicationData = await _firsStore.collection("applications").get();
      for (var item in applicationData.docs) {
        final data = item.data();
        if (data["jobid"] == jobid) {
          final ApplicationItem application = ApplicationItem.fromMap(data);
          _applications.add(application);
        }
      }
    } catch (e) {}

    return _applications;
  }

  Future updateApplicationStatus(
      String userId, String jobid, String status, String rejectReson) async {
    try {
      final applicationData = await _firsStore.collection("applications").get();
      for (var item in applicationData.docs) {
        final data = item.data();
        if (data["userid"] == userId && data["jobid"] == jobid) {
          if (rejectReson.isNotEmpty) {
            await _firsStore
                .collection("applications")
                .doc(item.id)
                .update({"status": status, "rejectreson": rejectReson});
            break;
          } else {
            await _firsStore
                .collection("applications")
                .doc(item.id)
                .update({"status": status});
          }
        }
      }
    } catch (e) {
      print("errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrwvwkrovqwkvl");
    }
  }
}
