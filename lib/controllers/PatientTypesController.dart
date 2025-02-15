import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class PatientTypesController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  // final RxList<dynamic> patientTypes = [].obs;
  final RxMap<String, dynamic> patientTypes = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetPatientTypes') ?? "Never";
    // patientTypes.value = await SharedPrefHelper.getApiData('/GetPatientTypes') ?? [];
    var data = await SharedPrefHelper.getApiData('/GetPatientTypes');

    if (data == null) {
      patientTypes.value = {}; // ✅ Handle null case with empty list
    } else if (data is  Map<String, dynamic>) {
      patientTypes.value = data; // ✅ Assign List directly
    }
  }

  Future<void> syncPatientTypes() async {
    isLoading.value = true;

    try {
      var response = await apiService.getRequestForMaster('/GetPatientTypes');


      if (response != null) {
        if (response is List) {
          var firstItem = response.first;

          // ✅ Response is a List, save directly
          await SharedPrefHelper.saveLastSyncedTime('/GetPatientTypes');
          await SharedPrefHelper.saveApiData('/GetPatientTypes', firstItem);
          lastSyncedTime.value = DateTime.now().toString();
          patientTypes.value = firstItem;
        }
        else if (response is Map<String, dynamic>) {
          // ✅ Response is a Map, wrap it in a List
          await SharedPrefHelper.saveApiData('/GetPatientTypes', [response]);
          await SharedPrefHelper.saveLastSyncedTime('/GetPatientTypes');
          lastSyncedTime.value = DateTime.now().toString();
          patientTypes.value = response;
        }
        else {
          print("Error: Unexpected response format!");
        }
      }


  /*    if (response != null && response is List) {
        await SharedPrefHelper.saveLastSyncedTime('/GetPatientTypes');
        await SharedPrefHelper.saveApiData('/GetPatientTypes', response);
        lastSyncedTime.value = DateTime.now().toString();
        patientTypes.value = response;
      } else {
        print("Error: Expected a List but got something else!");
      }*/
    } catch (e) {
      print("Error syncing patient types: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
