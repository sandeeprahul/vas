import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class BlocksController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  // final RxList<dynamic> blocks = [].obs; // Store API data
  final RxMap<String, dynamic> blocks = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value =
        await SharedPrefHelper.getLastSyncedTime('/GetBlocks') ?? "Never";
    // blocks.value = await SharedPrefHelper.getApiData('/GetBlocks') ?? [];

    var data = await SharedPrefHelper.getApiData('/GetBlocks');

    if (data == null) {
      blocks.value = {}; // ✅ Handle null case with empty list
    } else if (data is  Map<String, dynamic>) {
      blocks.value = data; // ✅ Assign List directly
    }
  }

  Future<void> syncBlocks(String districtId, String userId) async {
    isLoading.value = true; // Start loading

    try {
      String formattedEndpoint = '/GetBlocks/0/$userId';
      // String formattedEndpoint = '/GetBlocks/$districtId/$userId';
      var response = await apiService.getRequestForMaster(formattedEndpoint, );
      print("syncBlocks response:");
      print(response);


      if (response != null) {
        if (response is List) {
          var firstItem = response.first;

          // ✅ Response is a List, save directly
          await SharedPrefHelper.saveLastSyncedTime('/GetBlocks');
          await SharedPrefHelper.saveApiData('/GetBlocks', firstItem);
          lastSyncedTime.value = DateTime.now().toString();
          blocks.value = firstItem;
        }
        else if (response is Map<String, dynamic>) {
          // ✅ Response is a Map, wrap it in a List
          await SharedPrefHelper.saveApiData('/GetBlocks', [response]);
          await SharedPrefHelper.saveLastSyncedTime('/GetBlocks');
          lastSyncedTime.value = DateTime.now().toString();
          blocks.value = response;
        }
        else {
          print("Error: Unexpected response format!");
        }
      }

      // if (response != null && response is List) { // ✅ Ensure it's a list
      //   await SharedPrefHelper.saveLastSyncedTime(formattedEndpoint);
      //   await SharedPrefHelper.saveApiData(formattedEndpoint, response);
      //
      //   lastSyncedTime.value = DateTime.now().toString();
      //   blocks.value = response; // ✅ Assign the list directly
      // } else {
      //   print("Error: Expected a List but got something else!");
      // }
    } catch (e) {
      print("Error syncing blocks: $e");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }
}
