// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class JobItem extends StatelessWidget {
  final String companyname;
  final String jobtitle;
  final String location;
  final String worktime;
  final String jopexperince;
  final String joblistedtime;

  const JobItem({
    Key? key,
    required this.companyname,
    required this.jobtitle,
    required this.location,
    required this.worktime,
    required this.jopexperince,
    required this.joblistedtime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobtitle,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(companyname),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(location),
                        SizedBox(width: 4),
                        Icon(Icons.location_on, size: 16, color: Colors.grey),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(jopexperince),
                        SizedBox(width: 4),
                        Icon(Icons.timer, size: 16, color: Colors.grey),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(worktime),
                        SizedBox(width: 4),
                        Icon(Icons.access_time, size: 16, color: Colors.grey),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(joblistedtime.toString()),
                        SizedBox(width: 4),
                        Icon(Icons.access_time, size: 16, color: Colors.grey),
                      ],
                    )
                  ],
                ),
              )
              // Company logo placeholder
            ],
          ),
        ),
      ),
    );
  }

  static fromMap(Map<String, dynamic> map) {
    return JobItem(
        companyname: map["companyname"] ?? "",
        jobtitle: map["jobname"] ?? "",
        location: map["joblocation"] ?? "",
        worktime: map["worktime"] ?? "",
        jopexperince: map["jobexperience"] ?? "",
        joblistedtime: map["createdat"] ?? "");
  }
}
