import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class BlocksController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  // final RxList<dynamic> blocks = [].obs; // Store API data
  final RxMap<String, dynamic> blocks = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> blocksList = <Map<String, dynamic>>[].obs;
  // Selected values for dropdowns
  final RxString selectedBlock = 'Select Block'.obs;
  final RxString selectedBlockId = ''.obs; // ✅ Stores districtId for submission
  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
    // getBlocks();
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


  Future<void> getBlocks(String userId,String district) async {
    isLoading.value = true;

    try {
      String formattedEndpoint = '/GetBlocks/$district/$userId';
      var response = await apiService.getRequestForMaster(formattedEndpoint);

      if (response != null) {
        if (response is List) {
          blocksList.value = List<Map<String, dynamic>>.from(response); // Correct conversion


        } else if (response is Map<String, dynamic>) {
          // Wrap the Map in a List if that's your intended structure.
          blocksList.value = [response];
          // Or, if you want to store the map directly:
          // locationTypes.value = response;  // If you change the Rx type to RxMap

        } else {
          print("Error: Unexpected response format: ${response.runtimeType}"); // Print the actual type
          // Consider throwing an exception here if the format is critical.
          // throw FormatException("Unexpected response format");
        }
      } else {
        print("Error: API returned null!");
      }
    } catch (e) {
      print("Error syncing LocationTypes: $e");
    } finally {
      isLoading.value = false;
    }
  }


}
