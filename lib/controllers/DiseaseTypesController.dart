import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class DiseaseTypesController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  // final RxList<dynamic> diseaseTypes = [].obs;
  final RxMap<String, dynamic> diseaseTypes = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetDiseaseTypes') ?? "Never";
    // diseaseTypes.value = await SharedPrefHelper.getApiData('/GetDiseaseTypes') ?? [];
    var data = await SharedPrefHelper.getApiData('/GetDiseaseTypes');

    if (data == null) {
      diseaseTypes.value = {}; // ✅ Handle null case with empty list
    } else if (data is  Map<String, dynamic>) {
      diseaseTypes.value = data; // ✅ Assign List directly
    }
  }

  Future<void> syncDiseaseTypes(String userId) async {
    isLoading.value = true;

    try {
      var response = await apiService.getRequestForMaster('/GetDiseaseTypes/$userId');

      if (response != null) {
        if (response is List) {
          var firstItem = response.first;

          // ✅ Response is a List, save directly
          await SharedPrefHelper.saveLastSyncedTime('/GetDiseaseTypes');
          await SharedPrefHelper.saveApiData('/GetDiseaseTypes', firstItem);
          lastSyncedTime.value = DateTime.now().toString();
          diseaseTypes.value = firstItem;
        }
        else if (response is Map<String, dynamic>) {
          // ✅ Response is a Map, wrap it in a List
          await SharedPrefHelper.saveApiData('/GetDiseaseTypes', [response]);
          await SharedPrefHelper.saveLastSyncedTime('/GetDiseaseTypes');
          lastSyncedTime.value = DateTime.now().toString();
          diseaseTypes.value = response;
        }
        else {
          print("Error: Unexpected response format!");
        }
      }
      else {
        print("Error: API returned null!");
      }



      // if (response != null && response is List) {
      //   await SharedPrefHelper.saveLastSyncedTime('/GetDiseaseTypes');
      //   await SharedPrefHelper.saveApiData('/GetDiseaseTypes', response);
      //   lastSyncedTime.value = DateTime.now().toString();
      //   diseaseTypes.value = response;
      // } else {
      //   print("Error: Expected a List but got something else!");
      // }
    } catch (e) {
      print("Error syncing disease types: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
