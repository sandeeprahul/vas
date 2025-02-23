import 'package:get/get.dart';
import 'package:vas/services/api_service.dart';

import '../utils/showDialogNoContext.dart';
import '../utils/showLoadingDialog.dart';
import '../utils/showOdodmeterDialog.dart';

class OdometerController extends GetxController {
  var odometerReading = ''.obs; // Store odometer input
  final ApiService apiService = ApiService();

  void updateOdometer(String value) {
    odometerReading.value = value;
  }



}
