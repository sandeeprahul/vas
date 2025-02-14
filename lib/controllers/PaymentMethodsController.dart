import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class PaymentMethodsController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  final RxList<dynamic> paymentMethods = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetPaymentMethod') ?? "Never";
    paymentMethods.value = await SharedPrefHelper.getApiData('/GetPaymentMethod') ?? [];
  }

  Future<void> syncPaymentMethods(String userId) async {
    isLoading.value = true;

    try {
      String formattedEndpoint = '/GetPaymentMethod/$userId';
      var response = await apiService.getRequestForMaster(formattedEndpoint,);
      if (response != null && response is List) {
        await SharedPrefHelper.saveLastSyncedTime(formattedEndpoint);
        await SharedPrefHelper.saveApiData(formattedEndpoint, response);
        lastSyncedTime.value = DateTime.now().toString();
        paymentMethods.value = response;
      } else {
        print("Error: Expected a List but got something else!");
      }
    } catch (e) {
      print("Error syncing payment methods: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
