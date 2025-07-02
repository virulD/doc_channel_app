class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String imageUrl;
  final double rating;
  final int experience;
  final String education;
  final double consultationFee;
  final List<String> availableDays;
  final List<String> availableTimeSlots;
  final String dispensaryId;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.rating,
    required this.experience,
    required this.education,
    required this.consultationFee,
    required this.availableDays,
    required this.availableTimeSlots,
    required this.dispensaryId,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      specialty: json['specialty'],
      imageUrl: json['imageUrl'],
      rating: json['rating'].toDouble(),
      experience: json['experience'],
      education: json['education'],
      consultationFee: json['consultationFee'].toDouble(),
      availableDays: List<String>.from(json['availableDays']),
      availableTimeSlots: List<String>.from(json['availableTimeSlots']),
      dispensaryId: json['dispensaryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'imageUrl': imageUrl,
      'rating': rating,
      'experience': experience,
      'education': education,
      'consultationFee': consultationFee,
      'availableDays': availableDays,
      'availableTimeSlots': availableTimeSlots,
      'dispensaryId': dispensaryId,
    };
  }
} 