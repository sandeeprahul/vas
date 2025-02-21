import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../data/TripDetails.dart';

class DashboardController extends GetxController {
  var tripId = "".obs;
  var tripDetails = Rxn<TripDetailsModel>();
  var isTripActive = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTripDetails("StartTrip"); // Load the latest trip when the dashboard opens
  }

  Future<TripDetailsModel?> getTripDetails(String  tripType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString(tripType);

    if (jsonData != null) {
      return TripDetailsModel.fromJsonString(jsonData);
    }
    return null;
  }
  Future<void> loadTripDetails(String tripType) async {
    tripDetails.value = await getTripDetails(tripType);
  }


  Future<void> clearTrip() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("StartTrip");
    tripId.value = "";
    tripDetails.value=null;
    isTripActive.value = false;
  }
}
