import 'package:flutter/material.dart';
import 'package:vas/services/api_service.dart';

import '../data/IncidentType.dart';
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
    final incidentResponse = await apiService.getRequestList("/GetIncidentTypes");
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
          _buildTextField('Remark', 'Remark'),
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
          _buildTextField('Remark', 'Remark'),
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
          _buildTextField('Unit', 'Unit'),
        ];
      default:
        return [];
    }
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
                  'Lab Sample',
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
