import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class GeneralSettingsController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> generalSettings = <String, dynamic>{}.obs;

  @override
  Future<void> onInit() async {
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
      String formattedEndpoint = '/GetGeneralSettings/$userId';
      var response = await apiService.getRequestForMaster(formattedEndpoint,);

      if (response != null) {
        if (response is List) {
          var firstItem = response.first;

          // ✅ Response is a List, save directly
          await SharedPrefHelper.saveLastSyncedTime('/GetGeneralSettings');
          await SharedPrefHelper.saveApiData('/GetGeneralSettings', firstItem);
          lastSyncedTime.value = DateTime.now().toString();
          generalSettings.value = firstItem;
        }
        else if (response is Map<String, dynamic>) {
          // ✅ Response is a Map, wrap it in a List
          await SharedPrefHelper.saveApiData('/GetGeneralSettings', [response]);
          await SharedPrefHelper.saveLastSyncedTime('/GetGeneralSettings');
          lastSyncedTime.value = DateTime.now().toString();
          generalSettings.value = response;
        }
        else {
          print("Error: Unexpected response format!");
        }
      }
      else {
        print("Error: API returned null!");
      }
   /*   if (response != null && response is Map<String, dynamic>) {
        await SharedPrefHelper.saveLastSyncedTime(formattedEndpoint);
        await SharedPrefHelper.saveApiData(formattedEndpoint, response);
        lastSyncedTime.value = DateTime.now().toString();
        generalSettings.value = response;
      } else {
        print("Error: Expected a Map but got something else!");
      }*/
    } catch (e) {
      print("Error syncing general settings: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
