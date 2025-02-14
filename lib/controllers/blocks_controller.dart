import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class BlocksController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  final RxList<dynamic> blocks = [].obs; // Store API data

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value =
        await SharedPrefHelper.getLastSyncedTime('/GetBlocks') ?? "Never";
    blocks.value = await SharedPrefHelper.getApiData('/GetBlocks') ?? [];
  }

  Future<void> syncBlocks(String districtId, String userId) async {
    isLoading.value = true; // Start loading

    try {
      String formattedEndpoint = '/GetBlocks/0/$userId';
      // String formattedEndpoint = '/GetBlocks/$districtId/$userId';
      var response = await apiService.getRequestForMaster(formattedEndpoint, );
      print("syncBlocks response:");
      print(response);

      if (response != null && response is List) { // ✅ Ensure it's a list
        await SharedPrefHelper.saveLastSyncedTime(formattedEndpoint);
        await SharedPrefHelper.saveApiData(formattedEndpoint, response);

        lastSyncedTime.value = DateTime.now().toString();
        blocks.value = response; // ✅ Assign the list directly
      } else {
        print("Error: Expected a List but got something else!");
      }
    } catch (e) {
      print("Error syncing blocks: $e");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }
}
