import 'package:get/get.dart';
import 'package:vas/shared_pref_helper.dart';
import 'package:vas/utils/showLoadingDialog.dart';
import '../services/api_service.dart';

class EventTypesController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> eventTypes = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetEventTypes') ?? "Never";
    // eventTypes.value = await SharedPrefHelper.getApiData('/GetEventTypes') ?? [];
    var data = await SharedPrefHelper.getApiData('/GetEventTypes');

    if (data == null) {
      eventTypes.value = {}; // ✅ Handle null case with empty list
    } else if (data is  Map<String, dynamic>) {
      eventTypes.value = data; // ✅ Assign List directly
    }
  }

  Future<void> syncEventTypes() async {
    isLoading.value = true; // Start loading

    showLoadingDialog();
    try {
      var response = await apiService.getRequestForMaster('/GetEventTypes');
      print("syncEventTypes response:");
      print(response);


      if (response != null) {
        if (response is List) {
          var firstItem = response.first;

          // ✅ Response is a List, save directly
          await SharedPrefHelper.saveLastSyncedTime('/GetEventTypes');
          await SharedPrefHelper.saveApiData('/GetEventTypes', firstItem);
          lastSyncedTime.value = DateTime.now().toString();
          eventTypes.value = firstItem;
        }
        else if (response is Map<String, dynamic>) {
          // ✅ Response is a Map, wrap it in a List
          await SharedPrefHelper.saveApiData('/GetEventTypes', [response]);
          await SharedPrefHelper.saveLastSyncedTime('/GetEventTypes');
          lastSyncedTime.value = DateTime.now().toString();
          eventTypes.value = response;
        }
        else {
          print("Error: Unexpected response format!");
        }
      }
      else {
        print("Error: API returned null!");
      }


      // if (response != null && response is List) { // ✅ Ensure it's a list
      //   await SharedPrefHelper.saveLastSyncedTime('/GetEventTypes');
      //   await SharedPrefHelper.saveApiData('/GetEventTypes', response);
      //
      //   lastSyncedTime.value = DateTime.now().toString();
      //   eventTypes.value = response; // ✅ Assign the list directly
      // } else {
      //   print("Error: Expected a List but got something else!");
      // }
    } catch (e) {
      print("Error syncing event types: $e");
    } finally {
      isLoading.value = false; // Stop loading
      // showLoadingDialog();
      hideLoadingDialog();
    }
  }
  }


