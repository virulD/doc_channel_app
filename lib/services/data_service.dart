import '../models/dispensary.dart';
import '../models/doctor.dart';
import '../models/appointment.dart';
import 'location_service.dart';

class DataService {
  static final List<Dispensary> _dispensaries = getMockDispensaries();
  static final Map<String, List<Doctor>> _doctors = {};

  static void addDispensary(Dispensary dispensary) {
    _dispensaries.add(dispensary);
  }

  static void addDoctor(Doctor doctor) {
    if (_doctors[doctor.dispensaryId] == null) {
      _doctors[doctor.dispensaryId] = [];
    }
    _doctors[doctor.dispensaryId]!.add(doctor);
  }

  static List<Dispensary> getMockDispensaries() {
    return [
      Dispensary(
        id: '1',
        name: 'Green Leaf Medical Center',
        address: '123 Main Street, Downtown',
        latitude: 40.7128,
        longitude: -74.0060,
        phone: '+1-555-0123',
        imageUrl: 'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=Green+Leaf',
        rating: 4.5,
        specialties: ['General Medicine', 'Pain Management', 'Mental Health'],
      ),
      Dispensary(
        id: '2',
        name: 'Wellness Dispensary',
        address: '456 Oak Avenue, Midtown',
        latitude: 40.7589,
        longitude: -73.9851,
        phone: '+1-555-0456',
        imageUrl: 'https://via.placeholder.com/300x200/2196F3/FFFFFF?text=Wellness',
        rating: 4.8,
        specialties: ['Cardiology', 'Neurology', 'Orthopedics'],
      ),
      Dispensary(
        id: '3',
        name: 'Health First Clinic',
        address: '789 Pine Street, Uptown',
        latitude: 40.7505,
        longitude: -73.9934,
        phone: '+1-555-0789',
        imageUrl: 'https://via.placeholder.com/300x200/FF9800/FFFFFF?text=Health+First',
        rating: 4.2,
        specialties: ['Dermatology', 'Pediatrics', 'Gynecology'],
      ),
      Dispensary(
        id: '4',
        name: 'Care Plus Medical',
        address: '321 Elm Street, Westside',
        latitude: 40.7648,
        longitude: -73.9808,
        phone: '+1-555-0321',
        imageUrl: 'https://via.placeholder.com/300x200/9C27B0/FFFFFF?text=Care+Plus',
        rating: 4.6,
        specialties: ['Oncology', 'Radiology', 'Emergency Medicine'],
      ),
    ];
  }

  static List<Doctor> getMockDoctors(String dispensaryId) {
    if (_doctors.containsKey(dispensaryId)) {
      return _doctors[dispensaryId]!;
    }
    final mockDoctors = [
      Doctor(
        id: '1',
        name: 'Dr. Sarah Johnson',
        specialty: 'General Medicine',
        imageUrl: 'https://via.placeholder.com/150x150/4CAF50/FFFFFF?text=Dr.+Sarah',
        rating: 4.7,
        experience: 8,
        education: 'Harvard Medical School',
        consultationFee: 150.0,
        availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
        availableTimeSlots: ['09:00 AM', '10:00 AM', '11:00 AM', '02:00 PM', '03:00 PM'],
        dispensaryId: dispensaryId,
      ),
      Doctor(
        id: '2',
        name: 'Dr. Michael Chen',
        specialty: 'Cardiology',
        imageUrl: 'https://via.placeholder.com/150x150/2196F3/FFFFFF?text=Dr.+Michael',
        rating: 4.9,
        experience: 12,
        education: 'Stanford Medical School',
        consultationFee: 200.0,
        availableDays: ['Monday', 'Wednesday', 'Friday'],
        availableTimeSlots: ['10:00 AM', '11:00 AM', '02:00 PM', '03:00 PM'],
        dispensaryId: dispensaryId,
      ),
      Doctor(
        id: '3',
        name: 'Dr. Emily Rodriguez',
        specialty: 'Pediatrics',
        imageUrl: 'https://via.placeholder.com/150x150/FF9800/FFFFFF?text=Dr.+Emily',
        rating: 4.6,
        experience: 6,
        education: 'Yale Medical School',
        consultationFee: 120.0,
        availableDays: ['Tuesday', 'Thursday', 'Saturday'],
        availableTimeSlots: ['09:00 AM', '10:00 AM', '11:00 AM', '01:00 PM'],
        dispensaryId: dispensaryId,
      ),
      Doctor(
        id: '4',
        name: 'Dr. James Wilson',
        specialty: 'Neurology',
        imageUrl: 'https://via.placeholder.com/150x150/9C27B0/FFFFFF?text=Dr.+James',
        rating: 4.8,
        experience: 15,
        education: 'Johns Hopkins Medical School',
        consultationFee: 250.0,
        availableDays: ['Monday', 'Tuesday', 'Thursday'],
        availableTimeSlots: ['02:00 PM', '03:00 PM', '04:00 PM'],
        dispensaryId: dispensaryId,
      ),
    ];
    _doctors[dispensaryId] = mockDoctors;
    return mockDoctors;
  }

  static Future<List<Dispensary>> getNearbyDispensaries() async {
    if (_dispensaries.isNotEmpty) {
      // Get user's current location
      var userLocation = await LocationService.getCurrentLocation();
      
      if (userLocation != null) {
        // Calculate distances and sort by nearest
        for (var dispensary in _dispensaries) {
          double distance = LocationService.calculateDistance(
            userLocation.latitude,
            userLocation.longitude,
            dispensary.latitude,
            dispensary.longitude,
          );
          dispensary = Dispensary(
            id: dispensary.id,
            name: dispensary.name,
            address: dispensary.address,
            latitude: dispensary.latitude,
            longitude: dispensary.longitude,
            phone: dispensary.phone,
            imageUrl: dispensary.imageUrl,
            rating: dispensary.rating,
            specialties: dispensary.specialties,
            distance: distance,
          );
        }
        
        // Sort by distance
        _dispensaries.sort((a, b) => a.distance.compareTo(b.distance));
      }
    }
    
    return _dispensaries;
  }

  static Future<Appointment> bookAppointment({
    required String userId,
    required String doctorId,
    required String dispensaryId,
    required String date,
    required String timeSlot,
    required UserDetails userDetails,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Get doctor details to calculate bill
    List<Doctor> doctors = getMockDoctors(dispensaryId);
    Doctor selectedDoctor = doctors.firstWhere((d) => d.id == doctorId);
    
    // Generate appointment ID
    String appointmentId = DateTime.now().millisecondsSinceEpoch.toString();
    
    return Appointment(
      id: appointmentId,
      userId: userId,
      doctorId: doctorId,
      dispensaryId: dispensaryId,
      date: date,
      timeSlot: timeSlot,
      status: 'Confirmed',
      totalBill: selectedDoctor.consultationFee,
      userDetails: userDetails,
    );
  }
} 