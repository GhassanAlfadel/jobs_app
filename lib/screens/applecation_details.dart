import 'package:flutter/material.dart';

class ApplicationDetails extends StatelessWidget {
  final String jobName;
  final String userName;
  final String userLocation;

  const ApplicationDetails({
    super.key,
    required this.jobName,
    required this.userName,
    required this.userLocation,
    required String jonName,
  });

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
        fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey);
    const valueStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);

    return Directionality(
      // Ensures Arabic RTL layout
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تفاصيل الطلب"),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoCard(Icons.work_outline, "المسمى الوظيفي", jobName,
                  labelStyle, valueStyle),
              const SizedBox(height: 16),
              _buildInfoCard(Icons.person_outline, "مقدم الطلب", userName,
                  labelStyle, valueStyle),
              const SizedBox(height: 16),
              _buildInfoCard(Icons.location_on_outlined, "مكان الإقامة",
                  userLocation, labelStyle, valueStyle),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    IconData icon,
    String label,
    String value,
    TextStyle labelStyle,
    TextStyle valueStyle,
  ) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black38,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: labelStyle),
                const SizedBox(height: 4),
                Text(value, style: valueStyle),
              ],
            ),
            Icon(icon, size: 30, color: Colors.teal),
          ],
        ),
      ),
    );
  }
}
