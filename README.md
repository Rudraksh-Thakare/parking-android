# Parking App - Flutter

A modern, feature-rich parking app built with Flutter that helps users find and book parking spots easily.

## Features

- 🔐 **User Authentication** - Login and registration system
- 🗺️ **Parking Spot Discovery** - Browse available parking spots with details
- 📍 **Location-based Search** - Find parking spots near you
- 📅 **Booking System** - Book parking spots with date/time selection
- 💳 **Payment Integration** - Ready for payment gateway integration
- 📱 **Booking History** - View and manage your past and upcoming bookings
- ⭐ **Ratings & Reviews** - See ratings for parking spots
- 🎨 **Modern UI** - Beautiful Material Design 3 interface
- 🌙 **Dark Mode Support** - Automatic theme switching

## Screenshots

The app includes the following screens:
- Login/Registration Screen
- Home Screen with parking spot listings
- Parking Detail Screen
- Booking Screen
- Bookings History Screen
- Profile Screen

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

### Installation

1. **Clone the repository**
   ```bash
  git clone https://github.com/Rudraksh-Thakare/parking-android.git
  cd parking-android
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### For Android

1. Make sure you have Android Studio installed
2. Open the project in Android Studio
3. Connect an Android device or start an emulator
4. Run `flutter run`

### For iOS (macOS only)

1. Make sure you have Xcode installed
2. Open `ios/Runner.xcworkspace` in Xcode
3. Connect an iOS device or start a simulator
4. Run `flutter run`

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                  # Data models
│   ├── parking_spot.dart
│   └── booking.dart
├── providers/               # State management
│   ├── auth_provider.dart
│   └── parking_provider.dart
├── screens/                 # UI screens
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── parking_detail_screen.dart
│   ├── booking_screen.dart
│   ├── bookings_screen.dart
│   └── profile_screen.dart
├── widgets/                 # Reusable widgets
│   └── parking_spot_card.dart
└── theme/                   # App theming
    └── app_theme.dart
```

## State Management

The app uses **Provider** for state management:
- `AuthProvider` - Handles user authentication
- `ParkingProvider` - Manages parking spots and bookings

## Dependencies

- `provider` - State management
- `google_maps_flutter` - Map integration (ready for implementation)
- `shared_preferences` - Local storage
- `intl` - Date/time formatting
- `http` / `dio` - API calls (ready for backend integration)

## Customization

### Adding Real Backend

1. Update `lib/providers/parking_provider.dart` to make actual API calls
2. Update `lib/providers/auth_provider.dart` for real authentication
3. Configure API endpoints in a config file

### Adding Maps

1. Get Google Maps API key
2. Add to `android/app/src/main/AndroidManifest.xml` and `ios/Runner/AppDelegate.swift`
3. Implement map view in home screen

### Payment Integration

1. Integrate payment gateway (Stripe, Razorpay, etc.)
2. Update booking flow to include payment
3. Add payment confirmation screen

## Future Enhancements

- [ ] Real-time parking availability updates
- [ ] Push notifications for booking reminders
- [ ] QR code scanning for parking entry/exit
- [ ] Navigation to parking spots
- [ ] Multiple payment methods
- [ ] User reviews and ratings
- [ ] Favorite parking spots
- [ ] Parking spot filters (price, distance, amenities)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Support

For support, email support@parkingapp.com or create an issue in the repository.

---

Built with ❤️ using Flutter

