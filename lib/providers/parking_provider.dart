import 'package:flutter/foundation.dart';
import 'package:parking_app/models/parking_spot.dart';
import 'package:parking_app/models/booking.dart';
import 'package:parking_app/models/vehicle_type.dart';
import 'package:parking_app/models/payment_method.dart';
import 'package:parking_app/database/parking_spot_dao.dart';
import 'package:parking_app/database/booking_dao.dart';
import 'package:parking_app/database/notification_dao.dart';

class ParkingProvider with ChangeNotifier {
  final ParkingSpotDao _spotDao = ParkingSpotDao();
  final BookingDao _bookingDao = BookingDao();
  final NotificationDao _notificationDao = NotificationDao();

  List<ParkingSpot> _parkingSpots = [];
  final List<Booking> _bookings = [];
  ParkingSpot? _selectedSpot;
  bool _isLoading = false;

  List<ParkingSpot> get parkingSpots => _parkingSpots;
  List<Booking> get bookings => _bookings;
  ParkingSpot? get selectedSpot => _selectedSpot;
  bool get isLoading => _isLoading;

  ParkingProvider() {
    loadParkingSpots();
  }

  Future<void> loadParkingSpots() async {
    _isLoading = true;
    notifyListeners();

    try {
      _parkingSpots = await _spotDao.getAllParkingSpots();
      // If no spots loaded (e.g., on web), use mock data
      if (_parkingSpots.isEmpty) {
        _parkingSpots = _getMockParkingSpots();
      }
    } catch (e) {
      debugPrint('Error loading parking spots: $e');
      // On web or database error, use mock data
      _parkingSpots = _getMockParkingSpots();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<ParkingSpot> _getMockParkingSpots() {
    return [
      ParkingSpot(
        id: '1',
        name: 'City Center Mall',
        buildingType: 'Mall',
        latitude: 19.9975,
        longitude: 73.7898,
        address: 'City Center, Nashik Road, Nashik, Maharashtra 422101',
        pricePerHourCar: 50.00,
        pricePerHourBike: 20.00,
        totalCarSpots: 200,
        availableCarSpots: 65,
        totalBikeSpots: 120,
        availableBikeSpots: 48,
        rating: 4.6,
        amenities: [
          'Security',
          'EV Charging',
          'Covered',
          'Cinema',
          'Food Court',
          'Shopping'
        ],
      ),
      ParkingSpot(
        id: '2',
        name: 'Nashik Central Mall',
        buildingType: 'Mall',
        latitude: 19.9950,
        longitude: 73.7920,
        address: 'Central Mall, College Road, Nashik, Maharashtra 422005',
        pricePerHourCar: 60.00,
        pricePerHourBike: 25.00,
        totalCarSpots: 180,
        availableCarSpots: 52,
        totalBikeSpots: 100,
        availableBikeSpots: 38,
        rating: 4.7,
        amenities: [
          'Security',
          '24/7 Access',
          'Valet',
          'Cinema',
          'Shopping',
          'Restaurants'
        ],
      ),
      ParkingSpot(
        id: '3',
        name: 'PVR Cinemas Parking',
        buildingType: 'Cinema',
        latitude: 19.9980,
        longitude: 73.7900,
        address: 'PVR Cinemas, Trimbak Road, Nashik, Maharashtra 422002',
        pricePerHourCar: 40.00,
        pricePerHourBike: 15.00,
        totalCarSpots: 100,
        availableCarSpots: 32,
        totalBikeSpots: 80,
        availableBikeSpots: 25,
        rating: 4.4,
        amenities: ['Security', 'Covered', 'Movie Theater', 'Food Court'],
      ),
      ParkingSpot(
        id: '4',
        name: 'IT Park Nashik',
        buildingType: 'Building',
        latitude: 19.9930,
        longitude: 73.7950,
        address: 'IT Park, Satpur, Nashik, Maharashtra 422007',
        pricePerHourCar: 45.00,
        pricePerHourBike: 18.00,
        totalCarSpots: 150,
        availableCarSpots: 58,
        totalBikeSpots: 90,
        availableBikeSpots: 42,
        rating: 4.5,
        amenities: ['Security', 'EV Charging', 'Covered', '24/7 Access'],
      ),
      ParkingSpot(
        id: '5',
        name: 'Big Bazaar Parking',
        buildingType: 'Mall',
        latitude: 19.9960,
        longitude: 73.7880,
        address: 'Big Bazaar, Old Agra Road, Nashik, Maharashtra 422001',
        pricePerHourCar: 35.00,
        pricePerHourBike: 15.00,
        totalCarSpots: 250,
        availableCarSpots: 125,
        totalBikeSpots: 150,
        availableBikeSpots: 88,
        rating: 4.3,
        amenities: [
          'Security',
          'Covered',
          '24/7 Access',
          'Food Court',
          'Shopping'
        ],
      ),
      ParkingSpot(
        id: '6',
        name: 'Inox Cinemas Parking',
        buildingType: 'Cinema',
        latitude: 19.9990,
        longitude: 73.7910,
        address: 'Inox Cinemas, Gangapur Road, Nashik, Maharashtra 422013',
        pricePerHourCar: 45.00,
        pricePerHourBike: 18.00,
        totalCarSpots: 120,
        availableCarSpots: 45,
        totalBikeSpots: 70,
        availableBikeSpots: 28,
        rating: 4.6,
        amenities: [
          'Security',
          'Covered',
          'Cinema',
          'Food Court',
          'Restaurants'
        ],
      ),
      ParkingSpot(
        id: '7',
        name: 'Nashik Railway Station Parking',
        buildingType: 'Building',
        latitude: 19.9630,
        longitude: 73.8290,
        address: 'Nashik Road Railway Station, Nashik, Maharashtra 422101',
        pricePerHourCar: 30.00,
        pricePerHourBike: 12.00,
        totalCarSpots: 300,
        availableCarSpots: 145,
        totalBikeSpots: 200,
        availableBikeSpots: 95,
        rating: 4.2,
        amenities: ['Security', '24/7 Access', 'Covered'],
      ),
      ParkingSpot(
        id: '8',
        name: 'Shalimar Mall Parking',
        buildingType: 'Mall',
        latitude: 19.9940,
        longitude: 73.7930,
        address: 'Shalimar Mall, College Road, Nashik, Maharashtra 422005',
        pricePerHourCar: 55.00,
        pricePerHourBike: 22.00,
        totalCarSpots: 160,
        availableCarSpots: 48,
        totalBikeSpots: 95,
        availableBikeSpots: 35,
        rating: 4.5,
        amenities: [
          'Security',
          'Covered',
          'Cinema',
          'Gaming Zone',
          'Restaurants',
          'Shopping'
        ],
      ),
    ];
  }

  void setSelectedSpot(ParkingSpot? spot) {
    _selectedSpot = spot;
    notifyListeners();
  }

  Future<void> searchParkingSpots(String query) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    // In a real app, this would filter based on location/query
    _isLoading = false;
    notifyListeners();
  }

  Future<Booking> createBooking({
    required String userId,
    required ParkingSpot spot,
    required VehicleType vehicleType,
    String? vehicleNumber,
    required DateTime startTime,
    required DateTime endTime,
    String? eventName,
    PaymentMethod? paymentMethod,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Check availability
      final currentSpot = await _spotDao.getParkingSpotById(spot.id);
      if (currentSpot == null) {
        throw Exception('Parking spot not found');
      }

      if (vehicleType == VehicleType.car &&
          currentSpot.availableCarSpots <= 0) {
        throw Exception('No car parking spots available');
      }
      if (vehicleType == VehicleType.bike &&
          currentSpot.availableBikeSpots <= 0) {
        throw Exception('No bike parking spots available');
      }

      final hours = endTime.difference(startTime).inHours;
      final pricePerHour = vehicleType == VehicleType.car
          ? spot.pricePerHourCar
          : spot.pricePerHourBike;
      final totalPrice = pricePerHour * hours;

      // Generate unique booking number: BK-YYYYMMDD-HHMMSS-XXXX
      final now = DateTime.now();
      final bookingNumber =
          'BK-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-'
          '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}-'
          '${(now.millisecondsSinceEpoch % 10000).toString().padLeft(4, '0')}';

      final booking = Booking(
        id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
        bookingNumber: bookingNumber,
        userId: userId,
        parkingSpot: currentSpot,
        vehicleType: vehicleType,
        vehicleNumber: vehicleNumber,
        startTime: startTime,
        endTime: endTime,
        totalPrice: totalPrice,
        status: BookingStatus.confirmed,
        paymentMethod: paymentMethod,
        createdAt: DateTime.now(),
        eventName: eventName,
      );

      // Save booking to database
      await _bookingDao.createBooking(booking);

      // Update availability in database
      await _spotDao.updateParkingSpotAvailability(
        spotId: spot.id,
        isCar: vehicleType == VehicleType.car,
        change: -1,
      );

      // Refresh parking spots
      await loadParkingSpots();

      // Create notification
      try {
        await _notificationDao.createNotification(
          userId: userId,
          title: 'Booking Confirmed',
          body:
              'Your parking booking at ${spot.name} has been confirmed. Booking Number: $bookingNumber',
          type: 'booking',
        );

        // Create reminder notification (30 minutes before start)
        final reminderTime = startTime.subtract(const Duration(minutes: 30));
        if (reminderTime.isAfter(DateTime.now())) {
          // In a real app, use a background task scheduler
          // For now, we'll create it in the database
          await _notificationDao.createNotification(
            userId: userId,
            title: 'Reminder: Parking Booking',
            body: 'Your parking booking at ${spot.name} starts in 30 minutes',
            type: 'reminder',
          );
        }
      } catch (e) {
        // Ignore notification errors on web
        if (!e.toString().contains('UnsupportedError') &&
            !e.toString().contains('web') &&
            !e.toString().contains('SQLite')) {
          debugPrint('Error creating notification: $e');
        }
      }

      _isLoading = false;
      notifyListeners();

      return booking;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<List<Booking>> getUserBookings(String userId) async {
    debugPrint('📦 Fetching bookings for user: $userId');

    try {
      
      final bookings = await _bookingDao.getBookingsByUserId(userId);
      print("✅ Bookings fetched: ${bookings.length}");

      _bookings.clear();
      _bookings.addAll(bookings);
      notifyListeners();
      return bookings;
    } catch (e) {
      debugPrint('Error loading bookings: $e');
      return [];
    }
  }

  Future<void> cancelBooking(String bookingId) async {
  _isLoading = true;
  notifyListeners();

  try {
    debugPrint('🛑 Cancelling booking ID: $bookingId');

    final booking = await _bookingDao.getBookingById(bookingId);
    if (booking == null) {
      throw Exception('Booking not found');
    }

    // ✅ Update booking status in database
    await _bookingDao.updateBookingStatus(bookingId, BookingStatus.cancelled);
    debugPrint('✅ Booking status updated to cancelled');

    // ✅ Restore availability
    await _spotDao.updateParkingSpotAvailability(
      spotId: booking.parkingSpot.id,
      isCar: booking.vehicleType == VehicleType.car,
      change: 1,
    );
    debugPrint('✅ Parking availability restored');

    // ✅ Refresh local list
    _bookings.removeWhere((b) => b.id == bookingId);
    await getUserBookings(booking.userId);

    // ✅ Send notification
    await _notificationDao.createNotification(
      userId: booking.userId,
      title: 'Booking Cancelled',
      body:
          'Your booking at ${booking.parkingSpot.name} has been cancelled successfully.',
      type: 'booking',
    );

    debugPrint('📢 Cancellation notification created');
  } catch (e) {
    debugPrint('❌ Error cancelling booking: $e');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

}
