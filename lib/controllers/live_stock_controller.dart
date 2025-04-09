import 'package:get/get.dart';

class LivestockController extends GetxController {
  var formData = <String, dynamic>{}.obs;

  void saveFormData(Map<String, dynamic> data) {
    formData.value = data;
  }
}
