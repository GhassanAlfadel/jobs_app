import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jobs_app/providers/auth_provider.dart';
import 'package:jobs_app/screens/auth_screen.dart';
import 'package:jobs_app/screens/jobs_applications.dart';
import 'package:jobs_app/screens/company_jobs.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (!auth.logedin) {
      return const AuthScreen();
    } else if (auth.isUser && auth.logedin) {
      return const JobsApplications();
    } else if (auth.isCompany && auth.logedin) {
      return const CompanyJobs();
    } else {
      return const AuthScreen(); // fallback
    }
  }
}
