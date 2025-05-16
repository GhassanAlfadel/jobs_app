import 'package:flutter/material.dart';
import 'package:jobs_app/providers/auth_provider.dart';
import 'package:jobs_app/providers/jobs_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class UserDetailsPage extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String pdfUrl;

  const UserDetailsPage({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.pdfUrl,
  });

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  @override
  void initState() {
    final jobs = Provider.of<JobsProvider>(context, listen: false);
    jobs.uploading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final fileName = Uri.parse(pdfUrl).pathSegments.last;
    final jobs = Provider.of<JobsProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Overview'),
        backgroundColor: Colors.grey,
        elevation: 2,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.deepPurple[200],
                      child: const Icon(Icons.person),
                    ),
                    const SizedBox(height: 12),
                    const Text("ali ahmed",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const Divider(height: 30),
                    ListTile(
                      leading:
                          const Icon(Icons.email, color: Colors.deepPurple),
                      title: Text(widget.email),
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.phone, color: Colors.deepPurple),
                      title: Text(widget.phone),
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.picture_as_pdf, color: Colors.grey),
                      title: const Text("fileName"),
                      trailing: jobs.uploading
                          ? const CircularProgressIndicator()
                          : ElevatedButton.icon(
                              icon: const Icon(Icons.upload),
                              label: const Text('رفع السيره الذاتيه'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                jobs.pickAndUploadPDF();
                              },
                            ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      label: const Text("تسجيل خروج"),
                      icon: const Icon(Icons.logout),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
