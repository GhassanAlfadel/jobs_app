import 'package:flutter/material.dart';
import 'package:jobs_app/auth_gate.dart';
import 'package:jobs_app/providers/auth_provider.dart';
import 'package:jobs_app/screens/add_job.dart';
import 'package:jobs_app/screens/applecation_details.dart';
import 'package:jobs_app/screens/auth_screen.dart';
import 'package:jobs_app/screens/company_jobs.dart';
import 'package:jobs_app/screens/home_screen.dart';
import 'package:jobs_app/screens/jobs_applications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      auth.autologin();

      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  // void _checkNavigation() {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);

  //   if (authProvider.logedin) {
  //     if (authProvider.isUser) {
  //       Navigator.pushReplacementNamed(context, "/jobs_applications");
  //     } else if (authProvider.isCompany) {
  //       Navigator.pushReplacementNamed(context, "/company_jobs");
  //     }
  //   } else {
  //     Navigator.pushReplacementNamed(context, '/auth_screen');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (BuildContext context, auth, _) {
        return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            // initialRoute: "/company_jobs",
            routes: {
              "/auth_screen": (context) => const AuthScreen(),
              "/company_jobs": (context) => const CompanyJobs(),
              "/jobs_applications": (context) => const JobsApplications(),
              "/add_job": (context) => const AddJob(),
              "/application_drtails": (context) => const ApplicationDetails(
                    userName: '',
                    userLocation: '',
                    jobName: '',
                    jonName: '',
                  )
            },
            home: auth.logedin ? JobsApplications() : HomeScreen());
      },
    );
  }
}
