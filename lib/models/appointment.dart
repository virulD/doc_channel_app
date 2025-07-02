class Appointment {
  final String id;
  final String userId;
  final String doctorId;
  final String dispensaryId;
  final String date;
  final String timeSlot;
  final String status;
  final double totalBill;
  final UserDetails userDetails;

  Appointment({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.dispensaryId,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.totalBill,
    required this.userDetails,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      userId: json['userId'],
      doctorId: json['doctorId'],
      dispensaryId: json['dispensaryId'],
      date: json['date'],
      timeSlot: json['timeSlot'],
      status: json['status'],
      totalBill: json['totalBill'].toDouble(),
      userDetails: UserDetails.fromJson(json['userDetails']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'doctorId': doctorId,
      'dispensaryId': dispensaryId,
      'date': date,
      'timeSlot': timeSlot,
      'status': status,
      'totalBill': totalBill,
      'userDetails': userDetails.toJson(),
    };
  }
}

class UserDetails {
  final String name;
  final String email;
  final String phone;
  final String dateOfBirth;
  final String gender;
  final String address;

  UserDetails({
    required this.name,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'address': address,
    };
  }
} 