import 'package:get/get.dart';
import '../services/api_service.dart';
import '../shared_pref_helper.dart';

class PaymentMethodsController extends GetxController {
  final ApiService apiService = ApiService();
  final RxString lastSyncedTime = 'Never'.obs;
  final RxBool isLoading = false.obs;
  // final RxList<dynamic> paymentMethods = [].obs;
  final RxMap<String, dynamic> paymentMethods = <String, dynamic>{}.obs;

  @override
  void onInit()  {
    super.onInit();

    loadLastSyncedData();
  }

  Future<void> loadLastSyncedData() async {
    lastSyncedTime.value = await SharedPrefHelper.getLastSyncedTime('/GetPaymentMethod') ?? "Never";
    // paymentMethods.value = await SharedPrefHelper.getApiData('/GetPaymentMethod') ?? [];
    var data = await SharedPrefHelper.getApiData('/GetPaymentMethod');

    if (data == null) {
      paymentMethods.value = {}; // ✅ Handle null case with empty list
    } else if (data is  Map<String, dynamic>) {
      paymentMethods.value = data; // ✅ Assign List directly
    }
  }

  Future<void> syncPaymentMethods(String userId) async {
    isLoading.value = true;

    try {
      String formattedEndpoint = '/GetPaymentMethod/$userId';
      var response = await apiService.getRequestForMaster(formattedEndpoint,);


      if (response != null) {
        if (response is List) {
          var firstItem = response.first;

          // ✅ Response is a List, save directly
          await SharedPrefHelper.saveLastSyncedTime('/GetPaymentMethod');
          await SharedPrefHelper.saveApiData('/GetPaymentMethod', firstItem);
          lastSyncedTime.value = DateTime.now().toString();
          paymentMethods.value = firstItem;
        }
        else if (response is Map<String, dynamic>) {
          // ✅ Response is a Map, wrap it in a List
          await SharedPrefHelper.saveApiData('/GetPaymentMethod', [response]);
          await SharedPrefHelper.saveLastSyncedTime('/GetPaymentMethod');
          lastSyncedTime.value = DateTime.now().toString();
          paymentMethods.value = response;
        }
        else {
          print("Error: Unexpected response format!");
        }
      }
      else {
        print("Error: API returned null!");
      }

    /*  if (response != null && response is List) {
        await SharedPrefHelper.saveLastSyncedTime('/GetPaymentMethod');
        await SharedPrefHelper.saveApiData('/GetPaymentMethod', response);
        lastSyncedTime.value = DateTime.now().toString();
        paymentMethods.value = response;
      } else {
        print("Error: Expected a List but got something else!");
      }*/
    } catch (e) {
      print("Error syncing payment methods: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
