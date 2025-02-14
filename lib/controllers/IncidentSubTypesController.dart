import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class IncidentSubTypesController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  final RxList<dynamic> incidentSubTypes = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetIncidentSubTypes') ?? "Never";
    incidentSubTypes.value = await SharedPrefHelper.getApiData('/GetIncidentSubTypes') ?? [];
  }

  Future<void> syncIncidentSubTypes() async {
    isLoading.value = true;

    try {
      var response = await apiService.getRequestForMaster('/GetIncidentSubTypes');
      if (response != null && response is List) {
        await SharedPrefHelper.saveLastSyncedTime('/GetIncidentSubTypes');
        await SharedPrefHelper.saveApiData('/GetIncidentSubTypes', response);
        lastSyncedTime.value = DateTime.now().toString();
        incidentSubTypes.value = response;
      } else {
        print("Error: Expected a List but got something else!");
      }
    } catch (e) {
      print("Error syncing incident subtypes: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
