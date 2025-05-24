// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jobs_app/providers/auth_provider.dart';
import 'package:jobs_app/screens/company_jobs.dart';
import 'package:jobs_app/screens/jobs_applications.dart';
import 'package:jobs_app/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final String word = "JOB HAVEN";
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < word.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      );
      final animation = CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      );
      _controllers.add(controller);
      _animations.add(animation);
    }

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      _controllers[i].forward();
    }

    // Wait a little after animation
    await Future.delayed(const Duration(seconds: 1));

    // Check login state and navigate
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.autologin(context);

    if (auth.logedin && auth.isUser) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const JobsApplications()),
      );
    } else if (auth.logedin && auth.isCompany) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CompanyJobs()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(word.length, (index) {
            return FadeTransition(
              opacity: _animations[index],
              child: Text(
                word[index],
                style: const TextStyle(
                  fontSize: 64,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
