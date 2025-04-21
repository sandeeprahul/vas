// lib/screens/buffalo_case_details_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';

class BuffaloCaseDetailsScreen extends StatelessWidget {
  final controller = Get.put(BuffaloCaseDetailsController());
  final primaryColor = const Color(0xFF3B3486);
  RxBool isUploading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Buffalo - L',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor:               AppThemes.light.primaryColor,

        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppThemes.light.primaryColor,
              AppThemes.light.primaryColor.withOpacity(0.55),
              AppThemes.light.primaryColor.withOpacity(0.6),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(),
                const SizedBox(height: 16),
                _buildTimingCard(),
                const SizedBox(height: 16),
                _buildEmergencyCard(),
                const SizedBox(height: 16),
                _buildDocumentCard(),
                const SizedBox(height: 16),
                _buildEndCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildInfoRow(String label, String value, {bool isLink = false, bool hasPhone = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Value and Phone Icon
          Expanded(
            flex: 6,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isLink ? primaryColor : Colors.black87,
                      decoration: isLink ? TextDecoration.underline : null,
                    ),
                  ),
                ),
                if (hasPhone)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      icon: Icon(
                        Icons.phone,
                        color: primaryColor,
                        size: 20,
                      ),
                      onPressed: () {
                        // Handle phone call
                        final phoneNumber = value.split(',').last.trim();
                        // You can implement phone call functionality here
                        print('Calling: $phoneNumber');
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow('Case No', '250321100015', isLink: false),
            _buildInfoRow('Livestock details', 'BUFFALO', hasPhone: false),
            _buildInfoRow('Owner Info', 'SATYENDRA YADAV, 7250131985', hasPhone: false),
            _buildInfoRow('Service Address', 'Barhampur', isLink: false),
            _buildInfoRow('Base KM', '5735.00'),
          ],
        ),
      ),
    );
  }

  Widget _buildTimingCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(
              label: 'Seen Arrival',
              controller: controller.sceneArrivalController,
              readOnly: false,
              suffixIcon: Icons.access_time,
            ),
            _buildTextField(
              label: 'Service Start Time',
              controller: controller.serviceStartController,
              readOnly: false,
              suffixIcon: Icons.access_time,
            ),
            _buildTextField(
              label: 'Service Completed Time',
              controller: controller.serviceCompletedController,
              readOnly: false,
              suffixIcon: Icons.access_time,
            ),
            const SizedBox(height: 16),
            Text('BASE KM : 5740.00',
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(
              label: 'Drop KM',
              controller: controller.dropKmController,
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              label: 'PAF NO',
              controller: controller.pafNoController,
            ),
            _buildTextField(
              label: 'Owner\'s Aadhar Number',
              controller: controller.aadharController,
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              label: 'PPP ID',
              controller: controller.pppIdController,
            ),
            _buildTextField(
              label: 'Procedure Remark',
              controller: controller.procedureRemarkController,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    IconData? suffixIcon,
    TextInputType? keyboardType,
    int? maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
              suffixIcon: suffixIcon != null
                  ? IconButton(
                icon: Icon(suffixIcon, color: primaryColor),
                onPressed: () {
                  // Handle time picker
                },
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Documents',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            _buildDocumentUpload('Document 1'),
            _buildDocumentUpload('Document 2'),
          ],
        ),
      ),
    );
  }Widget _buildDocumentUpload(String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Document Label
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.file_present,
                  color: primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          // Upload Options
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Camera Option
                _buildUploadOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    // Handle camera
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'or',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Gallery Option
                _buildUploadOption(
                  icon: Icons.upload_file,
                  label: 'Upload',
                  onTap: () {
                    // Handle file upload
                  },
                ),
              ],
            ),
          ),
          // Preview Section (if document is uploaded)
          Obx(() => controller.hasDocument(label)
              ? _buildDocumentPreview(label)
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
  Widget _buildDocumentPreview(String documentLabel) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: primaryColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Document Icon/Thumbnail
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.insert_drive_file,
                        color: primaryColor,
                        size: 24,
                      ),
                    ),
                    if (controller.isUploading.value)
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Document Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Document_${documentLabel.split(' ').last}.jpg',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Uploaded',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.photo,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Image',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.straighten,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '2.5 MB',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildActionButton(
                icon: Icons.visibility,
                label: 'Preview',
                onTap: () {
                  // Handle preview
                },
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                icon: Icons.delete_outline,
                label: 'Remove',
                isDestructive: true,
                onTap: () {
                  // Handle delete
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red : primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildUploadOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: primaryColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: primaryColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(
              label: 'Base END KM',
              controller: controller.baseEndKmController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildActionButton(icon: Icons.fast_forward, label: 'MARK SERVICE COMPLETE', onTap: () {  }),//MARK SERVICE COMPLETE',
            const SizedBox(height: 16),
            _buildActionButton(icon: Icons.fast_forward, label: 'CLOSE THIS CASE', onTap: () {  }),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtofn(String text) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Controller
class BuffaloCaseDetailsController extends GetxController {
  final sceneArrivalController = TextEditingController();
  final serviceStartController = TextEditingController();
  final serviceCompletedController = TextEditingController();
  final dropKmController = TextEditingController();
  final pafNoController = TextEditingController();
  final aadharController = TextEditingController();
  final pppIdController = TextEditingController();
  final procedureRemarkController = TextEditingController();
  final baseEndKmController = TextEditingController();
  final isUploading = false.obs;

  final Map<String, RxBool> documentUploaded = {
    'Document 1': false.obs,
    'Document 2': false.obs,
  };
  bool hasDocument(String label) => documentUploaded[label]?.value ?? false;

  void toggleDocument(String label) {
    if (documentUploaded.containsKey(label)) {
      documentUploaded[label]?.value = !documentUploaded[label]!.value;
    }
  }
  @override
  void onInit() {
    super.onInit();
    // Initialize with sample data
    sceneArrivalController.text = '21/03/2025 14:35:00';
    serviceStartController.text = '21/03/2025 14:37:43';
    dropKmController.text = '5740';
  }

  @override
  void onClose() {
    sceneArrivalController.dispose();
    serviceStartController.dispose();
    serviceCompletedController.dispose();
    dropKmController.dispose();
    pafNoController.dispose();
    aadharController.dispose();
    pppIdController.dispose();
    procedureRemarkController.dispose();
    baseEndKmController.dispose();
    super.onClose();
  }
}