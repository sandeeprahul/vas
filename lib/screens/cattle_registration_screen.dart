import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vas/controllers/user_controller.dart';
import 'package:vas/services/api_service.dart';

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
                          child: Text('${entry.itemNumber} ',
                              textAlign: TextAlign.center,style: TextStyle(color: Colors.white),)),
                      Expanded(
                          child: Text('${entry.itemName} ',
                              textAlign: TextAlign.center,style: TextStyle(color: Colors.white))),
                      Expanded(
                          child: Text(entry.quantity,
                              textAlign: TextAlign.center,style: TextStyle(color: Colors.white))),
                      Expanded(
                          child: Text(entry.itemUnit,
                              textAlign: TextAlign.center,style: TextStyle(color: Colors.white))),
                    ],
                  )),
              const SizedBox(height: 6,),
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
                onPressed: _submitForm,
                child: const Text('Register Case'),
              ),
            ],
          ),
        ),
      ),
    );
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
