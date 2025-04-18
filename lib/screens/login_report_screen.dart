import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/login_report_controller.dart';
import '../theme.dart';

class LoginReportScreen extends StatefulWidget {
  const LoginReportScreen({super.key});

  @override
  State<LoginReportScreen> createState() => _LoginReportScreenState();
}

class _LoginReportScreenState extends State<LoginReportScreen> {
  final controller = Get.put(LoginReportController());

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? controller.fromDate.value : controller.toDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      if (isFrom) {
        controller.fromDate.value = picked;
      } else {
        controller.toDate.value = picked;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Report Self"),backgroundColor: AppThemes.light.primaryColor,),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppThemes.light.primaryColor,
              Colors.black,
              Colors.black,
            ],
          ),
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            // Date Range Pickers
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: GestureDetector(
                        onTap: () => _selectDate(context, true),
                        child: Obx(() => Text(
                              "From: ${DateFormat('dd/MM/yyyy').format(controller.fromDate.value)}",
                              style: const TextStyle(fontSize: 16),
                            )),
                      ),
                    ),
                  ),
                  // const Icon(Icons.arrow_drop_down),
                  // const Spacer(),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: GestureDetector(
                        onTap: () => _selectDate(context, false),
                        child: Obx(() => Text(
                              "To: ${DateFormat('dd/MM/yyyy').format(controller.toDate.value)}",
                              style: const TextStyle(fontSize: 16),
                            )),
                      ),
                    ),
                  ),
                  // const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => controller.fetchLoginReport(),
                child: Text(
                  "SHOW",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ListView for Report Data
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
                }
                if (controller.reportData.isEmpty) {
                  return const Center(
                      child: Text(
                    "No data found.",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.reportData.length,
                  itemBuilder: (context, index) {
                    final row = controller.reportData[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text("Login: ${row['login_Time'] ?? ''}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Logout: ${row['logout_Time'] ?? ''}"),
                            Text("Duration: ${row['duration'] ?? ''}"),
                            Text("Sessions: ${row['sessions'].toString()}"),
                          ],
                        ),
                        leading: CircleAvatar(
                          child: Text('${row['sn']}'),
                        ),
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
