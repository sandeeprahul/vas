import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class StandardRemarksController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  // final RxList<dynamic> standardRemarks = [].obs;
  final RxMap<String, dynamic> standardRemarks = <String, dynamic>{}.obs;

  @override
  Future<void> onInit() async {
    super.onInit();

    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetStandardRemarks') ?? "Never";
    standardRemarks.value = await SharedPrefHelper.getApiData('/GetStandardRemarks') ?? [];
  }

  Future<void> syncStandardRemarks(String userId) async {
    isLoading.value = true;

    try {
      String formattedEndpoint = '/GetStandardRemarks/$userId';
      var response = await apiService.getRequestForMaster(formattedEndpoint,);

      if (response != null) {
        if (response is List) {
          var firstItem = response.first;

          // ✅ Response is a List, save directly
          await SharedPrefHelper.saveLastSyncedTime('/GetStandardRemarks');
          await SharedPrefHelper.saveApiData('/GetStandardRemarks', firstItem);
          lastSyncedTime.value = DateTime.now().toString();
          standardRemarks.value = firstItem;
        }
        else if (response is Map<String, dynamic>) {
          // ✅ Response is a Map, wrap it in a List
          await SharedPrefHelper.saveApiData('/GetStandardRemarks', [response]);
          await SharedPrefHelper.saveLastSyncedTime('/GetStandardRemarks');
          lastSyncedTime.value = DateTime.now().toString();
          standardRemarks.value = response;
        }
        else {
          print("Error: Unexpected response format!");
        }
      }

/*
      if (response != null && response is List) {
        await SharedPrefHelper.saveLastSyncedTime(formattedEndpoint);
        await SharedPrefHelper.saveApiData(formattedEndpoint, response);
        lastSyncedTime.value = DateTime.now().toString();
        standardRemarks.value = response;
      } else {
        print("Error: Expected a List but got something else!");
      }*/
    } catch (e) {
      print("Error syncing standard remarks: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
