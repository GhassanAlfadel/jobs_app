// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class UserApplication extends StatelessWidget {
  final String jobtitle;
  final String userid;
  final String companyname;
  final String location;
  final String status;
  final String rejectreson;

  const UserApplication(
      {super.key,
      required this.jobtitle,
      required this.location,
      required this.status,
      required this.rejectreson,
      required this.userid,
      required this.companyname});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "الوظيفه: $jobtitle",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "الشركه: $companyname",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "الموقع : $location",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "سبب الرفض : $rejectreson",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                )
              ],
            ),
            Text(status)
          ],
        ),
      ),
    );
  }

  static fromMap(Map<String, dynamic> map) {
    return UserApplication(
      jobtitle: map["jobtitle"] ?? "",
      location: map["location"] ?? "",
      status: map["status"] ?? "",
      rejectreson: map["rejectreson"] ?? '',
      userid: map["userid"] ?? '',
      companyname: map["companyname"] ?? '',
    );
  }
}
