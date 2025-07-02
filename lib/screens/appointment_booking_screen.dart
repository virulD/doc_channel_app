import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dispensary.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import '../services/data_service.dart';
import 'appointment_confirmation_screen.dart';

class AppointmentBookingScreen extends StatefulWidget {
  final Dispensary dispensary;
  final Doctor doctor;

  const AppointmentBookingScreen({
    super.key,
    required this.dispensary,
    required this.doctor,
  });

  @override
  _AppointmentBookingScreenState createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedDate = '';
  String _selectedTimeSlot = '';
  String _selectedGender = 'Male';

  List<String> _availableDates = [];
  List<String> _availableTimeSlots = [];

  @override
  void initState() {
    super.initState();
    _generateAvailableDates();
  }

  void _generateAvailableDates() {
    DateTime now = DateTime.now();
    _availableDates = [];

    for (int i = 1; i <= 14; i++) {
      DateTime date = now.add(Duration(days: i));
      String dayName = DateFormat('EEEE').format(date);

      if (widget.doctor.availableDays.contains(dayName)) {
        _availableDates.add(DateFormat('yyyy-MM-dd').format(date));
      }
    }

    if (_availableDates.isNotEmpty) {
      _selectedDate = _availableDates.first;
      _updateAvailableTimeSlots();
    }
  }

  void _updateAvailableTimeSlots() {
    setState(() {
      _availableTimeSlots = List.from(widget.doctor.availableTimeSlots);
      if (_availableTimeSlots.isNotEmpty) {
        _selectedTimeSlot = _availableTimeSlots.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book Appointment',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF42A5F5),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF42A5F5),
              Color(0xFF1976D2),
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Doctor info
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                widget.doctor.imageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.person,
                                      size: 60, color: Colors.white);
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.doctor.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    widget.doctor.specialty,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    '\$${widget.doctor.consultationFee.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Booking form
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: _buildBookingForm(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookingForm() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Personal Information',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins')),
            const SizedBox(height: 20),
            _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person,
                validator: _required),
            const SizedBox(height: 16),
            _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail),
            const SizedBox(height: 16),
            _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: _required),
            const SizedBox(height: 16),
            _buildTextField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.location_on,
                maxLines: 2,
                validator: _required),
            const SizedBox(height: 16),
            const Text('Gender',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins')),
            const SizedBox(height: 8),
            Row(
              children: ['Male', 'Female', 'Other'].map((gender) {
                IconData icon = gender == 'Male'
                    ? Icons.male
                    : gender == 'Female'
                        ? Icons.female
                        : Icons.person;
                return Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildGenderOption(gender, icon)));
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text('Appointment Details',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins')),
            const SizedBox(height: 20),
            const Text('Select Date',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins')),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                DateTime now = DateTime.now();
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate.isNotEmpty ? DateTime.parse(_selectedDate) : now.add(const Duration(days: 1)),
                  firstDate: now.add(const Duration(days: 1)),
                  lastDate: now.add(const Duration(days: 14)),
                  selectableDayPredicate: (date) {
                    String dayName = DateFormat('EEEE').format(date);
                    return widget.doctor.availableDays.contains(dayName);
                  },
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
                    _updateAvailableTimeSlots();
                  });
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF42A5F5)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedDate.isNotEmpty
                            ? DateFormat('EEE, MMM dd, yyyy').format(DateTime.parse(_selectedDate))
                            : 'Select a date',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Select Time',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins')),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: _availableTimeSlots.map((timeSlot) {
                bool isSelected = _selectedTimeSlot == timeSlot;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTimeSlot = timeSlot;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF42A5F5)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: isSelected
                              ? const Color(0xFF42A5F5)
                              : Colors.grey[300]!),
                    ),
                    child: Text(timeSlot,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black87,
                            fontFamily: 'Poppins')),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _bookAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF42A5F5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text('Book Appointment',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF42A5F5)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF42A5F5) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? const Color(0xFF42A5F5) : Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: isSelected ? Colors.white : Colors.grey[600], size: 24),
            const SizedBox(height: 4),
            Text(gender,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }

  String? _required(String? value) =>
      value == null || value.isEmpty ? 'Required' : null;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Enter email';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value))
      return 'Invalid email';
    return null;
  }

  void _bookAppointment() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate.isEmpty || _selectedTimeSlot.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select date and time'),
            backgroundColor: Colors.red),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF42A5F5))),
      ),
    );

    try {
      UserDetails userDetails = UserDetails(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        dateOfBirth: '',
        gender: _selectedGender,
        address: _addressController.text,
      );

      Appointment appointment = await DataService.bookAppointment(
        userId: DateTime.now().millisecondsSinceEpoch.toString(),
        doctorId: widget.doctor.id,
        dispensaryId: widget.dispensary.id,
        date: _selectedDate,
        timeSlot: _selectedTimeSlot,
        userDetails: userDetails,
      );

      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AppointmentConfirmationScreen(
            appointment: appointment,
            dispensary: widget.dispensary,
            doctor: widget.doctor,
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to book appointment'),
            backgroundColor: Colors.red),
      );
    }
  }
}
