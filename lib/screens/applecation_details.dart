// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jobs_app/widgets/application_item.dart';
import 'package:provider/provider.dart';

import 'package:jobs_app/providers/jobs_provider.dart';

class ApplicationDetails extends StatelessWidget {
  final String jobid;

  const ApplicationDetails({
    super.key,
    required this.jobid,
  });

  @override
  Widget build(BuildContext context) {
    final jobsprovider = Provider.of<JobsProvider>(context, listen: false);
    return Directionality(
      // Ensures Arabic RTL layout
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("طلبات التوظيف"),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: StreamBuilder(
            stream: jobsprovider.getJopApplications(
              jobid,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return ListView.separated(
                    itemBuilder: (context, index) {
                      return ApplicationItem(
                        userName: snapshot.data![index].userName,
                        location: snapshot.data![index].location,
                        cv: snapshot.data![index].cv,
                        userid: snapshot.data![index].userid,
                        jobid: snapshot.data![index].jobid,
                        status: snapshot.data![index].status,
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                    itemCount: snapshot.data!.length);
              } else {
                return const Center(
                  child: Text("لا توجد طلبات توظيف"),
                );
              }
            }),
      ),
    );
  }
}
