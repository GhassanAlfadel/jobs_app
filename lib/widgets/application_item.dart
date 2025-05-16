// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:jobs_app/providers/jobs_provider.dart';
import 'package:jobs_app/screens/pdf_view.dart';

class ApplicationItem extends StatelessWidget {
  final String userName;
  final String location;
  final String cv;
  String userid;
  String jobid;

  ApplicationItem({
    super.key,
    required this.userName,
    required this.location,
    required this.cv,
    required this.userid,
    required this.jobid,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController resonController = TextEditingController();
    final jobsprovider = Provider.of<JobsProvider>(context, listen: false);
    return Directionality(
      textDirection: TextDirection.rtl, // Ensures proper Arabic alignment
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.person, size: 30, color: Colors.teal),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          location,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PdfView(pdflink: cv)));
                      },
                      child: const Text("قراءة السيره الزاتيه"))
                ],
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        jobsprovider.updateApplicationStatus(
                            userid, jobid, "مقبول", "");
                      },
                      child: const Text("قبول")),
                  TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("الرجاء ادخال سبب الرفض"),
                                content: TextField(
                                  controller: resonController,
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("الغاء")),
                                  TextButton(
                                      onPressed: () {
                                        jobsprovider.updateApplicationStatus(
                                            userid,
                                            jobid,
                                            "رفض",
                                            resonController.text);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("ارسال"))
                                ],
                              );
                            });
                      },
                      child: const Text("رفض"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static fromMap(Map<String, dynamic> map) {
    return ApplicationItem(
      userName: map["name"] ?? "",
      location: map["location"] ?? "",
      cv: map["cv"] ?? "",
      userid: map["userid"] ?? '',
      jobid: map["jobid"] ?? '',
    );
  }
}
