enum VehicleType {
  car,
  bike,
}

extension VehicleTypeExtension on VehicleType {
  String get displayName {
    switch (this) {
      case VehicleType.car:
        return 'Car';
      case VehicleType.bike:
        return 'Bike';
    }
  }

  String get icon {
    switch (this) {
      case VehicleType.car:
        return '🚗';
      case VehicleType.bike:
        return '🏍️';
    }
  }
}

