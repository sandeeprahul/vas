import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class IncidentSubTypesController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  // final RxList<dynamic> incidentSubTypes = [].obs;
  final RxMap<String, dynamic> incidentSubTypes = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetIncidentSubTypes') ?? "Never";
    // incidentSubTypes.value = await SharedPrefHelper.getApiData('/GetIncidentSubTypes') ?? [];
    var data = await SharedPrefHelper.getApiData('/GetIncidentSubTypes');

    if (data == null) {
      incidentSubTypes.value = {}; // ✅ Handle null case with empty list
    } else if (data is  Map<String, dynamic>) {
      incidentSubTypes.value = data; // ✅ Assign List directly
    }
  }

  Future<void> syncIncidentSubTypes() async {
    isLoading.value = true;

    try {
      var response = await apiService.getRequestForMaster('/GetIncidentSubTypes');


      if (response != null) {
        if (response is List) {
          var firstItem = response.first;

          // ✅ Response is a List, save directly
          await SharedPrefHelper.saveLastSyncedTime('/GetIncidentSubTypes');
          await SharedPrefHelper.saveApiData('/GetIncidentSubTypes', firstItem);
          lastSyncedTime.value = DateTime.now().toString();
          incidentSubTypes.value = firstItem;
        }
        else if (response is Map<String, dynamic>) {
          // ✅ Response is a Map, wrap it in a List
          await SharedPrefHelper.saveApiData('/GetIncidentSubTypes', [response]);
          await SharedPrefHelper.saveLastSyncedTime('/GetIncidentSubTypes');
          lastSyncedTime.value = DateTime.now().toString();
          incidentSubTypes.value = response;
        }
        else {
          print("Error: Unexpected response format!");
        }
      }
      else {
        print("Error: API returned null!");
      }

     /* if (response != null && response is List) {
        await SharedPrefHelper.saveLastSyncedTime('/GetIncidentSubTypes');
        await SharedPrefHelper.saveApiData('/GetIncidentSubTypes', response);
        lastSyncedTime.value = DateTime.now().toString();
        incidentSubTypes.value = response;
      } else {
        print("Error: Expected a List but got something else!");
      }*/
    } catch (e) {
      print("Error syncing incident subtypes: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
