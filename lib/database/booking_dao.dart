import 'package:sqflite/sqflite.dart';
import 'package:parking_app/database/database_helper.dart';
import 'package:parking_app/models/booking.dart';
import 'package:parking_app/models/parking_spot.dart';
import 'package:parking_app/models/vehicle_type.dart';
import 'package:parking_app/models/payment_method.dart';

class BookingDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<String> createBooking(Booking booking) async {
    final db = await _dbHelper.database;
    
    await db.insert(
      'bookings',
      {
        'id': booking.id,
        'booking_number': booking.bookingNumber,
        'user_id': booking.userId,
        'parking_spot_id': booking.parkingSpot.id,
        'vehicle_type': booking.vehicleType.toString(),
        'vehicle_number': booking.vehicleNumber,
        'start_time': booking.startTime.toIso8601String(),
        'end_time': booking.endTime.toIso8601String(),
        'total_price': booking.totalPrice,
        'status': booking.status.toString(),
        'payment_id': booking.paymentId,
        'payment_method': booking.paymentMethod?.toString(),
        'event_name': booking.eventName,
        'created_at': booking.createdAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    return booking.id;
  }

  Future<List<Booking>> getBookingsByUserId(String userId) async {
    final db = await _dbHelper.database;
    
    final bookings = await db.query(
      'bookings',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    
    final parkingSpots = await db.query('parking_spots');
    final spotsMap = {for (var spot in parkingSpots) spot['id'] as String: spot};
    
    return bookings.map((bookingData) {
      final spotData = spotsMap[bookingData['parking_spot_id'] as String]!;
      return _bookingFromMap(bookingData, spotData);
    }).toList();
  }

  Future<Booking?> getBookingById(String bookingId) async {
    final db = await _dbHelper.database;
    
    final bookingData = await db.query(
      'bookings',
      where: 'id = ?',
      whereArgs: [bookingId],
      limit: 1,
    );
    
    if (bookingData.isEmpty) return null;
    
    final spotId = bookingData.first['parking_spot_id'] as String;
    final spotData = await db.query(
      'parking_spots',
      where: 'id = ?',
      whereArgs: [spotId],
      limit: 1,
    );
    
    if (spotData.isEmpty) return null;
    
    return _bookingFromMap(bookingData.first, spotData.first);
  }

  Future<void> updateBookingStatus(String bookingId, BookingStatus status) async {
  final db = await _dbHelper.database;

  print("🛠 Updating booking $bookingId to status: $status"); // <-- ADD THIS

  await db.update(
    'bookings',
    {'status': status.toString()},
    where: 'id = ?',
    whereArgs: [bookingId],
  );

  print("✅ Booking status updated in DB.");
}


  Booking _bookingFromMap(Map<String, dynamic> bookingData, Map<String, dynamic> spotData) {
    final spot = _parkingSpotFromMap(spotData);
    
    return Booking(
      id: bookingData['id'] as String,
      bookingNumber: bookingData['booking_number'] as String,
      userId: bookingData['user_id'] as String,
      parkingSpot: spot,
      vehicleType: VehicleType.values.firstWhere(
        (e) => e.toString() == bookingData['vehicle_type'],
        orElse: () => VehicleType.car,
      ),
      vehicleNumber: bookingData['vehicle_number'] as String?,
      startTime: DateTime.parse(bookingData['start_time'] as String),
      endTime: DateTime.parse(bookingData['end_time'] as String),
      totalPrice: (bookingData['total_price'] as num).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString() == bookingData['status'],
        orElse: () => BookingStatus.pending,
      ),
      paymentId: bookingData['payment_id'] as String?,
      paymentMethod: bookingData['payment_method'] != null
          ? PaymentMethod.values.firstWhere(
              (e) => e.toString() == bookingData['payment_method'],
              orElse: () => PaymentMethod.upi,
            )
          : null,
      createdAt: DateTime.parse(bookingData['created_at'] as String),
      eventName: bookingData['event_name'] as String?,
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

