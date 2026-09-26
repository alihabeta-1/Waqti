# Waqti

Waqti is a Flutter appointment booking application built as a technical task focused on scheduling logic, state management, clean architecture, and responsive UI.

The application works entirely with local data and does not require an API or backend.

## Overview

Waqti allows users to select a date, choose a booking duration, view valid appointment times, and confirm a booking.

Working hours:

- 9:00 AM to 6:00 PM
- Each time slot is 30 minutes
- Supported durations: 30, 60, 90, and 120 minutes

Available start times are calculated dynamically according to the selected duration and current schedule.

## Booking Rules

The booking engine validates each selection before allowing confirmation.

The main rules are:

- Booking slots must be consecutive.
- Bookings cannot overlap existing bookings.
- Bookings cannot contain unavailable slots.
- A booking cannot extend beyond 6:00 PM.
- Start times are recalculated whenever the duration changes.
- The booking range is recalculated whenever the start time changes.
- Invalid isolated 30-minute gaps are prevented according to the scheduling rules.
- Past dates are available for viewing only.
- Past time slots on the current day cannot be booked.
- The booking is validated again before confirmation.

The UI distinguishes between the actual slot status and whether an available slot can be used as a start time for the currently selected duration.

## Features

- Appointment booking with dynamic availability
- Multiple date navigation
- 30 / 60 / 90 / 120 minute booking durations
- Dynamic valid start-time calculation
- Booking summary with start time, end time, and duration
- Confirm Booking
- Reset current selection
- Local booking persistence
- Light and Dark themes
- English and Arabic localization
- Full RTL support
- Responsive UI
- Animated splash screen
- Validation and confirmation feedback
- Persistent language and theme preferences

## Architecture

The project follows a simplified Feature-First Clean Architecture.

```text
lib/
├── app/
│   ├── cubit/
│   ├── data/
│   └── theme/
│
├── core/
│   ├── constants/
│   ├── di/
│   └── time/
│
├── features/
│   ├── splash/
│   │   └── presentation/
│   │       ├── views/
│   │       └── widgets/
│   │
│   └── booking/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       │
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── services/
│       │
│       └── presentation/
│           ├── cubit/
│           ├── views/
│           └── widgets/
│
└── l10n/
```

### Domain

Contains the core scheduling rules and entities.

Main concepts include:

- `TimeSlot`
- `SlotStatus`
- `BookingDuration`
- `Booking`
- `BookingValidator`
- `BookingValidationResult`

The booking logic is independent from the Flutter UI and local storage.

### Data

Responsible for local persistence and repository implementations.

Confirmed bookings are persisted using `SharedPreferences`.

### Presentation

Uses Cubit to manage application and booking state.

The UI contains no booking business logic and does not use `setState` for application state management.

## State Management

The project uses `flutter_bloc` with Cubit.

Two main Cubits are used:

### AppCubit

Responsible for:

- Theme mode
- Application language

Theme and language preferences are persisted locally.

### BookingCubit

Responsible for:

- Selected date
- Selected duration
- Selected start time
- Available slots
- Valid start times
- Selected booking range
- Booking confirmation
- Reset behavior

Complex scheduling validation remains inside the Domain layer rather than the Cubit.

## Local Persistence

The application does not use a backend.

`SharedPreferences` is used to persist:

- Confirmed bookings
- Selected theme
- Selected language

Confirmed bookings remain available after restarting the application.

## Dependency Injection

Dependencies are managed using `get_it`.

The dependency flow is conceptually:

```text
SharedPreferences
       |
       +--> AppPreferences --> AppCubit
       |
       +--> BookingLocalDataSource
                 |
                 v
          BookingRepository
                 |
                 v
            BookingCubit

BookingValidator -------> BookingCubit
```

## Localization

Waqti supports:

- English
- Arabic
- LTR
- RTL

Localization is implemented using Flutter's official ARB-based localization system.

```text
lib/l10n/
├── app_en.arb
└── app_ar.arb
```

## Responsive Design

The interface is responsive using `flutter_screenutil`.

The same widget structure is used for both Light and Dark themes.

No separate UI is maintained for different themes or languages.

## Testing

The core booking logic and state transitions are covered by unit tests.

The test suite includes cases for:

- Valid bookings
- Consecutive slot validation
- Booked slot conflicts
- Unavailable slot conflicts
- Working-hour limits
- 30-minute gap rules
- Valid start-time calculation
- Past date/time validation
- Duration changes
- Booking confirmation
- BookingCubit state transitions

Run all tests with:

```bash
flutter test
```

Run static analysis with:

```bash
flutter analyze
```

## Main Packages

```text
flutter_bloc
equatable
get_it
shared_preferences
flutter_screenutil
flutter_svg
intl
flutter_localizations
```

## Running the Project

Clone the repository:

```bash
git clone <repository-url>
```

Navigate to the project:

```bash
cd waqti
```

Install dependencies:

```bash
flutter pub get
```

Generate localization files:

```bash
flutter gen-l10n
```

Run the application:

```bash
flutter run
```

## Requirements

- Flutter SDK compatible with the project configuration
- Dart SDK `^3.8.1`
- Android/iOS development environment configured for Flutter

## Code Quality

The project follows these principles:

- Clean Architecture
- Separation of concerns
- Repository Pattern
- Dependency Injection
- Immutable state
- Reusable UI components
- Localized user-facing content
- Testable business logic
- No API or backend dependency
- No `setState` for application state management

## Author

Developed as a Flutter technical task demonstrating appointment scheduling logic, architecture, state management, persistence, localization, and responsive UI.
