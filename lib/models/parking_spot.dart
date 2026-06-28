class ParkingSpot {
  final String id;
  final String name;
  final String buildingType; // 'Mall', 'Building', 'Cinema', etc.
  final double latitude;
  final double longitude;
  final String address;
  final double pricePerHourCar;
  final double pricePerHourBike;
  final int totalCarSpots;
  final int availableCarSpots;
  final int totalBikeSpots;
  final int availableBikeSpots;
  final double rating;
  final String imageUrl;
  final List<String> amenities;
  final bool isAvailable;

  ParkingSpot({
    required this.id,
    required this.name,
    this.buildingType = 'Mall',
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.pricePerHourCar,
    required this.pricePerHourBike,
    required this.totalCarSpots,
    required this.availableCarSpots,
    required this.totalBikeSpots,
    required this.availableBikeSpots,
    required this.rating,
    this.imageUrl = '',
    this.amenities = const [],
    this.isAvailable = true,
  });

  // Legacy support - will be removed
  @Deprecated('Use pricePerHourCar or pricePerHourBike instead')
  double get pricePerHour => pricePerHourCar;
  
  @Deprecated('Use totalCarSpots + totalBikeSpots instead')
  int get totalSpots => totalCarSpots + totalBikeSpots;
  
  @Deprecated('Use availableCarSpots + availableBikeSpots instead')
  int get availableSpots => availableCarSpots + availableBikeSpots;

  factory ParkingSpot.fromJson(Map<String, dynamic> json) {
    return ParkingSpot(
      id: json['id'] as String,
      name: json['name'] as String,
      buildingType: json['buildingType'] as String? ?? 'Mall',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      pricePerHourCar: (json['pricePerHourCar'] as num?)?.toDouble() ?? 
                       (json['pricePerHour'] as num).toDouble(),
      pricePerHourBike: (json['pricePerHourBike'] as num?)?.toDouble() ?? 
                        ((json['pricePerHour'] as num).toDouble() * 0.5),
      totalCarSpots: json['totalCarSpots'] as int? ?? 
                     ((json['totalSpots'] as int?) ?? 0),
      availableCarSpots: json['availableCarSpots'] as int? ?? 
                         ((json['availableSpots'] as int?) ?? 0),
      totalBikeSpots: json['totalBikeSpots'] as int? ?? 0,
      availableBikeSpots: json['availableBikeSpots'] as int? ?? 0,
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String? ?? '',
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'buildingType': buildingType,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'pricePerHourCar': pricePerHourCar,
      'pricePerHourBike': pricePerHourBike,
      'totalCarSpots': totalCarSpots,
      'availableCarSpots': availableCarSpots,
      'totalBikeSpots': totalBikeSpots,
      'availableBikeSpots': availableBikeSpots,
      'rating': rating,
      'imageUrl': imageUrl,
      'amenities': amenities,
      'isAvailable': isAvailable,
    };
  }
}

