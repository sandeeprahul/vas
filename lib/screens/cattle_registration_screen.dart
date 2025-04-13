import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vas/controllers/ambulance_controller.dart';
import 'package:vas/controllers/blocks_controller.dart';
import 'package:vas/controllers/districts_controller.dart';
import 'package:vas/controllers/location_sub_type_controller.dart';
import 'package:vas/controllers/location_type_controller.dart';
import 'package:vas/controllers/user_controller.dart';
import 'package:vas/screens/case_details_screen.dart';
import 'package:vas/screens/dashboard_page.dart';
import 'package:vas/services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/case_registration_new_controller.dart';
import '../controllers/live_stock_controller.dart';
import '../data/DiseaseType.dart';
import '../data/IncidentType.dart';
import '../data/MedicineItem.dart';
import '../data/PatientType.dart';
import '../theme.dart';

class CattleRegistrationScreen extends StatefulWidget {
  const CattleRegistrationScreen({super.key});

  @override
  _CattleRegistrationScreenState createState() =>
      _CattleRegistrationScreenState();
}

class _CattleRegistrationScreenState extends State<CattleRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _registrationType = 'Individual Registration'; // Default type
  Map<String, dynamic> _formData = {};
  List<IncidentType> _incidentTypes = [];
  List<IncidentSubType> _incidentSubTypes = [];
  List<String> _filteredSubTypes = [];

  String? _selectedEventType;
  int? _selectedEventTypeId;
  String? _selectedCaseType;
  int? _selectedCaseTypeId;

  bool _isLoadingIncidentData = false;

  Future<void> loadIncidentData() async {
    setState(() {
      _isLoadingIncidentData = true;
    });

    try {
      ApiService apiService = ApiService();
      final incidentResponse = await apiService.getRequestList("/GetIncidentTypes");//EventType
      final subIncidentResponse = await apiService.getRequestList("/GetIncidentSubTypes");//CaseType

      print("loadIncidentDataloadIncidentDataloadIncidentDataloadIncidentData");
      print(subIncidentResponse);
      print(incidentResponse);

      if (incidentResponse != null && subIncidentResponse != null) {
        setState(() {
          _incidentTypes = (incidentResponse as List)
              .map((e) => IncidentType.fromJson(e))
              .toList();

          _incidentSubTypes = (subIncidentResponse as List)
              .map((e) => IncidentSubType.fromJson(e))
              .toList();
        });
      } else {
        Get.dialog(
          AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to load incident data'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error loading incident data: $e");
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text('Error loading incident data: $e'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoadingIncidentData = false;
      });
    }
  }

  Widget _buildEventTypeDropdown() {
    if (_isLoadingIncidentData) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppThemes.light.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.event, color: AppThemes.light.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Event Type',
                  border: InputBorder.none,
                ),
                value: _selectedEventType,
                items: _incidentTypes.map((e) {
                  return DropdownMenuItem<String>(
                    value: e.incidentName,
                    child: Text(e.incidentName!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEventType = value;
                    final selectedId = _incidentTypes
                        .firstWhere((e) => e.incidentName == value)
                        .incidentId;
                    _selectedEventTypeId = selectedId;
                    _filteredSubTypes = _incidentSubTypes
                        .where((s) => s.incidentID == selectedId)
                        .map((s) => s.subType)
                        .toList();
                    _selectedCaseType = null;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseTypeDropdown() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppThemes.light.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.category, color: AppThemes.light.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Case Type',
                  border: InputBorder.none,
                ),
                value: _selectedCaseType,
                items: _filteredSubTypes.map((caseType) {
                  return DropdownMenuItem<String>(
                    value: caseType,
                    child: Text(caseType),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    final selectedSubType = _incidentSubTypes.firstWhere(
                      (s) => s.subType == value,
                      orElse: () => IncidentSubType(incidentID: 0, subType: '', subID: 0),
                    );
                    setState(() {
                      _selectedCaseType = value;
                      _selectedCaseTypeId = selectedSubType.subID;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    switch (_registrationType) {
      case 'Individual Registration':
        return [
          _buildDropdown('Type', ['Individual Registration'], 'Type'),
          const SizedBox(height: 10),
          _buildDropdown('Species', ['Xyz', 'ABC'], 'Species'),
          const SizedBox(height: 10),
          _buildDropdown('Gender', ['M', 'F'], 'Gender'),
          const SizedBox(height: 10),
          _buildSectionTitle('Cattle details'),

          Row(
            children: [
              Expanded(
                  child: _buildTextField('Years', 'Years')),
              const SizedBox(
                width: 12,
              ),
              Expanded(child: _buildTextField('Months', 'Months')),
            ],
          ),
          const SizedBox(height: 10),
          _buildTypeDropdown(),
          const SizedBox(height: 10),
          _buildBreedDropdown(),
          const SizedBox(height: 10),
          _buildEventTypeDropdown(),
          const SizedBox(height: 10),
          _buildCaseTypeDropdown(),
          const SizedBox(height: 10),
          buildDiseaseDropdown(),
          const SizedBox(height: 44),
          _buildSectionTitle('Items'),


          buildMedicineSelector(),
          const SizedBox(height: 10),
          // _buildTextField('Remark', 'Remark'),
        ];
      case 'Lab Sample':
        return [
          _buildDropdown('Type', ['Lab Sample'], 'Type'),
          const SizedBox(height: 10),
          _buildDropdown('Species', ['Xyz', 'ABC'], 'Species'),
          const SizedBox(height: 10),
          _buildDropdown('Gender', ['M', 'F'], 'Gender'),
          const SizedBox(height: 10),
         _buildSectionTitle('Cattle details'),

          Row(
            children: [
              Expanded(
                  child: _buildTextField('Years', 'Years')),
              const SizedBox(
                width: 12,
              ),
              Expanded(child: _buildTextField('Months', 'Months')),
            ],
          ),
          const SizedBox(height: 10),
          _buildTypeDropdown(),
          const SizedBox(height: 10),
          _buildBreedDropdown(),
          const SizedBox(height: 10),
          _buildEventTypeDropdown(),
          const SizedBox(height: 10),
          _buildCaseTypeDropdown(),
          const SizedBox(height: 10),
          _buildDropdown('Result', ['Positive', 'Negative'], 'Result'),
          const SizedBox(height: 10),
          _buildTextField('Item Name', 'ItemName'),
          const SizedBox(height: 10),
          _buildTextField('Quantity', 'Quantity'),
          const SizedBox(height: 10),
          _buildTextField('Unit', 'Unit'),
          buildDiseaseDropdown(),
          const SizedBox(height: 44),
          _buildSectionTitle('Items'),

          buildMedicineSelector(),
          const SizedBox(height: 10),
          // _buildTextField('Remark', 'Remark'),
        ];
      case 'Mass Registration':
        return [
          _buildDropdown('Type', ['Mass Registration'], 'Type'),
          const SizedBox(height: 10),
          _buildDropdown('Species', ['ABC'], 'Species'),
          const SizedBox(height: 10),
          _buildTextField('No of Species', 'NoOfSpecies'),
          const SizedBox(height: 10),
          _buildSectionTitle('Cattle details'),

          Row(
            children: [
              Expanded(
                  child: _buildTextField('Years', 'Years')),
              const SizedBox(
                width: 12,
              ),
              Expanded(child: _buildTextField('Months', 'Months')),
            ],
          ),
          const SizedBox(height: 10),
          _buildTypeDropdown(),
          const SizedBox(height: 10),
          _buildBreedDropdown(),
          _buildEventTypeDropdown(),
          const SizedBox(height: 10),
          _buildCaseTypeDropdown(),
          const SizedBox(height: 10),
          _buildTextField('Remark', 'Remark'),
          const SizedBox(height: 10),
          _buildTextField('Item Name', 'ItemName'),
          const SizedBox(height: 10),
          _buildTextField('Quantity', 'Quantity'),
          const SizedBox(height: 10),
          buildDiseaseDropdown(),
          const SizedBox(height: 10),
          _buildTextField('Unit', 'Unit'),
          const SizedBox(height: 66),
          _buildSectionTitle('Items'),

          buildMedicineSelector(),
          const SizedBox(height: 10),
        ];
      default:
        return [];
    }
  }
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 12),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppThemes.light.primaryColor,
        ),
      ),
    );
  }

  List<DiseaseType> diseaseList = [];

  void showDiseasePopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Disease Type"),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: diseaseList.length,
              itemBuilder: (context, index) {
                final disease = diseaseList[index];
                return ListTile(
                  title: Text(disease.diseaseName),
                  onTap: () {
                    setState(() {
                      selectedDisease = disease.diseaseName;
                      selectedMedicines.clear();
                    });
                    Navigator.pop(context);
                    fetchMedicines(); // call here
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<PatientType> _types = [];
  List<PatientSubType> _allSubtypes = [];
  List<PatientSubType> _breedOptions = [];

  String? _selectedType;
  PatientSubType? _selectedBreed;

  bool _isLoadingPatientTypes = false;

  Future<void> loadPatientTypes() async {
    setState(() {
      _isLoadingPatientTypes = true;
    });

    try {
      ApiService apiService = ApiService();
      final response = await apiService.getRequest("/GetPatientTypes");

      if (response != null) {
        setState(() {
          // Handle p_Type_Data
          _types = (response['p_Type_Data'] as List)
              .map((e) => PatientType.fromJson(e))
              .toList();

          // Handle p_SubType_Data
          _allSubtypes = (response['p_SubType_Data'] as List)
              .map((e) => PatientSubType.fromJson(e))
              .toList();

          // Initialize breed options based on first type if available
          if (_types.isNotEmpty) {
            _selectedType = _types.first.pT_TEXT;
            _breedOptions = _allSubtypes
                .where((s) => s.pT_ID == _types.first.pT_ID)
                .toList();
          }
        });
      } else {
        Get.dialog(
          AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to load patient types'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error loading patient types: $e");
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text('Error loading patient types: $e'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoadingPatientTypes = false;
      });
    }
  }

  Widget _buildTypeDropdown() {
    if (_isLoadingPatientTypes) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppThemes.light.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.pets, color: AppThemes.light.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Cattle\'s Type',
                  border: InputBorder.none,
                ),
                value: _selectedType,
                items: _types.map((type) {
                  return DropdownMenuItem(
                    value: type.pT_TEXT,
                    child: Text(type.pT_TEXT),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    final selectedTypeObj = _types.firstWhere((t) => t.pT_TEXT == value);
                    caseRegistrationController.cattleType.value = "${selectedTypeObj.pT_ID}";

                    setState(() {
                      _selectedType = value;
                      _breedOptions = _allSubtypes
                          .where((s) => s.pT_ID == selectedTypeObj.pT_ID)
                          .toList();
                      _selectedBreed = null;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreedDropdown() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppThemes.light.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.pets, color: AppThemes.light.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<PatientSubType>(
                decoration: const InputDecoration(
                  labelText: 'Cattle\'s Breed',
                  border: InputBorder.none,
                ),
                value: _selectedBreed,
                items: _breedOptions.map((breed) {
                  return DropdownMenuItem<PatientSubType>(
                    value: breed,
                    child: Text(breed.ptS_TEXT),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBreed = value;
                    if (value != null) {
                      caseRegistrationController.cattleBreedType.value = value.ptS_ID.toString();
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<MedicineItem> medicineList = []; // from API
  List<MedicineItem> selectedMedicines = [];

  MedicineItem? selectedMedicine;

  String? selectedDisease;
  MedicineItem? selectedItem;

  bool _isLoadingMedicines = false;

  Future<void> fetchMedicines() async {
    setState(() {
      _isLoadingMedicines = true;
    });

    try {
      ApiService apiService = ApiService();
      UserController userController = Get.put(UserController());
      final response = await apiService
          .getRequest('/GetMedicines/${userController.userId.value}/1/100');
      
      if (response != null) {
        List<dynamic> records = response['records'];
        medicineList = records.map((e) {
          return MedicineItem(
            item_ID: e['item_ID'] ?? 0,
            itemName: e['item_Name'] ?? '',
            itemUnit: e['item_Unit'] ?? '',
            itemNumber: e['item_Number'] ?? '',
            itemType: e['item_Type'] ?? '',
            itemPrice: (e['item_Price'] ?? 0).toDouble(),
            iD_Name: e['iD_Name'] ,
          );
        }).toList();
        setState(() {});
      } else {
        Get.dialog(
          AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to load medicines'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error loading medicines: $e");
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text('Error loading medicines: $e'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoadingMedicines = false;
      });
    }
  }

  TextEditingController quantityController = TextEditingController();

  Widget buildMedicineSelector() {
    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppThemes.light.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.medication, color: AppThemes.light.primaryColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<MedicineItem>(
                    value: selectedMedicine,
                    items: medicineList.map((medicine) {
                      return DropdownMenuItem(
                        value: medicine,
                        child: Text('${medicine.itemName} (${medicine.itemUnit})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMedicine = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Select Medicine',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppThemes.light.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.numbers, color: AppThemes.light.primaryColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                if (selectedMedicine != null && quantityController.text.isNotEmpty) {
                  setState(() {
                    selectedMedicines.add(MedicineItem(
                      item_ID: selectedMedicine!.item_ID,
                      itemName: selectedMedicine!.itemName,
                      itemUnit: selectedMedicine!.itemUnit,
                      itemNumber: selectedMedicine!.itemNumber,
                      itemType: selectedMedicine!.itemType,
                      itemPrice: selectedMedicine!.itemPrice,
                      quantity: quantityController.text,
                      iD_Name: selectedMedicine!.iD_Name,
                    ));
                    quantityController.clear();
                    selectedMedicine = null; // Clear selection after adding
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemes.light.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Add Medicine'),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppThemes.light.primaryColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Item No',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Name',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Quantity',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Units',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              ...selectedMedicines.map((entry) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text(
                            '${entry.itemNumber}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.itemName,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.quantity,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.itemUnit,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> options, String key) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppThemes.light.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.list, color: AppThemes.light.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: label,
                  border: InputBorder.none,
                ),
                value: _formData[key],
                items: options.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _formData[key] = value;
                    // Handle gender mapping
                    if (key == 'Gender') {
                      if (value == 'M') {
                        caseRegistrationController.genderController.value = '1';
                      } else if (value == 'F') {
                        caseRegistrationController.genderController.value = '2';
                      }
                    }
                    print("caseRegistrationController.genderController.value");
                    print(caseRegistrationController.genderController.value);

                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String key) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppThemes.light.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.edit, color: AppThemes.light.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: label,
                  border: InputBorder.none,
                ),
                onChanged: (value) {

                  setState(() {
                    _formData[key] = value;
                  });
                  if(label=="Months"){
                    caseRegistrationController.monthsController.value = value;
                  }
                  if(label=="Years"){
                    caseRegistrationController.yearsController.value = value;
                  }

                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DiseaseType> _diseaseTypes = [];
  bool _isLoadingDiseaseTypes = false;

  Future<void> loadDiseaseTypes() async {
    setState(() {
      _isLoadingDiseaseTypes = true;
    });

    try {
      ApiService apiService = ApiService();
      final diseaseResponse = await apiService.getRequestList("/GetDiseaseTypes/1888");

      if (diseaseResponse != null && diseaseResponse is List) {
        setState(() {
          _diseaseTypes = diseaseResponse.map((e) => DiseaseType.fromJson(e)).toList();
        });
      } else {
        Get.dialog(
          AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to load disease types'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error loading disease types: $e");
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text('Error loading disease types: $e'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoadingDiseaseTypes = false;
      });
    }
  }

  Widget buildDiseaseDropdown() {
    if (_isLoadingDiseaseTypes) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppThemes.light.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.medical_services, color: AppThemes.light.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Disease Type',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                ),
                value: selectedDisease,
                items: _diseaseTypes
                    .map((disease) => DropdownMenuItem<String>(
                          value: disease.diseaseName,
                          child: Text(disease.diseaseName),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDisease = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Form Data: $_formData');
      // You can now process the form data (e.g., send to an API)
    }
  }

  CaseRegistrationNewController caseRegistrationController = Get.put(CaseRegistrationNewController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// loads data for patient types dropdown

    loadPatientTypes();

    /// loads incident types + subtypes

    loadIncidentData();

    ///loads desease type
    loadDiseaseTypes();
    // fetchDiseases();x
    fetchMedicines();
  }



  Future<void> submitLivestockForm() async {

    final liveCaseController = Get.put(LivestockController());
    final formData = liveCaseController.formData;
    final userController = Get.put(UserController());
    final blocksController = Get.put(BlocksController());
    final districtController = Get.put(DistrictsController());
    final locationTypeController = Get.put(LocationTypeController());
    final locationSubTypeController = Get.put(LocationSubTypeController());

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try
      {
        // Convert medicine list to proper format
        List<Map<String, dynamic>> medicineList = [];
        for (var medicine in selectedMedicines) {
          medicineList.add({
            "item_ID": medicine.item_ID,
            "iD_Value": medicine.item_ID,
            "iD_Name": medicine.iD_Name,
            "item_Number": medicine.itemNumber,
            "quantity": medicine.quantity.toString(),
          });
        }




        print(caseRegistrationController.genderController.value);
        print(caseRegistrationController.yearsController.value);
        print(caseRegistrationController.monthsController.value);

        print("Creating json:");

        final requestBody= {

          "userId": int.tryParse(userController.userId.value) ?? 0,
          "districtId": int.tryParse(districtController.selectedDistrictId.value) ?? 0,
          "blockId": int.tryParse(blocksController.selectedBlockId.value) ?? 0,
          "villageId": int.tryParse(locationSubTypeController.selectedLocationId.value) ?? 0,
          "gender": int.tryParse(caseRegistrationController.genderController.value) ?? 0,
          "yearAge": int.tryParse(caseRegistrationController.yearsController.value) ?? 0,
          "monthAge": int.tryParse(caseRegistrationController.monthsController.value) ?? 0,
          "cattleType": int.tryParse(caseRegistrationController.cattleType.value) ?? 0,
          "cattleSubType": int.tryParse(caseRegistrationController.cattleBreedType.value) ?? 0,

          "locationId": 1,
            "medicine": selectedMedicines.map((med) => med.toJson()).toList(),
            "cattleCount": 1,
            "imeiNumber": "",
          "latitude": caseRegistrationController.latitude.value,
          "longitude": caseRegistrationController.longitude.value,
          "ownerNo": liveCaseController.formData['OwnersContactNo'],
          "ownerName": liveCaseController.formData['Owners Name'],

            "address": "string",
            "cattleName": "string",

            "daysAge": 0,

            "incidentType": _selectedEventTypeId,
            "incidentSubType": _selectedCaseTypeId,
            "approvalRemark": liveCaseController.approvalRemark.value,
            "regnRemark": liveCaseController.registrationRemark.value,
        "docName1": liveCaseController.fileName.value,
        "doc2": "string",
        "docName2": "string",
            "doc1": liveCaseController.base64File.value


        };

        print("REQUEST BODY:");
        print(jsonEncode(requestBody));

        // Send the request
        final response = await http.post(
          Uri.parse('http://49.207.44.107/mvas/CreateCase'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestBody),
        );

        print("RESPONSE STATUS: ${response.statusCode}");
        print("RESPONSE BODY: ${response.body}");

        if (response.statusCode == 200) {
          setState(() {
            isLoading = false;
          });
          final responseBody = jsonDecode(response.body);
          if (responseBody['result'] == 0) {
            Get.back();
            Get.snackbar(
              'Success',
              'Case created successfully',
              duration: const Duration(seconds: 3),
            );
          } else {
            setState(() {
              isLoading = false;
            });
            Get.dialog(
              AlertDialog(
                title: const Text('Error'),
                content: Text(responseBody['message'] ?? 'Unknown error'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        } else {
          setState(() {
            isLoading = false;
          });
          final responseBody = jsonDecode(response.body);
          Get.dialog(
            AlertDialog(
              title: const Text('Error'),
              content: Text(responseBody['reasonPhrase'] ?? 'Unknown error'),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
      catch (e) {
        setState(() {
          isLoading = false;
        });
        print("ERROR: $e");
        Get.dialog(
          AlertDialog(
            title: const Text('Error'),
            content: Text('Exception: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cattle Registration'),
        elevation: 0,
        backgroundColor: AppThemes.light.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppThemes.light.primaryColor,
              Colors.white,
            ],
          ),
        ),
        child: isLoading?const Center(child: Column(mainAxisSize: MainAxisSize.min,children: [
          Text('Please wait..'),
          SizedBox(height: 6,),
          CircularProgressIndicator()
        ],),):Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppThemes.light.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.app_registration, color: AppThemes.light.primaryColor),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Registration Type',
                              border: InputBorder.none,
                            ),
                            value: _registrationType,
                            items: [
                              'Individual Registration',
                              // 'Lab Sample',
                              'Mass Registration',
                            ].map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _registrationType = value!;
                                _formData.clear(); // Clear form data when type changes
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ..._buildFormFields(),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemes.light.primaryColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: (){
                    showApprovalDialog();
                  caseRegistrationController.getCurrentLocation();
                  },
                  child: const Text('Register Case'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void showApprovalDialog() {
    final liveCaseController = Get.put(LivestockController());
    final TextEditingController approvalController = TextEditingController();
    final TextEditingController registrationController = TextEditingController();

    Get.defaultDialog(
      title: 'Submit Remarks',
      content: Column(
        children: [
          TextField(
            controller: approvalController,
            decoration: const InputDecoration(labelText: 'Approval Remark'),
          ),
          TextField(
            controller: registrationController,
            decoration: const InputDecoration(labelText: 'Registration Remark'),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined,size: 44,),
                // label: const Text("Pick Image"),
                onPressed: () async {

                  var status = await Permission.camera.status;

                  if (!status.isGranted) {
                    status = await Permission.camera.request();
                    if (!status.isGranted) {
                      Get.defaultDialog(
                        middleText: 'Please grant camera permission',
                      );
                      print('Camera permission denied');
                      return;
                    }
                  }

                  final picker = ImagePicker();
                  final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

                  if (pickedFile != null) {
                    final bytes = await pickedFile.readAsBytes();
                    final base64Str = base64Encode(bytes);
                    final filename = pickedFile.name; // 👈 gets the actual filename
                    Get.put(LivestockController()).setSelectedFile(File(pickedFile.path));

                    liveCaseController.setBase64File(base64Str, filename); // pass both
                    Get.snackbar('Success', 'Image selected successfully');
                  } else {
                    Get.snackbar('No image selected', '', snackPosition: SnackPosition.BOTTOM);
                  }
                },
              ),
              const Text('or'),
              IconButton(
                icon: const Icon(Icons.upload_file_rounded,size: 44),
                // label: const Text("Pick File"),
                onPressed: () async {



                  final picker = ImagePicker();
                  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

                  if (pickedFile != null) {
                    final bytes = await pickedFile.readAsBytes();
                    final base64Str = base64Encode(bytes);
                    final filename = pickedFile.name; // 👈 gets the actual filename

                    liveCaseController.setBase64File(base64Str, filename); // pass both

                    Get.snackbar('Success', 'File selected successfully');
                  } else {
                    Get.snackbar('No file selected', '', snackPosition: SnackPosition.BOTTOM);
                  }
                },
              ),

            ],
          ),
          Obx(() {
            final imageBase64 = liveCaseController.base64File.value;
            final filename = liveCaseController.fileName.value;

            if (imageBase64.isNotEmpty) {
              return Column(
                children: [
                  Text('Selected: $filename'),
                  const SizedBox(height: 8),
                  Image.memory(
                    base64Decode(imageBase64),
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ],
              );
            } else {
              return const Text('No image selected');
            }
          }),

        ],
      ),
      textConfirm: 'Submit',
      textCancel: 'Cancel',
      onConfirm: () async {
        // Save remarks
        liveCaseController.setApprovalRemark(approvalController.text);
        liveCaseController.setRegistrationRemark(registrationController.text);



        // Optional: show loading
        Get.back(); // close the dialog
        // Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

        await submitLivestockForm();

      },
    );
  }
  bool isLoading = false;

  void showAlert(String title,String msg){
    Get.defaultDialog(title: title,middleText: msg,
        textConfirm: 'OK',
        onConfirm: (){
      Get.back();
    });
  }

}

class SelectedMedicine {
  final MedicineItem medicine;
  final String quantity;

  SelectedMedicine({required this.medicine, required this.quantity});
}

class MedicineEntry {
  final MedicineItem medicine;
  final String quantity;

  MedicineEntry({required this.medicine, required this.quantity});
}
