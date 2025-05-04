// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class JobItem extends StatelessWidget {
  final String jobName;
  final String jobDescription;
  final String jobExperience;
  final String jobLocation;

  const JobItem({
    super.key,
    required this.jobName,
    required this.jobDescription,
    required this.jobExperience,
    required this.jobLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Arabic layout support
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Job Name and Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    jobName,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          // TODO: Delete action
                        },
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                      ),
                      IconButton(
                        onPressed: () {
                          // TODO: Edit action
                        },
                        icon:
                            const Icon(Icons.edit_outlined, color: Colors.blue),
                      ),
                    ],
                  ),
                  // Job Name
                ],
              ),
              const SizedBox(height: 12),

              // Job Description
              _buildInfoRow("الوصف الوظيفي", jobDescription),
              const SizedBox(height: 8),

              // Job Experience
              _buildInfoRow("الخبرة المطلوبة", jobExperience),
              const SizedBox(height: 8),

              // Job Location
              _buildInfoRow("مكان العمل", jobLocation),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline, size: 20, color: Colors.teal),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              text: "$label: ",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
