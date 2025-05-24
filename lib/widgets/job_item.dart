// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jobs_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'package:jobs_app/providers/jobs_provider.dart';

class JobItem extends StatelessWidget {
  final String companyname;
  final String jobtitle;
  final String location;
  final String worktime;
  final String jopexperince;
  final String joblistedtime;
  final String companyid;
  final String jobid;

  const JobItem({
    super.key,
    required this.companyname,
    required this.jobtitle,
    required this.location,
    required this.worktime,
    required this.jopexperince,
    required this.joblistedtime,
    required this.companyid,
    required this.jobid,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        color: Colors.blue,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      overflow: TextOverflow.clip,
                      "الوظيفة : $jobtitle",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      overflow: TextOverflow.clip,
                      "الشركة : $companyname",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      overflow: TextOverflow.clip,
                      "الموقع : $location",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      overflow: TextOverflow.clip,
                      "الخبرات المطلوبه : $jopexperince",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      overflow: TextOverflow.clip,
                      "الدوام : $worktime",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      overflow: TextOverflow.clip,
                      "تاريخ الاضافه : $joblistedtime",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              TextButton(
                  onPressed: () async {
                    final jobsprovider =
                        Provider.of<JobsProvider>(context, listen: false);
                    final authsprovider =
                        Provider.of<AuthProvider>(context, listen: false);
                    final userData = await authsprovider.getUserData();
                    jobsprovider.jopApplication(
                        companyid,
                        jobid,
                        userData!["id"].toString(),
                        userData["name"].toString(),
                        companyname,
                        jobtitle,
                        userData["location"].toString(),
                        userData["cv"].toString(),
                        context);
                  },
                  child: const Text(
                    "تقديم طلب",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
              // Company logo placeholder
            ],
          ),
        ),
      ),
    );
  }

  static fromMap(Map<String, dynamic> map) {
    return JobItem(
      companyid: map["companyid"] ?? "",
      companyname: map["companyname"] ?? "",
      jobtitle: map["jobname"] ?? "",
      location: map["joblocation"] ?? "",
      worktime: map["worktime"] ?? "",
      jopexperince: map["jobexperience"] ?? "",
      joblistedtime: map["createdat"] ?? "",
      jobid: map["jobid"] ?? "",
    );
  }
}
