import 'package:get/get.dart';
import 'package:flutter/material.dart';

void showLoadingDialog() {
  Get.dialog(
    const Center(
      child: CircularProgressIndicator(),
    ),
    barrierDismissible: false, // Prevent dismissing by tapping outside
  );
}

void hideLoadingDialog() {
  if (Get.isDialogOpen!) {
    Get.back();
  }
}
/*void showLoadingDialog() {
  if (Get.isDialogOpen != true) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Loading...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}

void hideLoadingDialog() {
  if (Get.isDialogOpen == true) {
    Get.back();
  }
}*/
