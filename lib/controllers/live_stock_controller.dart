import 'dart:io';

import 'package:get/get.dart';

class LivestockController extends GetxController {
  var formData = <String, dynamic>{}.obs;
  final approvalRemark = ''.obs;
  final registrationRemark = ''.obs;
  final base64File = ''.obs;
  final RxString fileName = ''.obs;
  var selectedFile = Rx<File?>(null);

  void saveFormData(Map<String, dynamic> data) {
    formData.clear();
    formData.value = data;
  }

  void setApprovalRemark(String value) => approvalRemark.value = value;

  void setRegistrationRemark(String value) => registrationRemark.value = value;

  void setSelectedFile(File file) => selectedFile.value = file;

  void setBase64File(String base64, String name) {
    base64File.value = base64;
    fileName.value = name;
  }


  void clearAll() {
    approvalRemark.value = '';
    registrationRemark.value = '';
    base64File.value = '';
    fileName.value = '';
    selectedFile.value = null;
    formData.clear();
  }
}
