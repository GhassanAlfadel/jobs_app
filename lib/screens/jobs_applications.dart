import 'package:flutter/material.dart';
import 'package:jobs_app/providers/auth_provider.dart';
import 'package:jobs_app/providers/jobs_provider.dart';
import 'package:jobs_app/widgets/application_item.dart';
import 'package:jobs_app/widgets/job_item.dart';
import 'package:provider/provider.dart';

class JobsApplications extends StatelessWidget {
  const JobsApplications({super.key});

  @override
  Widget build(BuildContext context) {
    final jobsprovider = Provider.of<JobsProvider>(context, listen: false);

    return Scaffold(
      drawer: Container(
        color: Colors.white,
        width: 200,
        height: double.maxFinite,
        child: TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/account_details");
            },
            child: const Text("account details")),
      ),
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
              child: const Text("logout"))
        ],
        title: const Align(
          alignment: Alignment.center,
          child: Text("طلبات التوظيف"),
        ),
      ),
      body: StreamBuilder(
          stream: jobsprovider.fetchjobs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return JobItem(
                      companyid: snapshot.data![index].companyid,
                      companyname: snapshot.data![index].companyname,
                      jobtitle: snapshot.data![index].jobtitle,
                      location: snapshot.data![index].location,
                      worktime: snapshot.data![index].worktime,
                      jopexperince: snapshot.data![index].jopexperince,
                      joblistedtime: snapshot.data![index].joblistedtime,
                      jobid: snapshot.data![index].jobid,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                  itemCount: snapshot.data!.length);
            } else {
              return const Center(
                child: Text("لا توجد وظائف"),
              );
            }
          }),
    );
  }
}
