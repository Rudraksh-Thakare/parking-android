# Parking Android App

A modern Flutter-based parking management app that helps users browse parking spots, book available spaces, manage bookings, and view profile-related information through a clean mobile interface.

## Features

* **User Authentication UI** – Login and registration flow
* **Parking Spot Listings** – Browse available parking locations with details
* **Parking Details Screen** – View price, rating, location, and availability information
* **Booking System** – Select parking spot and create bookings
* **Booking History** – View upcoming and previous bookings
* **Profile Management** – View and edit user profile details
* **Notifications Screen** – Basic notification interface for booking updates
* **Payment Method Screens** – UI prepared for future payment gateway integration
* **Local Data Handling** – Uses local database/helper structure for app data
* **Modern Flutter UI** – Clean Material Design-based interface
* **Multi-platform Flutter Structure** – Android, iOS, Web, Windows, Linux, and macOS folders included

## Tech Stack

* **Framework:** Flutter
* **Language:** Dart
* **State Management:** Provider
* **Local Storage:** Shared Preferences / SQLite structure
* **Database Helper:** SQFlite-based local database architecture
* **Networking Ready:** HTTP / Dio dependencies included for future backend integration
* **Maps Ready:** Google Maps / Flutter Map dependencies included for future location features

## Screens Included

* Login Screen
* Home Screen
* Parking Detail Screen
* Booking Screen
* Booking Receipt Screen
* Bookings History Screen
* Payment Method Screen
* Profile Screen
* Edit Profile Screen
* Notifications Screen
* Settings Screen
* Help & Support Screen

## Project Structure

```text
lib/
├── main.dart
├── database/
│   ├── database_helper.dart
│   ├── booking_dao.dart
│   ├── notification_dao.dart
│   ├── parking_spot_dao.dart
│   └── user_dao.dart
├── models/
│   ├── booking.dart
│   ├── parking_spot.dart
│   ├── payment_method.dart
│   └── vehicle_type.dart
├── providers/
│   ├── auth_provider.dart
│   ├── notification_provider.dart
│   └── parking_provider.dart
├── screens/
│   ├── booking_screen.dart
│   ├── booking_receipt_screen.dart
│   ├── bookings_screen.dart
│   ├── edit_profile_screen.dart
│   ├── help_support_screen.dart
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── notifications_screen.dart
│   ├── parking_detail_screen.dart
│   ├── payment_method_screen.dart
│   ├── payment_methods_screen.dart
│   ├── profile_screen.dart
│   └── settings_screen.dart
├── theme/
│   └── app_theme.dart
└── widgets/
    └── parking_spot_card.dart
```

## Getting Started

### Prerequisites

Make sure you have the following installed:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Android SDK
* Emulator or physical Android device

### Installation

1. Clone the repository:

```bash
git clone https://github.com/Rudraksh-Thakare/parking-android.git
```

2. Navigate to the project folder:

```bash
cd parking-android
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```

## Dependencies

Main dependencies used in this project:

* `provider` – State management
* `sqflite` – Local database support
* `shared_preferences` – Local key-value storage
* `intl` – Date and time formatting
* `http` – API request support
* `dio` – Advanced API request handling
* `google_maps_flutter` – Google Maps integration support
* `flutter_map` – Map UI support
* `url_launcher` – Open external links or apps

## Future Enhancements

* Real-time parking availability
* Backend API integration
* Google Maps live location support
* Online payment gateway integration
* QR code-based parking entry and exit
* Push notifications
* Admin dashboard for parking owners
* Parking filters by price, distance, and vehicle type
* User ratings and reviews
* Favorite parking spots

## Use Case

This project can be used as an academic or portfolio project to demonstrate:

* Flutter app development
* Provider-based state management
* Local database handling
* Mobile UI design
* Booking system workflow
* Scalable project folder structure

## Screenshots

Screenshots can be added here after running the app.

```text
assets/screenshots/
```

Recommended screenshots:

* Login Screen
* Home Screen
* Parking Detail Screen
* Booking Screen
* Booking History Screen
* Profile Screen

## Author

**Rudraksh Thakare**

GitHub: [Rudraksh-Thakare](https://github.com/Rudraksh-Thakare)

## License

This project is currently created for learning and portfolio purposes.
You can add an open-source license such as MIT by creating a separate `LICENSE` file.

---

Built with Flutter.
