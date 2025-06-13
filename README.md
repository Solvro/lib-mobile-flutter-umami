# Flutter Umami

[![License: MIT][license_badge]][license_link]

Simple Umami Analytics Flutter SDK made by [Solvro Team][solvro_link]

## Installation 💻

**❗ In order to start using Flutter Umami you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

Install via `flutter pub add`:

```sh
flutter pub add flutter_umami
```

## Usage 🚀

### Initialize Flutter Umami

First, create an instance of `FlutterUmami` by calling the `create` method:

```dart
final umami = await FlutterUmami.create(
  url: 'https://my.analytics.server', // Your Umami instance URL
  id: '9f65dd3f-f2be-4b27-8b58-d76f83510beb', // Your site ID from Umami dashboard
  hostname: 'com.my.app', // Your app's hostname
  locale: 'en-US', // User's locale
  screenSize: MediaQuery.of(context).size, // Current screen size
  isEnabled: kIsRelease // reccomended
);
```

### Track Screen Views

You can track screen views in two ways:

#### Using the `UmamiNavigationObserver` (recommended)

```dart
MaterialApp(
  navigatorObservers: [
    UmamiNavigationObserver(umami),
  ],
  // ... rest of your app configuration
);
```

#### Manually tracking screen views (usually not reccommended)

```dart
await umami.trackScreenView(
  'home_screen',
  referrer: 'previous_screen', // Optional
);
```

### Track Events

Track custom events with optional values:

```dart
await umami.trackEvent(
  eventType: 'button_click',
  eventValue: 'sign_up', // Optional
  screenName: 'home_screen', // Optional
);
```

## Credits

Based on some old discountinued package: [https://pub.dev/packages/umami_tracker](https://pub.dev/packages/umami_tracker)

---

[flutter_install_link]: https://docs.flutter.dev/get-started/install
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[solvro_link]: https://solvro.pwr.edu.pl
