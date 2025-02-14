import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class DiseaseTypesController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  final RxList<dynamic> diseaseTypes = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetDiseaseTypes') ?? "Never";
    diseaseTypes.value = await SharedPrefHelper.getApiData('/GetDiseaseTypes') ?? [];
  }

  Future<void> syncDiseaseTypes() async {
    isLoading.value = true;

    try {
      var response = await apiService.getRequestForMaster('/GetDiseaseTypes/0');
      if (response != null && response is List) {
        await SharedPrefHelper.saveLastSyncedTime('/GetDiseaseTypes');
        await SharedPrefHelper.saveApiData('/GetDiseaseTypes', response);
        lastSyncedTime.value = DateTime.now().toString();
        diseaseTypes.value = response;
      } else {
        print("Error: Expected a List but got something else!");
      }
    } catch (e) {
      print("Error syncing disease types: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
