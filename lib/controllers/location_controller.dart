import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class LocationsController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> locations = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetLocations') ?? "Never";
    // hospitals.value = await SharedPrefHelper.getApiData('/GetLocations') ?? [];
    var data = await SharedPrefHelper.getApiData('/GetLocations');

    if (data == null) {
      locations.value = {}; // ✅ Handle null case with empty list
    } else if (data is  Map<String, dynamic>) {
      locations.value = data; // ✅ Assign List directly
    }
  }

  Future<void> syncLocations(String deptId, String zoneId, String empId, int pageSize, int pageNo) async {
    isLoading.value = true;

    try {
      String formattedEndpoint = '/GetLocations/0/0/$empId/1/0';
      // String formattedEndpoint = '/GetLocations/$deptId/$zoneId/$empId/$pageSize/$pageNo';
      var response = await apiService.getRequestForMaster(formattedEndpoint, );

      if (response != null) {
        if (response is List) {
          var firstItem = response.first;

          // ✅ Response is a List, save directly
          await SharedPrefHelper.saveLastSyncedTime('/GetLocations');
          await SharedPrefHelper.saveApiData('/GetLocations', firstItem);
          lastSyncedTime.value = DateTime.now().toString();
          locations.value = firstItem;
        }
        else if (response is Map<String, dynamic>) {
          // ✅ Response is a Map, wrap it in a List
          await SharedPrefHelper.saveApiData('/GetLocations', [response]);
          await SharedPrefHelper.saveLastSyncedTime('/GetLocations');
          lastSyncedTime.value = DateTime.now().toString();
          locations.value = response;
        }
        else {
          print("Error: Unexpected response format!");
        }
      }
      else {
        print("Error: API returned null!");
      }

   /*   if (response != null && response is List) {
        await SharedPrefHelper.saveLastSyncedTime(formattedEndpoint);
        await SharedPrefHelper.saveApiData(formattedEndpoint, response);
        lastSyncedTime.value = DateTime.now().toString();
        hospitals.value = response;
      } else {
        print("Error: Expected a List but got something else!");
      }*/
    } catch (e) {
      print("Error syncing Locations: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
