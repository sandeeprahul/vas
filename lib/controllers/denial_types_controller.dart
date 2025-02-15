import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class DenialTypesController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  // final RxList<dynamic> denialTypes = [].obs; // Store API data
  final RxMap<String, dynamic> denialTypes = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value =
        await SharedPrefHelper.getLastSyncedTime('/GetDenialTypes') ?? "Never";
    // denialTypes.value =
    //     await SharedPrefHelper.getApiData('/GetDenialTypes') ?? [];

    var data = await SharedPrefHelper.getApiData('/GetDenialTypes');

    if (data == null) {
      denialTypes.value = {}; // ✅ Handle null case with empty list
    } else if (data is  Map<String, dynamic>) {
      denialTypes.value = data; // ✅ Assign List directly
    }
  }

  Future<void> syncDenialTypes(String userId) async {
    isLoading.value = true; // Start loading

    try {
      String formattedEndpoint = '/GetDenialTypes/$userId';
      var response = await apiService.getRequestForMaster(formattedEndpoint);
      print("syncDenialTypes response:");
      print(response);



      if (response != null) {
        if (response is List) {
          var firstItem = response.first;

          // ✅ Response is a List, save directly
          await SharedPrefHelper.saveLastSyncedTime('/GetDenialTypes');
          await SharedPrefHelper.saveApiData('/GetDenialTypes', firstItem);
          lastSyncedTime.value = DateTime.now().toString();
          denialTypes.value = firstItem;
        }
        else if (response is Map<String, dynamic>) {
          // ✅ Response is a Map, wrap it in a List
          await SharedPrefHelper.saveApiData('/GetDenialTypes', [response]);
          await SharedPrefHelper.saveLastSyncedTime('/GetDenialTypes');
          lastSyncedTime.value = DateTime.now().toString();
          denialTypes.value = response;
        }
        else {
          print("Error: Unexpected response format!");
        }
      }
      else {
        print("Error: API returned null!");
      }


      // if (response != null && response is List) { // ✅ Ensure it's a list
      //   await SharedPrefHelper.saveLastSyncedTime('/GetDenialTypes');
      //   await SharedPrefHelper.saveApiData('/GetDenialTypes', response);
      //
      //   lastSyncedTime.value = DateTime.now().toString();
      //   denialTypes.value = response; // ✅ Assign the list directly
      // } else {
      //   print("Error: Expected a List but got something else!");
      // }
    } catch (e) {
      print("Error syncing denial types: $e");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }
}
