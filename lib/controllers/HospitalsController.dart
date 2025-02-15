import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class HospitalsController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  // final RxList<dynamic> hospitals = [].obs;
  final RxMap<String, dynamic> hospitals = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetHospitals') ?? "Never";
    // hospitals.value = await SharedPrefHelper.getApiData('/GetHospitals') ?? [];
    var data = await SharedPrefHelper.getApiData('/GetHospitals');

    if (data == null) {
      hospitals.value = {}; // ✅ Handle null case with empty list
    } else if (data is  Map<String, dynamic>) {
      hospitals.value = data; // ✅ Assign List directly
    }
  }

  Future<void> syncHospitals(String deptId, String zoneId, String empId, int pageSize, int pageNo) async {
    isLoading.value = true;

    try {
      String formattedEndpoint = '/GetHospitals/0/0/0/1/1';
      // String formattedEndpoint = '/GetHospitals/$deptId/$zoneId/$empId/$pageSize/$pageNo';
      var response = await apiService.getRequestForMaster(formattedEndpoint, );

      if (response != null) {
        if (response is List) {
          var firstItem = response.first;

          // ✅ Response is a List, save directly
          await SharedPrefHelper.saveLastSyncedTime('/GetHospitals');
          await SharedPrefHelper.saveApiData('/GetHospitals', firstItem);
          lastSyncedTime.value = DateTime.now().toString();
          hospitals.value = firstItem;
        }
        else if (response is Map<String, dynamic>) {
          // ✅ Response is a Map, wrap it in a List
          await SharedPrefHelper.saveApiData('/GetHospitals', [response]);
          await SharedPrefHelper.saveLastSyncedTime('/GetHospitals');
          lastSyncedTime.value = DateTime.now().toString();
          hospitals.value = response;
        }
        else {
          print("Error: Unexpected response format!");
        }
      }
      else {
        print("Error: API returned null!");
      }

      // if (response != null && response is List) {
      //   await SharedPrefHelper.saveLastSyncedTime(formattedEndpoint);
      //   await SharedPrefHelper.saveApiData(formattedEndpoint, response);
      //   lastSyncedTime.value = DateTime.now().toString();
      //   hospitals.value = response;
      // } else {
      //   print("Error: Expected a List but got something else!");
      // }
    } catch (e) {
      print("Error syncing hospitals: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
