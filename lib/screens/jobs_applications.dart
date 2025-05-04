import 'package:flutter/material.dart';
import 'package:jobs_app/providers/auth_provider.dart';
import 'package:jobs_app/widgets/application_item.dart';
import 'package:provider/provider.dart';

class JobsApplications extends StatelessWidget {
  const JobsApplications({super.key});

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
        title: const Align(
          alignment: Alignment.center,
          child: Text("طلبات التوظيف"),
        ),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => const ApplicationItem(
                userName: "user name",
                location: "location",
              ),
          separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
          itemCount: 5),
    );
  }
}
