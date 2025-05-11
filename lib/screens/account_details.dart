import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class UserDetailsPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // final fileName = Uri.parse(pdfUrl).pathSegments.last;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Overview'),
        backgroundColor: Colors.deepPurple,
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
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style:
                            const TextStyle(fontSize: 32, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const Divider(height: 30),
                    ListTile(
                      leading:
                          const Icon(Icons.email, color: Colors.deepPurple),
                      title: Text(email),
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.phone, color: Colors.deepPurple),
                      title: Text(phone),
                    ),
                    ListTile(
                      leading: const Icon(Icons.picture_as_pdf,
                          color: Colors.deepPurple),
                      title: Text("fileName"),
                      trailing: ElevatedButton.icon(
                        icon: const Icon(Icons.visibility),
                        label: const Text('View PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PDFViewerPage(pdfUrl: pdfUrl),
                            ),
                          );
                        },
                      ),
                    ),
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

class PDFViewerPage extends StatelessWidget {
  final String pdfUrl;

  const PDFViewerPage({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: SfPdfViewer.network(
          "https://www.fsa.usda.gov/Internet/FSA_File/tech_assist.pdf"),
    );
  }
}
