import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class DriversController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  final RxList<dynamic> drivers = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetDrivers') ?? "Never";
    drivers.value = await SharedPrefHelper.getApiData('/GetDrivers') ?? [];
  }

  Future<void> syncDrivers(String empId, String zoneId, String blockId) async {
    isLoading.value = true;

    try {
      String formattedEndpoint = '/GetDrivers/$empId/$zoneId/$blockId';
      var response = await apiService.getRequestForMaster(formattedEndpoint, );
      if (response != null && response is List) {
        await SharedPrefHelper.saveLastSyncedTime(formattedEndpoint);
        await SharedPrefHelper.saveApiData(formattedEndpoint, response);
        lastSyncedTime.value = DateTime.now().toString();
        drivers.value = response;
      } else {
        print("Error: Expected a List but got something else!");
      }
    } catch (e) {
      print("Error syncing drivers: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
