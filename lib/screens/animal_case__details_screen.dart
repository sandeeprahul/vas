// // lib/screens/buffalo_case_details_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../theme.dart';
//
// class BuffaloCaseDetailsScreens extends StatelessWidget {
//   final controller = Get.put(BuffaloCaseDetailsController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Get.back(),
//         ),
//         title: const Text(
//           'Buffalo - L',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: AppThemes.light.primaryColor,
//
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.chat_bubble, color: Colors.white),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.share, color: Colors.white),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildInfoSection(
//                 'Case No',
//                 '250321100015',
//                 isLink: true,
//                 hasPhone: false,
//               ),
//               _buildInfoSection(
//                 'Livestock details',
//                 'BUFFALO',
//                 isLink: false,
//                 hasPhone: true,
//               ),
//               _buildInfoSection(
//                 'Owner Info',
//                 'SATYENDRA YADAV, 7250131985',
//                 isLink: false,
//                 hasPhone: true,
//               ),
//               _buildInfoSection(
//                 'Service Address',
//                 'Barhampur',
//                 isLink: true,
//                 hasPhone: false,
//               ),
//               _buildInfoSection(
//                 'Base KM',
//                 '5735.00',
//                 isLink: false,
//                 hasPhone: false,
//               ),
//               _buildTimingSection(),
//               _buildEmergencySection(),
//               _buildDocumentSection(),
//               _buildEndSection(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoSection(
//       String label,
//       String value, {
//         bool isLink = false,
//         bool hasPhone = false,
//       }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 3,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 5,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     value,
//
//                     style: TextStyle(
//
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: isLink ? Colors.blue : Colors.black,
//                     ),
//                   ),
//                 ),
//                 if (hasPhone)
//                   IconButton(
//                     icon: const Icon(Icons.phone),
//                     onPressed: () {},
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTimingSection() {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 16),
//       child: Column(
//         children: [
//           _buildTimeRow('Scene Arrival', '21/03/2025 14:35:00'),
//           _buildTimeRow('Service Start Time', '21/03/2025 14:37:43'),
//           const SizedBox(height: 4),
//           Text('KM(5740.00)', style: TextStyle(color: Colors.grey[600])),
//           _buildServiceCompletedButton(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTimeRow(String label, String time) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 3,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 5,
//             child: Text(
//               time,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmergencySection() {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         children: [
//           _buildFormField('Emergency Type', 'TREATMENT'),
//           _buildFormField('E. Sub Type', 'Other'),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildFormField('Drop KM', '5740'),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _buildFormField('Charge KM', '5.00'),
//               ),
//             ],
//           ),
//           _buildFormField('PAF NO', ''),
//           _buildFormField('Doctor Code', 'dctr060'),
//           _buildFormField('Para Vet Code', 'prvt085'),
//           _buildFormField('Driver Code', 'drv085'),
//           _buildFormField('Owner\'s Aadhar Number', ''),
//           _buildFormField('PPP ID', ''),
//           _buildFormField('Procedure Remark', ''),
//           _buildFormField('Remark Type', 'Select Remark Type'),
//           _buildFormField('Remark Sub Type', 'Select Remark Sub Type'),
//           _buildFormField('Standard Remark', ''),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFormField(String label, String value) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(color: Colors.grey.shade300),
//               ),
//             ),
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDocumentSection() {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildDocumentUpload('Document 1'),
//           _buildDocumentUpload('Document 2'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDocumentUpload(String label) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.camera_alt),
//                 onPressed: () {},
//               ),
//               const Text('or'),
//               IconButton(
//                 icon: const Icon(Icons.upload_file),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEndSection() {
//     return Column(
//       children: [
//         _buildFormField('Base END KM', '0.0'),
//         const SizedBox(height: 16),
//         _buildServiceCompletedButton(),
//         const SizedBox(height: 16),
//         _buildCloseButton(),
//       ],
//     );
//   }
//
//   Widget _buildServiceCompletedButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: () {},
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepOrange,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//         ),
//         child: const Text(
//           'MARK SERVICE COMPLETED',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCloseButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: () {},
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.deepOrange,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//         ),
//         child: const Text(
//           'CLOSE THIS CASE',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
//
// // Controller
// // Controller
// class BuffaloCaseDetailsController extends GetxController {
//   final sceneArrivalController = TextEditingController();
//   final serviceStartController = TextEditingController();
//   final serviceCompletedController = TextEditingController();
//   final dropKmController = TextEditingController();
//   final pafNoController = TextEditingController();
//   final aadharController = TextEditingController();
//   final pppIdController = TextEditingController();
//   final procedureRemarkController = TextEditingController();
//   final baseEndKmController = TextEditingController();
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize with sample data
//     sceneArrivalController.text = '21/03/2025 14:35:00';
//     serviceStartController.text = '21/03/2025 14:37:43';
//     dropKmController.text = '5740';
//   }
//
//   @override
//   void onClose() {
//     sceneArrivalController.dispose();
//     serviceStartController.dispose();
//     serviceCompletedController.dispose();
//     dropKmController.dispose();
//     pafNoController.dispose();
//     aadharController.dispose();
//     pppIdController.dispose();
//     procedureRemarkController.dispose();
//     baseEndKmController.dispose();
//     super.onClose();
//   }
// }