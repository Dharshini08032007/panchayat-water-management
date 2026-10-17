# NeerWatch

## Panchayat Water Management System

NeerWatch is a Flutter application prototype for improving communication between
Panchayat water-supply operators, residents, and administrators. It brings
water-supply schedules, water-issue complaints, and user account management
together in one mobile-friendly interface.

## Overview

Residents need reliable information about when water will be supplied and an
easy way to report problems such as low pressure, no supply, leaking pipes, or
dirty water. NeerWatch provides a simple role-based experience for:

- **Residents** to view schedules, submit complaints, and manage their profile.
- **Incharge operators** to access water-supply operations and resident issue
  information.
- **Administrators** to monitor Panchayat water-management information.

The current repository contains a functional UI prototype. Application state is
held in memory, so data is reset when the application is restarted.

## Features

### Authentication and roles

- Login using a phone number and password.
- Role selection for **User**, **Incharge**, and **Admin**.
- User self-registration with password confirmation and demo OTP verification.
- Profile editing and logout.

### Water-supply schedules

- View schedules by area or ward.
- Display supply date, start time, and end time.
- Show when an area has no schedule assigned.

The sample data includes:

- Ward 1 - River View
- Ward 2 - Temple Lane
- Ward 3 - Market Street
- Ward 4 - School Road

### Complaint management

- Submit a water-related complaint.
- Select an affected area and complaint type.
- Add an address and description.
- Attach a simulated site photo.
- View complaint statistics and previously submitted complaints.

Available complaint types include:

- Low pressure
- No supply
- Pipe leakage
- Dirty water
- Valve issue

### User experience

- Material 3 interface with a water-themed visual design.
- Responsive Flutter layouts for supported desktop and web targets.
- Bottom navigation for Home, Complaints, and Profile sections.
- Inline validation and feedback messages for login, signup, and complaint
  actions.

## Technology stack

- **Framework:** Flutter
- **Language:** Dart
- **UI:** Material 3
- **State management:** `ChangeNotifier` with an inherited
  `NeerWatchScope`
- **Icons:** Material Icons and `cupertino_icons`
- **Persistence/backend:** Not yet connected; prototype data is stored in
  memory
- **Platforms:** Android, iOS, Web, Windows, macOS, and Linux targets
  supported by the Flutter project configuration

## Requirements

- Flutter SDK compatible with Dart `^3.11.5`
- A configured Flutter device or desktop target
- Android Studio and an Android SDK for Android builds
- Xcode for iOS or macOS builds
- Visual Studio with the Desktop development with C++ workload for Windows
  desktop builds

Check the local Flutter installation with:

```bash
flutter doctor
```

## Getting started

Clone the repository and open the project directory:

```bash
git clone <repository-url>
cd water
flutter pub get
```

Run the application on a connected device:

```bash
flutter devices
flutter run
```

To run on a specific target:

```bash
flutter run -d windows
flutter run -d chrome
```

## Demo accounts

The prototype includes the following local demo accounts:

| Role | Phone number | Password |
| --- | --- | --- |
| User | `9876543210` | `Water@123` |
| Incharge | `9000011111` | `Incharge@123` |
| Admin | `8000000000` | `Admin@123` |

User signup uses the demo OTP:

```text
246810
```

These credentials are included only for local development and demonstration.
They must not be used as a production authentication mechanism.

## Testing

Run the Flutter test suite with:

```bash
flutter test
```

The current widget test verifies that the NeerWatch login screen renders with
the application title and role-selection prompt.

## Project structure

```text
.
├── android/                 # Android platform project
├── ios/                     # iOS platform project
├── lib/
│   ├── main.dart            # Application entry point
│   └── src/
│       └── neerwatch_app.dart
│                            # App theme, state, screens, and widgets
├── macos/                   # macOS platform project
├── test/                    # Flutter widget tests
├── web/                     # Web platform project
├── windows/                 # Windows platform project
├── analysis_options.yaml    # Dart and Flutter lint configuration
├── pubspec.yaml             # Project metadata and dependencies
└── README.md
```
## Project purpose

NeerWatch is intended to make Panchayat water distribution more transparent,
help residents receive timely supply information, and organize the handling of
water-related complaints.
