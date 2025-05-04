import 'package:flutter/material.dart';
import 'package:jobs_app/providers/auth_provider.dart';
import 'package:jobs_app/widgets/job_item.dart';
import 'package:provider/provider.dart';

class CompanyJobs extends StatelessWidget {
  const CompanyJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
              child: Text("logout"))
        ],
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "الوضائف",
          textAlign: TextAlign.center,
        ),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => const JobItem(
          jobName: "مهندس",
          jobLocation: "عطبره",
          jobDescription: 'مهندس مدني انشائي',
          jobExperience: '٤ سنوات',
        ),
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
        itemCount: 10,
      ),
    );
  }
}
