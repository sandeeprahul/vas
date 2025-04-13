import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class CaseRegistrationNewController extends GetxController {
  final RxString monthsController = ''.obs;
  final RxString yearsController = ''.obs; // ✅ Stores districtId for submission
  final RxString cattleType = ''.obs; // ✅ Stores districtId for submission
  final RxString cattleBreedType = ''.obs; // ✅ Stores districtId for submission
  final RxString genderController = ''.obs; // ✅ Stores gender value (1 for M, 2 for F)
  final RxDouble latitude = 0.0.obs; // ✅ Stores current latitude
  final RxDouble longitude = 0.0.obs; // ✅ Stores current longitude
  final RxBool isLocationLoading = false.obs; // ✅ Tracks location loading state

  @override
  void onInit() {
    super.onInit();
    // Request location when controller is initialized
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      isLocationLoading.value = true;
      
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.dialog(
          AlertDialog(
            title: const Text('Location Services Disabled'),
            content: const Text('Please enable location services to continue.'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  Geolocator.openLocationSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.dialog(
            AlertDialog(
              title: const Text('Location Permission Denied'),
              content: const Text('Location permission is required to continue.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    Geolocator.openAppSettings();
                  },
                  child: const Text('Open Settings'),
                ),
              ],
            ),
          );
          return;
        }
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      
    } catch (e) {
      print('Error getting location: $e');
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text('Could not get location: $e'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      isLocationLoading.value = false;
    }
  }
}