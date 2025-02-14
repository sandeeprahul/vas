import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class StandardRemarksController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  final RxList<dynamic> standardRemarks = [].obs;

  @override
  void onInit() {
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
      if (response != null && response is List) {
        await SharedPrefHelper.saveLastSyncedTime(formattedEndpoint);
        await SharedPrefHelper.saveApiData(formattedEndpoint, response);
        lastSyncedTime.value = DateTime.now().toString();
        standardRemarks.value = response;
      } else {
        print("Error: Expected a List but got something else!");
      }
    } catch (e) {
      print("Error syncing standard remarks: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
