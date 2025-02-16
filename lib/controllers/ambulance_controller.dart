import 'package:get/get.dart';
import 'package:vas/controllers/user_controller.dart';
import '../services/api_service.dart';

class AmbulanceController extends GetxController {
  final ApiService apiService = ApiService();
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> ambulanceList = <Map<String, dynamic>>[].obs; // Use RxList<Map>

  // Selected values for dropdowns
  final RxString selectedAmbulanceName = 'Select Ambulance'.obs;
  final RxString selectedAmbulanceId = ''.obs; // ✅ Stores districtId for submission

  final UserController userController  = Get.put(UserController()) ;

  @override
  void onInit() {
    super.onInit();
    // getLocationTypes();
  }


  Future<void> getAmbulances() async {
    // isLoading.value = true;

    try {
      String userId = userController.userId.value;
      String formattedEndpoint = '/GetVehicleListUserZoneWise/$userId';
      var response = await apiService.getRequestForMaster(formattedEndpoint);

      if (response != null && response is Map<String, dynamic>) {
        // ✅ Extract `records` list
        if (response.containsKey("vehicle_Data") && response["vehicle_Data"] is List) {
          ambulanceList.value = List<Map<String, dynamic>>.from(response["vehicle_Data"]);
        } else {
          print("Error: 'records' field missing or not a List!");
          ambulanceList.clear(); // Ensure UI updates if the response is invalid
        }
      } else {
        print("Error: Unexpected response format!");
        ambulanceList.clear();
      }
    } catch (e) {
      print("Error syncing Ambulances: $e");
    } finally {
      // isLoading.value = false;
    }
  }
}