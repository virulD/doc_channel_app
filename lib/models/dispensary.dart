class Dispensary {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String imageUrl;
  final double rating;
  final List<String> specialties;
  final double distance; // Distance from user's location

  Dispensary({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.imageUrl,
    required this.rating,
    required this.specialties,
    this.distance = 0.0,
  });

  factory Dispensary.fromJson(Map<String, dynamic> json) {
    return Dispensary(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      phone: json['phone'],
      imageUrl: json['imageUrl'],
      rating: json['rating'].toDouble(),
      specialties: List<String>.from(json['specialties']),
      distance: json['distance']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'imageUrl': imageUrl,
      'rating': rating,
      'specialties': specialties,
      'distance': distance,
    };
  }
} 