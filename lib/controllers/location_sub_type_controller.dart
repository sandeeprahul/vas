import 'package:get/get.dart';
import '../services/api_service.dart';

class LocationSubTypeController extends GetxController {
  final ApiService apiService = ApiService();
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> location = <Map<String, dynamic>>[].obs; // Use RxList<Map>

  // Selected values for dropdowns
  final RxString selectedLocationName = 'Select Location'.obs;
  final RxString selectedLocationId = ''.obs; // ✅ Stores districtId for submission


  @override
  void onInit() {
    super.onInit();
    // getLocationTypes();
  }


  Future<void> getLocations(String zoneId, String blockId, String userId, String locationType) async {
    isLoading.value = true;

    try {
      String formattedEndpoint = '/GetLocationsByStopType/$zoneId/$blockId/$userId/$locationType';
      var response = await apiService.getRequestForMaster(formattedEndpoint);

      if (response != null && response is Map<String, dynamic>) {
        // ✅ Extract `records` list
        if (response.containsKey("records") && response["records"] is List) {
          location.value = List<Map<String, dynamic>>.from(response["records"]);
        } else {
          print("Error: 'records' field missing or not a List!");
          location.clear(); // Ensure UI updates if the response is invalid
        }
      } else {
        print("Error: Unexpected response format!");
        location.clear();
      }
    } catch (e) {
      print("Error syncing Locations: $e");
    } finally {
      isLoading.value = false;
    }
  }
}