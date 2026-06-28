import 'package:parking_app/models/parking_spot.dart';
import 'package:parking_app/models/vehicle_type.dart';
import 'package:parking_app/models/payment_method.dart';

enum BookingStatus {
  pending,
  confirmed,
  active,
  completed,
  cancelled,
}

class Booking {
  final String id;
  final String bookingNumber; // Unique booking number for mall staff
  final String userId;
  final ParkingSpot parkingSpot;
  final VehicleType vehicleType;
  final String? vehicleNumber;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final BookingStatus status;
  final String? paymentId;
  final PaymentMethod? paymentMethod;
  final DateTime createdAt;
  final String? eventName; // e.g., "Movie: Avengers", "Shopping", etc.

  Booking({
    required this.id,
    required this.bookingNumber,
    required this.userId,
    required this.parkingSpot,
    required this.vehicleType,
    this.vehicleNumber,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
    this.paymentId,
    this.paymentMethod,
    required this.createdAt,
    this.eventName,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      bookingNumber: json['bookingNumber'] as String? ?? 
                     'BK-${DateTime.now().millisecondsSinceEpoch}',
      userId: json['userId'] as String,
      parkingSpot: ParkingSpot.fromJson(json['parkingSpot'] as Map<String, dynamic>),
      vehicleType: VehicleType.values.firstWhere(
        (e) => e.toString() == json['vehicleType'],
        orElse: () => VehicleType.car,
      ),
      vehicleNumber: json['vehicleNumber'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      paymentId: json['paymentId'] as String?,
      paymentMethod: json['paymentMethod'] != null
          ? PaymentMethod.values.firstWhere(
              (e) => e.toString() == json['paymentMethod'],
              orElse: () => PaymentMethod.upi,
            )
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      eventName: json['eventName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingNumber': bookingNumber,
      'userId': userId,
      'parkingSpot': parkingSpot.toJson(),
      'vehicleType': vehicleType.toString(),
      'vehicleNumber': vehicleNumber,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'totalPrice': totalPrice,
      'status': status.toString(),
      'paymentId': paymentId,
      'paymentMethod': paymentMethod?.toString(),
      'createdAt': createdAt.toIso8601String(),
      'eventName': eventName,
    };
  }

  String get statusText {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.active:
        return 'Active';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}

