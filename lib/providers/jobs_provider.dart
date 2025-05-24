import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobs_app/widgets/application_item.dart';
import 'package:jobs_app/widgets/company_job_item.dart';
import 'package:jobs_app/widgets/job_item.dart';
import 'package:jobs_app/widgets/user_application.dart';
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

  List<UserApplication> _userapplications = [];

  List<UserApplication> get userapplications => _userapplications;

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
        "createdat": formatTime(DateTime.now())
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
        "createdat": formatTime(DateTime.now())
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
      return _companyjobs.reversed.toList();
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

      return _jobs.reversed.toList();
    });
  }

  Future<void> pickAndUploadPDF() async {
    final userid = _auth.currentUser!.uid;
    uploading = true;
    notifyListeners();

    try {
      final result = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: ['pdf'], withData: true);

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        final fileName = path.basename(file.path!);
        final ref =
            FirebaseStorage.instance.ref().child('pdfs//$userid// fileName');
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
      String cvlink,
      BuildContext context) async {
    final user = _auth.currentUser;

    try {
      await _firsStore.collection("applications").add({
        "jobtitle": jobtitle,
        "userid": user!.uid,
        "companyname": companyname,
        "jobid": jobid,
        "name": username,
        "location": loaction,
        "status": "تحت المراجعه",
        "rejectreson": "",
        "cv": cvlink
      });

      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: Colors.blue,
            content: const Text(
              'تم التقديم بنجاح',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'تم',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    } on FirebaseException {}
  }

  Stream<List<ApplicationItem>> getJopApplications(
    String jobid,
  ) {
    _applications = [];

    return _firsStore.collection("applications").snapshots().map((snapshot) {
      for (var item in snapshot.docs) {
        final data = item.data();
        if (data["jobid"] == jobid) {
          final ApplicationItem application = ApplicationItem.fromMap(data);
          _applications.add(application);
        }
      }
      print(_applications);
      return _applications;
    });
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

  Future filterjops(String location, String worktime) async {
    _jobs = [];
    try {
      final jobsdata = await _firsStore.collection("jobs").get();
      for (var item in jobsdata.docs) {
        final data = item.data();
        if (data["joblocation"] == location && data["worktime"] == worktime) {
          final JobItem job = JobItem.fromMap(data);
          _jobs.add(job);
        }
      }
    } catch (e) {}
    print(_jobs);
    return _jobs.reversed.toList();
  }

  Stream<List<UserApplication>> fetchuserapplications() {
    final user = _auth.currentUser;
    print(user!.uid);

    return _firsStore.collection("applications").snapshots().map((snapshot) {
      _userapplications = [];
      for (var doc in snapshot.docs) {
        final UserApplication userapplication =
            UserApplication.fromMap(doc.data());
        if (userapplication.userid == user.uid) {
          _userapplications.add(userapplication);
        }
      }

      print(_userapplications);
      return _userapplications.reversed.toList();
    });
  }

  String formatTime(DateTime time) {
    final formattedDate = DateFormat('d-MMMM-y', 'ar').format(time);

    const westernToArabicDigits = {
      '0': '٠',
      '1': '١',
      '2': '٢',
      '3': '٣',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '٧',
      '8': '٨',
      '9': '٩',
    };

    return formattedDate.split('').map((char) {
      return westernToArabicDigits[char] ?? char;
    }).join();
  }
}
