import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class LocationsController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  final RxList<dynamic> hospitals = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetLocations') ?? "Never";
    hospitals.value = await SharedPrefHelper.getApiData('/GetLocations') ?? [];
  }

  Future<void> syncLocations(String deptId, String zoneId, String empId, int pageSize, int pageNo) async {
    isLoading.value = true;

    try {
      String formattedEndpoint = '/GetLocations/$deptId/$zoneId/$empId/$pageSize/$pageNo';
      var response = await apiService.getRequestForMaster(formattedEndpoint, );
      if (response != null && response is List) {
        await SharedPrefHelper.saveLastSyncedTime(formattedEndpoint);
        await SharedPrefHelper.saveApiData(formattedEndpoint, response);
        lastSyncedTime.value = DateTime.now().toString();
        hospitals.value = response;
      } else {
        print("Error: Expected a List but got something else!");
      }
    } catch (e) {
      print("Error syncing Locations: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
