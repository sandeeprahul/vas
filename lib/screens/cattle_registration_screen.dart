import 'package:flutter/material.dart';

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

  // Dynamic form fields based on registration type
  List<Widget> _buildFormFields() {
    switch (_registrationType) {
      case 'Individual Registration':
        return [
          _buildDropdown('Type', ['Individual Registration'], 'Type'),
          _buildDropdown('Species', ['Xyz', 'ABC'], 'Species'),
          _buildDropdown('Gender', ['M', 'F'], 'Gender'),
          _buildTextField('Cattle\'s Age (Years)', 'Years'),
          _buildTextField('Cattle\'s Age (Months)', 'Months'),
          _buildDropdown('Cattle\'s Type', ['Buffalo', 'Goat', 'Poultry'], 'CattleType'),
          _buildDropdown('Cattle\'s Breed', ['Cross', 'Descriptive'], 'Breed'),
          _buildDropdown('Event Type', ['TREATMENT', 'BLOOD SMEAR', 'POLITRY VACCINATION'], 'EventType'),
          _buildDropdown('Case Type', ['Bloat/Tympany', 'FOWLPOX'], 'CaseType'),
          _buildTextField('Remark', 'Remark'),
        ];
      case 'Lab Sample':
        return [
          _buildDropdown('Type', ['Lab Sample'], 'Type'),
          _buildDropdown('Species', ['Xyz', 'ABC'], 'Species'),
          _buildDropdown('Gender', ['M', 'F'], 'Gender'),
          _buildTextField('Cattle\'s Age (Years)', 'Years'),
          _buildTextField('Cattle\'s Age (Months)', 'Months'),
          _buildDropdown('Cattle\'s Type', ['Buffalo', 'Goat', 'Poultry'], 'CattleType'),
          _buildDropdown('Cattle\'s Breed', ['Cross', 'Descriptive'], 'Breed'),
          _buildDropdown('Event Type', ['BLOOD SMEAR'], 'EventType'),
          _buildDropdown('Case Type', ['BLOOD SMEAR'], 'CaseType'),
          _buildDropdown('Result', ['Positive', 'Negative'], 'Result'),
          _buildTextField('Item Name', 'ItemName'),
          _buildTextField('Quantity', 'Quantity'),
          _buildTextField('Unit', 'Unit'),
          _buildTextField('Remark', 'Remark'),
        ];
      case 'Mass Registration':
        return [
          _buildDropdown('Type', ['Mass Registration'], 'Type'),
          _buildDropdown('Species', ['ABC'], 'Species'),
          _buildTextField('No of Species', 'NoOfSpecies'),
          _buildTextField('Cattle\'s Age (Years)', 'Years'),
          _buildTextField('Cattle\'s Age (Months)', 'Months'),
          _buildDropdown('Cattle\'s Type', ['Poultry'], 'CattleType'),
          _buildDropdown('Cattle\'s Breed', ['Descriptive'], 'Breed'),
          _buildDropdown('Event Type', ['POLITRY VACCINATION'], 'EventType'),
          _buildDropdown('Case Type', ['FOWLPOX'], 'CaseType'),
          _buildTextField('Remark', 'Remark'),
          _buildTextField('Item Name', 'ItemName'),
          _buildTextField('Quantity', 'Quantity'),
          _buildTextField('Unit', 'Unit'),
        ];
      default:
        return [];
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cattle Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Registration Type'),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Register Case'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}