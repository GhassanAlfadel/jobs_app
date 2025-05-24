import 'package:flutter/material.dart';
import 'package:jobs_app/providers/auth_provider.dart';
import 'package:jobs_app/providers/jobs_provider.dart';
import 'package:provider/provider.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

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
    final auth = Provider.of<AuthProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Overview'),
        backgroundColor: Colors.grey,
        elevation: 2,
      ),
      body: FutureBuilder(
        future: auth.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    color: Colors.blue,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.deepPurple[200],
                            child: const Icon(Icons.person),
                          ),
                          const SizedBox(height: 12),
                          Text(snapshot.data!["name"].toString(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const Divider(height: 30),
                          ListTile(
                            trailing: const Text(
                              "البريد الالكتروني",
                              style: TextStyle(color: Colors.white),
                            ),
                            title: Text(
                              snapshot.data!["email"].toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          ListTile(
                            trailing: const Text(
                              "رقم الهاتف",
                              style: TextStyle(color: Colors.white),
                            ),
                            title: Text(
                              snapshot.data!["phonenumber"].toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          GestureDetector(
                            child: const ListTile(
                              trailing: Text(
                                "سجل الوظائف",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed("/application_history");
                            },
                          ),
                          ListTile(
                            trailing: jobs.uploading
                                ? const CircularProgressIndicator()
                                : ElevatedButton.icon(
                                    icon: const Icon(Icons.upload),
                                    label: const Text('رفع السيره الذاتيه'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                    onPressed: () {
                                      jobs.pickAndUploadPDF();
                                    },
                                  ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              auth.logout(context);
                            },
                            label: const Text("تسجيل خروج"),
                            icon: const Icon(Icons.logout),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
