import 'package:flutter/material.dart';
import 'package:jobs_app/providers/auth_provider.dart';
import 'package:jobs_app/providers/jobs_provider.dart';
import 'package:jobs_app/screens/applecation_details.dart';
import 'package:jobs_app/widgets/company_job_item.dart';
import 'package:provider/provider.dart';

class CompanyJobs extends StatefulWidget {
  const CompanyJobs({super.key});

  @override
  State<CompanyJobs> createState() => _CompanyJobsState();
}

class _CompanyJobsState extends State<CompanyJobs> {
  @override
  @override
  Widget build(BuildContext context) {
    final jobsProvider = Provider.of<JobsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
              child: const Text("logout"))
        ],
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "الوضائف",
          textAlign: TextAlign.center,
        ),
      ),
      body: StreamBuilder(
          stream: jobsProvider.fetchCompanyjobs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ApplicationDetails(
                                  jobid: snapshot.data![index].id.toString(),
                                )));
                      },
                      child: CompanyJob(
                          id: snapshot.data![index].id,
                          jobName: snapshot.data![index].jobName,
                          jobDescription: snapshot.data![index].jobDescription,
                          jobExperience: snapshot.data![index].jobExperience,
                          jobLocation: snapshot.data![index].jobLocation),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: snapshot.data!.length);
            } else {
              return const Center(
                child: Text("لا يوجد وظائف"),
              );
            }
          }),
      floatingActionButton: IconButton(
        style: IconButton.styleFrom(backgroundColor: Colors.teal),
        onPressed: () {
          Navigator.of(context).pushNamed("/add_job", arguments: {
            "jobname": "",
            "jobdescription": "",
            "jobexperience": "",
            "joblocation": ""
          });
        },
        icon: const Icon(
          Icons.add,
        ),
        iconSize: 50,
      ),
    );
  }
}
