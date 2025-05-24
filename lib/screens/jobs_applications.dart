import 'package:flutter/material.dart';
import 'package:jobs_app/providers/auth_provider.dart';
import 'package:jobs_app/providers/jobs_provider.dart';
import 'package:jobs_app/widgets/job_item.dart';
import 'package:provider/provider.dart';

class JobsApplications extends StatefulWidget {
  const JobsApplications({super.key});

  @override
  State<JobsApplications> createState() => _JobsApplicationsState();
}

class _JobsApplicationsState extends State<JobsApplications> {
  String? city;
  String? worktime;
  bool filtering = false;

  Widget buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                filtering = true;
              });
            },
            child: const Text("فلتره"),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                label: const Text("المدينه"),
                filled: true,
                fillColor: Colors.grey.shade300,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              value: city,
              onChanged: (value) {
                setState(() {
                  city = value;
                });
              },
              items: const [
                DropdownMenuItem(value: "شندي", child: Text("شندي")),
                DropdownMenuItem(value: "الخرطوم", child: Text("الخرطوم")),
                DropdownMenuItem(value: "عطبرة", child: Text("عطبرة")),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                label: const Text("الدوام"),
                filled: true,
                fillColor: Colors.grey.shade300,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              value: worktime,
              onChanged: (value) {
                setState(() {
                  worktime = value;
                });
              },
              items: const [
                DropdownMenuItem(value: "دوام كامل", child: Text("دوام كامل")),
                DropdownMenuItem(value: "دوام جزئي", child: Text("دوام جزئي")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobsprovider = Provider.of<JobsProvider>(context, listen: false);
    final authprovider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/account_details",
                  arguments: authprovider.getUserData());
            },
            icon: const Icon(Icons.account_circle),
          ),
        ],
        title: const Align(
          alignment: Alignment.center,
          child: Text("طلبات التوظيف"),
        ),
      ),
      body: filtering
          ? FutureBuilder(
              future: jobsprovider.filterjops(city ?? "", worktime ?? ""),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Column(
                    children: [
                      buildFilterRow(),
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            final job = snapshot.data![index];
                            return JobItem(
                              companyid: job.companyid,
                              companyname: job.companyname,
                              jobtitle: job.jobtitle,
                              location: job.location,
                              worktime: job.worktime,
                              jopexperince: job.jopexperince,
                              joblistedtime: job.joblistedtime,
                              jobid: job.jobid,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 5),
                          itemCount: snapshot.data!.length,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      buildFilterRow(),
                      const Expanded(
                        child: Center(child: Text("لا توجد وظائف")),
                      ),
                    ],
                  );
                }
              },
            )
          : StreamBuilder(
              stream: jobsprovider.fetchjobs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Column(
                    children: [
                      buildFilterRow(),
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            final job = snapshot.data![index];
                            return JobItem(
                              companyid: job.companyid,
                              companyname: job.companyname,
                              jobtitle: job.jobtitle,
                              location: job.location,
                              worktime: job.worktime,
                              jopexperince: job.jopexperince,
                              joblistedtime: job.joblistedtime,
                              jobid: job.jobid,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 5),
                          itemCount: snapshot.data!.length,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      buildFilterRow(),
                      const Expanded(
                        child: Center(child: Text("لا توجد وظائف")),
                      ),
                    ],
                  );
                }
              },
            ),
    );
  }
}
