import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jobs_app/providers/auth_provider.dart';
import 'package:jobs_app/providers/jobs_provider.dart';
import 'package:jobs_app/screens/account_details.dart';
import 'package:jobs_app/screens/add_job.dart';
import 'package:jobs_app/screens/application_history.dart';
import 'package:jobs_app/screens/auth_screen.dart';
import 'package:jobs_app/screens/company_jobs.dart';
import 'package:jobs_app/screens/home_screen.dart';
import 'package:jobs_app/screens/jobs_applications.dart';
import 'package:jobs_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => JobsProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // ignore: unused_element

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            routes: {
              "/auth_screen": (context) => const AuthScreen(),
              "/application_history": (context) => const ApplicationHistory(),
              "/company_jobs": (context) => const CompanyJobs(),
              "/account_details": (context) => const UserDetailsPage(),
              "/jobs_applications": (context) => const JobsApplications(),
              "/add_job": (context) => const AddJob(),
              "/home_screen": (context) => const HomeScreen(),
            },
            home: const SplashScreen());
      },
    );
  }
}
