import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class GeneralSettingsController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> generalSettings = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetGeneralSettings') ?? "Never";
    generalSettings.value = await SharedPrefHelper.getApiData('/GetGeneralSettings') ?? {};
  }

  Future<void> syncGeneralSettings(String userId) async {
    isLoading.value = true;

    try {
      String formattedEndpoint = '/GetGeneralSettings/0';
      var response = await apiService.postRequest(formattedEndpoint, {});
      if (response != null && response is Map<String, dynamic>) {
        await SharedPrefHelper.saveLastSyncedTime(formattedEndpoint);
        await SharedPrefHelper.saveApiData(formattedEndpoint, response);
        lastSyncedTime.value = DateTime.now().toString();
        generalSettings.value = response;
      } else {
        print("Error: Expected a Map but got something else!");
      }
    } catch (e) {
      print("Error syncing general settings: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
