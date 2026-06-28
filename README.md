# Parking App - Flutter Mobile Application

A Flutter-based mobile application that helps users browse parking spots, view parking details, and create parking bookings. The project is designed with a clean Material Design UI and structured using models, providers, screens, widgets, and theme files.

## Features

* User login and registration UI
* Home screen with parking spot listings
* Parking detail screen with spot information
* Booking screen with date and time selection
* Booking history screen
* User profile screen
* Dark mode support
* Reusable widgets and clean project structure
* Local storage support using SharedPreferences
* State management using Provider

## Tech Stack

* **Flutter**
* **Dart**
* **Provider** for state management
* **SharedPreferences** for local storage
* **intl** for date and time formatting
* **Material Design** for UI
* **http / dio** for future backend API integration

## Project Structure

```text
lib/
├── main.dart
├── models/
│   ├── parking_spot.dart
│   └── booking.dart
├── providers/
│   ├── auth_provider.dart
│   └── parking_provider.dart
├── screens/
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── parking_detail_screen.dart
│   ├── booking_screen.dart
│   ├── bookings_screen.dart
│   └── profile_screen.dart
├── widgets/
│   └── parking_spot_card.dart
└── theme/
    └── app_theme.dart
```

## State Management

This project uses **Provider** for managing application state.

* `AuthProvider` handles user authentication-related state.
* `ParkingProvider` manages parking spot data and booking-related operations.

## Screens Included

* Login / Registration Screen
* Home Screen
* Parking Detail Screen
* Booking Screen
* Booking History Screen
* Profile Screen

## Getting Started

### Prerequisites

Make sure you have the following installed:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Android Emulator or physical Android device

### Installation

1. Clone the repository

```bash
git clone https://github.com/Rudraksh-Thakare/parking-android.git
```

2. Go to the project folder

```bash
cd parking-android
```

3. Install dependencies

```bash
flutter pub get
```

4. Run the application

```bash
flutter run
```

## Future Enhancements

* Backend API integration
* Real-time parking availability
* Google Maps integration
* Online payment integration
* Push notifications for booking reminders
* Reviews and ratings for parking spots
* Parking filters based on price, distance, and availability

## About This Project

This project was created to practice Flutter mobile app development, UI design, navigation, state management using Provider, and local storage concepts. It helped improve understanding of Flutter app structure and reusable widget-based development.
