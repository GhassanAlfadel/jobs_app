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
                      jobtitle,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(companyname),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(location),
                        const SizedBox(width: 4),
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(jopexperince),
                        const SizedBox(width: 4),
                        const Icon(Icons.timer, size: 16, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(worktime),
                        const SizedBox(width: 4),
                        const Icon(Icons.access_time,
                            size: 16, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(joblistedtime.toString()),
                        const SizedBox(width: 4),
                        const Icon(Icons.access_time,
                            size: 16, color: Colors.grey),
                      ],
                    )
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
                        userData["id"].toString(),
                        userData["name"].toString(),
                        companyname,
                        jobtitle,
                        userData["location"].toString(),
                        userData["cv"].toString());
                  },
                  child: const Text("تقديم طلب")),
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
