import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vas/controllers/user_controller.dart';
import 'package:vas/screens/case_details_screen.dart';
import 'package:vas/screens/dashboard_page.dart';
import 'package:vas/services/api_service.dart';

import '../controllers/live_stock_controller.dart';
import '../data/DiseaseType.dart';
import '../data/IncidentType.dart';
import '../data/MedicineItem.dart';
import '../data/PatientType.dart';

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
  String? _selectedCaseType;

  // Dynamic form fields based on registration type

  Future<void> loadIncidentData() async {
    ApiService apiService = ApiService();
    final incidentResponse =
        await apiService.getRequestList("/GetIncidentTypes");
    print(incidentResponse);
    final subIncidentResponse =
        await apiService.getRequestList("/GetIncidentSubTypes");

    setState(() {
      _incidentTypes = (incidentResponse as List)
          .map((e) => IncidentType.fromJson(e))
          .toList();

      _incidentSubTypes = (subIncidentResponse as List)
          .map((e) => IncidentSubType.fromJson(e))
          .toList();
    });
  }

  Widget _buildEventTypeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Event Type'),
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

          _filteredSubTypes = _incidentSubTypes
              .where((s) => s.incidentID == selectedId)
              .map((s) => s.subType)
              .toList();

          _selectedCaseType = null;
        });
      },
    );
  }

  Widget _buildCaseTypeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Case Type'),
      value: _selectedCaseType,
      items: _filteredSubTypes.map((caseType) {
        return DropdownMenuItem<String>(
          value: caseType,
          child: Text(caseType),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCaseType = value;
        });
      },
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
          Row(
            children: [
              Expanded(
                  child: _buildTextField('Cattle\'s Age (Years)', 'Years')),
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
          const SizedBox(height: 66),
          const Text(
            'Items',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
          ),
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
          Row(
            children: [
              Expanded(
                  child: _buildTextField('Cattle\'s Age (Years)', 'Years')),
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
          const SizedBox(height: 66),
          const Text(
            'Items',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
          ),
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
          Row(
            children: [
              Expanded(
                  child: _buildTextField('Cattle\'s Age (Years)', 'Years')),
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
          const Text(
            'Items',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          buildMedicineSelector(),
          const SizedBox(height: 10),
        ];
      default:
        return [];
    }
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
  List<String> _breedOptions = [];

  String? _selectedType;
  String? _selectedBreed;

  Future<void> loadPatientTypes() async {
    ApiService apiService = ApiService();
    final response = await apiService.getRequest(
      "/GetPatientTypes",
    );
    print("loadPatientTypes");
    print("${response}");
    if (response != null) {
      setState(() {
        _types = (response['p_Type_Data'] as List)
            .map((e) => PatientType.fromJson(e))
            .toList();

        _allSubtypes = (response['p_SubType_Data'] as List)
            .map((e) => PatientSubType.fromJson(e))
            .toList();
      });
    }
  }

  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Cattle\'s Type'),
      value: _selectedType,
      items: _types.map((type) {
        return DropdownMenuItem(
          value: type.pT_TEXT,
          child: Text(type.pT_TEXT),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedType = value;
          _breedOptions = _allSubtypes
              .where((s) =>
                  s.pT_ID == _types.firstWhere((t) => t.pT_TEXT == value).pT_ID)
              .map((s) => s.ptS_TEXT)
              .toList();
          _selectedBreed = null; // reset breed on type change
        });
      },
    );
  }

  Widget _buildBreedDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Cattle\'s Breed'),
      value: _selectedBreed,
      items: _breedOptions.map((breed) {
        return DropdownMenuItem(
          value: breed,
          child: Text(breed),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedBreed = value;
        });
      },
    );
  }

  List<MedicineItem> medicineList = []; // from API
  List<MedicineItem> selectedMedicines = [];

  MedicineItem? selectedMedicine;

  String? selectedDisease;
  MedicineItem? selectedItem;

  Future<void> fetchMedicines() async {
    ApiService apiService = ApiService();
    UserController userController = Get.put(UserController());
    final response = await apiService
        .getRequest('/GetMedicines/${userController.userId.value}/1/100');
    if (response != null) {
      List<dynamic> records = response['records'];
      medicineList = records.map((e) {
        return MedicineItem(
          itemName: e['item_Name'] ?? '',
          itemUnit: e['item_Unit'] ?? '',
          itemNumber: e['item_Number'] ?? '',
        );
      }).toList();
      setState(() {});
    }
  }

  TextEditingController quantityController = TextEditingController();

  Widget buildMedicineSelector() {
    return Column(
      children: [
        Row(
          children: [
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
                decoration: const InputDecoration(labelText: 'Select Medicine'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (selectedMedicine != null &&
                  quantityController.text.isNotEmpty) {
                setState(() {
                  selectedMedicines.add(MedicineItem(
                    quantity: quantityController.text,
                    itemName: selectedMedicine!.itemName,
                    itemUnit: selectedMedicine!.itemUnit,
                    itemNumber: selectedMedicine!.itemNumber,
                  ));
                  quantityController.clear();
                });
              }
            },
            child: const Text('Add Medicine'),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Card(
          color: Colors.blue,
          child: Column(
            children: [
              Card(
                // margin: const EdgeInsets.only(top: 6),
                color: Colors.blue.shade100,
                child: const Row(
                  // mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Expanded(
                        child: Text(
                      'Item No',
                      textAlign: TextAlign.center,
                    )),
                    Expanded(child: Text('Name', textAlign: TextAlign.center)),
                    Expanded(
                        child: Text('Quantity', textAlign: TextAlign.center)),
                    Expanded(child: Text('Units', textAlign: TextAlign.center)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ...selectedMedicines.map((entry) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: Text(
                        '${entry.itemNumber} ',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      )),
                      Expanded(
                          child: Text('${entry.itemName} ',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white))),
                      Expanded(
                          child: Text(entry.quantity,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white))),
                      Expanded(
                          child: Text(entry.itemUnit,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white))),
                    ],
                  )),
              const SizedBox(
                height: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> options, String key) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
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
        });
      },
    );
  }

  Widget _buildTextField(String label, String key) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      onChanged: (value) {
        setState(() {
          _formData[key] = value;
        });
      },
    );
  }

  List<DiseaseType> _diseaseTypes = [];

  Future<void> loadDiseaseTypes() async {
    ApiService apiService = ApiService();
    final diseaseResponse =
        await apiService.getRequestList("/GetDiseaseTypes/1888");

    if (diseaseResponse != null && diseaseResponse is List) {
      setState(() {
        _diseaseTypes =
            diseaseResponse.map((e) => DiseaseType.fromJson(e)).toList();
      });
    } else {
      print("Failed to load disease types or response was not a list");
    }
  }

  // String? selectedDisease;

  Widget buildDiseaseDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Disease Type',
        // border: OutlineInputBorder(),
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
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Form Data: $_formData');
      // You can now process the form data (e.g., send to an API)
    }
  }

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


  Map<String, dynamic> buildLivestockJson() {
    final liveCaseController = Get.put(LivestockController());
    final formData = liveCaseController.formData;
    return {
      // 'ambulance_no': formData['AmbulanceNo'],
      "LocationID": 29078,
      "medicine": selectedMedicines.map((med) => med.toJson()).toList(),
      "CattleCount": 1,
      "ImeiNumber": "OnePlus_NE2211_347695b2fc87f884",
      "UserId": 800,
      "VehicleId": 330,
      "latitude": 43.73155,
      "longitude": -79.76242,
      "OwnerNo": liveCaseController.formData['OwnersContactNo'],
      "OwnerName": liveCaseController.formData['Owners Name'],
      "districtId": 1,
      "blockId": 1,
      "villageId": -1,
      "Address": "-",
      "CattleName": liveCaseController.formData['Category'],
      "Gender": _formData['Gender'],
      "YearAge": _formData['Years'],
      "MonthAge": _formData['Months'],
      "DaysAge": _formData['Days'],
      "CattleType": _selectedType,
      "CattleSubType": _selectedBreed,
      "IncidentType": _selectedEventType,
      "IncidentSubType": _selectedCaseType,
      "ApprovalRemark": liveCaseController.approvalRemark.value,
      "RegnRemark": liveCaseController.registrationRemark.value,
      "PatientNumber": "",
      'docname1': liveCaseController.fileName,
      'doc1': liveCaseController.base64File,
      // 'selected_medicines': selectedMedicines.map((med) => med.toJson()).toList(),
    };

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cattle Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Registration Type'),
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
              ..._buildFormFields(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: showApprovalDialog,
                child: const Text('Register Case'),
              ),
            ],
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

        // Build JSON
        final Map<String, dynamic> payload = buildLivestockJson();

        // Optional: show loading
        Get.back(); // close the dialog
        Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

        await submitLivestockForm(
          formFields: buildLivestockJson(),
          documentFile: liveCaseController.selectedFile.value,
        );
        /*try {
          final response = await ApiService().postRequest('/CreateCase', payload);



          // Optional: handle response
          Get.back(); // close loading
          Get.snackbar('Success', 'Data submitted successfully');
        } catch (e) {
          Get.back(); // close loading
          Get.snackbar('Error', 'Submission failed: $e');
        }*/
      },
    );
  }
  Future<void> submitLivestockForm({
    required Map<String, dynamic> formFields,
    File? documentFile,
  }) async {
    final uri = Uri.parse('http://49.207.44.107/mvas/CreateCase'); // replace with actual URL
    final request = http.MultipartRequest('POST', uri);

    formFields.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    if (documentFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('doc1', documentFile.path),
      );
    }

    try {
      final response = await request.send();
      final result = await http.Response.fromStream(response);

      if (result.statusCode == 200) {
        Get.back(); // Close loading
        Get.defaultDialog(
          title: 'Success',
          middleText: 'Do you want to continue with the same owner?',
          textConfirm: 'Yes',
          textCancel: 'No',
          onConfirm: () {
            // Navigate to another screen
            Get.off(() => const CaseDetailsScreen());
          },
          onCancel: () {
            Get.put(LivestockController()).clearAll();
            Get.offAll(() => DashboardPage());
          },
        );
      } else {
        final body = jsonDecode(result.body);
        Get.back();
        Get.snackbar('Error', body['reasonPhrase'] ?? 'Unknown error');
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Exception: $e');
    }
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
