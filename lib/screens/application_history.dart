import 'package:flutter/material.dart';
import 'package:jobs_app/providers/jobs_provider.dart';
import 'package:jobs_app/widgets/user_application.dart';
import 'package:provider/provider.dart';

class ApplicationHistory extends StatelessWidget {
  const ApplicationHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final jobsProvider = Provider.of<JobsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "سجل الوظائف",
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: StreamBuilder(
            stream: jobsProvider.fetchuserapplications(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return ListView.separated(
                    itemBuilder: (context, index) {
                      return UserApplication(
                        jobtitle: snapshot.data![index].jobtitle,
                        location: snapshot.data![index].location,
                        status: snapshot.data![index].status,
                        rejectreson: snapshot.data![index].rejectreson,
                        userid: snapshot.data![index].userid,
                        companyname: snapshot.data![index].companyname,
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
      ),
    );
  }
}
