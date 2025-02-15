import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class IncidentTypesController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> incidentTypes = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetIncidentTypes') ?? "Never";
    var data = await SharedPrefHelper.getApiData('/GetIncidentTypes');

    if (data == null) {
      incidentTypes.value = {}; // ✅ Handle null case with empty list
    } else if (data is  Map<String, dynamic>) {
      incidentTypes.value = data; // ✅ Assign List directly
    }
  }

  Future<void> syncIncidentTypes() async {
    isLoading.value = true;

    try {
      var response = await apiService.getRequestForMaster('/GetIncidentTypes');



      if (response != null) {
        if (response is List) {
          var firstItem = response.first;

          // ✅ Response is a List, save directly
          await SharedPrefHelper.saveLastSyncedTime('/GetIncidentTypes');
          await SharedPrefHelper.saveApiData('/GetIncidentTypes', firstItem);
          lastSyncedTime.value = DateTime.now().toString();
          incidentTypes.value = firstItem;
        }
        else if (response is Map<String, dynamic>) {
          // ✅ Response is a Map, wrap it in a List
          await SharedPrefHelper.saveApiData('/GetIncidentTypes', [response]);
          await SharedPrefHelper.saveLastSyncedTime('/GetIncidentTypes');
          lastSyncedTime.value = DateTime.now().toString();
          incidentTypes.value = response;
        }
        else {
          print("Error: Unexpected response format!");
        }
      }
      else {
        print("Error: API returned null!");
      }

    /*  if (response != null && response is List) {
        await SharedPrefHelper.saveLastSyncedTime('/GetIncidentTypes');
        await SharedPrefHelper.saveApiData('/GetIncidentTypes', response);
        lastSyncedTime.value = DateTime.now().toString();
        incidentTypes.value = response;
      } else {
        print("Error: Expected a List but got something else!");
      }*/
    } catch (e) {
      print("Error syncing incident types: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
