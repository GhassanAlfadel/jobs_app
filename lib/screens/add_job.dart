import 'package:flutter/material.dart';

class AddJob extends StatefulWidget {
  const AddJob({super.key});

  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  final _formKey = GlobalKey<FormState>();

  final _jobnameController = TextEditingController();
  final jobdescriptionController = TextEditingController();
  final _experionsController = TextEditingController();

  String? _selectedCity;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.center,
          child: Text(
            "اضافة وظيفه",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTextField(
                    controller: _jobnameController,
                    textAlign: TextAlign.right,
                    label: "المسمى الوظيفي",
                    validator: (value) => value == null || value.isEmpty
                        ? 'الرجاء إدخال المسمى الوظيفي '
                        : null,
                  ),
                  _buildTextField(
                    controller: jobdescriptionController,
                    textAlign: TextAlign.right,
                    label: 'وصف الوظيفة',
                    validator: (value) => value == null || value.isEmpty
                        ? 'الرجاء إدخال وصف الوظيفة'
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'اختر المدينة',
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      value: _selectedCity,
                      onChanged: (value) =>
                          setState(() => _selectedCity = value),
                      validator: (value) =>
                          value == null ? 'الرجاء اختيار المدينة' : null,
                      items: const [
                        DropdownMenuItem(value: "shendi", child: Text("شندي")),
                        DropdownMenuItem(
                            value: "khartoum", child: Text("الخرطوم")),
                        DropdownMenuItem(value: "atbara", child: Text("عطبرة")),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _experionsController,
                    label: 'الخبرات المطلوبه',
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    validator: (value) => value == null || value.length < 6
                        ? 'الرجاء ادخال الخبرات المطلوبه'
                        : null,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    TextAlign textAlign = TextAlign.end,
    TextDirection textDirection = TextDirection.rtl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Directionality(
        textDirection: textDirection,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          textAlign: textAlign,
          textDirection: textDirection,
          decoration: InputDecoration(
            floatingLabelAlignment: FloatingLabelAlignment.start,
            labelText: label,
            filled: true,
            fillColor: Colors.grey.shade300,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            errorStyle:
                const TextStyle(height: 1.2, fontSize: 12, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
