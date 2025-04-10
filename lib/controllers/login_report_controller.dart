import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:vas/controllers/user_controller.dart';

class LoginReportController extends GetxController {
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs;
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> reportData = <Map<String, dynamic>>[].obs;

  Future<void> fetchLoginReport() async {
    UserController userController = Get.put(UserController());
    isLoading.value = true;

    final from = DateFormat("dd/MM/yyyy").format(fromDate.value);
    final to = DateFormat("dd/MM/yyyy").format(toDate.value);

    final url = Uri.parse(
      "http://49.207.44.107/mvas/SelfLoginReport?userId=${userController.userId}&deptId=${userController.deptId}&emplId=${userController.userId}&FromDate=$from&ToDate=$to&pageSize=1&pageNo=1",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        reportData.value = List<Map<String, dynamic>>.from(data['records']);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load data");
    } finally {
      isLoading.value = false;
    }
  }
}
