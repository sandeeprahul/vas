import 'package:get/get.dart';
import 'package:vas/utils/showLoadingDialog.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class DoctorsController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  // final RxList<dynamic> drivers = [].obs;
  final RxMap<String, dynamic> doctors = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetDoctors') ?? "Never";
    // drivers.value = await SharedPrefHelper.getApiData('/GetDrivers') ?? [];
    var data = await SharedPrefHelper.getApiData('/GetDoctors');

    if (data == null) {
      doctors.value = {}; // ✅ Handle null case with empty list
    } else if (data is  Map<String, dynamic>) {
      doctors.value = data; // ✅ Assign List directly
    }
  }

  Future<void> syncDoctors(String empId,String zoneId,String blockId) async {
    isLoading.value = true;
    showLoadingDialog();
    try {
      // String formattedEndpoint = '/GetDoctors/$empId/5/38';
      String formattedEndpoint = '/GetDoctors/$empId/$zoneId/$blockId';
      // http://49.207.44.107/mvas/GetDoctors/462/5/38

      var response = await apiService.getRequestForMaster(formattedEndpoint, );


      if (response != null) {
        if (response is List) {
          var firstItem = response.first;

          // ✅ Response is a List, save directly
          await SharedPrefHelper.saveLastSyncedTime('/GetDoctors');
          await SharedPrefHelper.saveApiData('/GetDoctors', firstItem);
          lastSyncedTime.value = DateTime.now().toString();
          doctors.value = firstItem;
        }
        else if (response is Map<String, dynamic>) {
          // ✅ Response is a Map, wrap it in a List
          await SharedPrefHelper.saveApiData('/GetDoctors', [response]);
          await SharedPrefHelper.saveLastSyncedTime('/GetDoctors');
          // await SharedPrefHelper.saveApiData('/GetDrivers/$empId/$zoneId/$blockId', response);
          lastSyncedTime.value = DateTime.now().toString();
          doctors.value  = response;
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
      hideLoadingDialog();

    }
  }
}
