import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/dispensary.dart';
import '../services/data_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddDoctorScreen extends StatefulWidget {
  @override
  _AddDoctorScreenState createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _feeController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _experienceController = TextEditingController();
  final _educationController = TextEditingController();
  final _availableDaysController = TextEditingController();
  final _availableTimeSlotsController = TextEditingController();
  String? _selectedDispensaryId;
  List<Dispensary> _dispensaries = [];
  bool _isLoading = false;
  final List<String> _specialties = [
    'General Medicine',
    'Cardiology',
    'Neurology',
    'Orthopedics',
    'Dermatology',
    'Pediatrics',
    'Gynecology',
    'Oncology',
    'Radiology',
    'Emergency Medicine',
  ];
  String? _selectedSpecialty;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    DataService.getNearbyDispensaries().then((list) {
      setState(() {
        _dispensaries = list;
        if (list.isNotEmpty) _selectedDispensaryId = list.first.id;
      });
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDispensaryId == null) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    final newDoctor = Doctor(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      specialty: _selectedSpecialty ?? '',
      imageUrl: _selectedImage?.path ?? '',
      rating: 0.0,
      experience: int.tryParse(_experienceController.text) ?? 0,
      education: _educationController.text,
      consultationFee: double.tryParse(_feeController.text) ?? 0.0,
      availableDays: _availableDaysController.text.split(',').map((e) => e.trim()).toList(),
      availableTimeSlots: _availableTimeSlotsController.text.split(',').map((e) => e.trim()).toList(),
      dispensaryId: _selectedDispensaryId!,
    );
    DataService.addDoctor(newDoctor);
    setState(() => _isLoading = false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Doctor added successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Doctor'),
        backgroundColor: const Color(0xFF42A5F5),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Doctor Name', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSpecialty,
                items: _specialties.map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s),
                )).toList(),
                onChanged: (v) => setState(() => _selectedSpecialty = v),
                decoration: const InputDecoration(labelText: 'Specialty', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Select specialty' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _feeController,
                decoration: const InputDecoration(labelText: 'Consultation Fee', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Enter fee' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _selectedImage != null
                      ? Image.file(_selectedImage!, width: 60, height: 60, fit: BoxFit.cover)
                      : Container(width: 60, height: 60, color: Colors.grey[200], child: const Icon(Icons.image, size: 40)),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload Image'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDispensaryId,
                items: _dispensaries.map((d) => DropdownMenuItem(
                  value: d.id,
                  child: Text(d.name),
                )).toList(),
                onChanged: (v) => setState(() => _selectedDispensaryId = v),
                decoration: const InputDecoration(labelText: 'Dispensary', border: OutlineInputBorder()),
                validator: (v) => v == null ? 'Select dispensary' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(labelText: 'Experience (years)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Enter experience' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _educationController,
                decoration: const InputDecoration(labelText: 'Education', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Enter education' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _availableDaysController,
                decoration: const InputDecoration(labelText: 'Available Days (comma separated)', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Enter available days' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _availableTimeSlotsController,
                decoration: const InputDecoration(labelText: 'Available Time Slots (comma separated)', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Enter available time slots' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                      : const Text('Add Doctor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 