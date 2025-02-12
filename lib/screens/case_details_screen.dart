import 'package:flutter/material.dart';

import 'cattle_registration_screen.dart';



class CaseDetailsScreen extends StatefulWidget {
  const CaseDetailsScreen({super.key});

  @override
  _CaseDetailsScreenState createState() =>
      _CaseDetailsScreenState();
}

class _CaseDetailsScreenState extends State<CaseDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ambulanceNoController = TextEditingController();
  final _ownerContactNoController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _districtController = TextEditingController();
  final _blockController = TextEditingController();
  final _villageController = TextEditingController();
  String _category = 'OBC'; // Default category

  final List<String> _categories = ['OBC', 'SC', 'ST', 'General'];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process the form data
      final formData = {
        'Ambulance No': _ambulanceNoController.text,
        'Owner\'s Contact No': _ownerContactNoController.text,
        'Owner\'s Name': _ownerNameController.text,
        'District': _districtController.text,
        'Block': _blockController.text,
        'Village': _villageController.text,
        'Category': _category,
      };
      print('Form Data: $formData');
      // Navigate to the next screen (Cattle Registration)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CattleRegistrationScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case Registration New'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _ambulanceNoController,
                decoration: const InputDecoration(
                  labelText: 'Ambulance No',
                  hintText: 'Enter Ambulance Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the ambulance number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ownerContactNoController,
                decoration: const InputDecoration(
                  labelText: 'Owner\'s Contact No',
                  hintText: 'Enter Owner\'s Contact Number',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the contact number';
                  }
                  if (value.length != 10) {
                    return 'Contact number must be 10 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ownerNameController,
                decoration: const InputDecoration(
                  labelText: 'Owner\'s Name',
                  hintText: 'Enter Owner\'s Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the owner\'s name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _districtController,
                decoration: const InputDecoration(
                  labelText: 'District',
                  hintText: 'Enter District',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the district';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _blockController,
                decoration: const InputDecoration(
                  labelText: 'Block',
                  hintText: 'Enter Block',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the block';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _villageController,
                decoration: const InputDecoration(
                  labelText: 'Village',
                  hintText: 'Enter Village',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the village';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Category'),
                value: _category,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Cattle Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

