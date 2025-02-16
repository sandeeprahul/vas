import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class DriversController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  // final RxList<dynamic> drivers = [].obs;
  final RxMap<String, dynamic> drivers = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetDrivers') ?? "Never";
    // drivers.value = await SharedPrefHelper.getApiData('/GetDrivers') ?? [];
    var data = await SharedPrefHelper.getApiData('/GetDrivers');

    if (data == null) {
      drivers.value = {}; // ✅ Handle null case with empty list
    } else if (data is  Map<String, dynamic>) {
      drivers.value = data; // ✅ Assign List directly
    }
  }

  Future<void> syncDrivers(String empId, String zoneId, String blockId) async {
    isLoading.value = true;

    try {
      String formattedEndpoint = '/GetDrivers/462/1/0';
      // String formattedEndpoint = '/GetDrivers/$empId/$zoneId/$blockId';
      var response = await apiService.getRequestForMaster(formattedEndpoint, );


      if (response != null) {
        if (response is List) {
          var firstItem = response.first;

          // ✅ Response is a List, save directly
          await SharedPrefHelper.saveLastSyncedTime('/GetDrivers');
          await SharedPrefHelper.saveApiData('/GetDrivers', firstItem);
          lastSyncedTime.value = DateTime.now().toString();
          drivers.value = firstItem;
        }
        else if (response is Map<String, dynamic>) {
          // ✅ Response is a Map, wrap it in a List
          await SharedPrefHelper.saveApiData('/GetDrivers', [response]);

          await SharedPrefHelper.saveLastSyncedTime('/GetDrivers');
          // await SharedPrefHelper.saveApiData('/GetDrivers/$empId/$zoneId/$blockId', response);
          lastSyncedTime.value = DateTime.now().toString();
          drivers.value  = response;
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
