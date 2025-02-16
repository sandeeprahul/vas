import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class DistrictsController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  // final RxList<dynamic> drivers = [].obs;
  final RxMap<String, dynamic> districts = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> districtsList = <Map<String, dynamic>>[].obs;

  // Selected values for dropdowns
  final RxString selectedDistrict = 'Select District'.obs;
  final RxString selectedDistrictId = ''.obs; // ✅ Stores districtId for submission
  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetDistricts') ?? "Never";
    // drivers.value = await SharedPrefHelper.getApiData('/GetDrivers') ?? [];
    var data = await SharedPrefHelper.getApiData('/GetDistricts');

    if (data == null) {
      print('loadLastSyncedDataDistricts');

      districts.value = {}; // ✅ Handle null case with empty list
    } else if (data is  Map<String, dynamic>) {
      print('loadLastSyncedDataDistricts');
      print(' Map<String, dynamic>');

      districtsList.value = [Map<String, dynamic>.from(data)];

      districts.value = data; // ✅ Assign List directly
      print(districtsList.length);
    }
    else if (data is List) { // Check if it's a List
      print('loadLastSyncedDataDistricts');
      print(' List');
      // Convert to List<Map<String, dynamic>> and assign:
      districtsList.value = List<Map<String, dynamic>>.from(data); // Correct conversion

    }
  }

  Future<void> syncDistricts(String empId) async {
    isLoading.value = true;

    try {
      String formattedEndpoint = '/GetDistricts/$empId';
      // String formattedEndpoint = '/GetDistricts/462/5/38';
      var response = await apiService.getRequestForMaster(formattedEndpoint, );


      if (response != null) {
        if (response is List) {
          var firstItem = response.first;

          // ✅ Response is a List, save directly
          await SharedPrefHelper.saveLastSyncedTime('/GetDistricts');
          await SharedPrefHelper.saveApiData('/GetDistricts', firstItem);
          lastSyncedTime.value = DateTime.now().toString();
          districts.value = firstItem;
        }
        else if (response is Map<String, dynamic>) {
          // ✅ Response is a Map, wrap it in a List
          await SharedPrefHelper.saveApiData('/GetDistricts', [response]);

          await SharedPrefHelper.saveLastSyncedTime(formattedEndpoint);
          // await SharedPrefHelper.saveApiData('/GetDrivers/$empId/$zoneId/$blockId', response);
          lastSyncedTime.value = DateTime.now().toString();
          districts.value  = response;
        }
        else {
          print("Error: Unexpected response format!");
        }
      }



      //
      // if (response != null && response is List) {
      //   await SharedPrefHelper.saveLastSyncedTime(formattedEndpoint);
      //   await SharedPrefHelper.saveApiData(formattedEndpoint, response);
      //   lastSyncedTime.value = DateTime.now().toString();
      //   drivers.value = response;
      // } else {
      //   print("Error: Expected a List but got something else!");
      // }
    } catch (e) {
      print("Error syncing drivers: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
