import 'package:parking_app/database/database_helper.dart';
import 'package:parking_app/models/parking_spot.dart';

class ParkingSpotDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<ParkingSpot>> getAllParkingSpots() async {
    final db = await _dbHelper.database;
    final spots = await db.query('parking_spots');
    
    return spots.map((map) => _parkingSpotFromMap(map)).toList();
  }

  Future<ParkingSpot?> getParkingSpotById(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'parking_spots',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    
    return result.isEmpty ? null : _parkingSpotFromMap(result.first);
  }

  Future<void> updateParkingSpotAvailability({
    required String spotId,
    required bool isCar,
    required int change,
  }) async {
    final db = await _dbHelper.database;
    final field = isCar ? 'available_car_spots' : 'available_bike_spots';
    
    // Get current value
    final current = await db.query(
      'parking_spots',
      columns: [field],
      where: 'id = ?',
      whereArgs: [spotId],
      limit: 1,
    );
    
    if (current.isEmpty) return;
    
    final currentValue = current.first[field] as int;
    final newValue = (currentValue + change).clamp(0, double.infinity).toInt();
    
    await db.update(
      'parking_spots',
      {field: newValue},
      where: 'id = ?',
      whereArgs: [spotId],
    );
  }

  ParkingSpot _parkingSpotFromMap(Map<String, dynamic> map) {
    return ParkingSpot(
      id: map['id'] as String,
      name: map['name'] as String,
      buildingType: map['building_type'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      address: map['address'] as String,
      pricePerHourCar: (map['price_per_hour_car'] as num).toDouble(),
      pricePerHourBike: (map['price_per_hour_bike'] as num).toDouble(),
      totalCarSpots: map['total_car_spots'] as int,
      availableCarSpots: map['available_car_spots'] as int,
      totalBikeSpots: map['total_bike_spots'] as int,
      availableBikeSpots: map['available_bike_spots'] as int,
      rating: (map['rating'] as num).toDouble(),
      imageUrl: map['image_url'] as String? ?? '',
      amenities: (map['amenities'] as String?)?.split(',') ?? [],
      isAvailable: (map['is_available'] as int) == 1,
    );
  }
}

