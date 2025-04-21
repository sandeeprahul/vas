// lib/screens/case_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/screens/animal_case__details_screen.dart';
import 'package:vas/widgets/animal_bg_widget.dart';
import '../controllers/case_selection_controller.dart';
import '../theme.dart';
import 'new_animal_case_screen.dart';

class CaseSelectionScreen extends StatelessWidget {
  final CaseSelectionController controller = Get.put(CaseSelectionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Case Registration ',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: AppThemes.light.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.refreshData(),
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
        child: Stack(
          children: [
            const AnimalBgWidget(),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selection Cards Section
                    _buildSelectionSection(),

                    // const SizedBox(height: 24),

                    // Selected Case Details Section
              /*      Obx(() => controller.selectedCase.value != null
                        ? _buildSelectedCaseDetails()
                        : const SizedBox.shrink()),*/
            // Update the Obx wrapper to show a message when no case is selected
                    _buildSectionTitle("Primary case no"),
                    Obx(() => controller.selectedCase.value != null
                        ? _buildSelectedCaseDetails()
                        : const SizedBox.shrink()
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Selected Case Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.blue),
                                onPressed: () => controller.clearSelectedCase(),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.blue),
                          const SizedBox(height: 8),
                          _buildDetailRow(
                            'Case No',
                            'Not Available',
                            // caseItem.caseNo.isEmpty ?  : caseItem.caseNo,
                            isEmpty: true,
                          ),
                          _buildDetailRow(
                            'Primary Case No',
                            // caseItem.caseNo?.isEmpty ?? true ? : caseItem.caseNo!,
                            'Not Available',

                            isEmpty:  true,
                          ),
                          _buildDetailRow(
                            'Livestock Type',
                            // caseItem.livestockDetails.isEmpty ? 'Not Available' : caseItem.livestockDetails,
                            // isEmpty: caseItem.livestockDetails.isEmpty,
                            'Not Available',

                            isEmpty:  true,
                          ),
                          _buildDetailRow(
                            'Block',
                            // caseItem.block.isEmpty ? 'Not Available' : caseItem.block,
                            // isEmpty: caseItem.block.isEmpty,
                            'Not Available',

                            isEmpty:  true,
                          ),
                          _buildDetailRow(
                            'District',
                            // caseItem.district.isEmpty ? 'Not Available' : caseItem.district,
                            // isEmpty: caseItem.district.isEmpty,
                            'Not Available',

                            isEmpty:  true,
                          ),
                          _buildDetailRow(
                            'Service Address',
                            // caseItem.serviceAddress.isEmpty ? 'Not Available' : caseItem.serviceAddress,
                            // isEmpty: caseItem.serviceAddress.isEmpty,
                            'Not Available',

                            isEmpty:  true,
                          ),
                          _buildDetailRow(
                            'Caller Name',
                            // caseItem.callerName.isEmpty ? 'Not Available' : caseItem.callerName,
                            // isEmpty: caseItem.callerName.isEmpty,
                            'Not Available',

                            isEmpty:  true,
                          ),
                          _buildDetailRow(
                            'Status',
                            // caseItem.status.isEmpty ? 'Not Available' : caseItem.status,
                            // isEmpty: caseItem.status.isEmpty,
                            'Not Available',

                            isEmpty:  true,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (){

                                Get.to(BuffaloCaseDetailsScreen());
                                // Get.to(BuffaloCaseDetailsScreen());
                              },
                              // onPressed: () => controller.proceedWithCase(caseItem),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'PROCEED',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Cases List Section
                    Obx(() => controller.cases.isEmpty
                        ? const SizedBox.shrink()
                        : _buildCasesList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 12),
      child: Text(
        "$title : ",
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSelectionSection() {
    return Column(
      children: [
        _buildSelectionCard(
          title: 'Doctor Name',
          value: controller.selectedDoctor,
          onTap: () => _showDoctorSelectionDialog(Get.context!),
          icon: Icons.medical_services,
        ),
        const SizedBox(height: 16),
        _buildSelectionCard(
          title: 'Driver Name',
          value: controller.selectedDriver,
          onTap: () => _showDriverSelectionDialog(Get.context!),
          icon: Icons.person,
        ),
        const SizedBox(height: 16),

        _buildVehicleSelectionCard(), // Use the new vehicle selection card

      ],
    );
  }// Update the vehicle selection card to show loading state

  Widget _buildVehicleSelectionCard() {
    return Obx(() => Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showVehicleSelectionDialog(Get.context!),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.local_taxi, color: Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vehicle',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    controller.ambulanceController.isLoading.value
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : Text(
                      controller.selectedVehicle.value.isEmpty
                          ? '--Select Vehicle--'
                          : controller.selectedVehicle.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    ));
  }

  void _showVehicleSelectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text(
                    'Select Vehicle',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Vehicle List
            Expanded(
              child: Obx(() {
                if (controller.ambulanceController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.ambulanceController.ambulanceList.isEmpty) {
                  return const Center(
                    child: Text('No vehicles available'),
                  );
                }

                return ListView.builder(
                  itemCount: controller.ambulanceController.ambulanceList.length,
                  itemBuilder: (context, index) {
                    final vehicle = controller.ambulanceController.ambulanceList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.local_taxi, color: Colors.blue),
                        ),
                        title: Text(
                          vehicle['asseT_NO'] ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // subtitle: Text(
                        //   vehicle['asseT_NO'] ?? '',
                        //   style: TextStyle(
                        //     color: Colors.grey[600],
                        //   ),
                        // ),
                        onTap: () {
                          // Update selected vehicle
                          controller.selectedVehicle.value =
                          "${vehicle['asseT_NO']}";
                          controller.selectedVehicleId.value =
                              vehicle['id']?.toString() ?? '';

                          // Close dialog
                          Navigator.pop(context);

                          // Fetch cases for selected vehicle
                          controller.fetchCases();
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSelectedCaseDetails() {
    final caseItem = controller.selectedCase.value!;
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Selected Case Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.blue),
                onPressed: () => controller.clearSelectedCase(),
              ),
            ],
          ),
          const Divider(color: Colors.blue),
          const SizedBox(height: 8),
          _buildDetailRow(
            'Case No',
            caseItem.caseNo.isEmpty ? 'Not Available' : caseItem.caseNo,
            isEmpty: caseItem.caseNo.isEmpty,
          ),
          _buildDetailRow(
            'Primary Case No',
            caseItem.caseNo?.isEmpty ?? true ? 'Not Available' : caseItem.caseNo!,
            isEmpty: caseItem.caseNo?.isEmpty ?? true,
          ),
          _buildDetailRow(
            'Livestock Type',
            caseItem.livestockDetails.isEmpty ? 'Not Available' : caseItem.livestockDetails,
            isEmpty: caseItem.livestockDetails.isEmpty,
          ),
          _buildDetailRow(
            'Block',
            caseItem.block.isEmpty ? 'Not Available' : caseItem.block,
            isEmpty: caseItem.block.isEmpty,
          ),
          _buildDetailRow(
            'District',
            caseItem.district.isEmpty ? 'Not Available' : caseItem.district,
            isEmpty: caseItem.district.isEmpty,
          ),
          _buildDetailRow(
            'Service Address',
            caseItem.serviceAddress.isEmpty ? 'Not Available' : caseItem.serviceAddress,
            isEmpty: caseItem.serviceAddress.isEmpty,
          ),
          _buildDetailRow(
            'Caller Name',
            caseItem.callerName.isEmpty ? 'Not Available' : caseItem.callerName,
            isEmpty: caseItem.callerName.isEmpty,
          ),
          _buildDetailRow(
            'Status',
            caseItem.status.isEmpty ? 'Not Available' : caseItem.status,
            isEmpty: caseItem.status.isEmpty,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.proceedWithCase(caseItem),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'PROCEED',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isEmpty = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedCaseDetailds() {
    final caseItem = controller.selectedCase.value!;
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Selected Case Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.blue),
                onPressed: () => controller.clearSelectedCase(),
              ),
            ],
          ),
          const Divider(color: Colors.blue),
          const SizedBox(height: 8),
          _buildDetailRow('Case No', caseItem.caseNo),
          _buildDetailRow('Livestock Type', caseItem.livestockDetails),
          _buildDetailRow('Block', caseItem.block),
          _buildDetailRow('Service Address', caseItem.serviceAddress),
          _buildDetailRow('Caller Name', caseItem.callerName),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.proceedWithCase(caseItem),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'PROCEED',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowd(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCasesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Available Cases',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '${controller.cases.length} cases found',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.cases.length,
          itemBuilder: (context, index) {
            final caseItem = controller.cases[index];
            final isSelected =
                controller.selectedCase.value?.caseNo == caseItem.caseNo;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 2,
                ),
              ),
              elevation: isSelected ? 4 : 2,
              child: InkWell(
                onTap: () => controller.onCaseSelected(caseItem),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected ? Colors.blue.shade50 : Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Case No: ${caseItem.caseNo}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          _buildStatusChip(caseItem.status),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('District', caseItem.district),
                      _buildInfoRow('Block', caseItem.block),
                      _buildInfoRow('Livestock', caseItem.livestockDetails),
                      _buildInfoRow('Address', caseItem.serviceAddress),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    final isNotStarted = status.toLowerCase().contains('not started');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isNotStarted ? Colors.orange : Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

// Selection Dialog methods remain the same
// ...

// Add these methods in your CaseSelectionScreen class
  void _showVehicleSelectionDialogm(BuildContext context) {
    controller.showVehicleSelectionDialog(context);
  }

  Widget _buildSelectionCard({
    required String title,
    required RxString value,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                          value.value.isEmpty
                              ? 'Select $title'
                              : value.value,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showDoctorSelectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text(
                    'Select Doctor',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.doctors.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(controller.doctors[index]),
                    onTap: () {
                      controller.selectedDoctor.value =
                          controller.doctors[index];
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDriverSelectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text(
                    'Select Driver',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.drivers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(controller.drivers[index]),
                    onTap: () {
                      controller.selectedDriver.value =
                          controller.drivers[index];
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVehicleSelectionDialodg(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Text(
                    'Select Vehicle',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.vehicles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(controller.vehicles[index]),
                    onTap: () {
                      controller.selectedVehicle.value =
                          controller.vehicles[index];
                      Navigator.pop(context);
                      // Fetch cases when vehicle is selected
                      controller.fetchCases();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
