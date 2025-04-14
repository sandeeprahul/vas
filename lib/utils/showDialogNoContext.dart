import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/theme.dart';

void showErrorDialog(String title, String message) {
  Get.dialog(
    AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold,)),
      //
      content: Text(message,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppThemes.light.primaryColor),
          onPressed: () {
            Get.back();
          } // ✅ Close dialog
          ,
    /*      style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                // Add this
                borderRadius:
                    BorderRadius.circular(28.0), // Adjust the radius as needed
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold)),*/
          child: const Text("OK",),
        ),

        /*
        TextButton(
          onPressed: () => Get.back(), // ✅ Close dialog
          child: const Text("OK", style: TextStyle(color: Colors.blue)),
        ),*/
      ],
    ),
    barrierDismissible: false, // ✅ Prevent closing by tapping outside
  );
}
