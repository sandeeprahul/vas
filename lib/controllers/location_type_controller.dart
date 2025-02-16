import 'package:get/get.dart';
import '../services/api_service.dart';

class LocationTypeController extends GetxController {
  final ApiService apiService = ApiService();
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> locationTypes = <Map<String, dynamic>>[].obs; // Use RxList<Map>

  // Selected values for dropdowns
  final RxString selectedLocationType = 'Select LocationType'.obs;
  final RxString selectedLocationTypeId = ''.obs; // ✅ Stores districtId for submission


  @override
  void onInit() {
    super.onInit();
    getLocationTypes();
  }


  Future<void> getLocationTypes() async {
    isLoading.value = true;

    try {
      String formattedEndpoint = '/GetTripStopTypes';
      var response = await apiService.getRequestForMaster(formattedEndpoint);

      if (response != null) {
        if (response is List) {
          locationTypes.value = List<Map<String, dynamic>>.from(response); // Correct conversion


        } else if (response is Map<String, dynamic>) {
          // Wrap the Map in a List if that's your intended structure.
          locationTypes.value = [response];
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