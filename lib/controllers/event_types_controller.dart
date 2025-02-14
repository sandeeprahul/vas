import 'package:get/get.dart';
import 'package:vas/shared_pref_helper.dart';
import '../services/api_service.dart';

class EventTypesController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  final RxList<dynamic> eventTypes = [].obs; // Store API data

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetEventTypes') ?? "Never";
    eventTypes.value = await SharedPrefHelper.getApiData('/GetEventTypes') ?? [];
  }

  Future<void> syncEventTypes() async {
    isLoading.value = true; // Start loading

    try {
      var response = await apiService.getRequestForMaster('/GetEventTypes');
      print("syncEventTypes response:");
      print(response);

      if (response != null && response is List) { // ✅ Ensure it's a list
        await SharedPrefHelper.saveLastSyncedTime('/GetEventTypes');
        await SharedPrefHelper.saveApiData('/GetEventTypes', response);

        lastSyncedTime.value = DateTime.now().toString();
        eventTypes.value = response; // ✅ Assign the list directly
      } else {
        print("Error: Expected a List but got something else!");
      }
    } catch (e) {
      print("Error syncing event types: $e");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }
  }


