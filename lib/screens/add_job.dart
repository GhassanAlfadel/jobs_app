import 'package:flutter/material.dart';
import 'package:jobs_app/providers/auth_provider.dart';
import 'package:jobs_app/providers/jobs_provider.dart';
import 'package:provider/provider.dart';

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
  String? _worktime;
  bool _isInit = true;

  @override
  void initState() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    auth.getcompanyname();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      if (args != null) {
        _jobnameController.text = args["jobname"] ?? '';
        jobdescriptionController.text = args["jobdescription"] ?? '';
        _experionsController.text = args["jobexperience"] ?? '';
        if (args["joblocation"].toString().isEmpty) {
          _selectedCity = null;
        } else {
          _selectedCity = args["joblocation"];
        }
        print(args);
      }

      _isInit = false;
    }
  }

  @override
  void dispose() {
    _jobnameController.dispose();
    jobdescriptionController.dispose();
    _experionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.center,
          child: Text("اضافة وظيفه"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(
                  controller: _jobnameController,
                  label: "المسمى الوظيفي",
                  validator: (value) => value == null || value.isEmpty
                      ? 'الرجاء إدخال المسمى الوظيفي'
                      : null,
                ),
                _buildTextField(
                  controller: jobdescriptionController,
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
                      label: Text("اختر المدينه"),
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    value: _selectedCity,
                    onChanged: (value) {
                      setState(() {
                        _selectedCity = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'الرجاء اختيار المدينة' : null,
                    items: const [
                      DropdownMenuItem(value: "شندي", child: Text("شندي")),
                      DropdownMenuItem(
                          value: "الخرطوم", child: Text("الخرطوم")),
                      DropdownMenuItem(value: "عطبرة", child: Text("عطبرة")),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      label: Text("نوع الدوام"),
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    value: _worktime,
                    onChanged: (value) {
                      setState(() {
                        _worktime = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'الرجاء اختيار المدينة' : null,
                    items: const [
                      DropdownMenuItem(
                          value: "دوام كامل", child: Text("دوام كامل")),
                      DropdownMenuItem(
                          value: "دوام جزئي", child: Text("دوام جزئي")),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _experionsController,
                  label: 'الخبرات المطلوبه',
                  validator: (value) => value == null || value.length < 6
                      ? 'الرجاء ادخال الخبرات المطلوبه'
                      : null,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final jobsProvider =
                          Provider.of<JobsProvider>(context, listen: false);
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      jobsProvider.addJob(
                          _jobnameController.text.trim(),
                          jobdescriptionController.text.trim(),
                          _experionsController.text.trim(),
                          _selectedCity!,
                          authProvider.companyname,
                          _worktime!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("تمت إضافة الوظيفة")),
                      );
                      Navigator.pop(context); // optionally go back
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "اضافة وظيفة",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
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
    TextAlign textAlign = TextAlign.right,
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
          decoration: InputDecoration(
            floatingLabelAlignment: FloatingLabelAlignment.start,
            labelText: label,
            filled: true,
            fillColor: Colors.grey.shade300,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 10,
            ),
            errorStyle: const TextStyle(
              height: 1.2,
              fontSize: 12,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
