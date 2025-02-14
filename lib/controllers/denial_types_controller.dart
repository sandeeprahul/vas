import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class DenialTypesController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  final RxList<dynamic> denialTypes = [].obs; // Store API data

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value =
        await SharedPrefHelper.getLastSyncedTime('/GetDenialTypes') ?? "Never";
    denialTypes.value =
        await SharedPrefHelper.getApiData('/GetDenialTypes') ?? [];
  }

  Future<void> syncDenialTypes(String userId) async {
    isLoading.value = true; // Start loading

    try {
      String formattedEndpoint = '/GetDenialTypes/$userId';
      var response = await apiService.getRequestForMaster(formattedEndpoint);
      print("syncDenialTypes response:");
      print(response);

      if (response != null && response is List) { // ✅ Ensure it's a list
        await SharedPrefHelper.saveLastSyncedTime(formattedEndpoint);
        await SharedPrefHelper.saveApiData(formattedEndpoint, response);

        lastSyncedTime.value = DateTime.now().toString();
        denialTypes.value = response; // ✅ Assign the list directly
      } else {
        print("Error: Expected a List but got something else!");
      }
    } catch (e) {
      print("Error syncing denial types: $e");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }
}
